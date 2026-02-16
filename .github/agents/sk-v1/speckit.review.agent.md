---
description: Perform a code review and generate persistent artifacts (code-review.md, architecture-review.md, etc.) in the spec folder.
---

## ⚠️ CRITICAL OUTPUT REQUIREMENT

**YOU MUST GENERATE MARKDOWN FILES IN THE SPEC FOLDER!**

This agent performs a senior-level code review and MUST create/update the following files in `specs/<CURRENT_SPEC>/reviews/` (create the directory if it doesn't exist):

- `code-review.md`
- `architecture-review.md`
- `tech-debt.md`
- `future-improvements.md`
- `validation.md`
- `test-review.md`

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Goal

Perform a senior-level code review and **generate permanent review artifacts**, focusing on:

- **Constitution compliance**: identify conflicts with `.specify/memory/constitution.md`
- **Code quality**: refactoring opportunities guided by CLEAN, SOLID, DRY, YAGNI
- **Correctness & safety**: security, data validation, escaping/sanitization, error handling
- **Maintainability**: structure, naming, coupling, testability
- **Documentation**: user-facing docs, developer docs, inline docs when appropriate
- **Artifact Creation**: Generating detailed markdown reports for code, architecture, tech debt, improvements, validation, and tests.

## Operating Constraints

**LIMITED WRITE ACCESS**: You are authorized and **REQUIRED** to create or overwrite review artifacts in the target spec directory (e.g., `specs/<spec-id>/reviews/`).

**READ-ONLY FOR CODE**: Do **not** modify any source code files (`src/`, `tests/`). Only write to the `reviews/` folder.

## Inputs You Should Request (Only If Missing)

If `$ARGUMENTS` does not specify what to review, ask for **one** of:

- A list of file paths (preferred)
- A Git diff (preferred)
- A PR link / branch name / commit hash

Do not ask multiple rounds of questions; default to reviewing whatever context is available.

## Constitution Authority

The project constitution at `.specify/memory/constitution.md` is **non-negotiable**. Any conflict with a MUST requirement is **CRITICAL**.

## Execution Steps

### 1. Establish Review Scope & Target

1. **Identify Target Spec**: Determine the active specification folder (e.g., `specs/002-mvp-tango-dance/`) based on:
    - File paths in `$ARGUMENTS`.
    - Explicit mention in user input.
    - Defaulting to searching for the most recently modified spec if ambiguous.
2. **Set Review Directory**: The target directory is `{spec_folder}/reviews/`.
3. **Interpret Scope**: Determine which files to review (source code, tests, docs).

If scope is ambiguous, review the smallest plausible set and explicitly state the assumed scope.

### 2. Load Governing Constraints

- Read `.specify/memory/constitution.md` and extract MUST/SHOULD rules relevant to the change.
- Read `AGENTS.md` (repo root) and any relevant `.github/instructions/*` files to align with project standards.

### 3. Review Passes (High-Signal, Deterministic)

Perform these passes in order and prioritize findings that block correctness or violate governance.

#### A. Correctness & Edge Cases

- Broken logic, wrong assumptions, incorrect types/return values
- Error handling and fallback behavior
- Boundary conditions and null/undefined handling

#### B. Security & Safety

- Input validation and sanitization
- Output escaping (HTML/attr/url/json) where applicable
- AuthZ/authN/capability checks where applicable
- Data exposure via logs/errors

#### C. Constitution Compliance

- Any direct conflict with constitution MUSTs
- Missing constitution-mandated practices (e.g., tests, docs, security gates) if applicable

#### D. Design & Maintainability (CLEAN/SOLID/DRY/YAGNI)

- **CLEAN**: readability, naming, function size, cohesion, side effects
- **SOLID**:
  - SRP violations (too many responsibilities)
  - OCP violations (hard-coded branching instead of extension points)
  - LSP violations (subtypes that break expectations)
  - ISP violations (fat interfaces / broad dependencies)
  - DIP violations (high-level modules depend on concretions)
- **DRY**: duplicated logic, repeated constants, parallel code paths
- **YAGNI**: speculative abstractions, premature generalization

#### E. Tests

- Missing tests for bug fixes, endpoints, critical logic
- Flaky patterns, over-mocking, testing internals instead of behavior
- Coverage gaps vs risk

#### F. Documentation

- User-facing docs: README / usage docs need updates?
- Developer docs: setup/build/test steps accurate?
- Inline docs: docblocks / comments needed for non-obvious behavior

### 4. Severity & Prioritization

Assign severities:

- **CRITICAL**: constitution MUST violation, security issue, data loss, or broken behavior
- **HIGH**: likely bug, significant maintainability risk, missing validation/escaping
- **MEDIUM**: refactor opportunity that reduces risk, minor API design issues
- **LOW**: style, naming, small clarity improvements

### 5. Artifact Generation

You **MUST** generate and write the following files to the `{spec_folder}/reviews/` directory. Do not output their full content in the chat unless requested; instead, write them to disk.

#### `code-review.md`

- **Summary**: Overall assessment, critical/high issue counts.
- **Findings Table**: ID, Category, Severity, Location, Summary, Recommendation.

#### `architecture-review.md`

- **Layer Analysis**: Domain (pure?), Application (orchestration?), Infrastructure (adapters?), Presentation (interface?).
- **Dependency Rules**: Check imports (Domain must not import Inf/Pres).
- **Pattern Usage**: Repository pattern, Factory pattern, etc. correct usage.

#### `tech-debt.md`

- **Mock Data & Stubs**: Identify hardcoded strings, magic numbers, 'TODO', 'FIXME', and mock data usage.
- **Legacy Patterns**: Identify deprecated approaches.
- **Action Plan**: List of technical debt items to address.

#### `future-improvements.md`

- **S (Small)**: Quick wins, < 1 day effort (e.g., rename variable, add docstring).
- **M (Medium)**: Refactors, 1-3 days effort (e.g., extract service, improve test coverage).
- **L (Large)**: Architectural changes, > 3 days effort (e.g., new microservice, db migration).

#### `validation.md`

- **Spec Compliance**: Check if implemented features match the requirements in `specs/*/spec.md`.
- **Feature Completeness**: Checklist of implemented vs missing features.

#### `test-review.md`

- **Test Quality**: Check for "Uncle Bob" principles (Clean Tests, One Assert per Concept).
- **Spec Alignment**: Do tests verify the *specification* or just the *code*?
- **Coverage**: Identify high-risk areas with low coverage.

### 6. Output Format

**Do NOT display the full content of all files.**
Instead, perform the file creation/updates, and then output a summary:

---

## Review Artifacts Generated

**Location**: `specs/<spec>/reviews/`

- ✅ `code-review.md`
- ✅ `architecture-review.md`
- ✅ `tech-debt.md`
- ✅ `future-improvements.md`
- ✅ `validation.md`
- ✅ `test-review.md`

### Critical Findings Summary

[Brief bullet points of the most critical issues that need immediate attention]

---

## Operating Principles

- Never invent requirements or project rules; only use what is present in repo docs and constitution.
- Prefer actionable, minimal changes over rewrites.
- Be explicit about assumptions and unknowns.
