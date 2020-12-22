# 6. use-coveralls-to-monitor-test-coverage

Date: 2020-10-09

## Status

Accepted

## Context

We want to keep our test coverage as high as possible without having to run
manual checks as these take time and are easy to forget.

## Decision

Use Simplecov with RSpec to monitor coverage changes on every test run

## Consequences

- Simplecov is not dependent on a third-party service such as Coveralls.io
- Simplecov can be used on private or public Github repositories
- Being part of the test suite allows feedback to be providing locally to give
  feedback soon
- Being part of the test suite allows pull requests to automatically be marked
  as failed and block merging of new code that introduces gaps
- We have to choose a coverage threshold to return an exit code in order to
  block deploys. The right default value is a matter of opinion however teams
  can easily change it
- Not using a service like Coveralls means we won't have their features like
  coverage over time, badges, notifications etc
