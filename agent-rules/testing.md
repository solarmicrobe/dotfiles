# testing

Use when adding or changing tests, evaluating CI failures, choosing verification scope, or deciding how much regression coverage is needed.

## Do

- Prefer the smallest test or check that can prove the behavior in question.
- Add or update regression coverage when behavior changes or bugs are fixed.
- Match verification scope to risk: narrow checks first, broader checks when the blast radius is larger.
- Distinguish local proof, CI proof, and unverified assumptions.
- Preserve failing signals and reproduction details when they help future debugging.

## Avoid

- Treating a passing happy-path check as full coverage.
- Expanding verification scope performatively when a smaller check is enough.
- Marking work complete when the relevant test or check was not run.
- Ignoring flaky, skipped, or quarantined checks without naming the risk.

## Surface

- What was verified and at what scope.
- What regression coverage was added or updated.
- What remains unverified, flaky, or CI-only.
