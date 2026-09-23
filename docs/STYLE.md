# Documentation Style

Documentation here is written for both humans and AI agents.

Good documentation should:

- Use clear, direct Markdown.
- Prefer stable headings.
- Link to related docs and source files with Markdown relative links from the current file.
- Explain behavior, responsibilities, flows, invariants, and pitfalls.
- Avoid restating every implementation detail.
- Avoid unsupported guesses — mark uncertainty explicitly when behavior is hard to infer.
- Include source maps for important files.
- Stay concise enough to read before making changes.

The best docs are not exhaustive. They are navigational and explanatory: they help a reader understand what matters, where the details live, and what could break if the system changes.

## Documentation granularity

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

## Source maps

Every system and flow doc should include a source map linking to the most important files that implement the behavior. Do not list every file unless the system or flow is small.

## Code comments vs. docs

Use system docs to explain how a system works. Use flow docs to explain cross-system behavior. Use code comments only for implementation-specific context best read beside the code — non-obvious branches, ordering constraints, retries/caching/locking rationale, security-check reasoning, or external API quirks. Avoid comments that restate what the code already says or duplicate what belongs in a system/flow doc.

## Keeping docs updated

Update the affected doc as part of the same change whenever it affects: responsibilities, runtime or user-visible behavior, data models, external integrations, configuration, error handling, security/auth behavior, invariants/assumptions, testing/debugging expectations, or glossary-defined concepts.

If docs and code disagree, either update the docs to match the code, update the code to match the documented intent, or explicitly call out the mismatch for review.
