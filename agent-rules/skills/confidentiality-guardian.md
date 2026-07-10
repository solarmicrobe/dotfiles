# confidentiality-guardian

Use before converting any private, W2, client, consulting, or source-derived observation into public consulting content, LinkedIn posts, articles, diagrams, checklists, talks, newsletters, sales collateral, or durable thought-leadership assets.

## Purpose

Prevent confidential, proprietary, employer-owned, client-owned, security-sensitive, contract-sensitive, or identifying material from entering public content.

## Classification

Assign exactly one status:

- `Public`: safe to develop using the available material.
- `Needs Sanitization`: potentially useful after specific details are removed or generalized.
- `Needs External Research`: the thesis may be usable, but evidence must come from public sources.
- `Never Publish`: unsafe, proprietary, identifying, or inseparable from confidential work.

## Automatically Protected Material

Treat the following as confidential unless explicitly public:

- Employer, client, customer, product, project, repository, and ticket names
- Internal source code, configuration, prompts, tool contracts, schemas, and automation
- Non-public architecture, domain models, integrations, operating models, and workflows
- Business rules, delivery processes, production metrics, internal benchmarks, and financial details
- Roadmaps, incidents, vulnerabilities, security controls, security posture, and operational constraints
- Credentials, account identifiers, internal URLs, cloud resource names, and infrastructure names
- Employee names, team behavior, staffing details, performance information, and identifiable anecdotes
- Contracts, pricing, negotiations, vendor details, and client commercial context
- Customer, regulated, personal, or sensitive data
- Unique combinations of otherwise sanitized details that identify the organization or engagement

## Review Method

For each candidate:

1. Identify the source context: W2, consulting, personal, open source, homelab, or mixed.
2. Identify every source-specific fact.
3. Test whether removing names still leaves the employer, client, customer, team, product, or engagement inferable.
4. Determine whether the lesson can be recreated from first principles or public sources.
5. Remove unnecessary specificity and separate the general pattern from the implementation.
6. Separate direct observation from hypothesis, interpretation, and public evidence.
7. Identify employment-policy, NDA, invention-assignment, duty-of-loyalty, client-contract, or confidentiality concerns.
8. Assign a classification and explain the decision.

## Default Posture

When uncertain, exclude the material or require external public evidence.

Generalize the pattern, not the implementation.
