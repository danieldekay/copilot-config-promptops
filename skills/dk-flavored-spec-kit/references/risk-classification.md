# Risk Classification

Risk labels tell the implement agent HOW MUCH verification a task needs. They are assigned by `dk.speckit.tasks` and consumed by `dk.speckit.implement` and `dk.speckit.review`.

## Risk Levels

| Level      | Label | Criteria                                          | Examples                                                                                                     |
| ---------- | ----- | ------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| **Green**  | 🟢    | Additive, isolated, low blast radius              | New tests, documentation, config, comments, new utility files, CSS-only changes                              |
| **Yellow** | 🟡    | Modifies existing behavior, moderate blast radius | Changing business logic, function signatures, database queries, UI state management, API response shapes     |
| **Red**    | 🔴    | High-stakes, hard to reverse, wide blast radius   | Auth/crypto/payments, data deletion, schema migrations, concurrency, public API surface, security boundaries |

## Task Sizing

Size indicates expected implementation complexity, independent of risk:

| Size       | Label | Criteria                                                                                   |
| ---------- | ----- | ------------------------------------------------------------------------------------------ |
| **Small**  | S     | One-liner, config tweak, typo, rename — completes in < 5 minutes                           |
| **Medium** | M     | Single-concern change, one file focus — bug fix, feature addition, targeted refactor       |
| **Large**  | L     | Multi-file, architecture-level — new feature module, cross-cutting concern, major refactor |

## Combined Label Format

In `tasks.md`, risk and size appear as a combined bracket:

```
- [ ] [T1] [P] [US1] [🟢S] Add helper utility for date formatting
- [ ] [T2] [US1] [🟡M] Modify user service to support avatar upload
- [ ] [T3] [US2] [🔴L] Implement token refresh with rotation
```

## Classification Rules

1. **When in doubt, classify UP** — a task that might be 🟡 should be called 🟡, not 🟢
2. **Risk is per-file, size is per-task** — if a task touches one 🔴 file and three 🟢 files, the task is 🔴
3. **Dependencies escalate** — if a 🟢 task blocks a 🔴 task, treat it with 🟡 care (errors cascade)
4. **Tests inherit parent risk** — test tasks for 🔴 features are 🟡 (not green, because wrong tests give false confidence)

## Risk → Verification Depth Mapping

| Risk | Verification Depth                                                                     | Adversarial Review                                                   | Pushback Gate                        |
| ---- | -------------------------------------------------------------------------------------- | -------------------------------------------------------------------- | ------------------------------------ |
| 🟢   | Quick: lint + affected tests only                                                      | None                                                                 | None                                 |
| 🟡   | Standard: lint + full test suite + IDE diagnostics → log to ledger                     | Self-review (re-read own output)                                     | Optional (if conflict detected)      |
| 🔴   | Deep: baseline snapshot → implement → full verify → adversarial review → log to ledger | 1 adversarial pass (different-model or different-perspective prompt) | Required (evaluate before executing) |

## How Agents Use This

- **`dk.speckit.tasks`**: Assigns `[🟢S]`, `[🟡M]`, `[🔴L]` labels during task generation
- **`dk.speckit.implement`**: Reads labels to determine verification depth per task
- **`dk.speckit.review`**: Uses labels to focus adversarial review energy on 🔴 tasks
