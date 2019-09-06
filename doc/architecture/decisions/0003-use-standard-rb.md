# 3. Use Standard for Ruby linting

Date: 2019-09-06

## Status

Accepted

## Context

We need to make sure our code is written in a standard style for clarity, consistency across a project and to avoid back and forth between developers about code style.

## Decision

We will use [Standard.rb](https://github.com/testdouble/standard) and run the standard.rb rake task to lint the code as part of the test suite.

## Consequences

Code must be written to match the standard.rb style, otherwise the test suite will fail. Most errors can be automatically fixed by running `rake standard:fix`.
