# Using this template

1. Search for `TODO` across the repository to customise the template to the new
   project
1. Find and replace `rails-template` across the repository
1. Be aware of [dxw RFCs](https://github.com/dxw/tech-team-rfcs), especially
   those that have not resulted in a default code change in this repository:
   - [rfc-013-use-docker-to-deploy-and-run-applications-in-containers](https://github.com/dxw/tech-team-rfcs/blob/master/rfc-013-use-docker-to-deploy-and-run-applications-in-containers.md)

TODO: Remove this section from the README once complete

---

# Rails Template

TODO: replace README header with project name

TODO: Add a summary of who the application is for and what it will do.

## Getting started

### With Docker

Using Docker is the faster and more reliable way to get started. [We always use Docker containers for CI and should use it in live environments](https://github.com/dxw/tech-team-rfcs/blob/main/rfc-013-use-docker-to-deploy-and-run-applications-in-containers.md) so using it locally will provide better environment parity.

Start the server:

```bash
$ script/dserver
```

Start a console:

```bash
$ script/dconsole
```

Run the tests:

```bash
$ docker-compose -f docker-compose.test.yml run --rm test bundle exec rake
```

### Without Docker

You will have to use various scripts to help you get your environment close to that which Docker provisions in live environments.

Testing locally without of Docker is recommended as it is much faster.

Run the setup script:

```bash
$ script/setup
```

Start the server:

```bash
$ script/server
```

Start a console:

```bash
$ script/console
```

Run the tests:

```bash
$ script/test
```

## Static code analysis

Run [Brakeman](https://brakemanscanner.org/) to highlight any security
vulnerabilities:

```bash
$ brakeman
```

To pipe the results to a file:

```bash
$ brakeman -o report.text
```

## Making changes

When making a change, update the [changelog](CHANGELOG.md) using the
[Keep a Changelog 1.0.0](https://keepachangelog.com/en/1.0.0/) format. Pull
requests should not be merged before any relevant updates are made.

## Releasing changes

When making a new release, update the [changelog](CHANGELOG.md) in the release
pull request.

## Architecture decision records

We use ADRs to document architectural decisions that we make. They can be found
in doc/architecture/decisions and contributed to with the
[adr-tools](https://github.com/npryce/adr-tools).

## Managing environment variables

We use [Dotenv](https://github.com/bkeepers/dotenv) to manage our environment
variables locally.

The repository will include safe defaults for development in `/.env.example` and
for test in `/.env.test`. We use 'example' instead of 'development' (from the
Dotenv docs) to be consistent with current dxw conventions and to make it more
explicit that these values are not to be committed.

To manage sensitive environment variables:

1. Add the new key and safe default value to the `/.env.example` file eg.
   `ROLLBAR_TOKEN=ROLLBAR_TOKEN`
1. Add the new key and real value to your local `/.env.development.local` file,
   which should never be checked into Git. This file will look something like
   `ROLLBAR_TOKEN=123456789`

## Access

TODO: Where can people find the service and the different environments?

## Source

This repository was bootstrapped from
[dxw's `rails-template`](https://github.com/dxw/rails-template).
