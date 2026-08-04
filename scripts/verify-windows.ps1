# Verify Windows-native cross-platform dotfiles support (branch: feature/cross-platform).
#
# Read-only checks only. Run in PowerShell after `chezmoi apply`, from the
# chezmoi source dir (`chezmoi source-path`):
#
#     pwsh scripts/verify-windows.ps1      # or: powershell -File scripts/verify-windows.ps1
#
# Prints PASS/WARN/FAIL with remediation; exits non-zero on any hard FAIL.
# See docs/windows-port.md for the full plan + prereqs.

$script:pass = 0; $script:fail = 0; $script:warn = 0
function Ok($m)    { Write-Host "  PASS $m" -ForegroundColor Green;  $script:pass++ }
function Bad($m,$r){ Write-Host "  FAIL $m`n       -> $r" -ForegroundColor Red;    $script:fail++ }
function Warn($m,$r){ Write-Host "  WARN $m`n       -> $r" -ForegroundColor Yellow; $script:warn++ }

Write-Host "== Windows-native dotfiles verification =="

# 1. platform partial -> windows
if (Get-Command chezmoi -ErrorAction SilentlyContinue) {
  $plat = (chezmoi execute-template '{{ includeTemplate "platform" . | trim }}' 2>$null)
  if ($plat -eq 'windows') { Ok "chezmoi platform partial -> windows" }
  else { Bad "chezmoi platform partial -> '$plat'" "expected 'windows'; check .chezmoitemplates/platform" }
} else { Bad "chezmoi not installed" "winget install twpayne.chezmoi" }

# 2. ssh config uses the 1Password named pipe
$sshcfg = Join-Path $HOME ".ssh\config"
if ((Test-Path $sshcfg) -and (Select-String -Path $sshcfg -SimpleMatch 'openssh-ssh-agent' -Quiet)) {
  Ok "ssh config: IdentityAgent -> named pipe (openssh-ssh-agent)"
} else {
  Bad "ssh config missing the named-pipe IdentityAgent" "run 'chezmoi apply'; expect 'IdentityAgent \\.\pipe\openssh-ssh-agent' under Host *"
}

# 3. private keys are NOT on disk (agent-only)
$leaked = Get-ChildItem (Join-Path $HOME ".ssh") -ErrorAction SilentlyContinue |
  Where-Object { $_.Name -match '^(personal|imagebuilder)_id_' -and $_.Name -notlike '*.pub' }
if (-not $leaked) { Ok "no on-disk private keys in ~/.ssh (agent-only)" }
else { Warn "on-disk private key(s): $($leaked.Name -join ', ')" "not needed on Windows; keys should come from the 1Password agent" }

# 4. 1Password SSH agent reachable
if (Get-Command ssh-add -ErrorAction SilentlyContinue) {
  ssh-add -l *> $null
  if ($LASTEXITCODE -eq 0) { Ok "SSH agent reachable (ssh-add -l lists keys)" }
  else { Bad "ssh-add -l could not list keys" "enable 1Password 'Use the SSH agent' + Windows OpenSSH client" }
} else { Bad "ssh-add not found" "install the Windows OpenSSH client feature" }

# 5. chezmoi renders cleanly (op:// paths resolve)
if (Get-Command chezmoi -ErrorAction SilentlyContinue) {
  chezmoi apply --dry-run *> $null
  if ($LASTEXITCODE -eq 0) { Ok "chezmoi apply --dry-run renders (1Password paths resolve)" }
  else { Bad "chezmoi apply --dry-run failed" "run 'chezmoi apply --dry-run -v' and check op:// paths / 1P sign-in" }
}

# 6. winget present (Phase 2 package install)
if (Get-Command winget -ErrorAction SilentlyContinue) { Ok "winget present" }
else { Warn "winget not found" "install 'App Installer' from the Microsoft Store" }

# 7. winget manifest deployed
$manifest = Join-Path $HOME ".config\winget\packages.json"
if (Test-Path $manifest) { Ok "winget manifest present (~/.config/winget/packages.json)" }
else { Warn "winget manifest not found" "run 'chezmoi apply'; expect ~/.config/winget/packages.json" }

# 8. PowerShell profile deployed + loaded from the expected path
if (Test-Path $PROFILE.CurrentUserCurrentHost) {
  Ok "PowerShell profile present ($($PROFILE.CurrentUserCurrentHost))"
} else {
  Warn "PowerShell profile not found at `$PROFILE" "run 'chezmoi apply'; if ~/Documents is OneDrive-redirected, chezmoi's target may differ from `$PROFILE — reconcile the path"
}

Write-Host ""
Write-Host "== summary: $script:pass pass, $script:warn warn, $script:fail fail =="
if ($script:fail -eq 0) {
  Write-Host "All hard checks passed. Address any WARN items, then verify a git push in a work repo."
  exit 0
} else {
  Write-Host "Fix the FAIL items above and re-run."
  exit 1
}
