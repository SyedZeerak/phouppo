# Install the Phouppo skill for Cursor, Claude Code, Codex, and Antigravity (Windows PowerShell).
param(
  [ValidateSet("global","project")][string]$Scope = "global",
  [string]$Agents = "cursor,claude,codex,antigravity",
  [switch]$Uninstall
)

$ErrorActionPreference = "Stop"
$SkillName = "phouppo"
$Src = Join-Path $PSScriptRoot "skills\$SkillName"
$Home_ = $env:USERPROFILE
$Cwd = (Get-Location).Path

function Get-Base($agent) {
  if ($Scope -eq "global") {
    switch ($agent) {
      "cursor"      { return Join-Path $Home_ ".cursor\skills" }
      "claude"      { return Join-Path $Home_ ".claude\skills" }
      "codex"       { return Join-Path $Home_ ".agents\skills" }
      "antigravity" { return Join-Path $Home_ ".gemini\antigravity\skills" }
    }
  } else {
    switch ($agent) {
      "cursor"      { return Join-Path $Cwd ".cursor\skills" }
      "claude"      { return Join-Path $Cwd ".claude\skills" }
      "codex"       { return Join-Path $Cwd ".agents\skills" }
      "antigravity" { return Join-Path $Cwd ".agent\skills" }
    }
  }
  return $null
}

if (-not $Uninstall -and -not (Test-Path (Join-Path $Src "SKILL.md"))) {
  throw "Cannot find $Src\SKILL.md. Run this script from the repository root."
}

foreach ($agent in ($Agents -split ",")) {
  $agent = $agent.Trim()
  $base = Get-Base $agent
  if (-not $base) { Write-Warning "Skipping unknown agent: $agent"; continue }
  $target = Join-Path $base $SkillName
  if ($Uninstall) {
    if (Test-Path $target) { Remove-Item -Recurse -Force $target }
    Write-Output "Removed: $target"
    continue
  }
  New-Item -ItemType Directory -Force -Path $base | Out-Null
  if (Test-Path $target) { Remove-Item -Recurse -Force $target }
  Copy-Item -Recurse $Src $target
  Write-Output "Installed for ${agent}: $target"
}
Write-Output "Done. Restart your agent if the skill does not appear."
