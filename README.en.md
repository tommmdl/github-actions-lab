# GitHub Actions: from tests to a published image

English · [Português](README.md)

Once the app is running with Docker, the next step is to stop repeating the work by hand. This project moves testing into GitHub Actions and publishes the image to GHCR when the checks pass.

The important part is keeping what was tested: the first job builds and checks an image; the second receives that same image and publishes it without rebuilding. Application code stays in [docker-lab](https://github.com/tommmdl/docker-lab).

[![CI + GHCR](https://github.com/tommmdl/github-actions-lab/actions/workflows/ci.yml/badge.svg)](https://github.com/tommmdl/github-actions-lab/actions/workflows/ci.yml)

## Getting started

You only need repository access to follow the workflow. The local demo uses Linux/WSL, Docker, Compose, Bash, Python 3, curl and an available port 8001.

From the repository root:

```bash
gh workflow run ci.yml --repo tommmdl/github-actions-lab --ref main
gh run list --repo tommmdl/github-actions-lab
```

You can also open **Actions → Test and publish Docker Lab → Run workflow** on GitHub.

The published image is available without logging in:

```bash
docker pull ghcr.io/tommmdl/docker-lab:latest
```

To run the demo environment:

```bash
bash scripts/prepare.sh
bash scripts/compose.sh -f compose.ghcr.yaml up -d --wait --wait-timeout 180
```

Open http://localhost:8001. Use a published digest instead of `latest` to select a specific image.

## Things to try

1. Follow the checks and inspect the run artifacts.
2. Compare the tested image ID with the published one.
3. Pull the GHCR image and run the application.
4. Update the commit in `source.json` when you want to test another `docker-lab` revision.

## What has been tested

The pipeline passed all 23 checks and published the image. Anonymous pull worked, and the published app was tested locally. The documentation also records a failed run that blocked publication.

The [results and their limits](docs/validation.en.md) include execution details and evidence. They refer to the revisions recorded in those reports.

## When you are done

```bash
bash scripts/compose.sh -f compose.ghcr.yaml down
```

The demo keeps notes in its own volume; adding `-v` deletes them. Pull requests only test. Publication is restricted to main and uses the temporary `GITHUB_TOKEN`, without a PAT.

## A closer look

The [usage guide](docs/guide.en.md) covers architecture, configuration, tests, limitations and troubleshooting. The [portfolio](https://github.com/tommmdl/devops-portfolio) connects this project to the other labs.

[About the history update](docs/history.md)

## Check image security

[security-lab](https://github.com/tommmdl/security-lab) scans this project's published image with Trivy and enforces a HIGH/CRITICAL gate. Blocking and reports live in that repository's CI; this publication pipeline does not yet depend on that gate.

The pipeline now builds and tests the API together with the derived PostgreSQL image from `docker-lab/images/postgres`. Both tested images travel in the same artifact; publication verifies each image ID before pushing them to GHCR. The publication artifact records both digests. The separate security gate still reports remaining HIGH/CRITICAL findings and may stay red. Publishing a remediation image does not mean that gate approved it.

Both digests use the existing public `ghcr.io/tommmdl/docker-lab` package. API tags are unchanged; database tags start with `postgres-` (for example `postgres-latest`). Deployment uses digests rather than mutable tags.

Database publication now also requires 20 privilege/resource checks and an in-place upgrade test with three notes, in addition to the 23 API checks. The upgrade verifies the same volume, preserved login/data and termination of an old privileged session. The separate vulnerability gate remains unchanged.

The same pipeline now tests an additional PostgreSQL Alpine image on separate volumes. It checks logical restore, rollback, 23 API checks and 20 privilege/resource checks. The tested-image artifact carries three images and their IDs. Publication writes three digests in order: API, Bookworm PostgreSQL, Alpine PostgreSQL. Alternative tags start with `postgres-alpine-`; existing `postgres-` tags keep the Bookworm variant. Published digests do not automatically replace running databases.

The main Docker and Kubernetes labs have since adopted the tested Alpine image by digest, with logical backups and actual rollback. The source commit pinned in this publication lab records the earlier tested release; the standalone GHCR demo is unchanged. [Adoption and recovery](https://github.com/tommmdl/security-lab/blob/main/docs/postgres-adoption.en.md).

The [Alpine API experiment](https://github.com/tommmdl/security-lab/blob/main/docs/api-alpine.en.md) tests both basic and instrumented images with full scans, application checks and real Collector/Tempo/Grafana/Loki tracing. It uses separate workloads and databases; main API image pins remain unchanged.
