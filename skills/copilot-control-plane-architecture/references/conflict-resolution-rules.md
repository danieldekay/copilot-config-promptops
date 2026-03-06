# Conflict Resolution Rules

Use these rules when multiple customization files overlap.

## Priority By Purpose

- Global policy belongs in `.github/copilot-instructions.md`
- Context-specific policy belongs in `.github/instructions/*.instructions.md`
- Task workflow belongs in `.github/prompts/*.prompt.md`
- Persona and tool constraints belong in `.github/agents/*.agent.md`
- Enforceable checks belong in `.github/workflows/*.yml`

## Resolution Algorithm

1. Identify duplicate or conflicting statement
2. Classify statement by purpose
3. Move statement to canonical layer
4. Replace duplicates with brief references
5. Validate no behavior regressions

## Keep / Move / Delete Heuristic

- **Keep** if statement is unique and correctly placed
- **Move** if statement is valid but in wrong layer
- **Delete** if statement is duplicated, stale, or contradictory

## Typical Corrections

- Move hard quality gates from prompts into workflows
- Move global conventions from prompts into repo instructions
- Keep prompts task-focused and reusable
- Keep agents role-focused with explicit tool boundaries

## Output Format

Provide a table with columns:
- File
- Problem
- Action (keep/move/delete)
- Target location
- Rationale
