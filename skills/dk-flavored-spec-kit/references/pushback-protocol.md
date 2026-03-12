# Pushback Protocol

Agents that can say "this is a bad idea" before implementing save more time than agents that implement the wrong thing fast.

## When to Push Back

Pushback is NOT for every task. It triggers only when:

### Mandatory (🔴 tasks)

Every 🔴 risk task gets a **pre-execution evaluation**. The implement agent must:

1. Read the task description and affected files
2. Grep the codebase for existing code in the same area
3. Evaluate whether the task description is sufficient for safe execution
4. If ANY concern → pushback before implementing

### Situational (any task)

| Trigger                         | Example                                                                      |
| ------------------------------- | ---------------------------------------------------------------------------- |
| **Conflict with existing code** | Task says "create DateFormatter" but one already exists                      |
| **Requirement gap**             | Task requires auth behavior but spec doesn't define token lifecycle          |
| **Scope exceeds description**   | Task says "add field" but requires schema migration + API change + UI update |
| **Tech debt introduction**      | Implementation would duplicate logic that should be shared                   |
| **Safety concern**              | Task involves deletion without confirmation, or hardcoded credentials        |

### Never push back for

- Style preferences (that's what lint is for)
- Minor naming suggestions (note it, don't block)
- Hypothetical future concerns (YAGNI)
- Things already decided in the spec/plan

## Pushback Format

When pushing back, the implement agent uses this structure:

```markdown
⚠️ **Pushback — [Task ID]**: [One-line summary]

**Concern**: [Detailed explanation of the problem]

**Options**:
A. [First option with tradeoffs]
B. [Second option with tradeoffs]
C. Escalate to user for decision

**Recommendation**: [Which option and why]
```

## askQuestions Flow

The implement agent uses `askQuestions` to escalate to the orchestrator:

```
implement → askQuestions → orchestrator
```

The orchestrator triages the pushback:

| Pushback Type                  | Orchestrator Action                                  |
| ------------------------------ | ---------------------------------------------------- |
| Implementation choice (A vs B) | Approve one option directly                          |
| Requirement gap                | Route to `speckit.clarify` → return clarified answer |
| Architecture question          | Route to `speckit.plan` → return design decision     |
| User decision needed           | Escalate to user via `askQuestions`                  |
| Safety concern                 | Always escalate to user                              |

## Frequency Budget

- **Target**: 0-2 pushbacks per implementation cycle
- **If pushback count > 2**: Suggests the spec/plan was undercooked → orchestrator should consider re-routing to `speckit.clarify` or `speckit.plan`
- **If pushback count = 0 on a cycle with 🔴 tasks**: Review should flag this — 🔴 tasks that didn't trigger any evaluation deserve scrutiny

## Logging

All pushbacks are recorded in `evidence-ledger.json` under each task's `pushbacks` array. This data feeds into `dk.speckit.retro` for compound learning.

## Reuse Detection (related)

Before implementing, scan for existing code that overlaps with the task:

```
grep -r "function_name\|ClassName\|similar_pattern" src/
```

If existing code covers >50% of the task intent:

```markdown
♻️ **Reuse detected — [Task ID]**: Found `existing_function()` in `path/to/file.py` that handles [X].

**Options**:
A. Reuse as-is (covers requirement fully)
B. Extend with [specific addition]
C. Create new (justify why existing doesn't work)

**Recommendation**: [Which option]
```

Log in `evidence-ledger.json` under `reuse_detected`. Reuse is always preferred over new code.
