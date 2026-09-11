# core

Use when the task is substantive, multi-step, or likely to involve judgment beyond a trivial answer.

## Do

- Solve the actual problem, not adjacent ones.
- Keep active context small and load only what is needed.
- State assumptions and decision-relevant uncertainty.
- If multiple interpretations exist, surface them; if something is unclear, stop and ask.
- Prefer reversible moves and low operational overhead.
- Match the local environment and existing constraints before inventing new structure.
- Use the minimum rule, context, and implementation surface that solves the task.
- Load guides and references progressively: start with the local entry point, prefer search and headings, and load referenced material only when it changes the next decision or verification step.
- Store screenshots, comparisons, and generated proof that need to outlive the session under `~/Documents/session-scratchpad/<identifier>/`, where `<identifier>` is a stable PR number, ticket key, or short concept slug.

## Avoid

- Loading broad instruction sets without a trigger.
- Optimizing for elegance over clarity and maintainability.
- Turning small tasks into frameworks or cleanup campaigns.
- Copying broad guide content into prompts, tickets, or generated docs unless the user asked for that artifact to contain it.

## Surface

- Intended outcome.
- What was checked or verified.
- Remaining risk, if any.

## Durable Evidence

Use `~/Documents/session-scratchpad/<identifier>/` for evidence backing a PR, decision, or investigation. Accumulate
evidence for the current session's work there as it is generated. Across sessions, only continue an existing folder
when the user names the folder or identifier to resume. Use one folder per identifier; ask when ownership is ambiguous.
