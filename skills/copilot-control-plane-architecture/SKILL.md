---
name: copilot-control-plane-architecture
description: Build, review, refactor, and operationalize a GitHub Copilot customization control plane in a repository. Use when users ask how `.github/copilot-instructions.md`, `.github/instructions/*.instructions.md`, `.github/prompts/*.prompt.md`, `.github/agents/*.agent.md`, and `.github/workflows/*.yml` should interact, or when they ask to create/update these files directly (for example: “create a new agent”, “save this as prompt”, “add scoped instructions”, “add a governance workflow”, "create new prompt", "create new instructions file", "edit prompt", "edit instructions file").
---

# Copilot Control Plane Architecture

Design and govern the `.github/` customization stack as a layered system.

## Apply This Skill

Use this skill to:

- Explain interaction between instructions, prompts, agents, and workflows
- Define a clean folder strategy for Copilot customization
- Audit conflicting instruction files and propose deconfliction
- Plan migration from legacy `*.chatmode.md` to `*.agent.md`
- Create a practical starter blueprint for team adoption
- Create or update concrete control-plane files on request

## Execution Modes

Choose one mode based on user intent:

1. **Architecture Advisory Mode**
   - Use for analysis, audits, governance recommendations, and migration plans
   - Produce structured findings and prioritized actions

2. **File Creation Mode**
   - Use when user asks for concrete artifacts (agent, prompt, instructions, workflow)
   - Create files directly in the proper `.github/` locations using templates
   - Keep output minimal, valid, and immediately usable

3. **Refactor Mode**
   - Use when existing files are bloated, conflicting, or outdated
   - Preserve intent while consolidating duplicated or contradictory rules

## Inputs To Collect

Collect these artifacts first:

- `.github/copilot-instructions.md`
- `.github/instructions/**/*.instructions.md`
- `.github/prompts/**/*.prompt.md`
- `.github/agents/**/*.agent.md`
- `.github/workflows/**/*.yml`
- Any legacy `chatmodes/` folders or `_deactivated` archives

Then load supporting docs as needed:

- `./references/control-plane-audit-checklist.md`
- `./references/file-creation-workflows.md`
- `./references/conflict-resolution-rules.md`

## Layer Model

Treat the system as five layers:

1. **Always-on policy**: repo-wide baseline in `copilot-instructions.md`
2. **Scoped policy**: conditional rules in `.instructions.md` with `applyTo`
3. **Task playbooks**: manually invoked prompt files
4. **Role/tool guardrails**: custom agents and handoffs
5. **Enforcement automation**: CI/CD and governance workflows

Use this hierarchy to avoid policy duplication and context drift.

## Workflow

### 1) Map The Current State

- Inventory files per layer
- Identify missing layers or overlap
- Detect legacy naming (`chatmode` vs `agent`)

### 2) Check For Conflicts

- Find contradictory instructions across global and scoped files
- Flag rules duplicated in instructions, prompts, and agents
- Identify vague or low-signal trigger descriptions in skills/agents/prompts

### 3) Normalize Responsibilities

- Keep stable non-negotiables in `copilot-instructions.md`
- Keep path/language specific behavior in `.instructions.md`
- Keep reusable task procedures in `.prompt.md`
- Keep role behavior and tool restrictions in `.agent.md`
- Keep mandatory quality gates in workflows

### 4) Apply Guardrails

- Ensure read-only planner mode exists where needed
- Restrict tools by role for risky domains
- Keep autonomous workflows narrow, reviewable, and reversible

### 5) Define Migration Path

- Convert `*.chatmode.md` to `*.agent.md`
- Move active personas into `.github/agents/`
- Keep deactivated files archived but out of discovery paths

### 6) Deliver Blueprint

Provide:

- Recommended target folder layout
- Top 5 conflict fixes
- Starter set suggestion: 1 global instruction, 3 scoped instructions, 3 agents, 5 prompts
- Governance checklist for PR review

### 7) Create Files When Requested

- If user asks to create or save files, switch to File Creation Mode immediately
- Select template(s) from `./templates/` that match request intent
- Materialize artifacts in target locations:
  - `.github/agents/*.agent.md`
  - `.github/prompts/*.prompt.md`
  - `.github/instructions/*.instructions.md`
  - `.github/workflows/*.yml`
  - `.github/copilot-instructions.md`
- Validate naming, frontmatter, and minimal required sections
- Summarize what was created and where

## File Creation Routing

Map user requests to templates:

- “create a new agent” → `./templates/agent-template.agent.md`
- “save this as prompt” → `./templates/prompt-template.prompt.md`
- “add scoped rule/instruction” → `./templates/instruction-template.instructions.md`
- “add repository workflow” → `./templates/workflow-template.yml`
- “create global copilot instructions” → `./templates/copilot-instructions-template.md`

For complete creation flow and fill-in guidance, follow:

- `./references/file-creation-workflows.md`

## Quality Bar

Ensure output is:

- **Layered**: each rule lives in one canonical place
- **Non-conflicting**: no competing directives across instruction files
- **Actionable**: includes migration and rollout steps
- **Auditable**: includes explicit validation checkpoints
- **Operational**: can produce requested artifacts directly

## Anti-Patterns

Avoid:

- Storing enforcement-only rules in prompt files
- Repeating identical rules in instructions, prompts, and agents
- Long monolithic instruction files without scoping
- Unrestricted agent tool access in high-risk repositories
- Creating files without matching repository conventions

## Output Template

Use this structure for deliverables:

1. **BLUF** — one-paragraph architecture summary
2. **Current State** — what exists now by layer
3. **Gaps/Conflicts** — highest-impact issues
4. **Target Architecture** — recommended structure
5. **Migration Plan** — phased rollout
6. **Governance** — review checklist + ownership

For file-creation requests, use this structure:

1. **Intent Mapping** — what file type(s) requested
2. **Artifacts Created** — exact paths created/updated
3. **Template Source** — which template(s) were applied
4. **Validation Checks** — naming/frontmatter/tool constraints
5. **Next Optional Step** — one suggested follow-up

## Reference Facts To Preserve

Anchor recommendations on these facts:

- Repo instructions are always-on context
- Scoped instruction files are conditionally applied via file globs
- Prompt files are invoked on demand
- Agent files define role behavior and tool boundaries
- Workflows provide enforceable execution and compliance
