# Personal Claude Code Skills

A collection of custom Claude Code skills (slash commands).

## Install

### Method 1: One-liner (no clone)

```bash
curl -fsSL https://raw.githubusercontent.com/tahar-mb/personal-skills/main/install.sh | bash
```

Downloads and installs directly — no clone needed.

### Method 2: Clone + install

```bash
git clone https://github.com/tahar-mb/personal-skills
cd personal-skills
./install
```

### Method 3: Plugin marketplace (from within Claude Code)

```
/plugin marketplace add tahar-mb/personal-skills
/plugin install personal-skills@personal-skills
```

Skills are namespaced — use `/personal-skills:skill-audit`.

### Install a single skill

```bash
./install <skill-name>
```

### Uninstall

```bash
./uninstall          # remove all skills installed from this repo
./uninstall <name>   # remove a specific skill
```

## Structure

```
personal-skills/
  install            # local install (clone first)
  install.sh         # remote install (pipe from curl)
  uninstall          # remove installed skills
  .claude-plugin/    # plugin marketplace support
    plugin.json
    marketplace.json
  skills/
    <skill-name>/
      SKILL.md       # skill definition
```

## Skills

| Skill | Description |
|-------|-------------|
| `skill-audit` | Read-only security audit of Claude Code skills |
