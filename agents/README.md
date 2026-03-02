# Agent Workflow Documentation

This directory contains agent definitions for automated code quality and version control workflows.

## Available Agents

### 1. Code Review Agent (`code-review.agent.md`)

**Purpose**: Perform thorough code reviews of staged or changed files.

**Features**:

- Analyzes code for logic errors, type safety, security issues, performance problems
- Detects code smells and technical debt
- Creates structured review artifacts when a spec is active
- Outputs findings organized by severity (Critical / Major / Minor)

**Artifacts created** (when spec is active):

- `code-review.md` — Primary review findings
- `code-smells.md` — Code smell inventory
- `tech-debt.md` — Technical debt items
- `improvement-plan.md` — Prioritized action items
- `future-improvements.md` — Long-term enhancements

**Usage**:

```bash
# Review all staged files
[Invoke code-review agent]

# Review specific files
[Invoke code-review agent with file paths]
```

### 2. Code Fix Agent (`code-fix.agent.md`)

**Purpose**: Automatically fix issues identified in code review artifacts.

**Features**:

- Reads code review artifacts and extracts fixable issues
- Prioritizes fixes by severity (Critical → Major → Smells → Minor)
- Implements fixes systematically with verification after each change
- Updates review artifacts to reflect fix status
- Creates detailed fix report (`FIX_UPDATE.md`)

**What it fixes**:

- ✅ Critical issues (mandatory)
- ✅ Major issues (mandatory)
- ✅ High-severity code smells (recommended)
- ✅ P0/P1 technical debt (recommended)
- ⏭️ Minor issues (skipped by default, unless requested)

**Safety features**:

- Runs type check after each fix
- Runs tests after each fix
- Reverts fixes that break tests or types
- Never bypasses safety checks

**Usage**:

```bash
# Fix all critical and major issues
[Invoke code-fix agent]

# Fix specific issues or files
[Invoke code-fix agent with issue IDs or file paths]
```

### 3. Commit Agent (`commit.agent.md`)

**Purpose**: Create conventional commits with automated code review and optional auto-fix.

**Features**:

- Orchestrates code-review → code-fix → commit workflow
- Checks for existing reviews to avoid duplication
- Groups changes into semantic/logical commits
- Supports user decision points (auto-fix vs. manual fix vs. commit as-is)
- Creates conventional commit messages automatically

**Commit grouping strategy**:

- **Types** — Type definition changes
- **Validation** — Schema and validator changes
- **Components** — UI component changes
- **Tests** — Test file changes
- **Config** — Configuration changes
- **Docs** — Documentation changes
- **Specs** — Specification and planning docs
- **Code Review** — Review artifacts

**Usage**:

```bash
# Commit all changes with review + auto-fix
[Invoke commit agent]

# Commit with custom message
[Invoke commit agent with message]

# Commit specific files
[Invoke commit agent with file paths]
```

### 4. Codebase Audit Agent (`codebase-audit.agent.md`)

**Purpose**: Orchestrate a comprehensive codebase audit using five specialized subagents.

**Features**:

- Analyzes all source files for structure, patterns, complexity, and quality
- Updates documentation, docstrings, and type annotations
- Generates architecture documentation in `docs/understanding/`
- Produces improvement proposals (refactorings, improvements S/M/L, upside potentials)
- Assesses codebase against 2026 modern patterns and standards

**Subagents**:

- **Codebase Analyze** (`codebase-analyze.agent.md`) — Per-file structural analysis (read-only)
- **Codebase Doc Updater** (`codebase-doc-updater.agent.md`) — Updates docblocks and type hints
- **Codebase Architecture Docs** (`codebase-arch-docs.agent.md`) — Generates architecture documentation
- **Codebase Proposals** (`codebase-proposals.agent.md`) — Refactoring and improvement proposals
- **Codebase Modern Patterns** (`codebase-modern-patterns.agent.md`) — 2026 standards assessment

**Artifacts created** (in `docs/understanding/`):

- `AUDIT_REPORT.md` — Executive summary and statistics
- `architecture.md` — System architecture overview
- `patterns.md` — Design patterns catalog
- `dependencies.md` — Dependency graph
- `data-flow.md` — Key data flows
- `conventions.md` — Coding conventions
- `proposals.md` — Prioritized improvement roadmap
- `modern-patterns.md` — 2026 standards gap analysis
- `components/*.md` — Component deep dives

**Usage**:

```bash
# Full codebase audit
[Invoke codebase-audit agent]

# Audit a specific directory
[Invoke codebase-audit agent with "src/Services"]

# Audit a specific file
[Invoke codebase-audit agent with "src/Core.php"]

# Skip documentation updates (analysis + proposals only)
[Invoke codebase-audit agent with "--skip-docs-update"]

# Proposals only (reuse existing analysis)
[Invoke codebase-audit agent with "--proposals-only"]
```

**Handoffs**:

- → **Code Fix Agent**: Implement quick wins from proposals
- → **Commit Agent**: Commit documentation and type annotation updates

### 5. Engineering Manager Agent (`engineering-manager.agent.md`)

**Purpose**: Orchestrate bug fixes and feature work **outside** the spec-kit flow.

**Features**:

- Routes requests into practical modes: Fix, Feature, Review, Audit, Ship
- Delegates to specialized agents instead of monolithic flows
- Uses Codebase Analyze + Proposals to reduce risk before implementing new features
- Keeps execution lightweight: no required `spec.md` / `plan.md` / `tasks.md`
- Supports finalization via Commit Agent after verification

**Subagents used**: Code Review, Code Fix, Codebase Analyze, Codebase Proposals, Codebase Audit, Commit Agent.

### 6. Codebase Cartographer (`codebase-cartographer.agent.md`)

**Purpose**: Explore and document an existing codebase (GitHub or local) into structured `understanding/` documents.

**Subagents** (3-phase pipeline):

| Phase | Agent | What it does |
|-------|-------|--------------|
| 1 — Scan | `codebase-cartographer.scan` | Structure, tech stack, key files, health signals |
| 2 — Analyze | `codebase-cartographer.analyze` | Architecture patterns, domain model, code quality |
| 3 — Map | `codebase-cartographer.map` | Synthesizes into 6 understanding documents |

**Artifacts created** (in `understanding/`):

- `OVERVIEW.md` — Executive summary
- `architecture.md` — System architecture
- `domain-model.md` — Core entities and relationships
- `tech-stack.md` — Technology inventory
- `conventions.md` — Code conventions and patterns
- `entry-points.md` — Key files and navigation guide

### 7. Deep Research Pipeline (`deep-researcher.agent.md`)

**Purpose**: 5-tier research pipeline from broad data collection to structured synthesis.

**Subagents** (5 tiers + utility):

| Tier | Agent | What it does |
|------|-------|--------------|
| 1 — Gather | `deep-research.gather` | Broad data collection: 7–10 varied queries across web, bookmarks, internal |
| 2 — Process | `deep-research.process` | Triage and classify sources into 5 quality tiers |
| 3 — Extract | `deep-research.extract` | Deep reading and structured knowledge extraction |
| 4 — Evaluate | `deep-research.evaluate` | Cross-reference, triangulate, assign confidence scores |
| 5 — Synthesize | `deep-research.synthesize` | Transform evidence into knowledge artifacts |
| Utility | `deep-research.bookmark` | Archive sources to Raindrop.io |

### 8. Spec-Kit Extended Agents

In addition to the core spec-kit workflow (orchestrator, specify, clarify, plan, tasks, implement, review, analyze, checklist, constitution), the following agents provide lifecycle integration:

| Agent | Purpose |
|-------|---------|
| `speckit.agent.md` | Full 9-stage lifecycle orchestrator (proactive state detection) |
| `speckit.quality-gate.agent.md` | 7-check automated gate: format, lint, type, test, coverage, security, architecture |
| `speckit.autofix.agent.md` | Bounded auto-fix of quality gate failures (max 3 iterations) |
| `speckit.commit.agent.md` | Conventional commit with pre-commit verification |
| `speckit.retro.agent.md` | Retrospective: capture lessons, propose improvements |

### 9. Knowledge Management Agents

| Agent | Purpose |
|-------|---------|
| `literature-reviewer.agent.md` | Academic literature review using Pacheco-Vega AIC method |
| `zk.agent.md` | Zettelkasten note management (MCP-backed) |
| `zk-orchestrator.agent.md` | Routes knowledge work to workflows, lifecycle management |

### 10. Standalone Agents

| Agent | Purpose |
|-------|---------|
| `prompt-builder.agent.md` | Dual-persona prompt engineering (Builder + Tester) |
| `prompt-engineer.agent.md` | Prompt analysis against OpenAI best practices |
| `wg-code-alchemist.agent.md` | JARVIS-inspired Clean Code refactoring |
| `janitor.agent.md` | Tech debt elimination (deletion-first) |
| `r-datascientist.agent.md` | R + Tufte-quality data analysis |
| `research-technical-spike.agent.md` | Technical spike research and documentation |
| `plan.agent.md` | General planning agent |
| `prd.agent.md` | Product requirements document generation |
| `planner.agent.md` | Lightweight planning |
| `playwright-tester.agent.md` | Playwright test authoring |

---

## Integrated Workflow

The three agents work together in a coordinated workflow:

```
┌─────────────────────────────────────────────────────────────────┐
│                     USER: Invoke Commit                         │
└───────────────────────────────┬─────────────────────────────────┘
                                │
                                ▼
                    ┌───────────────────────┐
                    │   COMMIT AGENT        │
                    │ ─────────────────────  │
                    │ 1. Preflight check    │
                    │ 2. Check for review   │
                    └───────────┬───────────┘
                                │
                    ┌───────────┴───────────┐
                    │  Review exists?       │
                    └───────────┬───────────┘
                                │
                    ╔═══════════╩═══════════╗
                    ║         NO            ║
                    ╚═══════════╦═══════════╝
                                ▼
                    ┌───────────────────────┐
                    │  CODE REVIEW AGENT    │
                    │ ───────────────────── │
                    │ • Analyze all changes │
                    │ • Create artifacts    │
                    │ • Return assessment   │
                    └───────────┬───────────┘
                                │
                    ╔═══════════╩═══════════╗
                    ║  Issues found?        ║
                    ╚═══════════╦═══════════╝
                                │
                    ╔═══════════╩═══════════╗
                    ║         YES           ║
                    ╚═══════════╦═══════════╝
                                ▼
                    ┌───────────────────────┐
                    │  Check FIX_UPDATE.md  │
                    └───────────┬───────────┘
                                │
                    ╔═══════════╩═══════════╗
                    ║     Exists?           ║
                    ╚═══════════╦═══════════╝
                                │
                    ╔═══════════╩═══════════╗
                    ║          NO           ║
                    ╚═══════════╦═══════════╝
                                ▼
                    ┌───────────────────────┐
                    │  ASK USER:            │
                    │  • Auto-fix           │
                    │  • Skip fixes         │
                    │  • Cancel             │
                    └───────────┬───────────┘
                                │
                    ╔═══════════╩═══════════╗
                    ║    Auto-fix chosen    ║
                    ╚═══════════╦═══════════╝
                                ▼
                    ┌───────────────────────┐
                    │  CODE FIX AGENT       │
                    │ ───────────────────── │
                    │ • Fix Critical/Major  │
                    │ • Verify each fix     │
                    │ • Create FIX_UPDATE   │
                    └───────────┬───────────┘
                                │
                                ▼
                    ┌───────────────────────┐
                    │  COMMIT AGENT         │
                    │ ───────────────────── │
                    │ • Group changes       │
                    │ • Create commits      │
                    │ • Show summary        │
                    └───────────────────────┘
```

## State Management

The agents use filesystem artifacts to coordinate:

| File                  | Purpose              | Created By  | Used By          |
| --------------------- | -------------------- | ----------- | ---------------- |
|-----------------------|----------------------|-------------|------------------|
| `code-review.md`      | Review findings      | Code Review | Commit, Code Fix |
| `FIX_UPDATE.md`       | Fix status tracker   | Code Fix    | Commit           |
| `code-smells.md`      | Code smell inventory | Code Review | Code Fix         |
| `tech-debt.md`        | Technical debt log   | Code Review | Code Fix         |
| `improvement-plan.md` | Action items         | Code Review | Code Fix         |

**Benefits of this approach**:

- ✅ Idempotent — Can safely re-run agents without duplication
- ✅ Resumable — Can interrupt and resume workflow
- ✅ Traceable — Full audit trail of review → fix → commit
- ✅ Efficient — Skips unnecessary work (no redundant reviews)

## Performance Optimization

### Caching Strategy

1. **Review caching**: If `code-review.md` exists and is recent, reuse it
2. **Fix caching**: If `FIX_UPDATE.md` exists, fixes are already applied
3. **Semantic grouping**: Multiple related commits reduce noise

### Token Efficiency

- The commit agent checks for existing artifacts before delegating
- Code-fix agent batches file edits to reduce tool invocations
- Review artifacts are structured for easy parsing

### Time Savings

Typical workflow times:

- **Code review**: 30-60 seconds (depending on file count)
- **Code fix**: 60-180 seconds (depending on issue count)
- **Commit**: 10-20 seconds (after review/fixes)

**With caching**:

- Second commit after review: ~10 seconds (skips review)
- After manual fixes: ~10 seconds (detects FIX_UPDATE.md)

## Safety Guarantees

All agents follow strict safety rules:

### Never:

- ❌ Push code without user confirmation
- ❌ Use `--force`, `--no-verify`, or `--amend` without user approval
- ❌ Commit secrets, credentials, or private keys
- ❌ Bypass type checking or tests
- ❌ Modify code without verification

### Always:

- ✅ Run type check after fixes
- ✅ Run tests after fixes
- ✅ Ask user confirmation for critical decisions
- ✅ Provide clear summaries and status updates
- ✅ Preserve existing code patterns and conventions

## Configuration

Agents are configured in the frontmatter of each `.agent.md` file:

```yaml
---
description: "Agent description"
tools: [list of allowed tools]
agents: [list of subagents this agent can delegate to]
model: Claude Sonnet 4.5 (copilot)
name: Agent Name
target: vscode
argument-hint: "Hint for user input"
handoffs: [list of handoff options to other agents]
---
```

## Maintenance

### Adding a New Agent

1. Create `.github/agents/your-agent.agent.md`
2. Define frontmatter with required fields
3. Document workflow in markdown
4. Add handoffs to integrate with existing agents
5. Update this README with agent description

### Modifying an Agent

1. Update the agent's `.agent.md` file
2. Test the workflow manually
3. Update integration documentation if needed
4. Commit with `docs(agents): update [agent-name] workflow`

### Debugging Agent Issues

1. Check agent logs in VS Code output panel
2. Verify tool permissions in frontmatter
3. Ensure subagent references are correct
4. Check that required artifacts exist

## Best Practices

### When to Use Each Agent

| Scenario                                | Agent to Invoke                      |
| --------------------------------------- | ------------------------------------ |
| Just want to commit changes quickly     | Commit Agent (it handles everything) |
| Want detailed review without committing | Code Review Agent                    |
| Have review artifacts, need fixes       | Code Fix Agent                       |
| Committing after manual fixes           | Commit Agent (it detects fixes)      |
| Scenario                                    | Agent to Invoke                      |
|---------------------------------------------|--------------------------------------|
| Just want to commit changes quickly         | Commit Agent (it handles everything) |
| Want detailed review without committing     | Code Review Agent                    |
| Have review artifacts, need fixes           | Code Fix Agent                       |
| Committing after manual fixes               | Commit Agent (it detects fixes)      |
| Deep codebase analysis + proposals          | Codebase Audit Agent                 |
| Explore an unfamiliar codebase              | Codebase Cartographer                |
| Update docs/types for specific files        | Codebase Doc Updater                 |
| Generate architecture documentation         | Codebase Architecture Docs           |
| Assess modernization opportunities          | Codebase Modern Patterns             |
| Fix bugs or build features outside spec-kit | Engineering Manager Agent            |
| Research a topic with evidence synthesis     | Deep Researcher                      |
| Full spec-to-commit development lifecycle   | Spec-Kit Orchestrator (speckit.agent)|
| Run quality gate checks                     | speckit.quality-gate                 |
| Academic literature review                  | Literature Reviewer                  |
| Knowledge management (notes)               | Zettelkasten (zk)                    |
| Build or improve prompts                    | Prompt Builder                       |
| Refactor code (Clean Code)                  | WG Code Alchemist                    |
| Eliminate tech debt                         | Janitor                              |

### Workflow Recommendations

1. **Standard workflow**:
   - Invoke Commit Agent → it handles review → user chooses auto-fix → done

2. **Review-first workflow**:
   - Invoke Code Review Agent → read findings → fix manually → Invoke Commit Agent

3. **Auto-fix workflow**:
   - Invoke Commit Agent → choose auto-fix → review FIX_UPDATE.md → approve commits

4. **Iterative workflow**:
   - Invoke Code Review → Invoke Code Fix → Invoke Code Review again (verify) → Invoke Commit

5. **Codebase audit workflow**:
   - Invoke Codebase Audit → review proposals → implement quick wins → Commit Agent

6. **Targeted audit workflow**:
   - Invoke Codebase Audit with `src/Services` → review findings → fix manually → Commit Agent

### Tips

- **Use argument hints**: Pass specific files or scopes to focus agents
- **Check artifacts**: Review `code-review.md` and `FIX_UPDATE.md` before committing
- **Trust but verify**: Auto-fixes are safe, but always review the diff
- **Semantic commits**: Let Commit Agent group changes — results in cleaner history

## Troubleshooting

### Agent isn't detecting existing review

**Cause**: Review artifacts in unexpected location  
**Cause**: Review artifacts in unexpected location
**Fix**: Ensure `.specify/scripts/bash/check-prerequisites.sh` exists and is executable

### Code Fix Agent skips all issues

**Cause**: Issues may already be fixed or validation failed  
**Cause**: Issues may already be fixed or validation failed
**Fix**: Check Verify Fix section of FIX_UPDATE.md for details

### Commit Agent creates too many commits

**Cause**: Changes span many semantic groups  
**Cause**: Changes span many semantic groups
**Fix**: Stage specific files with `git add` before invoking agent

### Type errors after fixes

**Cause**: Fix introduced type incompatibility  
**Cause**: Fix introduced type incompatibility
**Fix**: Code Fix Agent auto-reverts failed fixes — check skipped issues in FIX_UPDATE.md

## Future Enhancements

Planned improvements:

- [ ] Support for custom commit templates
- [ ] Integration with GitHub Issues (auto-link commits to issues)
- [ ] Configurable fix priorities (per-project)
- [ ] Machine learning for better semantic grouping
- [ ] Parallel fix execution for unrelated issues
- [ ] Integration with CI/CD pipelines

## References

- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Spec Kit Documentation](../skills/spec-kit/SKILL.md)
