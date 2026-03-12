# Verification Strategy

How much verification each task gets depends on its risk label. This reference defines the verification cascade for each risk level.

## Quick Reference

| Risk | Before            | After                           | Adversarial        | Ledger   |
| ---- | ----------------- | ------------------------------- | ------------------ | -------- |
| 🟢   | —                 | lint + affected tests           | —                  | Optional |
| 🟡   | baseline snapshot | lint + full tests + diagnostics | Self-review        | Required |
| 🔴   | baseline snapshot | lint + full tests + diagnostics | 1 adversarial pass | Required |

## 🟢 Green — Quick Verify

**When**: Additive changes, new files, docs, config, tests.

```
1. Implement the task
2. Run lint on changed files only
3. Run tests for the affected module/file
4. Mark [X] if both pass
```

No ledger entry required (but welcomed). No pushback gate. No adversarial review.

**Time budget**: Minimal overhead — the verification should take < 30 seconds.

## 🟡 Yellow — Standard Verify

**When**: Modifying existing behavior, changing signatures, touching business logic.

```
1. BASELINE: Run full test suite → record in ledger (phase: baseline)
2. BASELINE: Run lint → record in ledger
3. Implement the task
4. AFTER: Run lint → record in ledger (phase: after)
5. AFTER: Run full test suite → record in ledger
6. AFTER: Check IDE diagnostics (0 errors) → record in ledger
7. SELF-REVIEW: Re-read the diff, check for:
   - Unintended side effects
   - Missing edge cases
   - Broken existing behavior
8. Mark [X] if all pass
```

If baseline had failures that are NOT related to this task, note them but proceed. Only regressions (new failures compared to baseline) block completion.

**Time budget**: Moderate — baseline + verify is worthwhile for code that affects existing behavior.

## 🔴 Red — Deep Verify

**When**: Auth, crypto, payments, deletion, schema migrations, concurrency, public API.

```
1. PRE-TASK EVALUATION (pushback gate):
   - Read affected files
   - Grep for existing code in the area
   - Evaluate task completeness
   - If concerns → pushback via askQuestions to orchestrator
   - Wait for resolution before proceeding

2. BASELINE: Run full test suite → record in ledger
3. BASELINE: Run lint + type check → record in ledger

4. Implement the task

5. AFTER: Run lint → record in ledger
6. AFTER: Run full test suite → record in ledger
7. AFTER: Run type check → record in ledger
8. AFTER: Check IDE diagnostics → record in ledger

9. ADVERSARIAL REVIEW:
   - Re-examine the implementation as if you're a hostile reviewer
   - Specifically challenge:
     • Auth: Can this be bypassed? Token reuse? Privilege escalation?
     • Deletion: Is it reversible? Confirmation required? Cascade effects?
     • Schema: Backward compatible? Migration rollback possible?
     • API: Breaking change? Version bump needed? Error contract?
   - Record adversarial verdict in ledger (phase: review)

10. Mark [X] only if ALL verifications pass
```

**Time budget**: Significant — but 🔴 tasks are where bugs cause the most damage. The overhead is justified.

## Adversarial Review Detail

For 🔴 tasks, the implement agent performs a structured adversarial pass:

### Prompt Pattern

After implementing, mentally switch roles:

> "I am now a senior security/reliability reviewer. My job is to find problems in the code I just wrote. I will specifically look for: [domain-specific concerns from the task's risk category]."

### What to Challenge

| Domain               | Specific Challenges                                                  |
| -------------------- | -------------------------------------------------------------------- |
| **Auth**             | Bypass vectors, token handling, session management, privilege checks |
| **Data deletion**    | Reversibility, cascade effects, confirmation UI, audit trail         |
| **Schema migration** | Backward compatibility, rollback path, data loss risk                |
| **Concurrency**      | Race conditions, deadlocks, atomic operations                        |
| **Public API**       | Breaking changes, version compatibility, error contracts             |
| **Crypto**           | Algorithm choice, key management, timing attacks                     |
| **Payments**         | Idempotency, double-charge prevention, refund handling               |

### Recording the Verdict

```json
{
  "phase": "review",
  "check": "adversarial",
  "tool": "self-review (adversarial prompt)",
  "passed": true,
  "output_snippet": "Reviewed auth token refresh. Checked: bypass via expired token (safe — middleware validates), privilege escalation via role claim (safe — roles from DB not token), token reuse after rotation (safe — old token blacklisted). No findings.",
  "timestamp": "ISO-8601"
}
```

If the adversarial review finds issues → fix them before marking [X], then re-run the verification cascade.

## Verification Failures

| Scenario                              | Action                                            |
| ------------------------------------- | ------------------------------------------------- |
| Lint fails after implementation       | Fix lint issues, re-verify                        |
| New test failures (regression)        | Fix implementation or test, re-verify             |
| Pre-existing failures in baseline     | Note in ledger, don't count as regression         |
| Adversarial review finds issue        | Fix, re-run full verify cascade                   |
| IDE diagnostics show errors           | Fix before proceeding                             |
| Verify repeatedly fails (>2 attempts) | Pushback to orchestrator — task may need redesign |
