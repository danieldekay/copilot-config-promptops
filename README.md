# copilot-config-promptops

Initial repository for Copilot / PromptOps configuration and workflows.

## Layout

- `docs/` — documentation and design notes
- `src/` — source code and tooling
- `examples/` — usage examples and sample configs
- `scripts/` — tooling and helper scripts
- `tests/` — test suites
- `.github/workflows/` — CI workflows
- `.vscode/` — editor settings

## Next steps

1. Add contributing guidelines and license.
2. Implement CI steps in `.github/workflows/ci.yml`.
3. Add code in `src/` and examples in `examples/`.
**Best-of-the-best** collection of GitHub Copilot agents, skills, prompts, and coding instructions. A centralized PromptOps repository — single source of truth for AI context across all projects.

> **Concept**: [PromptOps Git Workflow and File Management](docs/PromptOps%20Git%20Workflow%20and%20File%20Management.md) — treat prompts as code, synchronized across projects via `ai.mk`.

## Quick Start

```bash
# Pull this repo's AI config into any project
cp ai.mk /path/to/your/project/
make -f ai.mk sync
```

See [ai.mk](ai.mk) and [docs/using-ai-makefile.md](docs/using-ai-makefile.md) for details.

## Repository Layout

| Directory | Contents | Count |
|-----------|----------|-------|
| [`agents/`](agents/) | Agent definitions (`.agent.md`) | 48 agents |
| [`skills/`](skills/) | Skill packages (`SKILL.md` + scripts) | 85 skills |
| [`prompts/`](prompts/) | Reusable prompt templates (`.prompt.md`) | 25 prompts |
| [`instructions/`](instructions/) | Coding standards (`.instructions.md`) | 15 modules |
| [`chatmodes/`](chatmodes/) | VS Code chat mode definitions (`.chatmode.md`) | 7 chatmodes |
| [`docs/`](docs/) | Architecture and usage documentation | — |
| [`config/`](config/) | Default AI config template | — |
| [`.specify/`](.specify/) | Spec-Kit templates and scripts | — |
| [`tests/`](tests/) | Prompt regression tests (Promptfoo) | — |

See [CATALOG.md](CATALOG.md) for the full annotated index of every item.

---

## Agents

Agents are specialized AI personas with defined tools, models, and handoffs.

### Code Quality Pipeline

| Agent | Purpose |
|-------|---------|
| `code-review.agent.md` | Thorough code review; produces structured artifacts in spec directory |
| `code-fix.agent.md` | Auto-fix Critical/Major findings from code review artifacts |
| `commit.agent.md` | Runs review → fix → conventional commit workflow |
| `engineering-manager.agent.md` | Routes fix/feature/audit/commit work to specialist subagents |
| `browser-testing.agent.md` | Playwright-backed smoke, regression, UI, API, and a11y tests |

### Codebase Audit Suite

| Agent | Purpose |
|-------|---------|
| `codebase-audit.agent.md` | Orchestrates full codebase audit (orchestrates 5 subagents) |
| `codebase-analyze.agent.md` | Per-file structural analysis |
| `codebase-proposals.agent.md` | S/M/L improvement proposals from analysis findings |
| `codebase-arch-docs.agent.md` | Generates architecture docs in `docs/understanding/` |
| `codebase-doc-updater.agent.md` | Updates docstrings and type annotations |
| `codebase-modern-patterns.agent.md` | Assesses against 2026 PHP/JS/WP best practices |

### Spec-Kit Workflow

Spec-kit is a full feature development workflow: spec → plan → tasks → implement → review → commit.

| Agent | Purpose |
|-------|---------|
| `speckit.agent.md` | Full 9-stage lifecycle orchestrator (state detection, routing, gate enforcement) |
| `speckit.orchestrator.agent.md` | Lightweight state analyzer and router |
| `speckit.specify.agent.md` | Creates feature spec from natural language description |
| `speckit.clarify.agent.md` | Resolves underspecified areas with targeted questions |
| `speckit.plan.agent.md` | Generates technical design artifacts |
| `speckit.tasks.agent.md` | Creates dependency-ordered task list |
| `speckit.checklist.agent.md` | Generates custom implementation checklists ("unit tests for requirements") |
| `speckit.implement.agent.md` | Executes implementation from tasks.md (TDD) |
| `speckit.quality-gate.agent.md` | Runs 7-check automated gate (format, lint, type, test, coverage, security, arch) |
| `speckit.autofix.agent.md` | Bounded auto-fix of quality gate failures |
| `speckit.review.agent.md` | Post-implementation cross-artifact review |
| `speckit.retro.agent.md` | Retrospective: extract patterns, propose improvements |
| `speckit.commit.agent.md` | Conventional commit with pre-commit verification |
| `speckit.analyze.agent.md` | Consistency audit across spec artifacts |
| `speckit.constitution.agent.md` | Creates/updates project constitution |
| `speckit.taskstoissues.agent.md` | Converts tasks to GitHub Issues |
| `speckit.ui.agent.md` | UI-specific spec and implementation |

### Other Agents

`janitor.agent.md`, `planner.agent.md`, `prd.agent.md`, `playwright-tester.agent.md`, `prompt-builder.agent.md`, `prompt-engineer.agent.md`, `r-datascientist.agent.md`, `research-technical-spike.agent.md`, `wg-code-alchemist.agent.md`

### Deep Research Pipeline

Multi-tier research methodology from raw data gathering through evaluation to synthesis.

| Agent | Purpose |
|-------|---------|
| `deep-researcher.agent.md` | Orchestrator: 5-tier pipeline routing (gather → process → extract → evaluate → synthesize) |
| `deep-research.gather.agent.md` | Broad data collection (web, bookmarks, academic, internal knowledge) |
| `deep-research.process.agent.md` | Triage, classify, and quality-rate collected sources (5 tiers) |
| `deep-research.extract.agent.md` | Deep reading and structured knowledge extraction |
| `deep-research.evaluate.agent.md` | Cross-reference, triangulate, and assess evidence confidence |
| `deep-research.synthesize.agent.md` | Transform evaluated evidence into knowledge artifacts |
| `deep-research.bookmark.agent.md` | Archive useful sources to Raindrop with structured metadata |

### Codebase Cartographer

Explores and documents existing codebases into structured understanding documents.

| Agent | Purpose |
|-------|---------|
| `codebase-cartographer.agent.md` | Orchestrator: 3-phase pipeline (scan → analyze → map) |
| `codebase-cartographer.scan.agent.md` | Surface scanning: structure, tech stack, key files, health signals |
| `codebase-cartographer.analyze.agent.md` | Deep analysis: architecture patterns, domain model, code quality |
| `codebase-cartographer.map.agent.md` | Synthesize findings into 6 structured understanding documents |

---

## Skills

Skills are self-contained capability packages (`SKILL.md` + optional scripts/references/assets).

### Process & Engineering

| Skill | Description |
|-------|-------------|
| `brainstorming` | **GATE**: Design-first before any implementation. Explore intent → propose approaches → get approval |
| `using-superpowers` | Meta-skill: invoke relevant skills BEFORE any response |
| `compound-learnings` | Transform session patterns into permanent rules/skills/agents |
| `thinking-tools` | Structured self-reflection (collected-info, task-adherence, done-check) |
| `verification-before-completion` | Quality gate before declaring work done |
| `lesson-learned` | Extract SE principles from recent git changes |
| `self-learning` | Learn new tech from the web and create a skill for it |
| `find-skills` | Discover installable skills for a capability |

### Code Quality

| Skill | Description |
|-------|-------------|
| `clean-code` | Robert C. Martin's Clean Code principles (naming, functions, tests) |
| `clean-architecture` | Clean Architecture (42 rules across 8 categories) |
| `code-refactoring-refactor-clean` | Systematic refactoring workflow |
| `codebase-cleanup-refactor-clean` | Codebase-wide cleanup with SOLID principles |

### Research & Thinking

| Skill | Description |
|-------|-------------|
| `deep-research` | Multi-source synthesis with citations and confidence levels |
| `literature-review` | Academic literature review (Pacheco-Vega AIC method, CSE matrix) |
| `web-research` | Structured web research workflow |
| `first-principles-thinking` | Socratic coach: decompose to fundamentals, challenge assumptions |
| `design-thinking` | IDEO/Stanford d.school 5-phase innovation framework |
| `systems-thinking` | Map complex systems: leverage points, feedback loops, dynamics |
| `critical-thinking-logical-reasoning` | Analyze written content for logic, evidence, and fallacies |
| `scientific-critical-thinking` | Evaluate research rigor (GRADE, Cochrane ROB, statistics) |

### Frontend & UI

| Skill | Description |
|-------|-------------|
| `frontend-design` | Production-grade UI with distinctive aesthetics (anti-generic AI slop) |
| `ui-ux-pro-max` | 50 styles, 21 palettes, 50 font pairings, 20 charts, 9 stacks |
| `web-design-guidelines` | Review UI code against Web Interface Guidelines (a11y, UX) |
| `theme-factory` | 10+ curated color/typography themes |

### WordPress / Web

| Skill | Description |
|-------|-------------|
| `wordpress-pro` | WordPress themes, plugins, Gutenberg, WooCommerce, performance |
| `wp-plugin-development` | Plugin architecture, hooks, activation, Settings API |
| `wp-rest-api` | `register_rest_route`, controllers, authentication, schema |

### Content & Communication

| Skill | Description |
|-------|-------------|
| `skill-creator` | Create and evaluate skills with benchmark tooling |
| `communication-storytelling` | Transform analysis/data into persuasive narratives |
| `written-communication` | Clear, concise writing for memos, emails, strategy docs |
| `professional-communication` | Technical communication: emails, meetings, audience adaptation |
| `content-strategy` | Content planning, topic clusters, editorial calendar |
| `social-content` | Platform-specific social media content (LinkedIn, Twitter, etc.) |
| `marketing-ideas` | 139 proven marketing approaches organized by category |
| `markdown-documentation` | GitHub Flavored Markdown, READMEs, documentation formatting |
| `seo-audit` | Technical SEO, meta tags, on-page analysis |

### Document Processing

| Skill | Description |
|-------|-------------|
| `docx` | Create, read, edit, manipulate Word `.docx` files |
| `pdf` | Read, merge, split, annotate, OCR PDF files |
| `pptx` | Create, edit, parse PowerPoint presentations |
| `xlsx` | Spreadsheet creation, editing, data cleaning |
| `baoyu-slide-deck` | Generate professional slide deck images from content |

### Django / Python

| Skill | Description |
|-------|-------------|
| `django-expert` | Django models, views, serializers, ORM, DRF |
| `django-patterns` | Architecture patterns, REST API design, caching, signals |
| `django-security` | Authentication, CSRF, SQL injection prevention, secure deployment |
| `django-tdd` | pytest-django, TDD, factory_boy, mocking, DRF API testing |

### Infrastructure & DevOps

| Skill | Description |
|-------|-------------|
| `ansible-automation` | Playbooks, roles, inventory management |
| `ansible-expert` | Expert-level Ansible for configuration management and IaC |
| `cloudflare-dns` | Cloudflare DNS management with Azure/Kubernetes integration |
| `debian-linux-triage` | Triage Debian Linux issues (apt, systemd, AppArmor) |
| `secure-vps-setup` | Step-by-step Linux VPS hardening (Tailscale, Traefik, CrowdSec) |
| `vps-checkup` | Read-only VPS health and security audit |

### Home Assistant

| Skill | Description |
|-------|-------------|
| `home-assistant-automation-scripts` | Automations, scripts, blueprints, triggers/conditions/actions |
| `home-assistant-best-practices` | Native helpers, entity_id patterns, automation modes |
| `home-assistant-dashboards-cards` | Lovelace dashboards, views, card types, HACS |

### Blog & Writing

| Skill | Description |
|-------|-------------|
| `blog-post` | Long-form blog posts, tutorials, educational articles |
| `community-building` | Product community building and ambassador programs |
| `community-marketing` | Community-led growth and engagement strategies |

### Scientific / Data

| Skill | Description |
|-------|-------------|
| `scientific-writing` | IMRAD structure, citations, figures, journals |
| `scientific-visualization` | Publication-grade matplotlib, color palettes |
| `scientific-slides` | Beamer LaTeX + PowerPoint presentation templates |
| `scientific-critical-thinking` | Evaluate research rigor |
| `statistical-analysis` | Test selection, effect sizes, Bayesian stats |
| `deep-research` | Multi-source synthesis with citations |
| `exploratory-data-analysis` | EDA workflows and visualizations |

---

## Prompts

Slash-command prompts for common development tasks.

| Prompt | Purpose |
|--------|---------|
| `fix-and-refactor.prompt.md` | Diagnose root cause → refactor → TDD fix → lock with tests |
| `small-change.prompt.md` | Pattern discovery → code reuse hierarchy → implement |
| `compress.prompt.md` | Compress session context into `progress.md` handover file |
| `commit.prompt.md` | Conventional commit with review |
| `fix-tests.prompt.md` | Fix failing tests systematically |
| `sentinel.prompt.md` | Security-focused agent for Django/Python codebases |
| `documentation-writer.prompt.md` | Generate comprehensive documentation |
| `create-readme.prompt.md` | Create a README for any project |
| `create-agentsmd.prompt.md` | Bootstrap an AGENTS.md for a project |
| `create-technical-spike.prompt.md` | Create a technical spike research document |
| `copilot-instructions-blueprint-generator.prompt.md` | Generate a `copilot-instructions.md` |
| `prompt-builder.prompt.md` | Build and validate prompts with dual-persona workflow |
| `tldr-prompt.prompt.md` | Summarize content concisely |
| `speckit.*` | Full spec-kit workflow (specify → plan → tasks → implement → review) |
| `continue-spec.prompt.md` | Continue implementing a spec-kit feature |

---

## Instructions

Language and domain-specific coding standards (applied via `applyTo` glob).

| File | Applies To | Topics |
|------|-----------|--------|
| `python.instructions.md` | `**/*.py` | Clean Architecture, SOLID, Pydantic entities, type coverage 100% |
| `markdown.instructions.md` | `**/*.md` | YAML frontmatter, traceability matrix, bidirectional references |
| `task-implementation.instructions.md` | `**/.copilot-tracking/**` | Progressive tracking: plan → details → changes |
| `deep-research-templates.instructions.md` | `skills/deep-research/**` | Research pipeline document templates |
| `literature-review-templates.instructions.md` | `skills/literature-review/**` | AIC reading and CSE matrix templates |
| `php.instructions.md` | `**/*.php` | WordPress security, Meta Box, PHPStan |
| `javascript.instructions.md` | `**/*.js` | WordPress React, `createElement`, `apiFetch` |
| `scss.instructions.md` | `**/*.scss` | Bootstrap 4, variable overrides, responsive |
| `r.instructions.md` | `**/*.r, **/*.R` | R data science patterns |
| `html-css-style-color-guide.instructions.md` | `**/*.html, **/*.css` | HTML/CSS style guide |
| `agents.instructions.md` | `**/*.agent.md` | Agent file authoring guidelines |
| `agent-skills.instructions.md` | `**/SKILL.md` | Skill authoring guidelines |
| `instructions.instructions.md` | `**/*.instructions.md` | Meta: instructions about instructions |
| `memory.instructions.md` | `**/*` | Recurring patterns and lessons (project-specific) |
| `self-explanatory-code-commenting.instructions.md` | `**/*` | When/how to comment code |

---

## Chatmodes

VS Code chat modes that configure AI behavior for specialized workflows.

### Development

| Chatmode | Purpose |
|----------|---------|
| `prompt-builder.chatmode.md` | Dual-persona prompt engineering (Builder + Tester with 3-cycle validation) |
| `prompt-engineer.chatmode.md` | Analyze and improve any prompt against OpenAI best practices |
| `wg-code-alchemist.chatmode.md` | JARVIS-inspired Clean Code refactoring specialist |
| `janitor.chatmode.md` | Aggressive tech debt elimination (deletion-first approach) |
| `speckit-implementer.chatmode.md` | TDD implementation specialist for spec-kit task workflows |

### Research

| Chatmode | Purpose |
|----------|---------|
| `task-researcher.chatmode.md` | Research-only: explore options, guide selection, no implementation |
| `task-planner.chatmode.md` | Create actionable task plans with mandatory research validation |

---

## Philosophy

This repo implements the **"Prompts as Code"** principle described in
[docs/PromptOps Git Workflow and File Management.md](docs/PromptOps%20Git%20Workflow%20and%20File%20Management.md):

- AI instructions are versioned, modular, and testable
- Local `copilot-instructions.md` is a *build artifact* from upstream modules
- Skills share the context window — **concise is key**
- Agents have clear roles: Constraints (instructions) → Personas (agents) → Capabilities (skills)
