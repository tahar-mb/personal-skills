# Personal Claude Code Skills

A collection of custom Claude Code skills (slash commands).

## Install

```bash
git clone <repo-url>
cd personal-skills
./install
```

This symlinks all skills into `~/.claude/skills/` so they're available as `/` commands in Claude Code.

### Install a single skill

```bash
./install <skill-name>
```

### Uninstall

```bash
./uninstall          # remove all skills from this repo
./uninstall <name>   # remove a specific skill
```

## Structure

```
personal-skills/
  install            # install entry point
  uninstall          # remove symlinks
  bin/link           # symlink engine (called by install)
  <skill-name>/
    SKILL.md         # skill definition
    ...              # optional supporting files
```

## Skills

| Skill | Description |
|-------|-------------|
| `skill-audit` | Read-only security audit of Claude Code skills |
