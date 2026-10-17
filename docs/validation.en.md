# Validation — 2026-10-17

[Português](validation.md)

## Actual execution

[Successful workflow](https://github.com/tommmdl/github-actions-lab/actions/runs/39073184363), triggered by a push to main. `test` job: 49 seconds; `publish` job: 30 seconds. Completed at 19:00:29 America/Sao_Paulo (22:00:29 UTC).

- Pipeline commit: `b598bf465215dbc1c6ab5540ba858074d2415cb8`.
- Application commit: `2c04e97d892796659bb2fc716f7ff18cc55d7305`.
- GitHub-hosted Ubuntu 24.04 runner, amd64 architecture.
- **All 23 integration checks passed**, including persistence and recovery after PostgreSQL outage.
- Image archive verified by SHA-256; image ID checked after `docker load` and registry pull.
- Published tags: `latest`, `app-2c04e97d892796659bb2fc716f7ff18cc55d7305` and `run-39073184363-1`.

Published image:

```text
ghcr.io/tommmdl/docker-lab@sha256:d8fdaffb99e0ac514b9e031ac9204b89fc2702112d198d1bebedd9d351fd19f0
```

## Actual registry consumption

Anonymous pull passed with a separate empty Docker configuration directory, without reusing GitHub login credentials. The published image ran by digest in the demonstration Compose project on port 8001. Readiness returned 200; creation 201; the note appeared in the list and deletion returned 204. API and PostgreSQL were healthy. Existing environments on ports 8000 and 8080 were preserved.

## Initial failure and fix

[The first run](https://github.com/tommmdl/github-actions-lab/actions/runs/39073078828) failed before integration checks: the host password file mode 0600 prevented API UID 10001 from reading the bind mount on the Linux runner. The `publish` job was skipped; that run published no image.

The upstream fix protects `.local/` with directory mode 0700 and allows the mounted file to be read with mode 0644. The corrected commit was pinned in `source.json`, and the next run passed. The password was not baked into the image or uploaded as an artifact.

## Evidence files

- [Job metadata and steps](../evidence/run.json)
- [All 23 checks](../evidence/integration-results.json)
- [Tested image ID](../evidence/tested-image-id.txt)
- [Published digest](../evidence/published-image.txt)
- [CI Compose logs](../evidence/compose.log)
- [Local registry smoke test](../evidence/registry-smoke.json)
- [Initial failure summary](../evidence/first-run-failure.txt)

## Limits

Testing/publication ran on main; PR behavior was checked in configuration without opening a demonstration PR. Publication blocking after failure was observed in the first run. No production deployment, multiple architectures, visual tests, signing or vulnerability analysis. Full integration checks ran in CI; the local published-image test covered readiness and basic notes operations. Actions artifacts expire; these files preserve this specific run's results. Technical execution performed by the assistant with owner authorization.
