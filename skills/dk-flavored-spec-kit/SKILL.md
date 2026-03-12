---
name: dk-flavored-spec-kit
description: "Shared knowledge base for the dk.speckit.* agent family. Defines evidence-first execution, risk classification, pushback protocol, verification strategy, and artifact contracts. Agents reference this skill to stay DRY — philosophy and formats live here, agent files focus on workflow."
risk: safe
author: danieldekay
date_added: "2026-03-12"
---

# dk-Flavored Spec-Kit

Shared knowledge base for the `dk.speckit.*` agent pipeline. This skill extracts all cross-cutting concerns so individual agent files stay focused on their workflow.

## Philosophy

The dk-flavored spec-kit extends the OOTB spec-kit pipeline with three principles borrowed from [Anvil](https://github.com/burkeholland/anvil):

1. **Evidence-first execution** — verification is recorded, not self-reported. If it's not in the ledger, it didn't happen.
2. **Risk-scaled depth** — not every task deserves the same scrutiny. Green tasks get a quick check; red tasks get adversarial review.
3. **Pushback as a feature** — agents that can say "this is a bad idea" before implementing save more time than agents that implement the wrong thing fast.

## Agent Family

| Agent | Role | Key Anvil Enhancement |
|-------|------|-----------------------|
| `dk.speckit.main` | Lifecycle orchestrator (GPT-5) | Git hygiene, pushback triage |
| `dk.speckit.orchestrator` | State detection & routing (Sonnet) | Pushback routing, ledger-aware gates |
| `dk.speckit.tasks` | Task breakdown with risk labels | 🟢🟡🔴 risk + S/M/L sizing |
| `dk.speckit.implement` | Anvil-enhanced execution | Verification ledger, pushback, reuse detection |
| `dk.speckit.quality-gate` | Automated checks | Unchanged — reads code |
| `dk.speckit.autofix` | Bounded fix loops | Ledger-aware context |
| `dk.speckit.review` | Evidence-backed review | Consumes evidence bundle, adversarial pass for 🔴 |
| `dk.speckit.commit` | Conventional commits | Unchanged |
| `dk.speckit.retro` | Compound learning | Ledger analytics |
| `dk.speckit.ui` | UI requirements analysis | Unchanged |

## How Agents Reference This Skill

Agents load specific reference files before execution:

```markdown
## Skill References

Before execution, read the following from `skills/dk-flavored-spec-kit/references/`:
- `risk-classification.md` — for interpreting 🟢🟡🔴 labels and S/M/L sizing
- `evidence-ledger.md` — for ledger format and logging rules
- `pushback-protocol.md` — for when/how to escalate via askQuestions
```

This keeps agent files focused on WHAT to do. The skill defines HOW and WHY.

## Pipeline Flow

```
User Request
    │
    ▼
dk.speckit.main / dk.speckit.orchestrator
    │ (git hygiene → state detection → routing)
    ▼
SPECIFICATION STAGES (OOTB sk-v1, unchanged)
    constitution → specify → clarify → plan → tasks
    │                                         │
    │                          dk.speckit.tasks wraps
    │                          with risk + sizing
    ▼
dk.speckit.implement
    │ (ledger, risk-scaled verify, pushback ↔ orchestrator)
    ▼
dk.speckit.quality-gate ↔ dk.speckit.autofix
    │
    ▼
dk.speckit.review (evidence audit + adversarial for 🔴)
    │
    ▼
dk.speckit.commit → dk.speckit.retro (ledger analytics)
```

## Artifact Flow

```
tasks.md (with 🟢🟡🔴 labels)
    │
    ├──→ dk.speckit.implement reads risk labels
    │         │
    │         ├──→ evidence-ledger.json (written per task)
    │         └──→ pushback-log.json (if escalations occurred)
    │
    ├──→ dk.speckit.review reads evidence-ledger.json
    │         │
    │         └──→ review-report.md (includes Evidence Audit pass)
    │
    └──→ dk.speckit.retro reads evidence-ledger.json
              │
              └──→ retro.md (includes ledger analytics)
```

## Reference Index

| Reference | Purpose | Used By |
|-----------|---------|---------|
| [risk-classification.md](references/risk-classification.md) | 🟢🟡🔴 definitions, S/M/L sizing | tasks, implement, review |
| [evidence-ledger.md](references/evidence-ledger.md) | JSON ledger schema, logging rules | implement, review, retro |
| [pushback-protocol.md](references/pushback-protocol.md) | When/how to pushback, askQuestions flow | implement, main, orchestrator |
| [verification-strategy.md](references/verification-strategy.md) | Depth scaling by risk level | implement, review |
| [artifact-registry.md](references/artifact-registry.md) | All artifacts, ownership, locations | all agents |
