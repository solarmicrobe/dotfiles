# dependencies

Use when adding, removing, upgrading, or comparing dependencies, SDKs, CLIs, packages, or automation with maintenance and compatibility impact.

## Do

- Prefer existing dependencies and built-ins before adding new ones.
- State why a dependency or upgrade is needed, not just what it provides.
- Check maintenance posture, compatibility, migration cost, and operational overhead.
- Prefer small, reversible upgrades over broad version churn when possible.
- Note any required follow-up for lockfiles, generated artifacts, or rollout sequencing.

## Avoid

- Adding dependencies because they are popular rather than necessary.
- Mixing unrelated upgrades or package cleanup into the same change.
- Hiding breaking changes, transitive risk, or new operational requirements.
- Treating version bumps as risk-free when interfaces, defaults, or tooling behavior may change.

## Surface

- Why the dependency or upgrade was chosen.
- Compatibility, maintenance, or migration risks.
- Required verification, follow-up, or rollback considerations.
