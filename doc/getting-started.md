# Getting started

## With Docker

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

## Without Docker

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
