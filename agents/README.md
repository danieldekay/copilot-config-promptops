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

### Workflow Recommendations

1. **Standard workflow**:
   - Invoke Commit Agent → it handles review → user chooses auto-fix → done

2. **Review-first workflow**:
   - Invoke Code Review Agent → read findings → fix manually → Invoke Commit Agent

3. **Auto-fix workflow**:
   - Invoke Commit Agent → choose auto-fix → review FIX_UPDATE.md → approve commits

4. **Iterative workflow**:
   - Invoke Code Review → Invoke Code Fix → Invoke Code Review again (verify) → Invoke Commit

### Tips

- **Use argument hints**: Pass specific files or scopes to focus agents
- **Check artifacts**: Review `code-review.md` and `FIX_UPDATE.md` before committing
- **Trust but verify**: Auto-fixes are safe, but always review the diff
- **Semantic commits**: Let Commit Agent group changes — results in cleaner history

## Troubleshooting

### Agent isn't detecting existing review

**Cause**: Review artifacts in unexpected location  
**Fix**: Ensure `.specify/scripts/bash/check-prerequisites.sh` exists and is executable

### Code Fix Agent skips all issues

**Cause**: Issues may already be fixed or validation failed  
**Fix**: Check Verify Fix section of FIX_UPDATE.md for details

### Commit Agent creates too many commits

**Cause**: Changes span many semantic groups  
**Fix**: Stage specific files with `git add` before invoking agent

### Type errors after fixes

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
