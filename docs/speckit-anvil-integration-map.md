# Spec-Kit + Anvil Integration Map

**Date**: 2026-03-12
**Purpose**: Visualize the full spec-kit pipeline (OOTB sk-v1 + dk.speckit.\* extensions), and highlight where Anvil-style improvements add the most value.

---

## 1. Full Pipeline — OOTB + dk Extensions

```mermaid
flowchart TD
    subgraph ORCH["🎯 dk.speckit.main / dk.speckit.orchestrator"]
        direction LR
        O_detect["Detect State"]
        O_route["Route to Agent"]
        O_verify["Verify Gates"]
        O_detect --> O_route --> O_verify
    end

    subgraph SPEC_STAGES["📋 SPECIFICATION STAGES (OOTB sk-v1)"]
        S1["🏛️ speckit.constitution\n• Project principles\n• Non-negotiable MUSTs"]
        S2["📝 speckit.specify\n• User stories\n• Requirements\n• Acceptance criteria"]
        S2b["❓ speckit.clarify\n• Up to 5 targeted questions\n• Updates spec in-place"]
        S3["🗺️ speckit.plan\n• Architecture + tech stack\n• data-model.md, contracts/\n• research.md"]
        S3ui["🎨 dk.speckit.ui\n• UI analysis\n• Component mapping\n• Integration points"]
        S4["📋 speckit.tasks\n• Dependency-ordered tasks\n• [P] parallelism markers\n• [USn] story labels"]
        SCK["✓ speckit.checklist\n• Requirement quality\n  validation"]
        SAN["🔍 speckit.analyze\n• Cross-artifact\n  consistency audit"]

        S1 --> S2
        S2 --> S2b
        S2b --> S3
        S3 --> S3ui
        S3ui --> S4
        S3 --> SCK
        S4 --> SAN
    end

    subgraph IMPL_STAGES["⚡ IMPLEMENTATION STAGES"]
        S5["🔨 speckit.implement (OOTB)\n• Load tasks.md\n• Validate checklists\n• Execute phases sequentially\n• Mark tasks [X]"]
    end

    subgraph QUALITY_STAGES["🛡️ QUALITY STAGES (dk extensions)"]
        S6["🚦 dk.speckit.quality-gate\n• format (black)\n• lint (ruff)\n• type-check (mypy/pyright)\n• tests (pytest)\n• coverage\n• security (bandit)"]
        S6b["🔧 dk.speckit.autofix\n• Auto-fix gate failures\n• Bounded retries (max 2)\n• Escalate if stuck"]
        S7["👁️ dk.speckit.review\n• Spec compliance\n• Architecture compliance\n• Constitution compliance\n• Code quality (CLEAN/SOLID)\n• Test quality\n• Severity: C/M/m/i"]

        S6 -->|"❌ FAIL"| S6b
        S6b -->|"re-run gate"| S6
        S6 -->|"✅ PASS"| S7
    end

    subgraph INTEGRATION_STAGES["📦 INTEGRATION STAGES (dk extensions)"]
        S8["💾 dk.speckit.commit\n• Conventional commits\n• Pre-commit quick gate\n• Task ID references\n• Semantic grouping"]
    end

    subgraph LEARNING_STAGES["🧠 LEARNING STAGES (dk extensions)"]
        S9["🔄 dk.speckit.retro\n• Cycle analysis\n• Pattern detection\n• Proposed improvements\n• Compound learning"]
    end

    subgraph EXPORT["📤 EXPORT (OOTB)"]
        S10["🎫 speckit.taskstoissues\n• GitHub issue creation"]
    end

    ORCH ==>|"delegates"| SPEC_STAGES
    ORCH ==>|"delegates"| IMPL_STAGES
    ORCH ==>|"delegates"| QUALITY_STAGES
    ORCH ==>|"delegates"| INTEGRATION_STAGES
    ORCH ==>|"delegates"| LEARNING_STAGES

    SPEC_STAGES --> IMPL_STAGES
    IMPL_STAGES --> QUALITY_STAGES
    QUALITY_STAGES -->|"review passed"| INTEGRATION_STAGES
    QUALITY_STAGES -->|"critical findings"| IMPL_STAGES
    INTEGRATION_STAGES --> LEARNING_STAGES
```

---

## 2. Agent Inventory — Who Does What

### OOTB sk-v1 Agents (10)

| Agent                   | Stage  | Role                            | Writable Artifacts                                      |
| ----------------------- | ------ | ------------------------------- | ------------------------------------------------------- |
| `speckit.constitution`  | 1      | Establish project principles    | `constitution.md`                                       |
| `speckit.specify`       | 2      | Define requirements & stories   | `spec.md`                                               |
| `speckit.clarify`       | 2b     | Resolve ambiguities via Q&A     | Updates `spec.md`                                       |
| `speckit.plan`          | 3      | Technical design & architecture | `plan.md`, `data-model.md`, `contracts/`, `research.md` |
| `speckit.tasks`         | 4      | Actionable task breakdown       | `tasks.md`                                              |
| `speckit.checklist`     | X-cut  | Requirement quality validation  | `checklists/`                                           |
| `speckit.analyze`       | X-cut  | Cross-artifact consistency      | Analysis report                                         |
| `speckit.implement`     | 5      | Execute tasks from tasks.md     | Source code, tests                                      |
| `speckit.review`        | 6      | Code review → review artifacts  | `reviews/` (6 files)                                    |
| `speckit.taskstoissues` | Export | Convert tasks to GitHub issues  | GitHub issues                                           |

### dk.speckit.\* Extensions (8)

| Agent                     | Stage | Role                                   | Writable Artifacts                                        |
| ------------------------- | ----- | -------------------------------------- | --------------------------------------------------------- |
| `dk.speckit.main`         | Orch  | Lifecycle orchestrator (GPT-5)         | Status reports                                            |
| `dk.speckit.orchestrator` | Orch  | State detection & routing (Sonnet 4.6) | Status reports                                            |
| `dk.speckit.quality-gate` | 6     | Run automated checks                   | `gate-report.md`                                          |
| `dk.speckit.autofix`      | 6b    | Fix gate failures (bounded)            | Source code fixes                                         |
| `dk.speckit.review`       | 7     | Enhanced structured review             | `review-report.md`, `reviews/`                            |
| `dk.speckit.commit`       | 8     | Conventional commits                   | Git commits                                               |
| `dk.speckit.retro`        | 9     | Compound learning cycle                | `retro.md`                                                |
| `dk.speckit.ui`           | 3b    | UI requirements analysis               | `ui-analysis.md`, `ui-components.md`, `ui-integration.md` |

---

## 3. Anvil Integration Points — Where Evidence-First Helps

```mermaid
flowchart TD
    subgraph CURRENT["CURRENT PIPELINE"]
        direction TB
        tasks["speckit.tasks\n📋 generates tasks"]
        impl["speckit.implement\n🔨 executes tasks"]
        qgate["dk.quality-gate\n🚦 runs checks"]
        autofix["dk.autofix\n🔧 fixes failures"]
        review["dk.review\n👁️ code review"]
        commit["dk.commit\n💾 commits"]
        retro["dk.retro\n🔄 retrospective"]

        tasks --> impl --> qgate
        qgate -->|fail| autofix --> qgate
        qgate -->|pass| review
        review -->|critical| impl
        review -->|pass| commit --> retro
    end

    subgraph ANVIL_OVERLAY["🔶 ANVIL-STYLE IMPROVEMENTS"]
        direction TB
        A1["🔴 HIGH IMPACT\n─────────────\n1. Verification Ledger\n   in speckit.implement\n2. Risk labels (🟢🟡🔴)\n   from speckit.tasks\n3. Pushback protocol\n   in speckit.implement\n4. Implement ↔ Orchestrator\n   via askQuestions"]
        A2["🟡 MEDIUM IMPACT\n─────────────\n5. Adversarial multi-model\n   review for 🔴 tasks\n6. Evidence bundle per task\n   (implement → review)\n7. Reuse detection\n   in plan/implement\n8. Git hygiene check\n   at session start"]
        A3["🟢 LOW IMPACT\n─────────────\n9. Retro consumes ledger\n   data for analytics\n10. Autofix uses evidence\n    context from ledger\n11. Task sizing (S/M/L)\n    from speckit.tasks"]
    end

    A1 -.->|"inject into"| impl
    A1 -.->|"inject into"| tasks
    A2 -.->|"inject into"| review
    A2 -.->|"inject into"| impl
    A3 -.->|"inject into"| retro
    A3 -.->|"inject into"| autofix

    style A1 fill:#ff6b6b,color:#fff
    style A2 fill:#ffd93d,color:#333
    style A3 fill:#6bff6b,color:#333
```

---

## 4. Detailed Integration Map — Agent × Anvil Feature

### 🔴 HIGH IMPACT — Inject into `speckit.implement`

```
┌─────────────────────────────────────────────────────────────────┐
│                    speckit.implement (CURRENT)                  │
│                                                                 │
│  1. Load tasks.md                                               │
│  2. Validate checklists                                         │
│  3. For each task:                                              │
│     • Execute implementation                                    │
│     • Mark [X] when done                                        │
│  4. Report completion                                           │
│                                                                 │
│  GAP: No in-flight verification, no pushback, no risk scaling   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│              speckit.implement (ANVIL-ENHANCED)                 │
│                                                                 │
│  1. Load tasks.md                                               │
│  2. Validate checklists                                         │
│  ┌─── NEW: Pre-execution checkpoint ───────────────────────┐   │
│  │ • Scan for reuse opportunities (grep existing codebase)  │   │
│  │ • Evaluate overall scope — pushback if too vague/large   │   │
│  │ • If pushback needed → askQuestions to orchestrator       │   │
│  └──────────────────────────────────────────────────────────┘   │
│  3. For each task:                                              │
│     ┌── NEW: Read risk label (🟢🟡🔴) from tasks.md ──┐       │
│     │                                                    │       │
│     │  🟢 Green: Implement → quick verify (lint+test)    │       │
│     │  🟡 Yellow: Implement → verify → log to ledger     │       │
│     │  🔴 Red: Pushback → implement → deep verify        │       │
│     │          → adversarial self-review → log ledger     │       │
│     └────────────────────────────────────────────────────┘       │
│     • Execute implementation                                    │
│     ┌── NEW: Per-task verification ─────────────────────┐       │
│     │  Run targeted tests for changed files              │       │
│     │  Check IDE diagnostics (0 errors)                  │       │
│     │  Log result → evidence ledger (JSON)               │       │
│     └────────────────────────────────────────────────────┘       │
│     • Mark [X] when VERIFIED (not just "done")                  │
│     ┌── NEW: Mid-task pushback (if issues) ─────────────┐       │
│     │  "This task conflicts with existing code in X"     │       │
│     │  "Requirements have edge case Y"                   │       │
│     │  → askQuestions to orchestrator for routing         │       │
│     └────────────────────────────────────────────────────┘       │
│  4. Emit evidence bundle → consumed by dk.review                │
│  5. Report completion + ledger summary                          │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 🔴 HIGH IMPACT — Inject into `speckit.tasks`

```
┌─────────────────────────────────────────────────────────────────┐
│                    speckit.tasks (CURRENT)                      │
│                                                                 │
│  Task format:                                                   │
│  - [ ] [T1] [P] [US1] Description with file path               │
│                                                                 │
│  Labels: [P] = parallelizable, [USn] = user story               │
│  Missing: risk classification, task sizing                      │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│               speckit.tasks (ANVIL-ENHANCED)                    │
│                                                                 │
│  Task format:                                                   │
│  - [ ] [T1] [P] [US1] [🟢S] Description with file path         │
│  - [ ] [T2] [US1] [🟡M] Modify existing business logic         │
│  - [ ] [T3] [US2] [🔴L] Implement auth token refresh           │
│                                                                 │
│  NEW labels:                                                    │
│  • Risk: 🟢 additive/config/docs                                │
│          🟡 modify business logic/signatures/queries             │
│          🔴 auth/crypto/payments/deletion/schema/public-API      │
│  • Size: S = one-liner/config                                    │
│          M = single-concern change                               │
│          L = multi-file/architecture                             │
│                                                                 │
│  NEW section in tasks.md:                                       │
│  ## Verification Strategy                                       │
│  | Risk | Verification Depth | Reviewers |                     │
│  |------|-------------------|-----------|                       │
│  | 🟢   | Quick (lint+test) | 0         |                      │
│  | 🟡   | Standard (full)   | 1 (self)  |                      │
│  | 🔴   | Deep + adversarial| 1-3       |                      │
└─────────────────────────────────────────────────────────────────┘
```

### 🟡 MEDIUM IMPACT — Enhance `dk.speckit.review`

```
┌─────────────────────────────────────────────────────────────────┐
│                    dk.speckit.review (CURRENT)                  │
│                                                                 │
│  • Single-agent review pass                                     │
│  • Reconstructs evidence post-hoc by reading code               │
│  • Produces review-report.md + supporting artifacts             │
│  • Severity classification: Critical/Major/Minor/Info           │
│                                                                 │
│  GAP: No evidence from implementation, no adversarial pass      │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│              dk.speckit.review (ANVIL-ENHANCED)                 │
│                                                                 │
│  NEW Step 0: Load evidence bundle from implement                │
│  • Read verification ledger (JSON)                              │
│  • Identify which tasks were 🔴 risk                            │
│  • Check: did implement actually verify each task?              │
│  • Missing ledger entries = automatic MAJOR finding             │
│                                                                 │
│  Existing passes: Spec, Architecture, Constitution, Quality...  │
│                                                                 │
│  NEW Pass G: Evidence Audit                                     │
│  • For each 🟡🔴 task, verify ledger shows:                     │
│    - Tests ran and passed                                       │
│    - IDE diagnostics clean                                      │
│    - No skipped verification steps                              │
│  • Flag any "self-reported OK" without tool evidence            │
│                                                                 │
│  NEW: Adversarial review for 🔴 tasks                           │
│  • Switch to different model for 🔴 file review                 │
│  • Specifically challenge: auth logic, data deletion,           │
│    schema changes, public API surface                           │
│  • Merge adversarial findings into review-report.md             │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### 🟡 MEDIUM IMPACT — Enhance `dk.speckit.main` / `dk.speckit.orchestrator`

```
┌─────────────────────────────────────────────────────────────────┐
│              dk.speckit.main (ANVIL-ENHANCED)                   │
│                                                                 │
│  NEW Step 0b: Git Hygiene (from Anvil)                          │
│  ┌───────────────────────────────────────────────────────┐      │
│  │ At session start:                                      │      │
│  │ • Check git status --porcelain                         │      │
│  │ • If dirty: warn user → commit/stash/ignore            │      │
│  │ • If on main for non-trivial work: suggest branch      │      │
│  └───────────────────────────────────────────────────────┘      │
│                                                                 │
│  NEW: Receive pushback escalations from implement               │
│  ┌───────────────────────────────────────────────────────┐      │
│  │ implement → askQuestions → orchestrator:                │      │
│  │                                                        │      │
│  │ "Task T3 conflicts with existing auth in users.py.     │      │
│  │  Options: (A) Refactor existing, (B) Extend existing,  │      │
│  │  (C) Escalate to user"                                 │      │
│  │                                                        │      │
│  │ Orchestrator can:                                      │      │
│  │ • Route to speckit.clarify for requirement update      │      │
│  │ • Approve option A or B directly                       │      │
│  │ • Escalate to user via askQuestions                     │      │
│  └───────────────────────────────────────────────────────┘      │
│                                                                 │
│  NEW: Consume ledger summary for routing decisions              │
│  • If implement reports many 🔴 verification failures           │
│    → route to review with "high-scrutiny" flag                  │
│  • If implement pushback count > 2                              │
│    → suggest re-planning via speckit.plan                       │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 5. The askQuestions ↔ Orchestrator Pattern

This is the most architecturally interesting Anvil-inspired change. Currently, the pipeline is **strictly sequential**: orchestrator delegates → agent runs to completion → orchestrator checks results. Anvil's pushback protocol creates a need for **mid-execution communication**.

### Current Flow (fire-and-forget)

```mermaid
sequenceDiagram
    participant User
    participant Orch as dk.speckit.main
    participant Impl as speckit.implement

    User->>Orch: "implement the feature"
    Orch->>Impl: delegate(tasks.md)
    Note over Impl: runs autonomously<br/>no communication back<br/>until done
    Impl-->>Orch: return (all tasks done or context limit)
    Orch->>Orch: check tasks.md status
    alt incomplete
        Orch->>Impl: re-delegate(remaining tasks)
    else complete
        Orch->>User: "implementation done, routing to quality gate"
    end
```

### Anvil-Enhanced Flow (bidirectional during execution)

```mermaid
sequenceDiagram
    participant User
    participant Orch as dk.speckit.main
    participant Impl as speckit.implement
    participant Clarify as speckit.clarify

    User->>Orch: "implement the feature"
    Orch->>Impl: delegate(tasks.md)

    Note over Impl: Task T1 [🟢S] — quick execute + verify ✅

    Note over Impl: Task T2 [🟡M] — execute + verify + log ledger ✅

    Note over Impl: Task T3 [🔴L] — pre-task analysis...
    Impl->>Orch: askQuestions("T3 conflicts with existing auth.<br/>Options: refactor / extend / escalate")

    alt orchestrator resolves
        Orch-->>Impl: "Extend existing — approved"
        Note over Impl: T3 continues with direction ✅
    else needs clarification
        Orch->>Clarify: delegate("clarify auth requirements")
        Clarify-->>Orch: updated spec
        Orch-->>Impl: "Requirements updated — proceed with new spec"
        Note over Impl: T3 continues with clarified requirements ✅
    else escalate to user
        Orch->>User: "Implement found a conflict..."
        User-->>Orch: decision
        Orch-->>Impl: user's decision
    end

    Note over Impl: Task T4 [🟡M] — reuse detected!
    Impl->>Orch: askQuestions("Found existing DateFormatter.<br/>Reuse + extend, or create new?")
    Orch-->>Impl: "Reuse — good catch"

    Impl-->>Orch: return (all tasks done + evidence ledger)
    Orch->>Orch: review ledger summary
    Orch->>User: "Implementation done. 4 tasks, 1 pushback resolved, 1 reuse. Routing to quality gate."
```

### Why This Pattern Makes Sense

| Aspect                  | Current (fire-and-forget)                              | Anvil-Enhanced (bidirectional)           |
| ----------------------- | ------------------------------------------------------ | ---------------------------------------- |
| **Conflict detection**  | Discovered post-hoc in review                          | Caught during implementation             |
| **Reuse opportunities** | Missed — implement doesn't look                        | Discovered and applied inline            |
| **Requirements gaps**   | Silently guessed or skipped                            | Escalated to clarify agent               |
| **User visibility**     | Black box until done                                   | Progressive status via orchestrator      |
| **Wasted work**         | Implements wrong thing → review catches → reimplements | Stops before wrong implementation starts |
| **Orchestrator role**   | Passive (check after done)                             | Active (triage mid-execution)            |

### Implementation Considerations

1. **askQuestions is already in the orchestrator's toolset** — both `dk.speckit.main` and `dk.speckit.orchestrator` have `agent/askQuestions`. The implement agent would need it added too.

2. **Frequency budget** — pushback should be rare (1-2 per cycle), not on every task. Only trigger for:
   - 🔴 risk tasks (always evaluate before executing)
   - Reuse opportunities that affect multiple tasks
   - Requirement contradictions discovered during implementation
   - Scope that exceeds the task description

3. **Orchestrator as triage** — the orchestrator doesn't need to solve problems, just route them:
   - Implementation question → approve or pick option
   - Requirement question → route to `speckit.clarify`
   - Architecture question → route to `speckit.plan`
   - User decision needed → escalate with context

---

## 6. What NOT to Change

These agents should NOT receive Anvil-style modifications:

| Agent                   | Reason                                                                                                                     |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| `speckit.clarify`       | Already does requirements-level pushback well. Anvil pushback is execution-time; clarify is spec-time. Different concerns. |
| `speckit.checklist`     | Validates requirement _quality_, not implementation. Orthogonal to evidence-first execution.                               |
| `speckit.constitution`  | Defines principles — no execution rigor needed.                                                                            |
| `speckit.specify`       | Creates specs — verification ledgers are for code, not requirements prose.                                                 |
| `speckit.taskstoissues` | Pure export. No implementation to verify.                                                                                  |
| `dk.speckit.commit`     | Already has pre-commit gate. Adding verification ledger here is redundant — the evidence was collected during implement.   |

---

## 7. Priority-Ordered Implementation Plan

### Phase 1: Foundation (enable everything else)

1. **`speckit.tasks`** — Add risk labels and task sizing to task format
2. **`speckit.implement`** — Add verification ledger (JSON), risk-scaled verification, pushback protocol with askQuestions

### Phase 2: Evidence Flow

3. **`dk.speckit.review`** — Consume evidence bundle from implement, add Evidence Audit pass
4. **`dk.speckit.main`** — Add git hygiene at session start, handle pushback routing from implement

### Phase 3: Depth

5. **`dk.speckit.review`** — Add adversarial multi-model review for 🔴 tasks
6. **`dk.speckit.retro`** — Consume verification ledger data for cycle analytics
7. **`speckit.plan`** — Add "Verification Strategy" and "Reuse Opportunities" sections

---

## 8. Evidence Ledger Format (JSON, not SQL)

Anvil uses SQLite. For spec-kit, a JSON file per spec is lighter and artifact-friendly:

**Location**: `specs/<NNN>-<name>/evidence-ledger.json`

```json
{
  "spec": "003-feature-name",
  "created": "2026-03-12T10:00:00",
  "tasks": [
    {
      "task_id": "T1",
      "risk": "🟢",
      "size": "S",
      "verifications": [
        {
          "phase": "after",
          "check": "lint",
          "tool": "ruff check",
          "passed": true,
          "timestamp": "2026-03-12T10:05:00"
        },
        {
          "phase": "after",
          "check": "test",
          "tool": "pytest tests/test_feature.py -x",
          "passed": true,
          "output_snippet": "3 passed in 0.4s",
          "timestamp": "2026-03-12T10:05:30"
        }
      ],
      "pushbacks": [],
      "reuse_detected": null
    },
    {
      "task_id": "T3",
      "risk": "🔴",
      "size": "L",
      "verifications": [
        {
          "phase": "baseline",
          "check": "test",
          "tool": "pytest tests/ -x",
          "passed": true,
          "output_snippet": "42 passed in 2.1s",
          "timestamp": "2026-03-12T10:10:00"
        },
        {
          "phase": "after",
          "check": "test",
          "tool": "pytest tests/ -x",
          "passed": true,
          "output_snippet": "45 passed in 2.3s",
          "timestamp": "2026-03-12T10:25:00"
        },
        {
          "phase": "review",
          "check": "adversarial",
          "tool": "multi-model review (GPT-5)",
          "passed": true,
          "output_snippet": "No critical findings",
          "timestamp": "2026-03-12T10:26:00"
        }
      ],
      "pushbacks": [
        {
          "reason": "Task conflicts with existing auth in users.py",
          "resolution": "Extend existing — approved by orchestrator",
          "timestamp": "2026-03-12T10:12:00"
        }
      ],
      "reuse_detected": null
    }
  ]
}
```

---

## 9. Summary Diagram — Full Anvil-Enhanced Pipeline

```mermaid
flowchart TD
    START(["🚀 User Request"])

    subgraph ORCH["🎯 ORCHESTRATOR (dk.speckit.main)"]
        git_hygiene["0b. Git Hygiene ⚡NEW"]
        detect["Detect State"]
        route["Route to Agent"]
        triage["Triage Pushbacks ⚡NEW"]

        git_hygiene --> detect --> route
        triage -.->|"requirement Q"| CLARIFY
        triage -.->|"architecture Q"| PLAN
        triage -.->|"user decision"| USER_ESC
    end

    subgraph SPEC["📋 SPECIFICATION (unchanged)"]
        CONST["constitution"]
        SPECIFY["specify"]
        CLARIFY["clarify"]
        PLAN["plan"]
        UI["dk.ui"]
        TASKS["tasks ⚡ENHANCED\n+ risk labels 🟢🟡🔴\n+ task sizing S/M/L\n+ verification strategy"]
        CHECK["checklist"]
        ANALYZE["analyze"]
    end

    subgraph IMPL["⚡ IMPLEMENTATION (Anvil-enhanced)"]
        IMPLEMENT["implement ⚡ENHANCED\n+ verification ledger (JSON)\n+ risk-scaled verification\n+ pushback → orchestrator\n+ reuse detection\n+ evidence bundle output"]
    end

    subgraph QUALITY["🛡️ QUALITY (enhanced evidence flow)"]
        GATE["quality-gate"]
        AUTOFIX["autofix"]
        REVIEW["review ⚡ENHANCED\n+ consume evidence bundle\n+ evidence audit pass\n+ adversarial review (🔴)"]
    end

    subgraph CLOSE["📦 CLOSE"]
        COMMIT["commit"]
        RETRO["retro ⚡ENHANCED\n+ ledger analytics"]
    end

    USER_ESC(["👤 User Decision"])

    START --> ORCH
    ORCH --> SPEC
    SPEC --> IMPL
    IMPLEMENT <-->|"askQuestions\npushback"| triage
    IMPL --> GATE
    GATE -->|fail| AUTOFIX --> GATE
    GATE -->|pass| REVIEW
    REVIEW -->|critical| IMPLEMENT
    REVIEW -->|pass| COMMIT --> RETRO

    style git_hygiene fill:#ffd93d,stroke:#333
    style triage fill:#ffd93d,stroke:#333
    style TASKS fill:#ff6b6b,color:#fff,stroke:#333
    style IMPLEMENT fill:#ff6b6b,color:#fff,stroke:#333
    style REVIEW fill:#ffd93d,stroke:#333
    style RETRO fill:#6bff6b,stroke:#333
```

**Legend**: 🔴 Red = High-impact Anvil changes | 🟡 Yellow = Medium-impact | 🟢 Green = Low-impact | Unchanged = default style
