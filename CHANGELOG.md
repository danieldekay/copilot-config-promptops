# Changelog

All notable changes to this repository will be documented in this file.

## [Unreleased] - 2026-03-02

### Added

**Best-of-the-best merge** — merged production-tested agents, prompts, and skills from TMD projects and user skill collections:

#### New Agents (untracked → committed)

- `agents/browser-testing.agent.md` — Playwright smoke/regression/a11y tests
- `agents/codebase-analyze.agent.md` — Per-file structural analysis subagent
- `agents/codebase-arch-docs.agent.md` — Architecture documentation generator
- `agents/codebase-audit.agent.md` — Full orchstrated codebase audit
- `agents/codebase-doc-updater.agent.md` — Docstring and type annotation updater
- `agents/codebase-modern-patterns.agent.md` — 2026 best practices assessment
- `agents/codebase-proposals.agent.md` — S/M/L improvement proposals
- `agents/copilot-instructions.md` — Agents-dir copilot instructions
- `agents/engineering-manager.agent.md` — Non-speckit feature/fix/audit routing
- `agents/speckit.review.agent.md` — Post-implementation review
- `agents/speckit.ui.agent.md` — UI spec/implementation

#### New Prompts

- All `speckit.*` prompt variants (specify, clarify, plan, tasks, implement, review, analyze, checklist, constitution, taskstoissues, ui)
- `chat-session-learnings.prompt.md` — Session engineering record
- `small-change.prompt.md` — Pattern-first small change implementation

#### New Instructions

- `instructions/javascript.instructions.md` — WordPress React / `apiFetch` standards
- `instructions/memory.instructions.md` — Recurring patterns and known fixes
- `instructions/php.instructions.md` — WordPress security, Meta Box, PHPStan
- `instructions/scss.instructions.md` — Bootstrap 4 variable overrides and mixins

#### New Skills (from `~/.agents/skills/` and `notes/.agents/skills/`)

- `skills/clean-architecture/` — 42 Clean Architecture rules
- `skills/clean-code/` — Robert C. Martin Clean Code
- `skills/code-refactoring-refactor-clean/` — Systematic refactoring
- `skills/codebase-cleanup-refactor-clean/` — Codebase-scale SOLID cleanup
- `skills/communication-storytelling/` — Narrative for stakeholders
- `skills/compound-learnings/` — Session → permanent capability pipeline
- `skills/content-strategy/` — Content planning and topic clusters
- `skills/critical-thinking-logical-reasoning/` — Logic and fallacy analysis
- `skills/deep-research/` — Multi-source synthesis with citations
- `skills/design-thinking/` — IDEO/Stanford d.school 5-phase framework
- `skills/find-skills/` — Skill discovery meta-skill
- `skills/first-principles-thinking/` — Socratic decomposition
- `skills/lesson-learned/` — SE principles from git history
- `skills/markdown-documentation/` — GFM documentation standards
- `skills/marketing-ideas/` — 139 proven marketing approaches
- `skills/professional-communication/` — Technical communication guide
- `skills/self-learning/` — Learn new tech from web; create skill
- `skills/seo-audit/` — Technical SEO with AEO/GEO patterns
- `skills/social-content/` — Platform-specific social media
- `skills/systems-thinking/` — Leverage points, feedback loops
- `skills/thinking-tools/` — Agent self-reflection framework
- `skills/ui-ux-pro-max/` — 50 styles, 21 palettes, 9 stacks
- `skills/web-design-guidelines/` — Web Interface Guidelines review
- `skills/web-research/` — Structured web research workflow
- `skills/wordpress-pro/` — WordPress development guide
- `skills/wp-plugin-development/` — Plugin architecture and security
- `skills/wp-rest-api/` — WordPress REST API patterns
- `skills/written-communication/` — Clear writing guide

### Changed

- `agents/README.md` — Comprehensive agent workflow documentation
- `agents/code-review.agent.md` — Added handoffs and improved workflow
- `agents/code-fix.agent.md` — Enhanced fix prioritization
- `agents/commit.agent.md` — Added gitkraken tool integration
- `agents/speckit.orchestrator.agent.md` — Added quality assurance tracking, agent-efficiency.md
- `prompts/fix-and-refactor.prompt.md` — Refined root cause analysis steps
- `skills/brainstorming/SKILL.md` — Enhanced design gate and process flow
- `skills/skill-creator/SKILL.md` — Full eval pipeline with benchmark tooling
- `skills/using-superpowers/SKILL.md` — Updated skill flow diagram

### Documentation

- `README.md` — Complete rewrite: full layout, agent/skill/prompt/instructions tables
- `CATALOG.md` — New: full annotated index of all 35+ agents, 70+ skills, 27 prompts, 12 instructions

## [Unreleased] - 2026-01-07

### Added

- Implemented AI Knowledge Repository structure and scaffolding:
  - `instructions/` (modules for `copilot-instructions.md`) with `global/`, `languages/`, `frameworks/` folders
  - `agents/` (agent personas)
  - `skills/` (skills with `SKILL.md` and helper scripts)
  - `prompts/` (prompt templates)
  - `config/default-ai-config.mk` (template)
  - `ai.mk` and root `Makefile` (consumer-facing sync example)
  - `tests/promptfoo.yaml` (prompt regression test example)
  - `.gitattributes` configured for `*.md merge=union`
  - `README-STRUCTURE.md` documenting the layout

### Changed

- Added `README.md`, `CONTRIBUTING.md`, and `LICENSE` placeholders.

### Removed

- Deleted unused placeholder folders to keep repository focused:
  - `src/`, `examples/`, `scripts/`, `docs/`, `.vscode/`

### Notes

- No CI workflows were added per request. PromptOps CI (e.g., Promptfoo) can be added later when you are ready.

---

_This changelog was generated on 2026-01-07 to capture the initial repository bootstrapping and structure work._
