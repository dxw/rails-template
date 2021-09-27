# Getting started

We use the
["Scripts To Rule Them All"](https://github.com/dxw/tech-team-rfcs/blob/main/rfc-023-use-scripts-to-rule-them-all.md)
pattern to standardise the common commands we have to use.

Setup the application:

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

Update application to run for its current checkout:

```bash
$ script/update
```

## With Docker

Docker is made available to run these commands locally as containerisation [MUST be used on CI and SHOULD be used on live environments](https://github.com/dxw/tech-team-rfcs/blob/main/rfc-013-use-docker-to-deploy-and-run-applications-in-containers.md). Using Docker locally provides the strongest parity between development and live. It can also be more stable to get running on your machine.

Running the tests regularly should be done without Docker as it is much faster.

### Prerequisites

```bash
$ brew install --cask docker
```
