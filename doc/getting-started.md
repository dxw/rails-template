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

Docker is made available to run these commands locally as containerisation
[MUST be used on CI and SHOULD be used on live environments](https://github.com/dxw/tech-team-rfcs/blob/main/rfc-013-use-docker-to-deploy-and-run-applications-in-containers.md).
Using Docker locally provides the strongest parity between development and live.
It can also be more stable to get running on your machine.

Running the tests regularly should be done without Docker as it is much faster.

### Prerequisites

```bash
$ brew install --cask docker
```

### Usage

#### Occassional use

Use the `--docker` switch:

```bash
$ script/test --docker
```

#### Regular use

You can set `PREFER_DOCKER_FOR_DXW_RAILS=1` in your env to set this preference
automatically.

- Option 1:
  - Install and use
    [direnv to set an environment variable on a per codebase basis](https://direnv.net/)
  - Add `PREFER_DOCKER_FOR_DXW_RAILS=1` to your `.envrc`
  - Load change with `direnv allow .`
- Option 2:
  - Set `PREFER_DOCKER_FOR_DXW_RAILS=1` in your global `.zshrc` or `.bashrc`
  - Load your change with `source .zshrc`

Switches will take priority over any default preference. For example, with
`PREFER_DOCKER_FOR_DXW_RAILS=1` set you can run `--no-docker` to run without
Docker.
