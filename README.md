# Personal Claude Code Skills

A collection of custom skills compatible with **Claude Code**, **Hermes**, and **Cursor**.

## Quick Install

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/tahar-mb/personal-skills/main/install.sh | bash
```

### Windows (PowerShell 5+)

```powershell
iwr -useb https://raw.githubusercontent.com/tahar-mb/personal-skills/main/install.ps1 | iex
```

### Install for a specific tool

```bash
curl -fsSL https://raw.githubusercontent.com/tahar-mb/personal-skills/main/install.sh | bash -s -- --cursor
curl -fsSL https://raw.githubusercontent.com/tahar-mb/personal-skills/main/install.sh | bash -s -- --hermes

# Windows
.\install.ps1 -Target cursor
.\install.ps1 -Target claude,hermes
```

### Clone + install (any OS)

```bash
git clone https://github.com/tahar-mb/personal-skills
cd personal-skills
./install              # all tools
./install --cursor     # specific tool
```

### Plugin marketplace (Claude Code only)

```
/plugin marketplace add tahar-mb/personal-skills
/plugin install personal-skills@personal-skills
```

### Uninstall

```bash
./uninstall              # all targets
./uninstall --cursor     # specific target
./uninstall --claude skill-audit  # specific skill on specific target
```

## Targets

| Flag | Tool | macOS / Linux | Windows |
|------|------|---------------|---------|
| `--claude` | Claude Code | `~/.claude/skills/` | `%USERPROFILE%\.claude\skills\` |
| `--hermes` | Hermes Agent | `~/.hermes/skills/` | `%USERPROFILE%\.hermes\skills\` |
| `--cursor` | Cursor | `~/.cursor/skills/` | `%USERPROFILE%\.cursor\skills\` |

Default (no flag) installs to all three.

## Structure

```
personal-skills/
  install              # local install (clone first)
  install.sh           # remote install (pipe from curl)
  install.ps1          # Windows PowerShell installer
  uninstall            # remove installed skills
  .claude-plugin/      # Claude Code plugin marketplace
  skills/
    <name>/
      SKILL.md         # skill definition
```

## Skills

| Skill | Description |
|-------|-------------|
| `skill-audit` | Read-only security audit of Claude Code skills |
