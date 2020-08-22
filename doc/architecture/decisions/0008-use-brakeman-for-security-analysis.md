# 5. use-brakeman-for-security-analysis

Date: 2020-04-03

## Status

Accepted

## Context

We need a mechanism for highlighting security vulnerabilities in our code before it reaches production environments

## Decision

Use the [Brakeman](https://brakemanscanner.org/) static security analysis tool to find vulnerabilities in development and test

## Consequences

- Brakeman will be run as part of CI and fail the build if there are any warnings
- Brakeman can also be run in the development environment to allow developers to address issues before committing code to the repository
- Brakeman will help developers learn about common vulnerabilities and develop a more defensive coding style
- Use of Brakeman in development & test environments should reduce or eliminate code vulnerabilities that would be exposed in a penetration test
