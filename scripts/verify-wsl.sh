#!/usr/bin/env bash
# Verify the WSL cross-platform dotfiles support (branch: feature/wsl-support).
#
# Read-only checks only — safe to run repeatedly. Run INSIDE WSL, after
# `chezmoi apply`, from the chezmoi source dir (`chezmoi source-path`):
#
#     bash scripts/verify-wsl.sh
#
# Prints PASS/WARN/FAIL per check with remediation; exits non-zero if any
# hard check fails. See docs/windows-port.md for the full plan + prereqs.
set -u

pass=0; fail=0; warn=0
ok()     { printf '  \033[32mPASS\033[0m %s\n' "$1"; pass=$((pass+1)); }
bad()    { printf '  \033[31mFAIL\033[0m %s\n       -> %s\n' "$1" "$2"; fail=$((fail+1)); }
warned() { printf '  \033[33mWARN\033[0m %s\n       -> %s\n' "$1" "$2"; warn=$((warn+1)); }

echo "== WSL dotfiles verification =="

# 1. Running under WSL?
if grep -qiE 'microsoft|wsl' /proc/sys/kernel/osrelease 2>/dev/null; then
  ok "running under WSL ($(cat /proc/sys/kernel/osrelease))"
else
  warned "not detected as WSL" "this script verifies the WSL setup; run it inside WSL"
fi

# 2. platform partial resolves to wsl
if command -v chezmoi >/dev/null 2>&1; then
  plat=$(chezmoi execute-template '{{ includeTemplate "platform" . | trim }}' 2>/dev/null || true)
  if [ "$plat" = "wsl" ]; then
    ok "chezmoi platform partial -> wsl"
  else
    bad "chezmoi platform partial -> '${plat:-<none>}'" "expected 'wsl'; check .chezmoitemplates/platform"
  fi
else
  bad "chezmoi not installed" "install chezmoi first"
fi

# 3. bridge prerequisites
if command -v socat >/dev/null 2>&1; then ok "socat present"; else bad "socat missing" "sudo apt install socat"; fi
if command -v npiperelay.exe >/dev/null 2>&1; then
  ok "npiperelay.exe on PATH"
else
  bad "npiperelay.exe not found" "install on Windows (winget install npiperelay) and keep Windows PATH inherited in WSL"
fi

# 4. ssh config points at the bridge socket
sshcfg="$HOME/.ssh/config"
if [ -f "$sshcfg" ] && grep -q '\.1password/agent.sock' "$sshcfg"; then
  ok "ssh config: IdentityAgent points at the bridge socket"
else
  bad "ssh config missing the bridge IdentityAgent" "run 'chezmoi apply'; expect 'IdentityAgent .1password/agent.sock' under Host *"
fi

# 5. bridge socket live + 1Password agent reachable
sock="$HOME/.1password/agent.sock"
if [ -S "$sock" ]; then
  ok "bridge socket exists ($sock)"
else
  warned "bridge socket not found" "open a NEW login shell (zprofile starts the relay), then re-run"
fi
if SSH_AUTH_SOCK="$sock" ssh-add -l >/dev/null 2>&1; then
  n=$(SSH_AUTH_SOCK="$sock" ssh-add -l 2>/dev/null | grep -c .)
  ok "1Password agent reachable via bridge ($n key(s) listed)"
else
  bad "cannot list keys via bridge socket" "enable 1Password 'Use the SSH agent' (Windows) and confirm the socat relay is running"
fi

# 6. chezmoi renders cleanly (all op:// paths resolve)
if command -v chezmoi >/dev/null 2>&1; then
  if chezmoi apply --dry-run >/dev/null 2>&1; then
    ok "chezmoi apply --dry-run renders (1Password paths resolve)"
  else
    bad "chezmoi apply --dry-run failed" "run 'chezmoi apply --dry-run -v' and check op:// paths / 1P sign-in"
  fi
fi

# 7. linuxbrew + bundle
if command -v brew >/dev/null 2>&1; then
  ok "linuxbrew present"
  warned "brew bundle not run by this script" "run: brew bundle --file ~/Brewfile  (watch for missing linux bottles: microsoft/apm, mssql-tools, noobaa)"
else
  warned "linuxbrew not found" "install Homebrew on Linux, or adapt package install to apt"
fi

echo
echo "== summary: ${pass} pass, ${warn} warn, ${fail} fail =="
if [ "$fail" -eq 0 ]; then
  echo "All hard checks passed. Address any WARN items, run 'brew bundle', confirm a git push in a rezzell/solarmicrobe repo, then the branch is safe to merge."
  exit 0
else
  echo "Fix the FAIL items above and re-run."
  exit 1
fi
