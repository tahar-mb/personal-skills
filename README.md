# Personal Claude Code Skills

A collection of custom skills compatible with **Claude Code**, **Hermes**, and **Cursor**.

## Quick Install

### macOS

```bash
curl -fsSL https://raw.githubusercontent.com/tahar-mb/personal-skills/main/install-macos.sh | bash
```

### Linux

```bash
curl -fsSL https://raw.githubusercontent.com/tahar-mb/personal-skills/main/install-linux.sh | bash
```

### Windows (PowerShell 5+)

```powershell
iwr -useb https://raw.githubusercontent.com/tahar-mb/personal-skills/main/install.ps1 | iex
```

### Install for a specific tool

```bash
# macOS / Linux (replace script name as needed)
curl -fsSL https://raw.githubusercontent.com/tahar-mb/personal-skills/main/install-macos.sh | bash -s -- --cursor
curl -fsSL https://raw.githubusercontent.com/tahar-mb/personal-skills/main/install-linux.sh | bash -s -- --hermes

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
./uninstall
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
  install              # local install (any OS)
  install-macos.sh     # macOS remote one-liner
  install-linux.sh     # Linux remote one-liner
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
