# Getting started

We have options for developing with and without Docker.

## With Docker

Docker Compose is available to let you run a local server with all built
dependencies
[as used on CI](https://github.com/dxw/tech-team-rfcs/blob/main/rfc-013-use-docker-to-deploy-and-run-applications-in-containers.md)
and perhaps live environments. This provides the strongest parity for
development and can be more stable to get running on your machine.

Running the tests regularly should be done without Docker as it is much faster.

### Prerequisites

1. [Install Docker for MacOS](https://docs.docker.com/docker-for-mac/install/)

### Commands

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
$ docker-compose -f docker-compose.test.yml run --rm test script/test
```

## Without Docker

We use the
["Scripts To Rule Them All"](https://github.com/dxw/tech-team-rfcs/blob/main/rfc-023-use-scripts-to-rule-them-all.md)
pattern to standardise the common commands we have to use.

Our bootstrap and setup scripts attempt to configure your machine's environment
with the all the relevant packages required to run these commands.

### Commands

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
