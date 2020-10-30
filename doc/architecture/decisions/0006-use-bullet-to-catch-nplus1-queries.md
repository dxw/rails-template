# 2. use-bullet-to-catch-nplus1-queries

Date: 2019-09-19

## Status

Accepted

## Context

It can be easy to miss an inefficient database query during code review. These
can build up and have detremental performance on the application and effect the
user experience.

## Decision

Add an automatic check to the test suite to ensure (through CI) that these are
fixed before being deployed.

## Consequences

- Code reviews are depended upon less to catch this type of error, removing the
  risk of human error
- Application response times should no longer be affected by this type of issue
- Requires protected branch configuration to ensure that CI must succeed before
  being able to be merged
