# 4. add-rollbar-for-application-monitoring

Date: 2019-09-20

## Status

Accepted

## Context

We need a mechanism to capture and manage application errors. Without an integration our debugging options are to access a console on live environments and try to replicate (something we want to minimise) or by looking through information provided by logs.

We have used Rollbar for a few years now and we have not reviewed this decision since. It is currently being used for 14 applications.

For some projects we use their technical tooling of choice to aid in the transition to business as usual. Due to this we will have a handful of projects using Sentry and possible others.

Sometimes Rollbar environment names don't match the Rails environment. Dalmatian-<project> and paas-<project> both exist. There also exists both permutations for the same project as we transition. We have used ROLLBAR_ENV to manage this before so making it explicit will hopefully make it clearer how it can be changed.

## Decision

Use Rollbar to collect and manage our application errors.

## Consequences

- the Rails team will have a single tool to be familiar with
- there is only one tool new joiners will need to be invited to
- administering and paying for a single service is easier for dxw however there is a risk that sharing the same account with many projects may go over the usage threshold
- in the rarer case where we have to use the client tooling the team would have to accept an overhead of replace this configuration with one compatible with the tool of choice
