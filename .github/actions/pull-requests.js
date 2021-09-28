module.exports = {
  async olderThan({ github, context }, { days }) {
    const millisecondsAgo = Date.now() - days * 24 * 60 * 60 * 1000;

    const {
      repository: {
        pullRequests: { nodes: allPullRequests },
      },
    } = await github.graphql(
      `
        query($owner: String!, $name: String!) {
          repository(owner: $owner, name: $name) {
            pullRequests(first: 100, states: [OPEN]) {
              nodes {
                id
                createdAt
                isDraft
                timelineItems(
                  itemTypes: [
                    CLOSED_EVENT
                    CONVERT_TO_DRAFT_EVENT
                    READY_FOR_REVIEW_EVENT
                    REOPENED_EVENT
                  ]
                  last: 100
                ) {
                  nodes {
                    __typename
                    ... on ClosedEvent {
                      createdAt
                    }
                    ... on ConvertToDraftEvent {
                      createdAt
                    }
                    ... on ReadyForReviewEvent {
                      createdAt
                    }
                    ... on ReopenedEvent {
                      createdAt
                    }
                  }
                }
              }
            }
          }
        }
      `,
      {
        owner: context.repo.owner,
        name: context.repo.repo,
      }
    );

    console.log("Found %d open pull requests", allPullRequests.length);

    const nonDraftPullRequests = allPullRequests.filter((pr) => !pr.isDraft);

    console.log(
      "Found %d non-draft pull requests",
      nonDraftPullRequests.length
    );

    const pullRequestsReadyForReviewBeforeCutoff = nonDraftPullRequests.filter(
      (pr) => {
        if (pr.timelineItems.nodes.length === 0) {
          return new Date(pr.createdAt).valueOf() < millisecondsAgo;
        }

        const events = pr.timelineItems.nodes
          .map((event) => ({
            ...event,
            createdAt: new Date(event.createdAt).valueOf(),
          }))
          .sort((a, b) => b.createdAt - a.createdAt);

        const latestEvent = events[0];

        if (
          ["ClosedEvent", "ConvertToDraftEvent"].includes(
            latestEvent.__typename
          )
        ) {
          return false;
        }

        return latestEvent.createdAt < millisecondsAgo;
      }
    );

    console.log(
      "Found %d pull requests last made ready for review %d days or longer ago",
      pullRequestsReadyForReviewBeforeCutoff.length,
      days
    );

    const pullRequestIds = pullRequestsReadyForReviewBeforeCutoff.map(
      (pr) => pr.id
    );

    return pullRequestIds;
  },

  async removeLabelFrom({ github, context }, { ids, labelName }) {
    if (ids.length === 0) {
      return;
    }

    const {
      repository: { label },
    } = await github.graphql(
      `
        query($owner: String!, $name: String!, $labelName: String!) {
          repository(owner: $owner, name: $name) {
            label(name: $labelName) {
              id
            }
          }
        }
      `,
      {
        owner: context.repo.owner,
        name: context.repo.repo,
        labelName,
      }
    );

    if (!label) {
      throw new Error(`Unable to find label with name: ${labelName}`);
    }

    await Promise.all(
      ids.map((id) =>
        github.graphql(
          `
            mutation($input: RemoveLabelsFromLabelableInput!) {
              removeLabelsFromLabelable(input: $input) {
                clientMutationId
              }
            }
          `,
          {
            input: {
              labelIds: [label.id],
              labelableId: id,
            },
          }
        )
      )
    );

    return;
  },
};
