---
name: zettelkasten-orchestrator
description: "Orchestration logic for Zettelkasten knowledge management — routing, lifecycle management, maintenance protocols, and health checks. Use when managing the Zettelkasten system at scale, processing backlogs, making maintenance decisions, or coordinating between research and note-taking agents."
---

# Zettelkasten Orchestrator Skill

## Overview

The orchestrator is the control layer above the Zettelkasten MCP tools. While the tools handle individual operations (create, link, search), the orchestrator handles workflow decisions: what to do, in what order, when to delegate, and how to maintain system quality.

## When to Use This Skill

- Managing multiple notes or batch operations
- Deciding how to process a user's knowledge request
- Running maintenance or health checks on the system
- Coordinating between the Deep Research and Literature Review agents
- Processing a backlog of fleeting notes
- Creating or updating structure notes

## Routing Logic

### Decision Tree for User Requests

```
User request received
│
├─ Is it a quick capture? (single idea, no research needed)
│  └─ YES → Capture workflow (create note + link)
│
├─ Does it need research?
│  ├─ Academic literature → Delegate to Literature Reviewer
│  └─ General/mixed research → Delegate to Deep Researcher
│
├─ Is it about existing notes?
│  ├─ "Find connections" → Connection Discovery workflow
│  ├─ "Explore [topic]" → zk-knowledge-exploration.prompt.md
│  ├─ "Synthesize" → zk-knowledge-synthesis.prompt.md
│  └─ "Organize" → Structure Note Creation workflow
│
├─ Is it about system health?
│  └─ YES → Maintenance workflow
│
└─ Is it batch processing?
   ├─ "Process fleeting notes" → Fleeting Note Pipeline
   └─ "Create notes from [source]" → zk-knowledge-creation-batch.prompt.md
```

## Note Lifecycle

```
[External Input]
       │
       ▼
   ┌─────────┐     (quick capture, unprocessed thoughts)
   │ Fleeting │
   └────┬────┘
        │ research + formalize
        ▼
   ┌────────────┐    (extracted from a specific source with citations)
   │ Literature │
   └─────┬──────┘
         │ synthesize across sources
         ▼
   ┌───────────┐    (standalone insight, well-sourced, atomic)
   │ Permanent │
   └─────┬─────┘
         │ cluster 7-15 related notes
         ▼
   ┌───────────┐    (organizes a cluster of permanent notes)
   │ Structure │
   └─────┬─────┘
         │ entry point for broad domain
         ▼
   ┌─────┐          (navigational index for major topic areas)
   │ Hub │
   └─────┘
```

### Lifecycle Rules

1. **Fleeting notes** should not persist longer than 1 week
2. **Literature notes** are permanent but should link to permanent notes they inform
3. **Permanent notes** should have 2+ links within 24 hours of creation
4. **Structure notes** should reference 7-15 notes (not fewer, not much more)
5. **Hub notes** should be reviewed monthly for completeness

## Maintenance Protocols

### Daily (if active)
- Process new fleeting notes

### Weekly
- Count fleeting note backlog → if > 10, prioritize processing
- Review recently created notes → ensure they have links

### Monthly
- Run full orphan detection → `zk_find_orphaned_notes`
- Review central notes → `zk_find_central_notes` → are they accurate hubs?
- Tag audit → `zk_get_all_tags` → merge near-duplicates, remove unused
- Structure note review → are clusters well-organized?

### System Health Report Template

```markdown
## Zettelkasten Health Report — {{YYYY-MM-DD}}

### Metrics
- Total notes: {{N}} (approximate)
- Orphaned notes: {{N}} (should be < 5%)
- Fleeting backlog: {{N}} (should be < 10)
- Central note count: {{N}}
- Tag count: {{N}}

### Issues Found
1. {{issue description}} — {{severity: low/medium/high}}
2. {{issue description}} — {{severity}}

### Recommended Actions
1. {{action}} — {{priority}}
2. {{action}} — {{priority}}
```

## Research Tracking System

### Workspace Structure

All agent research and review process artifacts live in `notes/research-tracking/`, separate from the permanent Zettelkasten:

```
notes/research-tracking/
├── sessions/     # Active research or review sessions
│   └── YYYYMMDD-descriptive-topic/
│       ├── research-log.md        # Deep Researcher: running process log
│       ├── source-assessment.md   # Deep Researcher: source register
│       ├── research-brief.md      # Deep Researcher: final synthesis
│       ├── literature-matrix.md   # Lit Reviewer: master tracker
│       ├── conceptual-synthesis.md# Lit Reviewer: CSE matrix
│       └── memo-*.md              # Lit Reviewer: theme memos
├── plans/        # Research plans (created before sessions start)
│   └── YYYYMMDD-topic-plan.md
└── archive/      # Completed sessions (moved from sessions/)
```

### Session Management Protocol

**Starting a session**:

1. Check `notes/research-tracking/sessions/` for an existing session on the topic
2. If none exists, create `YYYYMMDD-descriptive-topic/` folder
3. If a plan exists in `plans/`, reference it when creating session artifacts
4. Initialize the appropriate templates based on which agent will do the work

**During a session**:

- All session artifacts are **living documents** — update in place, never duplicate
- Remove outdated content immediately — replace with current findings
- Consolidate related findings — no redundancy across sections
- Date-stamp significant updates within each file

**Completing a session**:

1. Verify all permanent insights have been pushed to Zettelkasten
2. Ensure session artifacts have accurate final state (not stale intermediate data)
3. Move the session folder from `sessions/` to `archive/`
4. Update any Zettelkasten structure notes that reference the research topic

### Naming Convention

- Folders: `YYYYMMDD-descriptive-topic-name` (kebab-case)
- Plans: `YYYYMMDD-topic-plan.md`
- Memos: `memo-theme-name.md` (within session folder)

### Information Hygiene

Adapted from the living-document pattern:

- **Never create duplicate files** for the same artifact — update existing ones
- **Remove superseded content** immediately when better information is found
- **Eliminate redundancy** — if a finding appears in two places, consolidate
- **Delete non-selected alternatives** once a research direction is chosen
- **Keep the session folder clean** — only artifacts relevant to the active research

## Coordination Patterns

### Deep Researcher → Zettelkasten

When the Deep Research agent produces findings:

1. Receive Research Brief and permanent notes
2. Verify notes have proper tags, citations, and structure
3. Find connection opportunities with existing notes
4. Create links between new research notes and existing knowledge
5. Create structure note if the research created 5+ related notes
6. Update any existing structure notes that now have new members

### Literature Reviewer → Zettelkasten

When the Literature Review agent produces outputs:

1. Receive AIC literature notes and research memos
2. Verify literature notes have full citation data
3. Store memos as permanent notes with `research-memo` tag
4. Link literature notes to the memos they inform
5. Update CSE matrix if one exists for this topic
6. Link to existing knowledge network

### Zettelkasten → Research (Reverse Flow)

When note exploration reveals knowledge gaps:

1. During exploration, note questions that can't be answered internally
2. Formulate as research requests
3. Route to Deep Researcher or Literature Reviewer as appropriate
4. Tag the requesting note with `needs-research`
5. Create a plan in `notes/research-tracking/plans/` scoping the needed research

## Quality Checks

Before any note enters the system:

| Check | For Note Types | Action if Fails |
|-------|---------------|----------------|
| Has title | All | Reject — require title |
| Has tags (2-5) | All | Add tags or ask user |
| Has at least 1 link | Literature, Permanent | Create link or document why isolated |
| Has citations | Permanent, Literature | Add citations or downgrade to fleeting |
| Atomic (single concept) | Permanent | Split into multiple notes |
| Correct type | All | Reclassify |

## Templates Reference

| Template | Location | Used By |
|----------|----------|---------|
| Fleeting | `.github/skills/zettelkasten/templates/fleeting.md` | Capture workflow |
| Literature | `.github/skills/zettelkasten/templates/literature.md` | Literature Review |
| Permanent | `.github/skills/zettelkasten/templates/permanent.md` | All synthesis |
| Structure | `.github/skills/zettelkasten/templates/structure.md` | Organization |
| Hub | `.github/skills/zettelkasten/templates/hub.md` | Major topics |
| Health Report | Inline above | Maintenance |
| Research Plan | `.github/skills/zettelkasten-orchestrator/templates/research-plan.md` | Session planning |
| Session README | `.github/skills/zettelkasten-orchestrator/templates/session-readme.md` | Session initialization |

### Research Tracking Templates

| Template | Location | Used By |
|----------|----------|---------|
| Research Brief | `.github/skills/deep-research/templates/research-brief.md` | Deep Researcher |
| Source Assessment | `.github/skills/deep-research/templates/source-assessment.md` | Deep Researcher |
| Research Log | `.github/skills/deep-research/templates/research-log.md` | Deep Researcher |
| Synthesis Report | `.github/skills/deep-research/templates/synthesis-report.md` | Deep Researcher |
| Analytical Note | `.github/skills/literature-review/templates/analytical-note.md` | Literature Reviewer |
| CSE Matrix | `.github/skills/literature-review/templates/conceptual-synthesis.md` | Literature Reviewer |
| Research Memo | `.github/skills/literature-review/templates/research-memo.md` | Literature Reviewer |
| Literature Matrix | `.github/skills/literature-review/templates/literature-matrix.md` | Literature Reviewer |
