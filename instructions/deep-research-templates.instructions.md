---
name: "Deep Research Templates — Quick Guide"
applyTo: ".github/skills/deep-research/templates/**"
---

# Deep Research Template Guide

## When to Use Which Template

| Template | Use When | Required? |
|----------|----------|-----------|
| `research-log.md` | Starting any research session | Always — IPC channel between agents |
| `source-assessment.md` | Completing Tier 2 (Process) | Always |
| `research-brief.md` | Completing Tier 5 (Synthesize) | Always — final output |
| `synthesis-report.md` | Complex multi-theme topics | Optional — for depth |

## Quick Rules

1. **Start every session** with a Research Log — it's the IPC channel between all subagents
2. **Fill the Source Assessment** during Tier 2 — don't skip quality ratings
3. **The Research Brief is the deliverable** — write it even for quick research
4. **Replace all `{{placeholders}}`** — no template variables in final output
5. **Confidence levels matter** — always state High/Medium/Low with justification
6. **Store artifacts** in the project's working directory or reference directory

## Tier → Template → Agent Mapping

```
Tier 1 (Gather)    → research-log.md (search queries)    ← deep-research.gather
Tier 2 (Process)   → source-assessment.md                ← deep-research.process
                   → research-log.md (bookmarking)       ← deep-research.bookmark
Tier 3 (Read)      → research-log.md (extraction notes)  ← deep-research.extract
Tier 4 (Evaluate)  → research-log.md (evaluation)        ← deep-research.evaluate
Tier 5 (Synthesize) → research-brief.md + synthesis-report.md ← deep-research.synthesize
```

## IPC Status Fields

Every tier section in `research-log.md` has status/gate fields for inter-agent communication:
- `**Status**: pending | in-progress | completed | failed`
- `**Gate**: pending | passed | failed | <reason>`

The orchestrator reads these after each subagent returns to decide the next step.

## Integration

- Key findings → create Zettelkasten `permanent` notes
- Important sources → create Zettelkasten `literature` notes
- Topic cluster (5+ notes) → create Zettelkasten `structure` note
