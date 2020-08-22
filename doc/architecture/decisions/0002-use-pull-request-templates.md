# 1. use-pull-request-templates

Date: 2019-08-16

## Status

Accepted

## Context

The quality of information included in our pull requests varies greatly which can lead to code reviews which take longer and are harder for the person to understand the considerations, outcomes and consquences of a series of changes.

A couple of recent projects have found a GitHub pull request template to have been a positive change. Prompting what pull request descriptions should include has lead to better documented changes that have been easier to review on the whole. 

## Decision

Include a basic pull request template for GitHub so that every pull request prompts every author to fill it out.

## Consequences

- a small overhead to every pull request which may prompt us to spend more time in creating a pull request. We accept the cost of this to gain the benefits of easier reviews, and better documented changes
- writing good pull request descriptions is not to be done instead of commit messages, they are the primary source of storing rationale that will persist. Commit messages may be duplicated into the pull request description.
- prompting authors to articulate their thought process and decision making can improve the quality of code before a reviewer becomes involved. Essentially you are following the process of [rubber ducking](https://en.wikipedia.org/wiki/Rubber_duck_debugging) which gives you the final opportunity to amend your proposal
- this is not compatible when source code is hosted on other services eg. [GitLab requires a file of a different name](https://docs.gitlab.com/ee/user/project/description_templates.html#creating-merge-request-templates), as all of our Rails projects are on GitHub this should be a minor issue
- asking for screenshots doesn't always make sense especially when production deployments are facilitated by pull requests from develop into master. We accept that in these cases the cost of editing the template is small enough to not be a problem. The first header that prompts to describe changes does still apply
- not all pull requests result in a frontend change that requires screenshots, we believe that these prompts can be removed quickly with a minor cost to the author
