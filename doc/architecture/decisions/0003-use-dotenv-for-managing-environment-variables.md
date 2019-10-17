# 3. use-dotenv-for-managing-environment-variables

Date: 2019-09-19

## Status

Accepted

## Context

Accessing ENV directly without a wrapper is limited and can introduce problems.

We want our tooling to help us guard against missing environment variables. When `nil` is accidentally provided during the start up process it is preferable to fail fast with an explicit message. Without this `nil` can be passed down through the stack and cause strange behaviour where the code has been designed with it as a dependency. Instead of adding `nil` guards throughout the codebase for required environment variables (eg. `ENV.fetch('FOO', 'default')`, this should be managed centrally.

We have previously used Figaro for this purpose but it was deprecated in 2016 https://github.com/laserlemon/figaro. We should only use supported gems to ensure we get support in the form of fixes and security patches.

We also want to be able to stub our environment variables in our test suite. An easy example of this is when we use environment variables as a feature flag mechanism. We want to stub the value to test both scenarios without being influenced by real values being loaded. Mutating the actual ENV value (eg. ` allow(ENV).to receive(:[]).with('BOX_ID').and_return("1234")`) is possible but may have unexpected consequences where more than 1 part of the same process under test uses the same variable. Figaro used to be a handy abstraction layer that we could stub eg. `allow(Figaro).to receive(:env).with(:foo).and_return('bar')`. We should then consider how we can stub environment variables.

## Decision

Use DotEnv to load our environment variables.

## Consequences

Should Docker and Docker Compose be added to the project the environment variables will need to be loaded with `docker-compose up --env-file=.env.development` rather than `docker-compose.env` which is a pattern we have used. Having 2 files for managing environment variables such as `.env*` and `docker-compose.env*` is undesirable due to the overhead in keeping these in sync.

DotEnv loads environment variables but doesn't offer an interface as Figaro did. For DotEnv you'd access by writing `ENV['foo']` rather than `DotEnv.foo`. We will need to make a supporting decision to use [Climate Control](https://thoughtbot.com/blog/testing-and-environment-variables#use-climate-control) to support testing.
