# debugging

Use when investigating a bug, flaky test, failing command, regression, or unexpected behavior.

## Do

- Reproduce the issue or define the failure mode precisely.
- Isolate variables before changing multiple things at once.
- Prefer root-cause evidence over symptom suppression.
- Add or run a check that would fail before the fix and pass after it.
- Preserve notes about the trigger, environment, and observed behavior when they matter.

## Avoid

- Blind patches based on hunches alone.
- Declaring success because the error disappeared once.
- Mixing unrelated cleanup into a bug fix.

## Surface

- Reproduction or failure signal.
- Root cause or best current theory.
- Evidence that the fix changed the failing behavior.
