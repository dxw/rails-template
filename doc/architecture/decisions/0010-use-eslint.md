# 10. Use ESLint

Date: 2020-10-19

## Status

Accepted

## Context

We want to enforce consistency in our code, and catch as many errors
automatically as we are able to. Linting the code is good practice to achieve
these aims. [ESLint](https://eslint.org/) is the standard linter for modern
JavaScript, and has good support for TypeScript and React though plugins.

## Decision

We will check code style using ESLint.

We will let Prettier have precedence when ESLint and Prettier conflict in their
styles.

We will use the recommended configuration for plugins where possible.

We will run ESLint as part of the test suite.

## Consequences

ESLint enables us to agree on and enforce a code style without having to keep it
in the heads of developers, meaning we shouldn't have to discuss individual code
style violations as they come up.
