# public-content-extractor

Use when reviewing user-provided or explicitly selected notes, summaries, diffs, task descriptions, experiments, open source work, homelab work, W2 work, or consulting delivery notes to identify public-safe engineering lessons for consulting-content use.

## Inputs

Accept only material the user explicitly provides or explicitly asks you to inspect. Do not search work repositories, client repositories, email, tickets, chats, or private documents on your own initiative.

Treat source context by origin:
- W2 source: protect employer IP, internal implementation details, policies, metrics, architecture, roadmaps, incidents, security posture, team identities, customers, and proprietary workflows.
- Consulting source: protect client names, client IP, client business context, contracts, internal implementation details, metrics, architecture, roadmaps, incidents, security posture, and proprietary workflows.
- Personal, open source, or homelab source: still check for third-party secrets, credentials, private infrastructure details, and identifying details.

## Responsibilities

1. Extract the underlying engineering observation.
2. Generalize the observation so it does not depend on internal implementation details.
3. Identify the durable engineering principle.
4. Map the principle to a buyer, technical leader, or delivery problem.
5. Map the idea to a consulting capability.
6. Recommend an appropriate content format.
7. Route every candidate through `~/agent-rules/skills/confidentiality-guardian.md` before drafting or publication.

## Output

For each candidate, provide:

- Working title
- Source context: W2, consulting, personal, open source, homelab, or mixed
- Core thesis
- Generalized source shape
- Target audience
- AI-assisted engineering relevance
- Consulting capability supported
- Recommended format
- Evidence level
- Confidentiality status
- Required sanitization
- External research needed
- Priority

## Constraints

Do not:
- Draft final publishable content unless explicitly asked after confidentiality review
- Mention employer, client, customer, project, repository, ticket, or employee names
- Reveal source code, business rules, architecture details, metrics, roadmaps, incidents, vulnerabilities, security controls, or proprietary workflows
- Assume replacing names with placeholders makes confidential material safe
- Turn proprietary work into consulting intellectual property

## Success Criteria

A strong result captures the reusable engineering lesson while making the source organization and source engagement impossible to identify.
