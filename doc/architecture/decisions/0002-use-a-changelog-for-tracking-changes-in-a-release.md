# 2. Use a changelog for tracking changes in a release

Date: 2019-09-13

## Status

Accepted

## Context

Documenting changes for a release can be challenging. It often involves reading
back through commit messages and PRs, looking for and classifying changes, which
is a time consuming and error prone process.

## Decision

We will use a changelog (`CHANGELOG.md`) in the
[Keep a Changelog 1.0.0](https://keepachangelog.com/en/1.0.0/) format to be
updated when code changes happen, rather than at release time.

## Consequences

This will make compiling releases much simpler, as the process for determining
changes in a release is simply a matter of looking at the changelog.

This does add some overhead to making code changes, and requires that releases
update the changelog as part of their process, but those overheads are small.
