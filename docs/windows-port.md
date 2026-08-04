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
- [x] `dot_zprofile.tmpl:2`: `/Users/{{`{{ .username }}`}}/.local/bin` → `$HOME`
  (redundant with `dot_zshrc.tmpl:157` — candidate for deletion).

### Phase 1 — WSL
- [x] Add derived `platform` (as `.chezmoitemplates/platform` partial, used via `includeTemplate "platform" . | trim` — avoids the re-init a data var would need).
- [x] Linux/WSL package path — `cask`/`mas`/mac-only formulae gated to `darwin`
  in `Brewfile.tmpl`; `run_once…packages` runs `brew bundle` via linuxbrew on
  `linux`. Mac render verified byte-identical. **Verify on real WSL:** linux
  bottles for `microsoft/apm`, `mssql-tools`, `noobaa`; `dive`/`diskonaut` are
  mac-only for now (left in the darwin GUI block) — promote to the cross-platform
  section if WSL needs them.
- [x] SSH: template `IdentityAgent` per platform (macos socket / windows pipe / wsl bridge sock / linux none). macOS render verified unchanged.
- [x] SSH: WSL bridge to the Windows 1Password agent (npiperelay + socat) — relay in `dot_zprofile.tmpl`; prereqs below.
- [ ] git credential helper: reuse the Windows GCM from WSL.

### Phase 2 — Windows native
- [ ] `winget` manifest (JSON) mirroring Brewfile essentials (git, gh,
  1Password, vscode, ...); Store apps for the `mas` items. **(next)**
- [x] SSH `IdentityAgent \\.\pipe\openssh-ssh-agent` (done in the platform partial
  + ssh config, commit `f106011`).
- [x] Agent-only keys — Windows `.chezmoiignore` drops on-disk private keys
  (`personal_id_*`, `imagebuilder_id_*`); keys come from the 1P named-pipe agent,
  dodging NTFS ACL rejection.
- [x] chezmoi script/shell handling — Windows `.chezmoiignore` drops the zsh rc
  files and the POSIX `run_*` scripts (packages via winget instead). **Verify on
  Windows:** confirm chezmoi skips the ignored `run_*` scripts (script-name
  matching in `.chezmoiignore` is untested here).
- [ ] Optional PowerShell profile (deferred — Windows-native scope is git/gh/ssh
  + winget for now; no zsh on Windows native).

### Phase 3 — behavior changes — **DO ON A BRANCH** (try before merge)
- [ ] Credential helper `/usr/local/share/gcm-core/git-credential-manager` →
  bare `git-credential-manager` on PATH, templated per platform. (Current path
  is Intel-only — **already wrong on M-series Macs**; Azure DevOps / CodeCommit
  auth only.)
- [ ] Gate Sourcetree difftool/mergetool (`/Applications/Sourcetree.app/...`)
  and `run_onchange_after_install-usr-local-bin.sh` (`sudo cp` to
  `/usr/local/bin`) to `darwin`.

## WSL agent bridge (one-time setup)

`dot_zprofile.tmpl` starts a `wsl`-gated `socat` relay that exposes the Windows
1Password agent (named pipe `//./pipe/openssh-ssh-agent`) as a Unix socket at
`~/.1password/agent.sock` — the `IdentityAgent`/`SSH_AUTH_SOCK` target. The relay
self-starts on login if not already running. Prerequisites:

- **Windows**: 1Password → Settings → Developer → enable "Use the SSH agent";
  install `npiperelay.exe` on the Windows PATH (`winget install npiperelay`, or
  scoop, or `GOOS=windows go build github.com/jstarks/npiperelay`).
- **WSL**: `sudo apt install socat` (or `brew install socat`).

Verify: open a new login shell, then `ssh-add -l` should list your 1Password keys.

## WSL verification (for a future WSL session)

After `chezmoi apply` on a WSL box, verify this branch end-to-end from the
chezmoi source dir (`chezmoi source-path`):

```bash
bash scripts/verify-wsl.sh
```

Read-only checks: WSL detection, `platform` partial → `wsl`, `socat` +
`npiperelay.exe` present, ssh-config bridge `IdentityAgent`, bridge socket +
`ssh-add -l` reachability, `chezmoi apply --dry-run` (1Password paths resolve),
and linuxbrew presence. Prints PASS/WARN/FAIL with remediation; exits non-zero
on any hard FAIL. (`scripts/verify-wsl.sh` is `.chezmoiignore`d — repo-only,
never deployed to `~`.)

**Definition of done (safe to merge to master):** `verify-wsl.sh` exits 0,
`brew bundle --file ~/Brewfile` completes, and a git push in a
rezzell/solarmicrobe repo authenticates through the bridged 1Password agent.

## Windows verification (for a future Windows session)

After `chezmoi apply` in PowerShell, from the chezmoi source dir
(`chezmoi source-path`):

```powershell
pwsh scripts/verify-windows.ps1
```

Read-only checks: `platform` partial → `windows`, ssh-config named-pipe
`IdentityAgent`, no on-disk private keys, `ssh-add -l` reachability,
`chezmoi apply --dry-run` (1Password paths resolve), winget presence.
(`scripts/verify-windows.ps1` is `.chezmoiignore`d — repo-only.) Not yet run on
a real Windows box; the winget package-install path is still TODO.

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
