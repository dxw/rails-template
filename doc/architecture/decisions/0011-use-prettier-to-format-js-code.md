# 11. use prettier to format JS code

Date: 2020-10-19

## Status

Accepted

## Context

We want to ensure we're all using one code style, that is familiar across
projects. [Prettier](https://prettier.io/) is an opinionated code formatter with
support for most, if not all, of the languages in the JavaScript ecosystem. As
of writing, it is used by over
[1 million repositories](https://github.com/prettier/prettier/network/dependents?package_id=UGFja2FnZS00OTAwMTEyNTI%3D)
on GitHub, including React itself, and has become a standard.

## Decision

We will enforce that everything supported by Prettier has its style enforced by
it.

We will set up Git hooks to automatically run the formatter before committing.

We will set continuous integration up to reject commits that are not correctly
formatted.

## Consequences

This adds some overhead to developers committing code, but that can be mitigated
using Git hooks and editor integrations.
