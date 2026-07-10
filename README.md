# dotfiles
Dotfiles managed by `chezmoi`

## Agent rules and public-content skills

Canonical shared agent behavior lives in `.chezmoitemplates/personal-rules.md.tmpl` and renders to:

- `~/AGENTS.md`
- `~/.codex/AGENTS.md`
- `~/.claude/CLAUDE.md`

Task-specific modules live under `agent-rules/` and render to `~/agent-rules/`. The public-content workflow files are:

- `agent-rules/profiles/public-content.md`
- `agent-rules/skills/public-content-extractor.md`
- `agent-rules/skills/confidentiality-guardian.md`
- `agent-rules/skills/thought-leadership-editor.md`
- `agent-rules/skills/research-agenda-manager.md`

Codex-native skill packages are also managed by chezmoi under `dot_codex/skills/` and render to:

- `~/.codex/skills/public-content-extractor/`
- `~/.codex/skills/confidentiality-guardian/`
- `~/.codex/skills/thought-leadership-editor/`
- `~/.codex/skills/research-agenda-manager/`

These paths are installed by chezmoi whether or not Codex has already created `~/.codex/`. Existing Codex installs use the same target path.

The public-content workflow is available to both W2 and consulting contexts, but it is never automatic. Agents must not scan repositories, email, tickets, chats, notes, or documents for public-content ideas without explicit instruction. W2 material must protect employer IP and confidentiality; consulting material must protect client confidentiality and contractual obligations. The Confidentiality Guardian is required before any source-derived idea advances toward public drafting.

To render and inspect the shared agent files locally:

```bash
chezmoi execute-template --file AGENTS.md.tmpl
chezmoi execute-template --file dot_codex/AGENTS.md.tmpl
chezmoi execute-template --file dot_claude/CLAUDE.md.tmpl
```

To validate the agent-rule integration:

```bash
scripts/validate-agent-rules.sh
```

To add another public-content skill, add a Markdown file under `agent-rules/skills/`, reference it from `agent-rules/profiles/public-content.md`, and add only a concise root-file summary to `.chezmoitemplates/personal-rules.md.tmpl` if the skill must be discoverable before loading the profile.
For Codex-native invocation, also add a matching package under `dot_codex/skills/<skill-name>/` with `SKILL.md` and `agents/openai.yaml`.

# Initial setup
The first run will ask to fill out the `.chezmoi.yaml` settings file. There are two main tags I use which should be exclusive from each set:
* Email address: Main email for this user; used in git config
* Full name: Name of person; used in git config and other places
* Machine type: desktop, laptop, server, or container
* Context: personal, work, or consulting

Other tags:
* Hackintosh - For use with non-apple hardware
* [workplace] - For use when a tool might be extremely specific to a company and might not carry forward to another job

## MacOS
```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
brew install chezmoi 1password-cli
brew install --cask 1password
chezmoi init solarmicrobe/dotfiles
```

## WSL (Ubuntu)
```bash
sudo snap install chezmoi --classic
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
  sudo tee /etc/apt/sources.list.d/1password.list && \
  sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/ && \
  curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
  sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol && \
  sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22 && \
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg && \
  sudo apt update && sudo apt install 1password-cli
chezmoi init solarmicrobe/dotfiles
```
