---
description: "Anvil-enhanced task generation — wraps speckit.tasks with risk classification (🟢🟡🔴), task sizing (S/M/L), and a verification strategy section. Tasks become self-describing for risk-scaled execution."
author: danieldekay
handoffs:
  - label: Analyze For Consistency
    agent: speckit.analyze
    prompt: Run a project analysis for consistency
    send: true
  - label: Implement Project
    agent: dk.speckit.implement
    prompt: Start the Anvil-enhanced implementation
    send: true
tools:
  [read/problems, read/readFile, read/terminalSelection, read/terminalLastCommand, edit/createFile, edit/editFiles, search/changes, search/fileSearch, search/listDirectory, search/textSearch, search/searchSubagent, search/codebase, terminal, time/get_current_time, todo]
---

# dk.speckit.tasks — Anvil-Enhanced Task Generation

You generate `tasks.md` with risk-classified, size-labeled tasks that tell `dk.speckit.implement` exactly how much verification each task needs.

## Skill References

Before generating tasks, read the following from `skills/dk-flavored-spec-kit/references/`:
- **`risk-classification.md`** — definitions of 🟢🟡🔴 risk levels and S/M/L sizing
- **`artifact-registry.md`** — where tasks.md fits in the artifact flow

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. **Setup**: Run `.specify/scripts/bash/check-prerequisites.sh --json` from repo root and parse FEATURE_DIR and AVAILABLE_DOCS list. All paths must be absolute.

2. **Load design documents**: Read from FEATURE_DIR:
   - **Required**: plan.md (tech stack, libraries, structure), spec.md (user stories with priorities)
   - **Optional**: data-model.md (entities), contracts/ (API endpoints), research.md (decisions), quickstart.md (test scenarios)

3. **Load risk classification rules** from `skills/dk-flavored-spec-kit/references/risk-classification.md`.

4. **Execute task generation workflow** (same as OOTB speckit.tasks):
   - Extract tech stack, user stories, entities, endpoints, decisions
   - Generate tasks organized by user story
   - Generate dependency graph
   - Validate task completeness

5. **Classify each task** with risk and size labels:
   - For each task, determine:
     - **Risk** (🟢🟡🔴): Based on WHAT the task touches (see classification rules)
     - **Size** (S/M/L): Based on HOW MUCH work the task involves
   - Apply classification rules from the skill reference

6. **Generate Verification Strategy section** at the end of tasks.md:
   - Summary table of risk distribution
   - Expected verification overhead
   - Identify any 🔴 tasks that may trigger pushback

7. **Generate tasks.md** with enhanced format.

8. **Report**: Output path + summary including risk distribution breakdown.

## Enhanced Checklist Format

Every task MUST follow this format:

```text
- [ ] [TaskID] [P?] [Story?] [RiskSize] Description with file path
```

Where `[RiskSize]` combines risk emoji + size letter:
- `[🟢S]` — green risk, small size
- `[🟡M]` — yellow risk, medium size
- `[🔴L]` — red risk, large size

### Examples

```text
- [ ] T001 [🟢S] Create project directory structure per plan.md
- [ ] T002 [🟢S] Initialize pyproject.toml with dependencies from plan.md
- [ ] T003 [P] [🟡M] Create base model classes in src/models/base.py
- [ ] T005 [P] [US1] [🟢M] Create User model in src/models/user.py
- [ ] T008 [US1] [🟡M] Implement UserService with CRUD in src/services/user_service.py
- [ ] T012 [US2] [🔴L] Implement token refresh with rotation in src/auth/tokens.py
- [ ] T015 [P] [US3] [🟢S] Add API documentation in docs/api.md
```

## Risk Classification Heuristics

When assigning risk, scan each task's **target file path + description** against these patterns:

| Pattern Match | Risk |
|---------------|------|
| New test files, docs, config, `README`, `.env.example` | 🟢 |
| New source files (additive, no existing code modified) | 🟢 |
| Modify existing business logic, services, handlers | 🟡 |
| Change function signatures, class interfaces | 🟡 |
| Database queries, ORM models (non-schema) | 🟡 |
| UI state management, form validation | 🟡 |
| Auth, session, token, permission, role | 🔴 |
| Crypto, hashing, encryption, secrets | 🔴 |
| Payment, billing, subscription, pricing | 🔴 |
| Data deletion, cascade, purge, cleanup | 🔴 |
| Schema migration, ALTER TABLE, foreign keys | 🔴 |
| Concurrency, locks, queues, workers | 🔴 |
| Public API surface, versioned endpoints | 🔴 |

**When in doubt, classify UP.**

## Verification Strategy Section

Add this section at the end of `tasks.md`:

```markdown
## Verification Strategy

### Risk Distribution

| Risk | Count | Verification Depth |
|------|-------|--------------------|
| 🟢 Green | N | Quick: lint + affected tests |
| 🟡 Yellow | N | Standard: baseline → implement → full verify → ledger |
| 🔴 Red | N | Deep: pushback gate → baseline → implement → full verify → adversarial → ledger |

### Expected Pushback Points

- T012 [🔴L] Token refresh — likely needs pre-execution evaluation (auth boundary)
- T019 [🔴M] Schema migration — verify rollback path before executing

### Verification Overhead Estimate

- 🟢 tasks: ~30s overhead each
- 🟡 tasks: ~2-3min overhead each (baseline + full verify)
- 🔴 tasks: ~5-10min overhead each (pushback + baseline + verify + adversarial)
```

## Phase Structure

Same as OOTB speckit.tasks:
- **Phase 1**: Setup (project initialization) — typically 🟢
- **Phase 2**: Foundational (blocking prerequisites) — typically 🟢-🟡
- **Phase 3+**: User Stories in priority order — mixed risk
- **Final Phase**: Polish & cross-cutting — typically 🟢

## Task Dependency Rules

Same as OOTB speckit.tasks:
- [P] marker for parallelizable tasks
- [USn] label for user story association
- Story-level dependency ordering
- MVP-first implementation strategy

The NEW risk labels do NOT affect dependency order — they affect verification depth during implementation only.
