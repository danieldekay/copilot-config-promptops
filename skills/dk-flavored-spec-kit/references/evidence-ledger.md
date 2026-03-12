# Evidence Ledger

The evidence ledger is a JSON file that records every verification action taken during implementation. It replaces self-reported claims ("tests pass") with tool-call evidence ("pytest exited 0 with output X").

**Core rule: If the INSERT didn't happen, the verification didn't happen.**

## Location

```
specs/<NNN>-<name>/evidence-ledger.json
```

Created by `dk.speckit.implement`. Consumed by `dk.speckit.review` and `dk.speckit.retro`.

## Schema

```json
{
  "spec": "003-feature-name",
  "created": "ISO-8601",
  "updated": "ISO-8601",
  "tasks": [
    {
      "task_id": "T1",
      "risk": "🟢",
      "size": "S",
      "started": "ISO-8601",
      "completed": "ISO-8601",
      "verifications": [
        {
          "phase": "baseline | after | review",
          "check": "descriptive name (e.g., lint, test, diagnostics, adversarial)",
          "tool": "exact command or tool used",
          "command": "full shell command if applicable",
          "exit_code": 0,
          "passed": true,
          "output_snippet": "first 500 chars of relevant output",
          "timestamp": "ISO-8601"
        }
      ],
      "pushbacks": [
        {
          "reason": "why the agent pushed back",
          "resolution": "what was decided",
          "resolved_by": "orchestrator | user | self",
          "timestamp": "ISO-8601"
        }
      ],
      "reuse_detected": {
        "existing_code": "path/to/file.py::function_name",
        "action": "reused | extended | skipped",
        "description": "what was reused and how"
      }
    }
  ],
  "summary": {
    "total_tasks": 5,
    "green": 3,
    "yellow": 1,
    "red": 1,
    "pushback_count": 1,
    "reuse_count": 0,
    "all_verified": true
  }
}
```

## Field Rules

### `phase` values

| Phase      | When                                     | Purpose                                                            |
| ---------- | ---------------------------------------- | ------------------------------------------------------------------ |
| `baseline` | Before implementation starts (🟡🔴 only) | Capture pre-existing test/lint state so regressions are detectable |
| `after`    | After implementation of this task        | Prove the task didn't break anything                               |
| `review`   | After adversarial self-review (🔴 only)  | Record the adversarial challenge result                            |

### Required verifications by risk

| Risk | `baseline` | `after` (lint) | `after` (test)     | `after` (diagnostics) | `review` (adversarial) |
| ---- | ---------- | -------------- | ------------------ | --------------------- | ---------------------- |
| 🟢   | —          | ✅             | ✅ (affected only) | —                     | —                      |
| 🟡   | ✅         | ✅             | ✅ (full suite)    | ✅                    | —                      |
| 🔴   | ✅         | ✅             | ✅ (full suite)    | ✅                    | ✅                     |

### `output_snippet` guidelines

- Keep to first 500 characters of meaningful output
- For test runs: capture the summary line (e.g., "42 passed, 0 failed in 2.1s")
- For lint: capture error count or "0 errors"
- For adversarial review: capture verdict + top finding
- Never include secrets, tokens, or credentials

## How Review Consumes the Ledger

`dk.speckit.review` performs an **Evidence Audit** pass:

1. Load `evidence-ledger.json`
2. For each task with risk 🟡 or 🔴:
   - Check required verifications exist
   - Check all verifications passed
   - Check timestamps are plausible (after > baseline)
3. Missing or failed entries → automatic **MAJOR** finding
4. Skipped adversarial review on 🔴 task → automatic **CRITICAL** finding

## How Retro Consumes the Ledger

`dk.speckit.retro` reads the summary block for cycle analytics:

- First-pass verification rate (how many tasks verified clean on first try)
- Pushback frequency and resolution patterns
- Reuse detection rate
- Time between baseline and completion (rough task duration)
