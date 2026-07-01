# Personal Claude Code Skills

A collection of custom Claude Code skills (slash commands).

## Install

```bash
git clone <repo-url>
cd personal-skills
./install
```

This copies all skills into `~/.claude/skills/`. Restart Claude Code or start a new session, then use `/skill-name` to invoke a skill.

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
  install            # installs skills into ~/.claude/skills/
  uninstall          # removes installed skills
  <skill-name>/
    SKILL.md         # skill definition (required)
    ...              # optional supporting files
```

## Skills

| Skill | Description |
|-------|-------------|
| `skill-audit` | Read-only security audit of Claude Code skills |
