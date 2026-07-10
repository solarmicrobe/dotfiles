# public-content profile

Use when the user asks to extract, evaluate, prioritize, or draft public consulting-content ideas from W2 work, consulting work, private notes, experiments, open source work, homelab work, or prior observations.

## Boundary

- Treat employer, client, customer, and partner material as confidential unless it is explicitly public.
- Use this workflow for both W2 and consulting sources: W2 work must protect company IP and confidentiality; consulting work must protect client confidentiality and contractual obligations.
- Never scan repositories, email, tickets, chats, notes, or documents for public-content candidates without explicit user instruction.
- Do not copy raw work notes into consulting artifacts or knowledge bases.
- Do not infer that replacing names makes content safe.
- Employment agreements, client contracts, NDAs, policies, and legal obligations take precedence.

## Skill Loading

- When the user asks to mine or extract public-safe lessons, read `~/agent-rules/skills/public-content-extractor.md` and `~/agent-rules/skills/confidentiality-guardian.md`.
- When the user asks to convert an approved idea into content, also read `~/agent-rules/skills/thought-leadership-editor.md`.
- When the user asks what to research, publish, or prioritize next, read `~/agent-rules/skills/research-agenda-manager.md`; also use the Confidentiality Guardian before advancing any source-derived idea.
- Load only the needed skill files for the current request.

## Approval Gate

Do not draft final publishable content from W2 or client-derived observations until the Confidentiality Guardian classifies the idea as `Public`, or as `Needs Sanitization` / `Needs External Research` after that work is complete.
