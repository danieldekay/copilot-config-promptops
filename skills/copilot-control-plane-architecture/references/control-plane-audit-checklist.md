# Control Plane Audit Checklist

Use this checklist when auditing a repository's Copilot customization control plane.

## Layer Inventory

- [ ] `.github/copilot-instructions.md` exists or explicit reason documented
- [ ] `.github/instructions/` contains scoped files with clear `applyTo`
- [ ] `.github/prompts/` contains task-oriented, reusable prompts
- [ ] `.github/agents/` contains role-oriented agents with clear tool scope
- [ ] `.github/workflows/` contains governance/enforcement automation

## Conflict & Duplication

- [ ] No contradictory rule exists between global and scoped instructions
- [ ] No policy duplicated across instructions, prompts, and agents unless justified
- [ ] Prompt files do not carry mandatory enforcement that belongs in workflows
- [ ] Agent behavior does not conflict with instruction constraints

## Naming & Discovery

- [ ] Agent files use `*.agent.md`
- [ ] Prompt files use `*.prompt.md`
- [ ] Scoped instructions use `*.instructions.md`
- [ ] Legacy `chatmode` files are migrated or intentionally archived

## Governance Readiness

- [ ] Ownership of each layer is defined
- [ ] Review checklist is included in PR process
- [ ] High-risk repos have stricter agent tool constraints
- [ ] Changes to control-plane files are reviewed like source code

## Output Summary Format

Use this summary:

1. Current State (by layer)
2. Top 5 issues
3. Quick wins (1-3 days)
4. Structural fixes (1-2 weeks)
5. Governance recommendation
