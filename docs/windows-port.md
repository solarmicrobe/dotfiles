# Windows / WSL Cross-Platform Port

Roadmap for making this chezmoi repo work on Windows-native (cmd/PowerShell)
and WSL, alongside the existing macOS/Linux support. The repo is macOS-first
today (Homebrew, `/Users/...` paths, mac-only 1Password agent socket).

> This file is repo-only documentation — `.chezmoiignore` excludes `docs/` so
> chezmoi never deploys it to the home directory.

## Decisions (2026-08-03)

| Decision | Choice | Why |
|---|---|---|
| Platform selection | **Derived `platform` var** (macos/windows/wsl/linux) computed in `.chezmoi.yaml.tmpl` | No new prompt; WSL self-identifies. `chassisType` stays form-factor; `container` keeps its persistent-VPS meaning. WSL != container. |
| Windows package manager | **winget** | Built into Win10/11, no admin bootstrap, declarative `winget import`, installs Store apps (covers `mas`). |
| WSL SSH keys | **Bridge to the Windows 1Password agent** (npiperelay + socat) | One keystore on the Windows host; keys never on disk in WSL. 1Password's documented WSL path. |

## Platform detection (drop into `.chezmoi.yaml.tmpl`)

```gotemplate
{{- $platform := .chezmoi.os -}}
{{- if eq .chezmoi.os "darwin" -}}{{- $platform = "macos" -}}{{- end -}}
{{- if eq .chezmoi.os "linux" -}}
{{-   if (.chezmoi.kernel.osrelease | lower | contains "microsoft") -}}
{{-     $platform = "wsl" -}}
{{-   end -}}
{{- end -}}
# data:
#   platform: {{ $platform }}
```

Then gate platform-specific bits with `{{ if eq .platform "wsl" }}` etc.
(`.chezmoi.kernel.osrelease` only exists on Linux — the guard above keeps it
scoped there.)

## Phases

### Phase 0 — cross-platform hygiene (helps macOS-arm too)
- [x] `dot_gitconfig.tmpl`: `/Users/{{`{{ .username }}`}}/...` → `~/...` for
  `core.excludesfile`, `commit.template`, `ghq.root` (commit `067c6d3`).
- [ ] `dot_zprofile.tmpl:2`: `/Users/{{`{{ .username }}`}}/.local/bin` → `$HOME`
  (redundant with `dot_zshrc.tmpl:157` — candidate for deletion).

### Phase 1 — WSL
- [ ] Add derived `platform` var (snippet above).
- [ ] Linux/WSL package path — `brew bundle` is currently `darwin`-gated, so
  WSL/Linux install **nothing**. Use linuxbrew or apt; strip casks / `mas`.
- [ ] SSH: template `IdentityAgent` per platform.
- [ ] SSH: WSL bridge to the Windows 1Password agent (npiperelay + socat).
- [ ] git credential helper: reuse the Windows GCM from WSL.

### Phase 2 — Windows native
- [ ] `winget` manifest (JSON) mirroring Brewfile essentials (git, gh,
  1Password, vscode, ...); Store apps for the `mas` items.
- [ ] SSH `IdentityAgent \\.\pipe\openssh-ssh-agent`.
- [ ] Agent-only keys (no on-disk private keys) to dodge NTFS ACL rejection.
- [ ] chezmoi `.sh` script handling on Windows — `.chezmoiignore` them or add
  `.ps1` equivalents / configure `[interpreters]`.
- [ ] Optional PowerShell profile (or scope Windows-native to git/gh/ssh only
  first — there is no zsh on Windows native).

### Phase 3 — behavior changes — **DO ON A BRANCH** (try before merge)
- [ ] Credential helper `/usr/local/share/gcm-core/git-credential-manager` →
  bare `git-credential-manager` on PATH, templated per platform. (Current path
  is Intel-only — **already wrong on M-series Macs**; Azure DevOps / CodeCommit
  auth only.)
- [ ] Gate Sourcetree difftool/mergetool (`/Applications/Sourcetree.app/...`)
  and `run_onchange_after_install-usr-local-bin.sh` (`sudo cp` to
  `/usr/local/bin`) to `darwin`.

## Subsystem reference

| Area | macOS (today) | WSL | Windows native |
|---|---|---|---|
| Packages | Homebrew + Brewfile + casks + `mas` | linuxbrew/apt, no casks/`mas` | winget manifest |
| Shell rc | `dot_zshrc`/`dot_zprofile` (zsh) | zsh works (mac `/usr/local/opt/*` PATHs are dead-but-harmless) | no zsh → pwsh profile or scope out |
| SSH agent | `IdentityAgent ~/Library/.../1password/...sock` | bridge to Windows 1P agent | `\\.\pipe\openssh-ssh-agent` |
| Key files | `private_` perms | fine | NTFS ACL differs → prefer agent-only |
| chezmoi scripts | `run_once_*.sh` shebangs | fine | `.sh` needs interpreter or ignore |

## Known bugs (independent of the port)
- `credential.helper` uses an Intel-only brew path — wrong on Apple Silicon (Phase 3).
- `.chezmoiignore` `work_id_*` rules use `has "work" .tags`, but no `work` tag
  is ever set (only `.purpose`). Dead no-op today (no `work_id_*` templates), but
  the same broken pattern as the `personal_id_rsa` gate that was fixed in `c0d6093`.
