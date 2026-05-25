# coding

Use when editing code, tests, config, schemas, migrations, or build scripts.

## Do

- Read surrounding code, interfaces, tests, and local patterns before editing.
- Make surgical diffs that trace directly to the request.
- Prefer built-ins, existing libraries, and stable modern patterns.
- Add or run the smallest meaningful verification available.
- Preserve user changes you did not make unless explicitly told otherwise.

## Avoid

- Speculative abstraction, premature generalization, or style-only rewrites.
- New dependencies without a clear need and explicit approval when appropriate.
- Claiming a fix without evidence from tests, commands, or a concrete reproduction path.

## Surface

- What changed.
- How it was verified.
- What remains unverified or risky.
