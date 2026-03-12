# Artifact Registry

All artifacts in the dk-flavored spec-kit pipeline, who creates them, and where they live.

## Artifact Locations

All spec artifacts live under:

```
specs/<NNN>-<name>/
```

## Registry

| Artifact                   | Created By               | Location                  | Format              | Consumed By                            |
| -------------------------- | ------------------------ | ------------------------- | ------------------- | -------------------------------------- |
| `constitution.md`          | speckit.constitution     | `.specify/memory/`        | Markdown            | All agents (principles)                |
| `spec.md`                  | speckit.specify          | `specs/<NNN>/`            | Markdown            | plan, tasks, review, implement         |
| `plan.md`                  | speckit.plan             | `specs/<NNN>/`            | Markdown            | tasks, implement, review, quality-gate |
| `data-model.md`            | speckit.plan             | `specs/<NNN>/`            | Markdown            | tasks, implement                       |
| `contracts/`               | speckit.plan             | `specs/<NNN>/contracts/`  | Markdown            | tasks, implement                       |
| `research.md`              | speckit.plan             | `specs/<NNN>/`            | Markdown            | tasks, implement                       |
| `tasks.md`                 | dk.speckit.tasks         | `specs/<NNN>/`            | Markdown checklist  | implement, orchestrator, review        |
| `checklists/`              | speckit.checklist        | `specs/<NNN>/checklists/` | Markdown checklists | implement (gate)                       |
| `ui-analysis.md`           | dk.speckit.ui            | `specs/<NNN>/`            | Markdown            | plan, tasks                            |
| `ui-components.md`         | dk.speckit.ui            | `specs/<NNN>/`            | Markdown            | tasks, implement                       |
| `ui-integration.md`        | dk.speckit.ui            | `specs/<NNN>/`            | Markdown            | tasks, implement                       |
| **`evidence-ledger.json`** | **dk.speckit.implement** | `specs/<NNN>/`            | **JSON**            | **review, retro**                      |
| `gate-report.md`           | dk.speckit.quality-gate  | `specs/<NNN>/`            | Markdown            | autofix, orchestrator, commit          |
| `review-report.md`         | dk.speckit.review        | `specs/<NNN>/`            | Markdown            | orchestrator, commit                   |
| `reviews/`                 | dk.speckit.review        | `specs/<NNN>/reviews/`    | Markdown (multiple) | orchestrator, commit                   |
| `retro.md`                 | dk.speckit.retro         | `specs/<NNN>/`            | Markdown            | orchestrator (compound learning)       |

## New Artifacts (Anvil-enhanced)

| Artifact               | Purpose                                             | Schema                                       |
| ---------------------- | --------------------------------------------------- | -------------------------------------------- |
| `evidence-ledger.json` | Per-task verification evidence with tool-call proof | See [evidence-ledger.md](evidence-ledger.md) |

## Artifact Gates

The orchestrator enforces these gates before routing to the next stage:

| Gate                     | Required Artifact  | Criteria                                   |
| ------------------------ | ------------------ | ------------------------------------------ |
| Spec → Plan              | `spec.md`          | Exists, no `[NEEDS CLARIFICATION]` markers |
| Plan → Tasks             | `plan.md`          | Exists with tech stack + architecture      |
| Tasks → Implement        | `tasks.md`         | Exists with checklist-format tasks         |
| Implement → Quality Gate | `tasks.md`         | All tasks `[X]`                            |
| Quality Gate → Review    | `gate-report.md`   | Overall: PASSED                            |
| Review → Commit          | `review-report.md` | No unresolved CRITICAL findings            |
| Commit → Retro           | Git commit         | Exists with conventional format            |

## Artifact Ownership Rules

1. **Only the creating agent writes to an artifact** — other agents read only
2. **Exception**: `spec.md` can be updated by `speckit.clarify` (in-place amendments)
3. **Exception**: `tasks.md` is updated by `dk.speckit.implement` (marking `[X]`)
4. **The orchestrator NEVER writes artifacts** — it only reads for gate checks
