# coding

Use when editing code, tests, config, schemas, migrations, or build scripts.

## Do

- Read surrounding code, interfaces, tests, and local patterns before editing.
- Make surgical diffs that trace directly to the request.
- Touch only what the task requires; clean up only unused imports, variables, functions, or artifacts created by your own change.
- Match existing style, even when you would choose differently in new code.
- Prefer built-ins, existing libraries, and stable modern patterns.
- Add or run the smallest meaningful verification available.
- Preserve user changes you did not make unless explicitly told otherwise.

## Avoid

- Speculative abstraction, premature generalization, or style-only rewrites.
- Features, flexibility, configurability, or error handling that were not requested and are not needed for correctness.
- Refactoring adjacent code, deleting pre-existing dead code, or improving unrelated formatting.
- New dependencies without a clear need and explicit approval when appropriate.
- Claiming a fix without evidence from tests, commands, or a concrete reproduction path.

## Surface

- What changed.
- How it was verified.
- What remains unverified or risky.
