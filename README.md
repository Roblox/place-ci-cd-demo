# Roblox place, sample CI/CD setup

> [!WARNING]  
> This is a sample project intended to demonstrate how the new Open Cloud Luau execution API can be used. It has not been battle tested so creators should proceed with caution when adapting it for their own experiences.

This repository is an example of a place CI/CD setup for fully managed Rojo projects.

It includes:

- Linting with [Selene](https://github.com/Kampfkarren/selene)
- Validating code format with [StyLua](https://github.com/JohnnyMorganz/StyLua)
- Running tests by building a RBXL with [Rojo](https://github.com/rojo-rbx/rojo), uploading to Roblox, then executing Luau using the Engine Open Cloud API for Executing Luau
- Deployment using [Rojo](https://github.com/rojo-rbx/rojo)

![A screenshot of the CI/CD steps in sequence](screenshot.png)

A special thanks is given to the creators of Rojo, Selene and StyLua for creating such awesome tools.

## How to setup

1. Create a Test place separate from your production place that can be used for running your tests
2. Generate an [Open Cloud API key](https://create.roblox.com/docs/cloud/open-cloud/api-keys) with the following permissions for both your test place and your production place.
    - `universe.places:write` 
    - `universe.place.luau-execution-session:write`
3. Save this API key as a [GitHub Actions Secret](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions) named `ROBLOX_API_KEY` 
4. Create [GitHub Actions Repository Variables](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/store-information-in-variables) for the following values 
    - `ROBLOX_PRODUCTION_UNIVERSE_ID`, `ROBLOX_PRODUCTION_PLACE_ID`
    - `ROBLOX_TEST_UNIVERSE_ID`, `ROBLOX_TEST_PLACE_ID`
5. (Optional) add [GitHub branch protection rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/managing-a-branch-protection-rule) to validate the checks have been passed on PRs before they have been merged

## Notes

* The CI/CD steps are implemented in [.github/workflows/cicd.yml](.github/workflows/cicd.yml), which in turn calls the python and shell scripts in [/scripts](/scripts)
* The implementation assumes you have a branch called `production` that all commits to are deployed, and all PRs to have checks run
* This implementation assumes you have a fully managed Rojo workflow. The automated testing would theoretically work on a partially managed Rojo workflow (provided your test did not reference non Rojo managed Instances) but deployment will not.
* The python wrappers for Open Cloud inside [/scripts/python](/scripts/python) were written for this demonstration and are not intended as clients for general use
* The Engine Open Cloud API for Executing Luau is currently limited to one concurrent request per universe. The GitHub actions config in this example accounts for this by creating a [concurrency group](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/control-the-concurrency-of-workflows-and-jobs). This will prevent Luau execution jobs from attempting to run concurrently and failing.
  * Note, we aim to lift this limit in the future.
* An example PR is given showing CI checks failing: [example](https://github.com/Roblox/place-ci-cd-demo/pull/1)
* Because the CI/CD pipeline requires an Open Cloud API key to run, more work is required for use in Open Source projects where fork maintainers will have to create these places, variables and API keys themselves for checks to run correctly on their forks.
