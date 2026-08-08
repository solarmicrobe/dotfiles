---
name: github-cli-sandbox
description: Use whenever a task involves the GitHub CLI `gh`, GitHub authentication, `gh auth status`, GitHub PR/issue/check/run commands, or any shell command using `gh` in Codex. On this machine, `gh` auth is only reliable outside the sandbox.
---

# GitHub CLI Sandbox

On this machine, GitHub CLI commands that depend on authentication or network state must run outside the Codex sandbox.

## Rules

- Use `sandbox_permissions: "require_escalated"` for `gh auth status`, `gh pr`, `gh issue`, `gh run`, `gh repo`, and any other authenticated or networked `gh` command.
- If a sandboxed `gh` command reports invalid auth, stale tokens, DNS failure, or repository access failure, do not treat that as authoritative. Rerun the same command outside the sandbox.
- Use a concise justification that says the local Codex sandbox cannot see the real GitHub CLI auth/network state.
- `gh --version` may run in the sandbox because it does not depend on auth.

## Pattern

```json
{
  "cmd": "gh auth status",
  "sandbox_permissions": "require_escalated",
  "justification": "The local Codex sandbox cannot see the real GitHub CLI auth state. Do you want to allow this gh command outside the sandbox?"
}
```
