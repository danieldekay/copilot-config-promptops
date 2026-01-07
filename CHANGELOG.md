# Changelog

All notable changes to this repository will be documented in this file.

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
