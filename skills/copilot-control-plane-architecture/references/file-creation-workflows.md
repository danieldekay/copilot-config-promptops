# File Creation Workflows

Use these workflows when users ask to create or save control-plane artifacts.

## Workflow A: Create New Agent

1. Determine agent purpose (planner, implementer, reviewer, security, docs)
2. Choose conservative tool set by default
3. Create file in `.github/agents/<name>.agent.md`
4. Add concise frontmatter: `name`, `description`, `tools`
5. Add behavior sections: role, constraints, success criteria

Template: `../templates/agent-template.agent.md`

## Workflow B: Save As Prompt

1. Determine whether prompt references an existing agent
2. Create file in `.github/prompts/<name>.prompt.md`
3. Add frontmatter: `description`, `agent`, `tools` (if needed)
4. Add clear task instructions and expected output format
5. Keep prompt procedural, avoid repository policy duplication

Template: `../templates/prompt-template.prompt.md`

## Workflow C: Add Scoped Instructions

1. Identify target scope (`applyTo` glob)
2. Create file in `.github/instructions/<name>.instructions.md`
3. Add frontmatter: `description`, `applyTo`
4. Add explicit rules for the scoped area only
5. Avoid re-stating global rules unless needed for clarity

Template: `../templates/instruction-template.instructions.md`

## Workflow D: Add Governance Workflow

1. Identify enforcement objective (lint, policy check, validation)
2. Create file in `.github/workflows/<name>.yml`
3. Start with manual trigger + PR trigger unless user requests more
4. Keep job scope narrow and observable
5. Document expected pass/fail behavior

Template: `../templates/workflow-template.yml`

## Workflow E: Create Repo-Wide Copilot Instructions

1. Ensure this should be global (not scoped)
2. Create or update `.github/copilot-instructions.md`
3. Keep concise: architecture, commands, core constraints
4. Move file-type specifics to scoped instructions
5. Confirm no contradiction with existing scoped rules

Template: `../templates/copilot-instructions-template.md`
