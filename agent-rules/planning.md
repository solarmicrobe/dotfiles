# planning

Use when work spans multiple steps, involves coordination risk, or would benefit from an explicit execution sequence.

## Do

- Make plans only as detailed as the task requires.
- Break work into concrete, verifiable steps.
- Put risky, uncertain, or dependency-blocking work early.
- Keep the next action obvious.
- Update the plan if reality changes.
- Define success criteria that can be checked independently.
- Route durable artifact creation through the matching workflow skill when the conversation shifts from exploration into tickets, specs, plans, PRs, or non-ephemeral docs.
- Capture out-of-scope follow-ups in the quarterly TODO file when they are worth remembering and do not warrant a Jira ticket.

## Avoid

- Writing ceremonial plans for trivial tasks.
- Mixing exploration, implementation, and verification into one vague step.
- Treating a plan as fixed when new evidence invalidates it.
- Scanning `~/Documents/todo-*.md` at every session start. Only scan TODO files when the task mentions TODOs, follow-ups, deferred work, continuing prior local work, or when a surfaced out-of-scope follow-up needs capture.

## Surface

- Goal.
- Ordered steps.
- Verification checkpoints and blockers.

## Goal-Driven Execution

Transform tasks into verifiable goals:

- "Add validation" -> "Write tests for invalid inputs, then make them pass".
- "Fix the bug" -> "Write a test that reproduces it, then make it pass".
- "Refactor X" -> "Ensure tests pass before and after".

For multi-step work, state a brief plan:

```text
1. [Step] -> verify: [check]
2. [Step] -> verify: [check]
3. [Step] -> verify: [check]
```

Strong success criteria let the agent loop independently. Weak criteria like "make it work" require clarification.

## Deferred Work TODOs

Quarterly file: `~/Documents/todo-YYYY-Q[1-4].md`, resolving the current quarter from today's date. Use it for
personal, local, ad-hoc follow-ups that do not warrant a Jira ticket, including non-blocking issues surfaced mid-task,
cleanup or experiments worth remembering, and investigations explicitly deferred.

Trigger TODO scanning only when the task mentions TODOs, follow-ups, deferred work, continuing prior local work, or an
out-of-scope follow-up needs capture. When scanning, inspect only open-item metadata (`Status`, `Conditions`, short
title) first. Load full `Prompt` or `Evidence` bodies only when an open item's conditions match the current task or
need verification.

Entry rules:

- The `Prompt` block must be self-contained: include PR or ticket URLs, file paths, expected outputs, and context needed to resume cold.
- On completion, fill `Evidence` before changing status to `done <YYYY-MM-DD>`.
- Never delete done entries.
- Items spanning quarters stay in their originating file; only completion date moves forward.

## Workflow Skill Suggestion

When an ad-hoc conversation transitions from understanding or research into durable artifact creation, pause and offer
the matching workflow skill before proceeding ad hoc. Examples include "we need a ticket", "draft the tickets", "file
this as a story", "create the AC", "let's plan", or "shape this into a ticket".

Use the pattern: "This looks like /brainstorm territory - want me to run it, or continue ad hoc?" Adapt the skill name
to the task. Do not pause for ephemeral output such as a single chat reply, one-line diff, or scratch math.
