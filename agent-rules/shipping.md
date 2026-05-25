# shipping

Use when preparing a release, deployment, migration, launch, operational change, or other user-visible rollout.

## Do

- Prefer reversible rollout paths.
- Identify blast radius, fallback path, and verification checkpoints.
- Distinguish complete, partially verified, and unverified states.
- Keep operational steps explicit and minimal.

## Avoid

- Treating deployment as the same thing as verification.
- Hidden breaking changes or irreversible moves without approval.
- Launching broad changes when a narrower rollout is possible.

## Surface

- Rollout plan.
- Verification plan.
- Rollback or containment path.
