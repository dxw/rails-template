# 9. use-scripts-to-rule-them-all

Date: 2020-09-25

## Status

Accepted

## Context

dxw have approved an RFC for following the pattern of Scripts To Rule Them
All[1].

This repository should include reference and document this decision.

[1]
https://github.com/dxw/tech-team-rfcs/blob/main/rfc-023-use-scripts-to-rule-them-all.md

## Decision

By default we will follow the Scripts To Rule Them All pattern for common tasks
in this template.

## Consequences

- it is easier to get an application running and perform common tasks without
  having a more in-depth knowledge of the code base
- consistency between applications helps members of the team move between
  projects with less friction
- the content of these scripts may not always be relevant to every application
  spawned from this template, changing from the default would require additional
  effort
- the dxw RFC uses "SHOULD" and "MAY" rather than "MUST", these scripts could
  therefore be removed and replaced if there is a good reason
