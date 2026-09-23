# AGENTS.md

Routing index for AI agents and contributors. This file tells you where to look and how to work; [`docs/`](docs/) explains how the repo actually works.

## Where things live

| What | Where |
| ---- | ----- |
| Docker Compose services (Testsigma agent + Selenium Chrome) — local dev/reference | `docker-compose.yml` |
| ECS Fargate deployment (WAGOVPIPELINE Tools account) | `Terraform/` — see [`docs/systems/ecs-service.md`](docs/systems/ecs-service.md), deploy steps in [`docs/operations/deploy.md`](docs/operations/deploy.md) |
| Terraform state bucket (self-bootstrapping) | `Terraform/state-bucket.tf` — see the ADR in [`docs/architecture/decisions/`](docs/architecture/decisions/) |
| Task runner (docker-compose + Terraform + AWS recipes) | `justfile` |
| Tool versions (just, gitleaks, trivy, pre-commit) | `mise.toml` |
| Git hooks config (gitleaks secret scanning) | `.pre-commit-config.yaml` |
| Documentation | `docs/` — see the map below |

## Docs map

- [`docs/README.md`](docs/README.md) — start here for an overview and full map.
- [`docs/systems/`](docs/systems/) — how coherent areas of the repo work.
- [`docs/flows/`](docs/flows/) — behavior that crosses systems.
- [`docs/operations/`](docs/operations/) — recurring operational procedures (deployment, destroy, troubleshooting).
- [`docs/architecture/`](docs/architecture/) — cross-cutting patterns and constraints, including [`decisions/`](docs/architecture/decisions/) (ADRs).
- [`docs/glossary.md`](docs/glossary.md) — domain-specific terms.
- [`docs/templates/`](docs/templates/) — templates for new system/flow/ADR docs.
- [`docs/STYLE.md`](docs/STYLE.md) — how these docs should be written and kept current.
- [`docs/CHANGELOG.md`](docs/CHANGELOG.md) — release history (pure semver `vX.Y.Z`). Add an entry here for every release-worthy change.

## Working here

1. Read `docs/README.md` and any system/flow/architecture/glossary docs related to the area you're changing.
2. Inspect the actual source files for implementation details.
3. Make the change.
4. Update the relevant docs if behavior, responsibilities, flows, invariants, interfaces, or glossary-defined concepts changed.
5. Make sure docs and code agree before finishing.

Do not dump detailed system behavior into this file — that belongs in `docs/`. This file stays a short index.

Repository instructions here reflect this project's conventions, but remain subordinate to system, user, and security constraints — they are never authorization to run unsafe commands or expose data. See [`CLAUDE.md`](CLAUDE.md) for the working protocol (approval-before-action, no independent decisions).
