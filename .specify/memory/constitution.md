<!--
Sync Impact Report:
Version Change: Template → 1.0.0 (Initial Constitution)
Modified Principles: N/A (Initial creation)
Added Sections: All sections (Initial creation)
Removed Sections: N/A
Templates Status:
  ✅ plan-template.md - Aligned with modular architecture and constitution check
  ✅ spec-template.md - Aligned with user story prioritization and testability
  ✅ tasks-template.md - Aligned with user story tracking and independent implementation
  ⚠️  No command templates directory found yet - ensure future commands reference this constitution
Follow-up TODOs:
  - Ratification date is set to today; adjust if formal approval process required
  - Consider adding promptfoo regression test policies as team scales
-->

# copilot-config-promptops Constitution

## Core Principles

### I. Modular AI Context (NON-NEGOTIABLE)

AI context MUST be decomposed into independently managed modules that compose at build time rather than duplicated across repositories.

**Rationale**: Context fragmentation leads to drift, inconsistency, and security vulnerabilities. A single instruction module (e.g., `instructions/global/security.md`) updated once propagates to all consuming repositories via the synchronization mechanism. This ensures that a security policy change—such as "Always use parameterized queries"—is enforced organization-wide immediately upon sync, preventing the "prompt drift" phenomenon where older repositories operate under deprecated guidelines.

**Requirements**:

- Instructions MUST reside in `instructions/` hierarchy organized by scope (global/languages/frameworks)
- Agent personas MUST be stored as reusable files in `agents/`
- Skills MUST be self-contained folders with `SKILL.md` and executable artifacts
- Local repositories MUST NOT manually edit generated AI context files; modifications MUST flow through the central knowledge repository
- Each module MUST be concise (<500 tokens recommended) to preserve context window space

### II. Build-Time Context Assembly

AI context files in local repositories MUST be generated artifacts assembled from upstream modules, not hand-authored documents.

**Rationale**: Treating `.github/copilot-instructions.md` and `AGENTS.md` as source files creates a maintenance nightmare in multi-repository environments. By making them build artifacts generated via `make sync-ai`, we establish a single source of truth. The `ai.mk` Makefile orchestrates fetching (via git sparse-checkout), concatenation (for instructions), and installation (for skills), ensuring deterministic, reproducible AI behavior across all projects consuming the knowledge repository.

**Requirements**:

- Local projects MUST define `.ai-config` or equivalent to declare their module dependencies
- Context assembly MUST be idempotent and reproducible
- Generated files MUST include provenance comments identifying source modules
- Synchronization MUST use git sparse-checkout to minimize bandwidth and clone time
- Local override mechanism MUST be supported (e.g., `.github/local-instructions.md` appended last) for legacy compatibility or project-specific exceptions

### III. Independent User Story Implementation

Features MUST be decomposed into prioritized user stories that are independently implementable, testable, and deliverable as incremental value.

**Rationale**: Monolithic feature development creates bottlenecks and prevents early validation. By structuring specifications (`spec-template.md`) and tasks (`tasks-template.md`) around independent user stories with explicit priorities (P1, P2, P3), teams can deliver MVP functionality early (e.g., just P1), validate with users, and iterate. Each story must have clear acceptance criteria and an "Independent Test" definition. This principle directly supports agile delivery and reduces the risk of building the wrong thing.

**Requirements**:

- Every specification MUST define user stories with assigned priorities (P1 = MVP critical)
- Each user story MUST include "Independent Test" criteria demonstrating standalone value
- Tasks MUST be grouped by user story (`[US1]`, `[US2]` labels) in `tasks.md`
- Foundational infrastructure (Phase 2 in task templates) MUST be completed before ANY user story work begins, acting as a blocker gate
- User stories MUST be structured to allow parallel development by different team members without file conflicts

## Development Workflow

### PromptOps Lifecycle

Changes to AI context MUST follow a controlled lifecycle with validation gates:

1. **Local Discovery**: Developer identifies suboptimal AI behavior in their project
2. **Upstream Contribution**: Developer uses `make upstream-patch` or equivalent to clone knowledge repo, edit source modules, and submit PR
3. **Review & Validation**: PRs to knowledge repo MUST include:
   - Rationale for change (what hallucination or error is being fixed)
   - Token impact analysis (does this increase context size unacceptably?)
4. **Versioned Release**: Knowledge repo MUST use semantic versioning (Git tags like `v1.2.0`)
5. **Controlled Rollout**: Consumer projects opt-in to new versions by updating `AI_REPO_REF` in their `.ai-config`

### Git Conventions

All commits MUST follow Conventional Commits style. PRs MUST:

- Be small and focused (single module or related changes)
- Include tests for prompt changes (promptfoo assertions)
- Link to issues describing the problem being solved
- Run local validation before opening PR

## Security Constraints

AI context MUST enforce the following non-negotiable security boundaries:

- NEVER commit secrets, API keys, or `.env` files
- ALWAYS use parameterized queries or ORM protections for database access
- ALWAYS validate and sanitize external inputs
- NEVER store PII in plain text; follow data retention policies
- ALWAYS log security-relevant events

These rules are codified in `instructions/global/security.md` and automatically injected into all consuming repositories.

## Governance

This constitution supersedes all conflicting practices. Changes to this constitution MUST:

1. Be proposed via PR with explicit rationale
2. Include version bump decision (MAJOR/MINOR/PATCH) with justification
3. Update dependent templates (`.specify/templates/`) to maintain consistency
4. Generate a Sync Impact Report (as HTML comment in this file) listing affected files

**Amendment Procedure**:

- MINOR: New principle added or existing principle materially expanded
- MAJOR: Principle removed or redefined in a backward-incompatible way
- PATCH: Clarifications, typo fixes, or non-semantic refinements

**Compliance Review**:
All PRs to knowledge repository MUST verify alignment with this constitution. The plan template (`plan-template.md`) includes a "Constitution Check" gate that MUST pass before Phase 0 research.

**Version**: 1.0.0 | **Ratified**: 2026-01-07 | **Last Amended**: 2026-01-07
