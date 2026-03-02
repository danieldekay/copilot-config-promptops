# Catalog — copilot-config-promptops

> Complete annotated index of all agents, skills, prompts, instructions, and chatmodes.
> Last updated: 2026-03-02

## Quality Rating Scale

| Rating | Meaning |
|--------|---------|
| ★★★★★ | Production-ready, comprehensive, highly reusable |
| ★★★★☆ | Mature, minor refinement possible |
| ★★★☆☆ | Useful but incomplete or narrowly scoped |

---

## Agents (48)

### Code Quality Pipeline (5)

| File | Rating | Description |
|------|--------|-------------|
| `code-review.agent.md` | ★★★★★ | Staged-file review; produces code-review.md, code-smells.md, tech-debt.md |
| `code-fix.agent.md` | ★★★★☆ | Auto-fixes Critical/Major findings from review artifacts |
| `commit.agent.md` | ★★★★☆ | Orchestrates review → fix → conventional commit workflow |
| `engineering-manager.agent.md` | ★★★★☆ | Routes Fix/Feature/Review/Audit/Ship modes to specialists |
| `browser-testing.agent.md` | ★★★★☆ | Playwright: smoke, regression, UI, API, a11y tests |

### Codebase Audit Suite (6)

| File | Rating | Description |
|------|--------|-------------|
| `codebase-audit.agent.md` | ★★★★☆ | Orchestrates 5-subagent audit pipeline |
| `codebase-analyze.agent.md` | ★★★★☆ | Per-file/class structural analysis with findings |
| `codebase-proposals.agent.md` | ★★★★☆ | S/M/L improvement roadmap from analysis findings |
| `codebase-arch-docs.agent.md` | ★★★★☆ | Architecture maps, pattern catalogs, dependency graphs |
| `codebase-doc-updater.agent.md` | ★★★☆☆ | Docstrings and type annotation updates |
| `codebase-modern-patterns.agent.md` | ★★★★☆ | 2026 best practices assessment |

### Codebase Cartographer (4)

| File | Rating | Description |
|------|--------|-------------|
| `codebase-cartographer.agent.md` | ★★★★★ | 3-phase explore pipeline orchestrator |
| `codebase-cartographer.scan.agent.md` | ★★★★★ | Phase 1: Structure, tech stack, health signals |
| `codebase-cartographer.analyze.agent.md` | ★★★★☆ | Phase 2: Architecture patterns, domain model, code quality |
| `codebase-cartographer.map.agent.md` | ★★★★☆ | Phase 3: Synthesizes into 6 understanding documents |

### Deep Research Pipeline (7)

| File | Rating | Description |
|------|--------|-------------|
| `deep-researcher.agent.md` | ★★★★★ | 5-tier research pipeline orchestrator |
| `deep-research.gather.agent.md` | ★★★★★ | Tier 1: Broad data collection (7–10 varied queries) |
| `deep-research.process.agent.md` | ★★★★☆ | Tier 2: Triage, classify, quality-rate (5 tiers) |
| `deep-research.extract.agent.md` | ★★★★☆ | Tier 3: Deep reading and structured extraction |
| `deep-research.evaluate.agent.md` | ★★★★☆ | Tier 4: Cross-reference, triangulate, confidence scoring |
| `deep-research.synthesize.agent.md` | ★★★★☆ | Tier 5: Transform evidence into knowledge artifacts |
| `deep-research.bookmark.agent.md` | ★★★☆☆ | Utility: Archive sources to Raindrop |

### Spec-Kit Workflow (17)

| File | Rating | Description |
|------|--------|-------------|
| `speckit.agent.md` | ★★★★★ | Full 9-stage lifecycle orchestrator (manager/router) |
| `speckit.orchestrator.agent.md` | ★★★★★ | State analyzer and routing engine |
| `speckit.specify.agent.md` | ★★★★★ | Create feature spec from natural language |
| `speckit.clarify.agent.md` | ★★★★★ | 5 targeted clarification questions → encode into spec |
| `speckit.tasks.agent.md` | ★★★★★ | Dependency-ordered task breakdown from design artifacts |
| `speckit.checklist.agent.md` | ★★★★★ | "Unit tests for requirements" — implementation checklist |
| `speckit.review.agent.md` | ★★★★★ | 6-category code review with severity levels |
| `speckit.quality-gate.agent.md` | ★★★★☆ | 7-check automated quality gate (format, lint, type, test, coverage, security) |
| `speckit.implement.agent.md` | ★★★★☆ | TDD execution from tasks.md with checklist gating |
| `speckit.constitution.agent.md` | ★★★★☆ | Create/update project constitution; sync templates |
| `speckit.analyze.agent.md` | ★★★★☆ | Cross-artifact consistency and quality audit |
| `speckit.commit.agent.md` | ★★★★☆ | Conventional commit with pre-commit verification |
| `speckit.retro.agent.md` | ★★★★☆ | Retrospective analysis and improvement proposals |
| `speckit.autofix.agent.md` | ★★★☆☆ | Bounded auto-fix of quality gate failures |
| `speckit.plan.agent.md` | ★★★☆☆ | Technical design generation |
| `speckit.taskstoissues.agent.md` | ★★☆☆☆ | Convert tasks → GitHub Issues (incomplete) |
| `speckit.ui.agent.md` | ★★★★☆ | UI-specific spec and implementation |

### Standalone (9)

| File | Rating | Description |
|------|--------|-------------|
| `prompt-builder.agent.md` | ★★★★★ | Dual-persona prompt engineering (Builder + Tester) |
| `prompt-engineer.agent.md` | ★★★★☆ | Prompt analysis against OpenAI best practices |
| `wg-code-alchemist.agent.md` | ★★★★☆ | JARVIS-style Clean Code refactoring |
| `janitor.agent.md` | ★★★★☆ | Tech debt elimination (deletion-first) |
| `r-datascientist.agent.md` | ★★★★☆ | R + Tufte-quality data analysis |
| `research-technical-spike.agent.md` | ★★★★☆ | Technical spike research |
| `plan.agent.md` | ★★★★☆ | General planning agent |
| `prd.agent.md` | ★★★★☆ | Product requirements document |
| `planner.agent.md` | ★★★☆☆ | Lightweight planner |
| `playwright-tester.agent.md` | ★★★☆☆ | Playwright test agent |

---

## Skills (85)

### Tier 1 — Production-Ready (★★★★★)

| Skill | Source | Description |
|-------|--------|-------------|
| `deep-research` | — | 5-tier orchestrator methodology with subagent architecture |
| `literature-review` | — | Pacheco-Vega AIC reading, CSE matrix, research memos |
| `skill-creator` | — | Full eval/test/iterate loop for creating skills |
| `compound-learnings` | — | Pattern extraction → skills/rules/agents |
| `thinking-tools` | — | 3 structured reflection patterns + iron laws |

### Process & Engineering (★★★★☆)

| Skill | Description |
|-------|-------------|
| `brainstorming` | **GATE**: Before ANY creative work — explore → design → approve |
| `using-superpowers` | Meta-skill: invoke relevant skills BEFORE acting |
| `verification-before-completion` | Quality gate before declaring work done |
| `lesson-learned` | 4-phase reflective approach from git history |
| `self-learning` | Web-based technology discovery, auto-create skills |
| `find-skills` | CLI reference for skill discovery |
| `writing-plans` | Convert designs to actionable implementation plans |
| `git-ops` | Git workflows, branch strategies, PR management |
| `writing-skills` | Skill writing and testing |

### Code Quality & Architecture (★★★★☆)

| Skill | Description |
|-------|-------------|
| `clean-architecture` | 42 rules across 8 categories from Robert C. Martin |
| `clean-code` | Uncle Bob reference — naming, functions, comments, tests |
| `code-refactoring-refactor-clean` | Systematic: identify smells → extract → simplify → test |
| `codebase-cleanup-refactor-clean` | SOLID at codebase scale, DRY, SRP, cohesion |

### Research & Thinking (★★★★☆)

| Skill | Description |
|-------|-------------|
| `web-research` | Structured web research with subagent delegation |
| `first-principles-thinking` | Socratic coach: break to fundamentals, challenge assumptions |
| `systems-thinking` | 6 principles, stakeholder mapping, feedback loops |
| `design-thinking` | IDEO/Stanford d.school 5-phase innovation process |
| `critical-thinking-logical-reasoning` | Analyze written content for logic, biases, fallacies |
| `hypothesis-generation` | Scientific hypothesis formulation |
| `research-lookup` | Literature survey and citation |

### Django & Python (★★★★☆)

| Skill | Description |
|-------|-------------|
| `django-expert` | Models, views, serializers, ORM, DRF |
| `django-patterns` | Architecture patterns, REST API, caching, signals |
| `django-security` | Auth, CSRF, SQL injection, secure deployment |
| `django-tdd` | pytest-django, TDD, factory_boy, mocking |

### WordPress & Web (★★★★☆)

| Skill | Description |
|-------|-------------|
| `wordpress-pro` | Themes, plugins, Gutenberg, WooCommerce |
| `wp-plugin-development` | Hooks, activation/deactivation, admin UI, security |
| `wp-rest-api` | REST routes, controllers, schema validation, auth |

### Infrastructure & DevOps (★★★★☆)

| Skill | Description |
|-------|-------------|
| `ansible-automation` | Playbooks, roles, inventory management |
| `ansible-expert` | Expert-level Ansible for IaC |
| `cloudflare-dns` | Cloudflare DNS + Azure/K8s integration |
| `debian-linux-triage` | apt, systemd, AppArmor triage |
| `secure-vps-setup` | VPS hardening (Tailscale, Traefik, CrowdSec) |
| `vps-checkup` | Read-only VPS health/security audit |

### Home Assistant (★★★★☆)

| Skill | Description |
|-------|-------------|
| `home-assistant-automation-scripts` | Automations, scripts, blueprints, run modes |
| `home-assistant-best-practices` | Native helpers, entity_id patterns, automation modes |
| `home-assistant-dashboards-cards` | Lovelace dashboards, views, HACS cards |

### Content & Communication (★★★★☆)

| Skill | Description |
|-------|-------------|
| `blog-post` | Long-form blog tutorials and educational articles |
| `communication-storytelling` | Transform analysis into persuasive narratives |
| `written-communication` | Clear, concise writing for professional contexts |
| `professional-communication` | Email, meetings, audience adaptation |
| `content-strategy` | Topic clusters, editorial calendar, SEO planning |
| `social-content` | Platform-specific social media (LinkedIn, Twitter/X) |
| `internal-comms` | Status reports, leadership updates, incident reports |
| `marketing-ideas` | 139 proven marketing approaches by category |
| `community-building` | Product community building and growth |
| `community-marketing` | Community-led growth strategies |
| `markdown-documentation` | GitHub Flavored Markdown and documentation formatting |
| `seo-audit` | Technical SEO, meta tags, AEO/GEO patterns |
| `market-research-reports` | Structured market analysis reports |

### Frontend & UI (★★★★☆)

| Skill | Description |
|-------|-------------|
| `frontend-design` | Production-grade UI, anti-generic AI aesthetics |
| `ui-ux-pro-max` | 50 styles, 21 palettes, 50 font pairings, 9 stacks |
| `web-design-guidelines` | Web Interface Guidelines audit (a11y, UX, contrast) |
| `theme-factory` | 10 curated color/typography themes |

### Scientific & Data (★★★★☆)

| Skill | Description |
|-------|-------------|
| `scientific-writing` | IMRAD, citations, journals, reporting guidelines |
| `scientific-visualization` | Publication-grade matplotlib, mplstyle |
| `scientific-slides` | Beamer LaTeX templates (conference/defense/seminar) |
| `scientific-critical-thinking` | GRADE, Cochrane ROB, statistics, methodology |
| `scientific-brainstorming` | Research ideation and direction exploration |
| `scientific-schematics` | Technical diagram generation |
| `statistical-analysis` | Test selection, effect sizes, power, Bayesian |
| `statsmodels` | Python statsmodels: GLM, time series, discrete choice |
| `exploratory-data-analysis` | EDA workflows |
| `scholar-evaluation` | Academic paper evaluation |
| `citation-management` | Reference management |
| `peer-review` | Peer review workflows |
| `research-grants` | Grant writing |

### Document Processing (★★★★☆)

| Skill | Description |
|-------|-------------|
| `docx` | Word document create, read, edit, manipulate |
| `pdf` | PDF read, merge, split, annotate, OCR |
| `pptx` | PowerPoint create, edit, parse |
| `pptx-posters` | Research/conference poster creation |
| `xlsx` | Spreadsheet creation, editing, data cleaning, formulas |
| `markitdown` | Document → Markdown conversion |
| `baoyu-slide-deck` | Slide deck image generation |

### Dev Tools (★★★☆☆–★★★★☆)

| Skill | Description |
|-------|-------------|
| `db-migrations` | Database migration patterns, rollback strategies |
| `mcp-builder` | Model Context Protocol server development |
| `perplexity-search` | Perplexity AI search integration |
| `get-available-resources` | Discover tools, MCPs, capabilities |
| `doc-coauthoring` | Collaborative document editing workflows |
| `algorithmic-art` | Code-generated generative art |

---

## Prompts (25)

### Spec-Kit Workflow (12)

| File | Rating | Description |
|------|--------|-------------|
| `speckit.specify.prompt.md` | ★★★★☆ | Create feature spec from description |
| `speckit.clarify.prompt.md` | ★★★★☆ | Identify underspecified areas |
| `speckit.plan.prompt.md` | ★★★★☆ | Generate technical design |
| `speckit.tasks.prompt.md` | ★★★★☆ | Create dependency-ordered tasks |
| `speckit.implement.prompt.md` | ★★★★☆ | Execute implementation from tasks |
| `speckit.review.prompt.md` | ★★★★☆ | Review implemented code |
| `speckit.analyze.prompt.md` | ★★★★☆ | Cross-artifact consistency check |
| `speckit.checklist.prompt.md` | ★★★★☆ | Generate implementation checklist |
| `speckit.constitution.prompt.md` | ★★★★☆ | Create/update project constitution |
| `speckit.taskstoissues.prompt.md` | ★★★☆☆ | Convert tasks to GitHub Issues |
| `speckit.ui.prompt.md` | ★★★★☆ | UI spec and implementation |
| `continue-spec.prompt.md` | ★★★★☆ | Resume spec-kit implementation |

### Development (5)

| File | Rating | Description |
|------|--------|-------------|
| `fix-and-refactor.prompt.md` | ★★★★☆ | Root cause → refactor → TDD fix → test coverage |
| `commit.prompt.md` | ★★★★☆ | Review-first conventional commit |
| `fix-tests.prompt.md` | ★★★★☆ | Systematic failing test diagnosis and fix |
| `compress.prompt.md` | ★★★★☆ | Context → `progress.md` handover |
| `small-change.prompt.md` | ★★★★☆ | Pattern discovery → reuse hierarchy → implement |

### Documentation & Utility (9)

| File | Rating | Description |
|------|--------|-------------|
| `documentation-writer.prompt.md` | ★★★★☆ | Generate comprehensive documentation |
| `create-readme.prompt.md` | ★★★★☆ | Bootstrap a README for any project |
| `create-agentsmd.prompt.md` | ★★★★☆ | Bootstrap an AGENTS.md |
| `copilot-instructions-blueprint-generator.prompt.md` | ★★★★☆ | Generate copilot-instructions.md |
| `create-technical-spike.prompt.md` | ★★★★☆ | Technical spike research document |
| `prompt-builder.prompt.md` | ★★★★☆ | Build and improve prompts |
| `sentinel.prompt.md` | ★★★☆☆ | Security sentinel review |
| `tldr-prompt.prompt.md` | ★★★☆☆ | Summarization |

---

## Instructions (15)

### Language & Framework (7)

| File | Rating | `applyTo` | Key Features |
|------|--------|-----------|--------------|
| `python.instructions.md` | ★★★★★ | `**/*.py` | Clean Architecture, SOLID, Pydantic, 100% type coverage |
| `markdown.instructions.md` | ★★★★★ | `**/*.md` | YAML frontmatter, traceability matrix, bidirectional refs |
| `php.instructions.md` | ★★★★☆ | `**/*.php` | WordPress security (sanitize/escape/nonce), Meta Box, PHPStan |
| `javascript.instructions.md` | ★★★★☆ | `**/*.js` | WordPress React, createElement, apiFetch, service layer |
| `scss.instructions.md` | ★★★★☆ | `**/*.scss` | Bootstrap 4, variable overrides, mixins, responsive |
| `r.instructions.md` | ★★★★☆ | `**/*.r` | R data science, tidyverse patterns |
| `html-css-style-color-guide.instructions.md` | ★★★★☆ | `**/*.html` | HTML/CSS style, color, typography guide |

### Workflow & Templates (3)

| File | Rating | `applyTo` | Key Features |
|------|--------|-----------|--------------|
| `task-implementation.instructions.md` | ★★★★☆ | `.copilot-tracking/**` | Progressive tracking: plan → details → changes |
| `deep-research-templates.instructions.md` | ★★★★☆ | `skills/deep-research/**` | Research pipeline templates |
| `literature-review-templates.instructions.md` | ★★★★☆ | `skills/literature-review/**` | AIC + CSE templates |

### Meta (5)

| File | Rating | `applyTo` | Key Features |
|------|--------|-----------|--------------|
| `agents.instructions.md` | ★★★★☆ | `**/*.agent.md` | Agent authoring: frontmatter fields, tools, handoffs |
| `agent-skills.instructions.md` | ★★★★☆ | `**/SKILL.md` | Skill authoring: concise, context-efficient |
| `instructions.instructions.md` | ★★★★☆ | `**/*.instructions.md` | Meta: how to write good instruction files |
| `self-explanatory-code-commenting.instructions.md` | ★★★★☆ | `**/*` | When and how to comment code without noise |
| `memory.instructions.md` | ★★★☆☆ | `**/*` | Recurring patterns, lessons, known fixes |

---

## Chatmodes (7)

### Development (5)

| File | Rating | Description |
|------|--------|-------------|
| `prompt-builder.chatmode.md` | ★★★★★ | Dual-persona prompt engineering (Builder + Tester, 3 validation cycles) |
| `wg-code-alchemist.chatmode.md` | ★★★★★ | JARVIS-inspired Clean Code refactoring |
| `task-planner.chatmode.md` | ★★★★★ | Actionable task plans with mandatory research validation |
| `speckit-implementer.chatmode.md` | ★★★★★ | TDD implementation for spec-kit workflows |
| `prompt-engineer.chatmode.md` | ★★★★☆ | Prompt analysis against OpenAI best practices |
| `janitor.chatmode.md` | ★★★★☆ | Aggressive tech debt elimination (deletion-first) |

### Research (2)

| File | Rating | Description |
|------|--------|-------------|
| `task-researcher.chatmode.md` | ★★★★★ | Research-only (no implementation), alternative analysis |
| `task-planner.chatmode.md` | ★★★★★ | Create actionable task plans with mandatory research validation |
