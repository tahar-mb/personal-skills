# Personal Claude Code Skills

A collection of my custom Claude Code skills (slash commands).

## Structure

```
personal-skills/
  <skill-name>/
    SKILL.md       # Skill definition (required)
    ...            # Optional supporting files
```

## Usage

Skills are symlinked into `~/.claude/skills/` to be available as `/` commands.

### Link all skills

```bash
./bin/link
```

### Link a single skill

```bash
./bin/link <skill-name>
```

## Skills

| Skill | Description |
|-------|-------------|
| `skill-audit` | Read-only security audit of Claude Code skills |
