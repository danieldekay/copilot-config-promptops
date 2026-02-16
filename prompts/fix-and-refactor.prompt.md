---
name: "Fix & Refactor"
description: "Diagnose a recurring or systemic issue, fix it in a general way, refactor the surrounding code, and cover it with tests. Applies to any topic — auth, data flow, rendering, performance, etc."
argument-hint: "Describe the symptom and the area of the codebase affected (e.g. 'REST 403s on benchmark endpoints', 'duplicate event queries in archive template')."
---

# Fix & Refactor Prompt

Meta:

- Created: 2026-02-15
- Scope: Any systemic or recurring issue in TMD Core / TMD4

## Primary Directive

When a bug keeps resurfacing or a code area is brittle, **don't patch the symptom — fix the system**. Diagnose the root cause, refactor the surrounding code to prevent recurrence, and lock the fix with tests.

## Workflow

### 1) Reproduce & Diagnose

Before writing any code:

1. **Reproduce the symptom** — gather error messages, HTTP status codes, log entries, or screenshots.
2. **Trace the call path** — follow the execution from trigger (UI click, cron, REST call) through every layer (JS → REST → PHP → DB).
3. **Separate concerns** — determine which layer actually fails vs. which layer reports the error. Common mismatch: the UI shows a generic error but the real cause is two layers deeper.
4. **Name the root cause** explicitly (e.g. "capability mismatch between menu registration and endpoint permission_callback", not "403 error").

```bash
# Useful diagnostic commands
grep -rn "pattern" src/ --include="*.php"
composer phpstan
wp eval 'var_dump(current_user_can("manage_options"));'
```

### 2) Design the General Fix

Think beyond the immediate symptom:

- **Is this a one-off or a pattern?** If the same class of bug could appear elsewhere, fix the pattern, not just the instance.
- **Where is the single source of truth?** Move the authoritative check / logic / config there if it's scattered.
- **What's the minimal change that prevents all instances?** Prefer a shared trait, helper, or abstraction over N individual patches.

Document your diagnosis in a brief bullet list before coding.

### 3) Refactor First, Then Fix

Follow the **refactor-before-implement** principle:

1. **Check file sizes** — any file approaching 400 lines must be split before adding code.
2. **Extract shared logic** — if the fix touches duplicated code, extract to a trait/helper/service first.
3. **Simplify the call path** — if the bug survived because the code is too tangled to reason about, untangle it.
4. **Then apply the fix** on the clean, refactored code.

```bash
# Check file sizes before editing
wc -l src/Path/To/File.php
# If > 400 lines → extract traits/helpers first
```

#### File Size Budget

| Type         | Soft Limit | Hard Limit | Action at Limit               |
| ------------ | ---------- | ---------- | ----------------------------- |
| PHP class    | 300 lines  | 400 lines  | Extract trait / split class   |
| JS component | 200 lines  | 300 lines  | Extract sub-component / hook  |
| Test file    | 300 lines  | 400 lines  | Split into focused test files |

### 4) TDD — Write Tests First (When Possible)

For the fix itself and for any refactored code:

1. **Write a failing test** that reproduces the bug or asserts the expected behavior.
2. **Make it pass** with the minimal fix.
3. **Refactor** under green tests.

If true TDD isn't practical (e.g. UI-layer gating, build-tool issue), at minimum:

- Write a test that would have caught the bug.
- Add it to the test suite so regression is impossible.

```bash
# Run targeted tests
vendor/bin/phpunit tests/Unit/Path/ToTest.php
vendor/bin/phpunit --filter="test_method_name"

# Run full suite
composer test
```

### 5) Verify Across Layers

After the fix:

- [ ] **Static analysis**: `composer phpstan` passes (or only pre-existing baseline issues)
- [ ] **Code style**: `composer phpcs` (don't fix unrelated style issues)
- [ ] **JS build**: `npm run build` succeeds (if JS was touched)
- [ ] **Tests**: All new and existing tests pass
- [ ] **Manual spot-check**: Verify the original symptom is gone

### 6) Document the Pattern

If this fix reveals a **recurring pattern** (a class of bugs that could reappear):

1. Add a note to `.github/instructions/memory.instructions.md` with:
   - **Pattern**: What the symptom looks like
   - **Cause**: The actual root cause
   - **Fix**: The general approach
   - **Key insight**: The non-obvious lesson
2. Consider whether a linter rule, phpstan check, or architectural constraint could prevent recurrence automatically.

## Anti-Patterns to Avoid

| Don't                                        | Do Instead                                    |
| -------------------------------------------- | --------------------------------------------- |
| Patch the symptom in one place               | Fix the root cause; check for other instances |
| Add code to a 500-line file                  | Extract first, then add                       |
| Skip tests because "it's a simple fix"       | Simple fixes are the easiest to test — do it  |
| Fix a bug and leave duplicate code around it | Refactor the duplication as part of the fix   |
| Guess the root cause from the error message  | Trace the full call path before coding        |
| Conflate authentication with authorization   | Name the exact layer and mechanism that fails |
| Add defensive checks everywhere              | Fix the one place that's actually wrong       |

## Checklist (copy into PR or commit message)

```markdown
- [ ] Root cause identified and documented
- [ ] Pattern checked — no other instances of the same bug
- [ ] Files under 400-line limit (refactored if needed)
- [ ] Test(s) added that would have caught this bug
- [ ] `composer phpstan` clean (or baseline-only)
- [ ] `npm run build` clean (if JS changed)
- [ ] All tests pass
- [ ] memory.instructions.md updated (if recurring pattern)
```

## Example Application

**Symptom**: REST endpoints return `403 rest_forbidden` for logged-in users.

1. **Diagnose**: Traced from browser console → REST response → `permission_callback` → `current_user_can('manage_options')`. User has `edit_posts` but not `manage_options`. Menu page requires `edit_posts`, so user reaches UI but all API calls fail.
2. **General fix**: Pass capability flags via `wp_localize_script`; gate UI components client-side; keep server-side `permission_callback` as authoritative check.
3. **Refactor**: Extracted permission helpers to `RestPermissions` trait; standardized error messages to include required capability name.
4. **TDD**: Added `RestPermissionsTest` covering admin-only and editor-level endpoints for both authorized and unauthorized users.
5. **Pattern**: Documented in `memory.instructions.md` — "Authorization ≠ Authentication; always distinguish which one fails."
