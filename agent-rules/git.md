# git

Use when creating branches, writing commit messages, preparing changes to check in, or interpreting repository branch and commit naming conventions.

## Do

- Default to Conventional Commits and conventional branch names unless a closer authority overrides them. Authority order: repo-local policy, then company or package policy, then user default.
- Use Conventional Commits by default: `type(scope): summary` when a scope helps, otherwise `type: summary`.
- Treat AI-facing docs as source when they define agent behavior, skills, prompts, evals, tool contracts, routing, memory behavior, or workflow policy. Do not classify those changes as docs-only just because the files are Markdown.
- Use conventional branch names by default: `type/short-kebab-summary`.
- Reuse the standard commit types for branches when they fit: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `build`, `ci`, `perf`.
- Follow repository-local conventions when a repo explicitly requires a different branch or commit scheme.

## Avoid

- Using `docs` for Markdown changes that change agent or skill behavior rather than human-facing documentation.
- AI-centric branch markers such as `ai/`, `agent/`, `codex/`, `claude/`, `gpt/`, `llm/`, or `-ai` unless that repository explicitly calls for agent-authored naming.
- Vague commit subjects such as `updates`, `misc`, or `fix stuff`.
- Inventing custom types when an existing conventional type already fits.

## Surface

- The proposed branch name when creating a branch.
- The proposed commit message when preparing a commit.
- Any repository-specific rule that overrides these defaults.
- Any explicit operator instruction that intentionally diverges from repo-local or company/package git policy.
