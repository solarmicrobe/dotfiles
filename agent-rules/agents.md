# agents

Use when editing prompts, evals, tool contracts, model routing, memory behavior, context-loading policy, or other AI-agent behavior.

## Do

- Preserve tool and structured-output contracts unless the change explicitly includes a compatibility update.
- Add or update evals, regression checks, or reproducible transcripts when agent behavior changes.
- Treat Markdown that defines agent behavior as implementation, not documentation, when choosing commit types.
- Prefer the smallest context that can support the task; summarize bulky material once the relevant facts are captured.
- Distinguish persistent memory, retrieved context, and turn-local working state before changing behavior.
- State expected behavior changes, cost or latency impact, and any fallback path explicitly.

## Avoid

- Changing prompts, schemas, or routing without checking downstream compatibility.
- Loading broad context “just in case” when a narrower slice is enough.
- Storing noisy, sensitive, or weak-signal information in persistent memory without need.
- Claiming an agent behavior fix without an eval, trace, or reproducible before/after check.

## Surface

- Behavior or contract changes that were made.
- Evals, traces, or regression checks that support the change.
- Context, memory, compatibility, or cost risks that remain.
