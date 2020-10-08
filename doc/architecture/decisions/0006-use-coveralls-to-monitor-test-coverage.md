# 6. use-coveralls-to-monitor-test-coverage

Date: 2020-10-08

## Status

Accepted

## Context

We want to keep our test coverage as high as possible without having to run manual checks as these take time and are easy to forget.

## Decision

Use the free tier of Coveralls to give us statistics and to give our pull requests feedback.

## Consequences

- The free tier only works on public repositories
- Pull request feedback should help us spot unexpected reductions in coverage and prompt us to keep it high before we merge
