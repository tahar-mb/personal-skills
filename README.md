# Personal Claude Code Skills

A collection of custom skills compatible with **Claude Code**, **Hermes**, and **Cursor**.

## Quick Install

### One-liner (no clone)

```bash
# Install to all supported tools
curl -fsSL https://raw.githubusercontent.com/tahar-mb/personal-skills/main/install.sh | bash

# Or to a specific tool
curl -fsSL https://raw.githubusercontent.com/tahar-mb/personal-skills/main/install.sh | bash -s -- --cursor
curl -fsSL https://raw.githubusercontent.com/tahar-mb/personal-skills/main/install.sh | bash -s -- --hermes
```

### Clone + install

```bash
git clone https://github.com/tahar-mb/personal-skills
cd personal-skills
./install              # all tools
./install --cursor      # cursor only
./install --claude --hermes  # specific tools
```

### Plugin marketplace (Claude Code only)

```
/plugin marketplace add tahar-mb/personal-skills
/plugin install personal-skills@personal-skills
```

### Install a single skill

```bash
./install --claude skill-audit
```

### Uninstall

```bash
./uninstall
```

## Targets

| Flag | Tool | Install path |
|------|------|-------------|
| `--claude` | Claude Code | `~/.claude/skills/` |
| `--hermes` | Hermes Agent | `~/.hermes/skills/` |
| `--cursor` | Cursor | `~/.cursor/skills/` |

Default (no flag) installs to all three.

## Structure

```
personal-skills/
  install            # local install
  install.sh         # remote install (pipe from curl)
  uninstall          # remove installed skills
  .claude-plugin/    # Claude Code plugin marketplace
  skills/
    <name>/
      SKILL.md       # skill definition
```

## Skills

| Skill | Description |
|-------|-------------|
| `skill-audit` | Read-only security audit of Claude Code skills |
