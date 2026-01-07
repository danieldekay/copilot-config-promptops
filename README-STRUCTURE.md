# AI Knowledge Repo Structure (implemented)

This repository contains the core modules for the AI Knowledge Repository described in `PromptOps Git Workflow and File Management.md`.

Key folders:
- `instructions/` — modular instruction modules used to build `copilot-instructions.md`
- `agents/` — personas for autonomous agents
- `skills/` — executable skills with `SKILL.md` and helper scripts
- `prompts/` — reusable prompt templates
- `config/` — templates and default config (`default-ai-config.mk`)
- `ai.mk` / `Makefile` — consumer-facing sync Makefile example
- `tests/` — prompt regression tests (Promptfoo example)

See `ai.mk` and `config/default-ai-config.mk` for usage examples.