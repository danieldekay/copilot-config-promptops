---
title: "Speckit Improvement Process"
description: "Post-implementation improvement workflow using rotf.speckit agents"
created: "2026-02-16"
last_updated: "2026-02-16"
author: "Daniel Kaesmayr"
status: "active"
category: "process"
tags:
  - "speckit"
  - "code-review"
  - "quality"
  - "workflow"
version: "1.2.0"
related_files:
  - ".github/agents/rotf.speckit.improve.agent.md"
  - ".github/agents/rotf.speckit.review.agent.md"
  - ".github/agents/rotf.speckit.fix.agent.md"
  - ".github/agents/rotf.speckit.quality.agent.md"
  - ".github/agents/rotf.feature-finish.agent.md"
  - ".specify/scripts/bash/finish-feature.sh"
cross_references:
  docs:
    - "docs/agent-context/specs.md"
    - "docs/agent-context/workflow.md"
---

# Speckit Improvement Process

## Overview

The **speckit improvement process** extends the core speckit pipeline with a structured post-implementation quality cycle. After `speckit.implement` completes a feature, four `rotf.speckit.*` agents systematically review, fix, improve, and validate the implementation before merge.

These agents are **ROTF custom additions** to the speckit pipeline (hence the `rotf.` prefix). They are workspace-agnostic — each agent reads `docs/agent-context/` for project-specific details rather than hardcoding commands or paths.

## Extended Pipeline

The full speckit lifecycle with the improvement cycle:

```
SPECIFICATION PHASE
  speckit.specify  →  speckit.clarify  →  speckit.plan

PLANNING PHASE
  speckit.tasks  →  (speckit.checklist)  →  speckit.analyze

IMPLEMENTATION PHASE → iterate until done.
  speckit.implement

IMPROVEMENT PHASE
  rotf.speckit.improve (orchestrator) → will orchestrate code review, auto fixes, quality improvements, and validation.
    ├── Phase 1: rotf.speckit.review
    ├── Phase 2a: rotf.speckit.fix      ─┐
    ├── Phase 2b: rotf.speckit.quality   ├─ (parallel)
    └── Phase 3: speckit.validate        ┘

  ↕ Repeat for each spec in the user story

FEATURE FINISH (user story level)
  rotf.feature-finish → quality gate, changelog, sync develop, merge, push
    ├── 1. Inventory all specs on the feature branch
    ├── 2. Run finish-feature.sh quality gate (tests, format, changelog, conflicts)
    ├── 3. Ensure changelog/unreleased.md is complete
    ├── 4. Sync with develop (merge or rebase)
    ├── 5. Resolve merge conflicts (with context from spec artifacts)
    ├── 6. git flow feature finish (merge → develop, delete branch)
    └── 7. Push develop, verify integration

POST-MERGE
  speckit.taskstoissues → convert tasks to tracking issues

```

## Agents

### rotf.speckit.improve — Orchestrator

**Invoke**: `@rotf.speckit.improve` or `@rotf.speckit.improve skip-review`

The orchestrator runs the full improvement cycle as a single command. It:

1. Delegates to `rotf.speckit.review` for structured code review
2. Gates on critical findings (pauses for user acknowledgment)
3. Delegates to `rotf.speckit.fix` and `rotf.speckit.quality` (can run in parallel)
4. Delegates to `speckit.validate` as final quality gate
5. Produces a unified `IMPROVEMENT_REPORT.md`

**Options**:

| Argument        | Effect                                             |
| --------------- | -------------------------------------------------- |
| (empty)         | Full cycle: review → fix + quality → validate      |
| `review-only`   | Phase 1 only                                       |
| `skip-review`   | Use existing review artifacts, skip to Phase 2     |
| `fix-only`      | Phase 2a only                                      |
| `quality-only`  | Phase 2b only                                      |
| `skip-validate` | Phases 1 + 2, skip final validation                |
| `re-review`     | Incremental re-review (updates existing artifacts) |

### rotf.speckit.review — Code Review

**Invoke**: `@rotf.speckit.review` or `@rotf.speckit.review path/to/specific/file.py`

Performs a thorough, structured code review of all implementation files. **Read-only** — never modifies production or test code.

**Creates** `FEATURE_DIR/code-review/` directory:

```
code-review/
├── findings.md       # Primary findings by severity (Critical/High/Medium/Low)
├── tech-debt.md      # Technical debt inventory
├── improvements.md   # Prioritized improvement plan (P0-P3)
└── future-ideas.md   # Beyond-scope architectural and feature ideas
```

**Review dimensions**: Clean Architecture compliance, SOLID principles, code quality (naming, size, complexity), code smells, security (OWASP Top 10), test quality (TDD compliance, anti-patterns), documentation.

**Incremental**: On re-review, validates existing findings (fixed / still present / no longer relevant) and adds new ones with audit trail.

### rotf.speckit.fix — Fix & Refactor

**Invoke**: `@rotf.speckit.fix` or `@rotf.speckit.fix CR-001 CR-003`

Fixes code review findings following the **fix-the-system-not-the-symptom** principle:

1. **Diagnose** root cause (not just the symptom)
2. **Refactor** surrounding code if needed (split large files, extract shared logic)
3. **Fix** on the clean, refactored code
4. **Test-lock** every fix with a test that would have caught the issue

**Creates**: `FEATURE_DIR/code-review/FIX_REPORT.md`
**Updates**: `findings.md` (marks fixed findings with ✅ FIXED inline), `tech-debt.md` (marks resolved items), `tasks.md` (appends "Improvement — Fix & Refactor" phase with `FX` task IDs)

**File size discipline**: Files approaching 400 LOC are split before code is added.

### rotf.speckit.quality — Tests & Documentation

**Invoke**: `@rotf.speckit.quality` or `@rotf.speckit.quality tests` or `@rotf.speckit.quality docs`

Two-phase quality improvement:

**Phase A — Test Improvement**:

- Audits for TDD anti-patterns (fixture-only tests, mock-the-target, passes-on-creation)
- Identifies coverage gaps prioritized by layer (domain > application > infrastructure)
- Adds missing tests following proper test taxonomy
- Enforces `TestXxxContract` / `TestXxxImplementation` naming

**Phase B — Documentation**:

- Updates spec artifacts (tasks.md — appends "Improvement — Quality" phase with `QA` task IDs, summary.md)
- Marks resolved items in `tech-debt.md`, `improvements.md`, and `findings.md` with ✅ inline
- Adds/updates Google-style docstrings for public APIs
- Updates project docs (`docs/`) to reflect new functionality
- Ensures `changelog/unreleased.md` is current

**Creates**: `FEATURE_DIR/code-review/QUALITY_REPORT.md`

**Important**: This agent never fixes production bugs — if a test reveals a bug, it documents it for `rotf.speckit.fix`.

## Artifact Flow

```
                    IMPLEMENT
                       │
                       ▼
              ┌─── REVIEW ────┐
              │                │
              ▼                ▼
     code-review/         code-review/
     findings.md          tech-debt.md
     improvements.md      future-ideas.md
              │                │
        ┌─────┴─────┐   ┌─────┴─────┐
        ▼            ▼   ▼            ▼
   FIX_REPORT.md   QUALITY_REPORT.md
   (updates         (new tests,
    findings.md      updated docs,
    + tasks.md       + tasks.md
      Phase:Fix)       Phase:Quality)
        │                │
        └────────┬───────┘
                 ▼
          VALIDATE (speckit.validate)
                 │
                 ▼
     IMPROVEMENT_REPORT.md
```

All artifacts live in `FEATURE_DIR/code-review/` and accumulate across iterations.

**Tracking convention**: Both fix and quality agents append improvement phases to `tasks.md` (with `FX` and `QA` prefixed task IDs) and mark resolved items inline in code-review artifacts with ✅.

## Iteration Pattern

The improvement cycle is designed to **tighten** with each pass:

```
Cycle 1:  review (30 findings) → fix (25 fixed) → quality (+15% coverage) → validate (5 remaining)
Cycle 2:  re-review (5 + 2 new) → fix (7 fixed) → quality (+3% coverage) → validate (0 remaining)
```

Invoke subsequent cycles with: `@rotf.speckit.improve re-review`

## Workspace Agnosticism

These agents don't hardcode project-specific commands. Instead, they read:

| Context                       | File                             |
| ----------------------------- | -------------------------------- |
| Project structure, tech stack | `docs/agent-context/overview.md` |
| Test standards, organization  | `docs/agent-context/testing.md`  |
| Coding conventions            | `docs/agent-context/style.md`    |
| Established patterns          | `docs/agent-context/patterns.md` |
| Build/run commands            | `docs/agent-context/workflow.md` |
| Spec system                   | `docs/agent-context/specs.md`    |

This means the agents can be copied to other ROTF repositories (e.g., the backend or frontend) by providing matching `docs/agent-context/` files.

## Design Principles

1. **Single Responsibility**: Each agent does exactly one thing well. Review doesn't fix. Fix doesn't test. Quality doesn't refactor production code.

2. **Artifact-Based Communication**: Agents communicate through filesystem artifacts (`code-review/` directory), not through prompts or memory. This makes the process auditable and resumable.

3. **Gates Between Phases**: The orchestrator checks that each phase produced expected artifacts before proceeding. Critical findings pause for user acknowledgment.

4. **Incremental Over Absolute**: Re-reviews update existing artifacts (marking resolved/new) rather than starting from scratch. This shows progress over time.

5. **Root Cause Over Symptom**: The fix agent traces root causes and documents patterns to prevent recurrence, rather than applying surface-level patches.

6. **Test-Locked Fixes**: Every fix is accompanied by a test. No exceptions. The test must have failed before the fix and passed after.

7. **Documentation as Contract**: The changelog is a contract with users. Every user-facing change must appear in `changelog/unreleased.md`.

8. **Spec-Level vs Feature-Level**: The speckit improvement agents operate at the **spec level** (one spec at a time). The feature-finish agent operates at the **feature/user-story level** (across all specs on a branch). This separation keeps each concern clean.

## Feature Finish: From Specs to Merge

After all specs on a feature branch have been validated through the improvement cycle, the **feature-finish** agent bridges the gap to git-flow:

### rotf.feature-finish — Git-Flow Feature Completion

**Invoke**: `@rotf.feature-finish` or `@rotf.feature-finish --dry-run`

Automates the entire [git-flow feature completion process](.github/instructions/git-flow-feature-completion.instructions.md) at the user-story level.

**Key concept**: A feature branch may contain multiple specs. All specs should be validated before finishing the feature.

**Steps**:

1. **Inventory specs** — scan `specs/` for all spec directories, assess validation status
2. **Quality gate** — run `.specify/scripts/bash/finish-feature.sh` (tests, formatting, changelog, merge conflicts, commit conventions)
3. **Changelog** — ensure `changelog/unreleased.md` has entries for all delivered specs
4. **Sync develop** — merge or rebase develop into the feature branch
5. **Resolve conflicts** — context-aware conflict resolution using spec artifacts
6. **Git-flow finish** — merge to develop, delete feature branch (with user confirmation)
7. **Push & verify** — push develop, run tests, clean up remote branch

**Quality gate script**: `.specify/scripts/bash/finish-feature.sh`

Adapted for the Python/uv environment, this script checks:

| Check                  | Tool                        | Blocking?                  |
| ---------------------- | --------------------------- | -------------------------- |
| Feature branch pattern | git                         | Yes                        |
| Spec validation status | spec artifacts              | Yes (if CRITICAL findings) |
| Tests pass             | `uv run pytest`             | Yes                        |
| Code formatting        | `./scripts/format.sh check` | Yes                        |
| Changelog entries      | `changelog/unreleased.md`   | Warning                    |
| Merge conflicts        | `git merge-tree`            | Yes                        |
| Temp test scripts      | `find`                      | Warning                    |
| Working tree clean     | `git status`                | Warning                    |
| Commit conventions     | `git log`                   | Warning                    |

**Safety**: The agent never executes destructive operations (merge, push, branch deletion) without explicit user confirmation.

### End-to-End Example

A typical user-story with two specs:

```
1. git flow feature start US-42-scientist-uploads
2. @speckit.specify "Upload presentation files with validation"
     → creates specs/001-upload-presentation/
3. @speckit.plan → @speckit.tasks → @speckit.implement
4. @rotf.speckit.improve
     → review → fix → quality → validate ✅

5. @speckit.specify "Parse uploaded files into structured data"
     → creates specs/002-parse-uploaded-files/
6. @speckit.plan → @speckit.tasks → @speckit.implement
7. @rotf.speckit.improve
     → review → fix → quality → validate ✅

8. @rotf.feature-finish
     → quality gate ✅ → changelog ✅ → sync develop ✅
     → git flow feature finish → push develop ✅
```
