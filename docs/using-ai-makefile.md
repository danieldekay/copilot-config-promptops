# Using the AI sync Makefile (ai.mk)

This document explains the general usage of the consumer-facing `ai.mk` Makefile included in this repository. It shows how to configure, run, and customize the sync workflow used to fetch and assemble instruction modules, agent personas, and skills from an upstream AI Knowledge Repo.

## Prerequisites

- Git (>= 2.27 recommended) with SSH configured (for private repos).
- `make` available on your system.
- Optional: `rsync` for installing skills (builtin on macOS and Linux).

## Quick start (in a consuming repository)

1. Create a local `.ai-config` file (see `.ai-config.example` in this repo) and set values for the variables you need. Typically you will at least set `AI_REPO_URL` and the modules you want.
2. Copy or include the `ai.mk` Makefile into your repository, or call `make -f /path/to/ai.mk sync-ai`.
3. Run:

```bash
# Using the Makefile in your repo
make sync-ai

# Or point to the ai.mk file directly
make -f /path/to/ai.mk sync-ai
```

On success, the Makefile will create (or update) `.github/copilot-instructions.md`, `AGENTS.md`, and `.github/skills/` in your repo based on the modules and skills you specified.

## Key variables (set in `.ai-config`)

- AI_REPO_URL — Git repository URL of the Knowledge Repo (SSH or HTTPS)
- AI_REPO_REF — branch or tag to sync from (use tags for pinning)
- AI_INSTRUCTION_MODULES — ordered list of markdown files to concatenate into `copilot-instructions.md`
- AI_AGENT_PERSONA — agent persona file to copy to `AGENTS.md`
- AI_SKILLS — list of skill directories to copy under `.github/skills/`

Notes:

- Order matters for `AI_INSTRUCTION_MODULES` — earlier modules appear first in the generated instructions.
- Pin `AI_REPO_REF` to a tag (e.g., `v1.2.0`) to avoid surprising changes; update on your schedule.

## Local overrides

If your repo needs a temporary or permanent override, create `.github/local-instructions.md` — the Makefile appends this file after the assembled upstream modules so local rules take precedence.

## Upstream contribution workflow

Use the `upstream-patch` helper (provided by the Makefile) to clone the Knowledge Repo into a temp folder where you can edit source modules, test locally, push a branch, and open a PR upstream.

## Security and performance tips

- Prefer SSH-based `git` operations for private repos (no PATs in logs).
- The Makefile uses sparse-checkout to fetch only requested files efficiently. This minimizes bandwidth and makes syncs fast.
- Keep modules small and focused; remember that `copilot-instructions.md` is injected into the agent/system prompt and has token impact.

## Troubleshooting

- Missing module warnings: ensure the `AI_INSTRUCTION_MODULES` paths match what's in the Knowledge Repo and the `AI_REPO_REF` contains those files.
- If `sync-ai` fails due to authentication, confirm your SSH key is loaded into the agent (e.g., `ssh-agent`) or use `gh auth login` for `gh`-based approaches.

---

For more advanced usage, see `ai.mk` and `config/default-ai-config.mk` in this repository. If you'd like, I can add example invocations for CI or automation workflows.
