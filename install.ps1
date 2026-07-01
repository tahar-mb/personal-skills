<#
.SYNOPSIS
    Install personal-skills for Claude Code, Hermes, and Cursor on Windows.
.DESCRIPTION
    Downloads skills from GitHub and installs them to the appropriate directories.
    Run from PowerShell 5+ or PowerShell Core.
.PARAMETER Target
    Which tool(s) to install for: claude, hermes, cursor. Default: all.
.PARAMETER RepoUrl
    GitHub repository URL. Default: https://github.com/tahar-mb/personal-skills
.EXAMPLE
    .\install.ps1
    .\install.ps1 -Target cursor
    .\install.ps1 -Target claude,hermes
#>

param(
  [string[]]$Target = @("claude", "hermes", "cursor"),
  [string]$RepoUrl = "https://github.com/tahar-mb/personal-skills"
)

$TargetDirs = @{
  claude = "$env:USERPROFILE\.claude\skills"
  hermes = "$env:USERPROFILE\.hermes\skills"
  cursor = "$env:USERPROFILE\.cursor\skills"
}

$ValidTargets = $Target | Where-Object { $TargetDirs.ContainsKey($_) }
if ($ValidTargets.Count -eq 0) {
  Write-Host "No valid targets. Use: claude, hermes, cursor" -ForegroundColor Red
  exit 1
}

$TmpDir = "$env:TEMP\personal-skills-$([System.IO.Path]::GetRandomFileName())"
New-Item -ItemType Directory -Path $TmpDir -Force | Out-Null

try {
  Write-Host "Downloading skills from $RepoUrl ..."
  $ArchivePath = "$TmpDir\archive.zip"
  $ArchiveUrl = "https://github.com/tahar-mb/personal-skills/archive/main.zip"
  Invoke-WebRequest -Uri $ArchiveUrl -OutFile $ArchivePath -UseBasicParsing

  Expand-Archive -Path $ArchivePath -DestinationPath $TmpDir -Force
  $ExtractedDir = "$TmpDir\personal-skills-main"

  if (-not (Test-Path $ExtractedDir)) {
    Write-Host "Error: failed to extract archive" -ForegroundColor Red
    exit 1
  }

  function Install-SkillTo {
    param([string]$Name, [string]$Src, [string]$Dst, [string]$Label)
    $ParentDir = Split-Path $Dst -Parent
    New-Item -ItemType Directory -Path $ParentDir -Force | Out-Null
    if (Test-Path $Dst) { Remove-Item -Recurse -Force $Dst }
    Copy-Item -Recurse -Path $Src -Destination $Dst
    "$RepoUrl" | Out-File -FilePath "$Dst\.installed-from" -Encoding ASCII
    Write-Host "  [$Label] Installed $Name"
  }

  foreach ($target in $ValidTargets) {
    $dest = $TargetDirs[$target]
    Write-Host "Installing to $dest ..."
    $installed = 0

    $searchBases = @("$ExtractedDir\skills", "$ExtractedDir")
    foreach ($base in $searchBases) {
      if (-not (Test-Path $base)) { continue }
      $dirs = Get-ChildItem -Directory -Path $base -ErrorAction SilentlyContinue
      foreach ($dir in $dirs) {
        $name = $dir.Name
        if ($name -eq ".git" -or $name -eq ".claude-plugin") { continue }
        $skillMd = Join-Path $dir.FullName "SKILL.md"
        if (Test-Path $skillMd) {
          Install-SkillTo -Name $name -Src $dir.FullName -Dst "$dest\$name" -Label $target
          $installed++
        }
      }
    }

    if ($installed -eq 0) {
      Write-Host "  No skills found."
    } else {
      Write-Host "  $installed skill(s) installed."
    }
  }

  Write-Host ""
  Write-Host "Done. Restart your editor to use the skills."
}
finally {
  Remove-Item -Recurse -Force $TmpDir -ErrorAction SilentlyContinue
}
