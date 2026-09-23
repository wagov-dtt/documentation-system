# Documentation System for Humans & Agents

## Contents

- [Summary](#summary)
- [Goals](#goals)
- [Repository Structure](#repository-structure)
- [`AGENTS.md`](#agentsmd)
- [Documentation Types](#documentation-types)
  - [System Documentation](#system-documentation)
  - [Flow Documentation](#flow-documentation)
  - [Architecture Documentation](#architecture-documentation)
  - [Architecture Decision Records](#architecture-decision-records)
  - [Glossary](#glossary)
- [Documentation Templates](#documentation-templates)
  - [System Template](#system-template)
  - [Flow Template](#flow-template)
  - [ADR Template](#adr-template)
- [Documentation Style](#documentation-style)
- [Documentation Granularity](#documentation-granularity)
- [Source Maps](#source-maps)
- [Code Comments](#code-comments)
- [Keeping Docs Updated](#keeping-docs-updated)
- [Agent Workflow](#agent-workflow)
- [Initial Implementation Guidance](#initial-implementation-guidance)
- [Viewing Documentation with MDTS](#viewing-documentation-with-mdts)
- [Extending the Documentation System](#extending-the-documentation-system)

## Credits

This documentation system was derived from [https://gist.github.com/lukewilson2002/cb48062397d8b51954034d94b8c19d6d](https://gist.github.com/lukewilson2002/cb48062397d8b51954034d94b8c19d6d).

## Summary

This documentation system exists because humans and AI agents are only as reliable as the context they can find. Without durable repo-local documentation, contributors have to infer product behavior, system boundaries, domain terms, and architectural constraints from scattered source files, comments, issues, and one-off instructions. That makes changes slower and increases the chance of breaking assumptions that were only implicit.

This document describes a lightweight, repo-local documentation system that functions as a shared knowledge base for humans and AI coding agents. `AGENTS.md` is the routing layer. The `docs/` folder contains durable documentation for systems, flows, architecture, glossary terms, and templates.

The source code remains the implementation source of truth. Documentation explains the system at a useful level of abstraction: what each important system does, how major workflows operate, what assumptions must remain true, where the key source files are, and what a contributor should understand before making changes.

This approach uses plain Markdown files stored in the repository and reviewed alongside code. It does not require generated documentation tooling, docs publishing infrastructure, or a separate documentation platform.

## Goals

The documentation system should:

- Help humans and AI agents understand the application quickly.
- Explain important systems and flows without restating every line of code.
- Tie together behavior that is spread across source files, services, routes, jobs, integrations, and UI.
- Make it easier to identify stale assumptions, undocumented behavior changes, and bugs.
- Keep `AGENTS.md` concise by using it as an index and operating guide.
- Keep documentation close to the codebase so it evolves with code changes.
- Require documentation affected by an important code change to be updated and reviewed with that change.

## Repository Structure

Use a top-level `docs/` directory:

```txt
docs/
  README.md
  STYLE.md
  glossary.md
  systems/
    ...
  flows/
    ...
  architecture/
    README.md
    decisions/
      README.md
  templates/
    system.md
    flow.md
    adr.md
```

The exact file names can follow existing repository conventions, but the conceptual structure should remain clear.

## `AGENTS.md`

The root `AGENTS.md` should act as an index and operating guide for agents, not as the place for detailed system documentation.

It should include:

- A short explanation that detailed documentation lives in `docs/`.
- A docs map pointing agents to `docs/README.md`, `docs/systems/`, `docs/flows/`, `docs/architecture/`, and `docs/glossary.md`.
- Instructions to read relevant docs before changing a system.
- Instructions to update relevant docs when behavior, responsibilities, flows, invariants, interfaces, or assumptions change.
- A rule that docs and code must agree.
- A reminder not to dump detailed system behavior into `AGENTS.md`.

A good rule for `AGENTS.md` is:

> `AGENTS.md` tells agents where to look and how to work; `docs/` explains how the application works.

Repository instructions should reflect each project's requirements, but they remain subordinate to system, user, and security constraints and must never be treated as authorization to run unsafe commands or expose data.

## Documentation Types

### System Documentation

System docs live in:

```txt
docs/systems/
```

A system is a coherent area of application behavior. It may map to a module, package, service, feature area, integration, or domain concern, but it does not have to match the code structure exactly.

Examples:

```txt
docs/systems/auth.md
docs/systems/billing.md
docs/systems/notifications.md
docs/systems/background-jobs.md
docs/systems/search.md
```

A system doc should explain how that part of the application works. It should tie together the important source files, concepts, data, entry points, dependencies, invariants, failure modes, and debugging notes.

System docs are useful when a human or agent asks questions like:

- How does Auth work?
- What happens during Email Verification?
- What state does Billing own?
- Which source files matter for Notifications?
- What should I know before changing Background Jobs?

A system can be broad or narrow. For example, `auth.md` may describe sessions, login, password reset, and Email Verification. If Email Verification becomes complex, cross-system, frequently changed, frequently debugged, or important enough to review independently, it can be promoted into its own flow doc.

### Flow Documentation

Flow docs live in:

```txt
docs/flows/
```

A flow doc explains important behavior that moves across systems or deserves independent documentation.

Examples:

```txt
docs/flows/email-verification.md
docs/flows/subscription-renewal.md
docs/flows/webhook-processing.md
docs/flows/user-onboarding.md
```

Use a flow doc when behavior:

- Crosses multiple systems.
- Has several steps or state transitions.
- Is frequently changed or debugged.
- Involves external services.
- Has important error handling.
- Has security, billing, data integrity, or user-visible implications.

Flow docs should describe triggers, participants, steps, state changes, failure behavior, observability, testing, and source files.

### Architecture Documentation

Architecture docs live in:

```txt
docs/architecture/
```

The architecture directory is for cross-system architecture, durable technical decisions, and system-wide constraints. It should explain why the application is shaped a certain way when that explanation affects more than one system.

Architecture docs are different from system and flow docs:

- `docs/systems/` explains how a specific system currently works.
- `docs/flows/` explains important behavior that moves across systems.
- `docs/architecture/` explains broader structure, long-lived constraints, and architectural decisions.

Use `docs/architecture/` for topics such as:

- System-wide patterns.
- Durable technical constraints.
- Cross-system boundaries.
- Major integration strategies.
- Persistence or deployment assumptions.
- Architectural tradeoffs.
- Architecture Decision Records.

Do not use `docs/architecture/` for ordinary implementation notes, feature documentation, or detailed behavior that belongs in a system or flow document.

### Architecture Decision Records

Architecture Decision Records, or ADRs, live in:

```txt
docs/architecture/decisions/
```

ADRs document proposed, active, and historical technical decisions, including their context, tradeoffs, consequences, and rejected alternatives.

ADRs in `docs/architecture/decisions/` describe architectural decisions considered for the codebase. Agents and humans should treat only ADRs with an `Accepted` status as current guidance when reviewing, planning, or changing code.

Architectural decisions are human-owned. Agents can help draft ADR text from accepted decisions and keep existing ADRs aligned with code.

Use ADRs for decisions that shape the system beyond a single implementation detail, such as:

- Why authentication is session-based instead of token-only.
- Why billing webhooks are processed asynchronously.
- Why a specific database owns a specific kind of state.
- Why background jobs must be idempotent.
- Why a third-party integration is isolated behind an adapter.

Proposed architectural decisions should be discussed in PRs, issues, planning docs, or review comments. An ADR may be created while that discussion is in progress with a `Proposed` status, then changed to `Accepted` once the decision is approved.

Do not rewrite an accepted ADR to describe a different decision. When a decision changes, create a new ADR, mark the old ADR as `Superseded`, and link the old ADR to its replacement with `superseded_by`. Accepted ADRs may still receive small corrections or links that do not change the recorded decision.

Every ADR must begin with YAML frontmatter. The allowed fields are:

- `status` (required): one of `Proposed`, `Accepted`, `Superseded`, `Deprecated`, or `Rejected`.
- `date` (required): the date the ADR was created, formatted as `YYYY-MM-DD`.
- `superseded_by` (required only for `Superseded` ADRs): a repository-relative path to the replacement ADR.

Do not add other frontmatter fields unless the project deliberately extends this schema in its documentation style guide. The statuses mean:

- `Proposed`: under discussion and not current guidance.
- `Accepted`: the current decision.
- `Superseded`: replaced by a newer ADR.
- `Deprecated`: discouraged but still relevant historically.
- `Rejected`: considered but intentionally not adopted.

Routine implementation details, small refactors, bug fixes, and temporary workarounds belong in code, PRs, issues, or ordinary documentation instead of ADRs.

### Glossary

The glossary lives at:

```txt
docs/glossary.md
```

The glossary defines important domain terms used across the application. It helps humans and agents avoid making incorrect assumptions about words that have specific meaning in the product or codebase.

Examples of useful glossary terms:

- Account
- Workspace
- Member
- Organization
- Session
- Subscription
- Email Verification
- Verification Token

Glossary entries should use Title Case for their headings.

In finished documentation, prefer using the same Title Case form when referring to glossary-defined concepts, especially when it improves clarity or distinguishes an application-specific concept from an ordinary word.

Treat Title Case as a clarity aid for finished docs. A glossary concept can still appear in lowercase in drafts, comments, source code identifiers, issues, or informal notes.

## Documentation Templates

Templates live in:

```txt
docs/templates/
```

Templates keep documentation consistent and make it easier for humans and agents to create new docs.

Recommended templates:

```txt
docs/templates/system.md
docs/templates/flow.md
docs/templates/adr.md
```

### System Template

A system doc should generally use this structure:

```md
# <System Name>

## Purpose

Explain what this system does and why it exists.

## Questions this doc answers

List the practical questions this document is meant to answer.

## Scope

Describe what is included in this system.

## Non-scope

Describe what this system does not own, especially where boundaries are easy to misunderstand.

## Key concepts

Define important domain concepts, states, entities, and terms used by this system.

Use Title Case for concepts that are defined in `docs/glossary.md` when doing so improves clarity.

## How the system works

Explain the system at a behavioral level. Focus on important mechanics, responsibilities, and interactions. Do not restate every implementation detail.

## Important flows

Describe major flows handled by this system. Link to separate flow docs when a flow is large, cross-system, frequently changed, frequently debugged, or important enough to review independently.

## Data and state

Describe important persisted data, in-memory state, caches, queues, external state, or derived state used by this system.

## Interfaces and entry points

List the main ways this system is used, such as API routes, UI entry points, background jobs, event handlers, webhooks, services, public functions, or external integrations.

## Dependencies

List systems, services, packages, APIs, or infrastructure this system depends on.

## Downstream effects

Describe what other systems may be affected when this system changes.

## Invariants and assumptions

List rules that must remain true for the system to behave correctly.

## Error handling

Describe important failure modes and how the system handles them.

## Security and privacy notes

Document security-sensitive behavior, permissions, authentication, authorization, user data handling, and privacy assumptions. Omit only if clearly irrelevant.

## Observability and debugging

Explain how to debug this system. Include relevant logs, metrics, traces, dashboards, admin screens, commands, or common symptoms when applicable.

## Testing notes

Describe important tests and how to validate changes.

## Common pitfalls

List things contributors or agents are likely to misunderstand.

## Source map

Link to the most important source files. Do not list every file unless the system is small.

## Related docs

Link to related system docs, flow docs, ADRs, glossary entries, or external references.
```

### Flow Template

A flow doc should generally use this structure:

```md
# <Flow Name>

## Purpose

Explain what this flow accomplishes and why it matters.

## Trigger

Describe what starts the flow.

## Participants

List the systems, services, users, jobs, routes, integrations, or external providers involved.

## Step-by-step flow

Describe the main sequence of behavior.

## Data and state changes

Describe important data created, updated, deleted, cached, queued, or derived during the flow.

## Success behavior

Describe what is true when the flow succeeds.

## Failure behavior

Describe important failure modes, retries, fallbacks, compensating behavior, and user-visible errors.

## External dependencies

List external services, APIs, providers, infrastructure, or configuration required by this flow.

## Invariants and assumptions

List rules that must remain true for this flow to behave correctly.

## Security and privacy notes

Document security-sensitive behavior, permissions, authentication, authorization, user data handling, and privacy assumptions. Omit only if clearly irrelevant.

## Observability and debugging

Explain how to debug this flow. Include logs, metrics, traces, dashboards, admin screens, commands, or common symptoms when applicable.

## Testing notes

Describe important tests and how to validate changes.

## Source map

Link to the most important source files.

## Related docs

Link to related system docs, flow docs, ADRs, glossary entries, or external references.
```

### ADR Template

The ADR template should generally use this structure:

```md
---
status: Proposed
date: "YYYY-MM-DD"
---

# <Decision Title>

## Context

Describe the problem, forces, constraints, and relevant background.

## Decision

Describe the decision that was made.

## Consequences

Describe the expected benefits, costs, risks, and tradeoffs.

## Alternatives considered

List meaningful alternatives and why they were not chosen.

## Related code

Link to important source files affected by this decision.

## Related docs

Link to related system docs, flow docs, ADRs, glossary entries, or external references.
```

All new ADRs should follow the ADR template unless there is a clear reason to extend it.

## Documentation Style

Documentation should be written for both humans and AI agents.

Good documentation should:

- Use clear, direct Markdown.
- Prefer stable headings.
- Link to related docs and source files with Markdown relative links from the current file.
- Explain behavior, responsibilities, flows, invariants, and pitfalls.
- Avoid restating every implementation detail.
- Avoid unsupported guesses.
- Mark uncertainty explicitly when behavior is hard to infer.
- Include source maps for important files.
- Stay concise enough to read before making changes.

The best docs are not exhaustive. They are navigational and explanatory. They help a reader understand what matters, where the details live, and what could break if the system changes.

## Documentation Granularity

Create or expand documentation when behavior is important enough that a human or agent would otherwise need to inspect several files to understand it.

Keep documentation inside a system doc when the behavior is local and easy to explain there.

Create a separate flow doc when the behavior:

- Crosses multiple systems.
- Has several steps or states.
- Is frequently changed or debugged.
- Has important error handling.
- Involves external services.
- Has security, billing, data integrity, or user-visible implications.

Do not document every file. Prioritize systems and flows that are central, risky, frequently changed, difficult to infer, or important to user-visible behavior.

## Source Maps

Every system and flow doc should include a source map linking to the most important files that implement the behavior.

A source map should help the reader inspect details without forcing them to rediscover where the implementation lives.

Do not list every file unless the system or flow is small. Prefer the most important entry points, state definitions, handlers, services, jobs, tests, and integration files.

## Code Comments

Use code comments for implementation-specific context that is most useful when read directly beside the code. Agents should read relevant docs first, then use comments as local context while inspecting source files.

Good comments explain non-obvious behavior, ordering constraints, side effects, invariants, security assumptions, external API quirks, retries, caching behavior, concurrency concerns, or cases where a local implementation affects another system.

Prefer comments when they prevent a real misunderstanding, bug, unsafe refactor, or unnecessary rediscovery.

Good uses for code comments include:

- Explaining why a non-obvious branch exists.
- Explaining why operations must happen in a specific order.
- Explaining why a variable, flag, or state transition triggers behavior in another system.
- Explaining why a retry, debounce, cache invalidation, lock, or transaction is necessary.
- Explaining why a security check exists.
- Explaining why an external API is called in an unusual way.
- Explaining what invariant a block of code preserves.
- Explaining what edge case or failure mode the code protects against.

Avoid comments that:

- Restate what the code already says.
- Explain obvious variable names.
- Duplicate system documentation.
- Add long architectural explanations inside source files.
- Leave stale historical notes that belong in an ADR.

Use system docs to explain how a system works. Use flow docs to explain cross-system behavior. Use code comments to explain why a specific implementation detail exists.

## Keeping Docs Updated

Documentation must be updated when code changes affect important system understanding.

Every pull request that changes behavior, interfaces, security, data, or operational procedures must update the affected documentation as part of the same change. Reviewers should treat documentation as part of the code change and verify that it is accurate before approving the work.

Update relevant docs when a change affects:

- System responsibilities.
- Runtime behavior.
- User-visible behavior.
- Internal workflows.
- Data models or persistence behavior.
- External integrations.
- Public APIs.
- Configuration.
- Error handling.
- Security or auth behavior.
- Important invariants or assumptions.
- Testing or debugging expectations.
- Glossary-defined domain concepts.

Documentation is valid only when it accurately describes the intended behavior of the current code.

If docs and code disagree, contributors must do one of the following:

- Update the docs to match the code.
- Update the code to match the documented intent.
- Explicitly call out the mismatch for review.

This makes documentation useful during code review. Reviewers can compare docs and code to catch stale assumptions, missing behavior changes, or bugs caused by mismatched intent and implementation.

## Agent Workflow

When an AI coding agent works in the repository, it should follow this workflow:

1. Read `AGENTS.md`.
2. Use `docs/README.md` to find relevant documentation.
3. Read the system, flow, architecture, and glossary docs related to the area being changed.
4. Inspect source files for implementation details.
5. Make the code change.
6. Update relevant docs if behavior, responsibilities, flows, invariants, assumptions, interfaces, or glossary-defined concepts changed.
7. Ensure docs and code agree before finishing.

This gives agents enough context to work effectively without requiring every task to start with full-codebase exploration.

## Initial Implementation Guidance

When introducing this system to an existing codebase, do not try to document everything at once.

Start with the most important systems and flows, such as:

- Core domain systems.
- Auth, session, and user systems.
- API/server behavior.
- Data access and persistence.
- Background jobs or workers.
- External integrations.
- Billing, payments, or subscriptions, if present.
- Notifications, email, or webhooks, if present.
- Important UI or application flows.

Each initial doc should be accurate, useful, and linked to relevant source files. It is acceptable to mark uncertain areas for follow-up rather than inventing explanations.

The central rule is that documentation must evolve with the code. When behavior changes, the relevant docs should change too. This makes the repository easier to understand, easier to review, and safer for agentic development.

## Viewing Documentation with MDTS

This documentation system works especially well with MDTS, a local Markdown documentation viewer.

Run MDTS from the repository root:

```sh
npx mdts
```

The command opens a browser page for exploring the Markdown documentation in the repository. It puts the project's Markdown files in one place so you can click through the documentation and move between related pages more easily.

Readers can click around linked documentation files and move between related docs. This makes source maps, related-doc links, ADR links, glossary links, and flow links more useful during planning, review, onboarding, and debugging.

Because `npx` may download and execute MDTS from npm, users are responsible for reviewing and trusting the package before running the command.

MDTS does not yet support viewing non-Markdown files. That means links to source files, configuration files, and other non-Markdown project files may not be viewable inside the MDTS browser page yet. There is an [open issue requesting support for common non-Markdown file types](https://github.com/unhappychoice/mdts/issues/830). If that support is added, MDTS could become a lightweight way to review project documentation and related repository context without extra documentation infrastructure or configuration.

## Extending the Documentation System

The structure in this document is a starting point. Projects can add documentation categories when they have recurring needs that do not fit systems, flows, architecture, or glossary documentation.

For example, a project with recurring deployment, migration, incident, rollback, or data-repair procedures may add `docs/operations/` or `docs/runbooks/`. Choose one convention for the repository and include it in `docs/README.md` and the docs map in `AGENTS.md`. Keep these extensions focused on durable project needs instead of creating categories in advance.
