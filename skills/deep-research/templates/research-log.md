# Research Log — {{Research Topic}}

---
type: research-log
created_date: "{{YYYY-MM-DD}}"
created_time: "{{HH:MM:SS}} UTC"
research_agent: "deep-researcher"
status: "in-progress"
---

## Research Question

{{The question driving this research session}}

## Session Context

- **Initiated by**: {{user request or upstream agent}}
- **Constraints**: {{time, scope, specific requirements}}
- **Expected output**: {{brief, report, notes, etc.}}

## Mandatory Research Dimensions

Every research session MUST explore all five dimensions. Track coverage here.

| # | Dimension | Status | Sources Found | Notes |
|---|-----------|--------|---------------|-------|
| 1 | Field Landscape | {{pending/done}} | {{N}} | {{subfields, adjacent areas, key terms}} |
| 2 | Key People & Publishers | {{pending/done}} | {{N}} | {{who is publishing, key voices}} |
| 3 | Alternative Approaches | {{pending/done}} | {{N}} | {{competing methods, frameworks, tools}} |
| 4 | Best Practices | {{pending/done}} | {{N}} | {{what is considered best practice}} |
| 5 | Critical Essentials | {{pending/done}} | {{N}} | {{most important things to know}} |

---

## Pre-Flight: Existing Bookmarks

**Status**: {{pending/completed}}
**Bookmark count**: {{N}} relevant bookmarks found

Raindrop bookmarks searched before pipeline start. These are pre-existing curated sources that seed Tier 1.

| # | Title | URL | Tags | Excerpt | Priority |
|---|-------|-----|------|---------|---------|
| 1 | {{title}} | {{url}} | {{tags}} | {{excerpt}} | {{high/normal — high if aic-processed or has ZK link}} |

**Notes**: {{any observations about bookmark coverage, gaps, or already-vetted items}}

---

## Tier 1: GATHER

**Status**: pending
**Gate**: pending
**Started**: —
**Completed**: —
**Agent**: `deep-research.gather`

### Search Queries Executed

| # | Query | Tool | Dimension | Results | Quality | Considered? | Notes |
|---|-------|------|-----------|---------|---------|-------------|-------|
| 1 | {{query}} | tavily_search | {{dimension}} | {{N}} hits | {{A/B/C}} | {{yes/no}} | {{why kept or discarded}} |
| 2 | {{query}} | tavily_search | {{dimension}} | {{N}} hits | {{A/B/C}} | {{yes/no}} | {{why}} |
| 3 | {{query}} | brave_web_search | {{dimension}} | {{N}} hits | {{A/B/C}} | {{yes/no}} | {{why}} |
| 4 | {{query}} | tavily_crawl | {{dimension}} | {{pages}} | {{A/B/C}} | {{yes/no}} | {{why}} |

### Internal Knowledge Check

- Zettelkasten: {{N}} existing notes found on `{{query}}`
- Relevant existing notes: {{list with IDs or "none"}}

### Curated Bookmarks Check

- Raindrop searches: {{N}} queries executed
- Bookmarks found: {{N}} relevant hits
- Pre-vetted sources (tagged `aic-processed` or with ZK links): {{N}}

| # | Search Query/Method | Results | Notes |
|---|-------------------|---------|-------|
| 1 | search_bookmarks_by_text("{{term}}") | {{N}} hits | {{quality note}} |
| 2 | search_bookmarks_by_tags(["{{tag}}"]) | {{N}} hits | {{quality note}} |

### Raw Sources Collected: {{N}}

### Academic Sources with PDFs: {{N}}

| # | Title | Authors | PDF URL | Format | Status |
|---|-------|---------|---------|--------|--------|
| 1 | {{title}} | {{authors}} | {{url}} | {{arXiv/journal/preprint}} | {{available/paywall/not found}} |

**Gate check**: [ ] ≥15 unique sources [ ] ≥3 source categories [ ] All 5 dimensions searched [ ] ≥3 dimensions have sources

---

## Tier 2: PROCESS

**Status**: pending
**Gate**: pending
**Started**: —
**Completed**: —
**Agent**: `deep-research.process`

### Filtering Decisions

| Source | Decision | Reason |
|--------|----------|--------|
| {{title}} | ✅ Keep | Tier {{X}}, core relevance |
| {{title}} | ❌ Drop | {{reason}} |

### Source Register: → See `source-assessment.md`

**Gate check**: [ ] Source Register completed [ ] ≥3 Tier 1-2 sources

---

## Bookmarking

**Status**: pending
**Agent**: `deep-research.bookmark`

### Initial Bookmarking (after Tier 2)

ALL non-discarded sources are bookmarked — this is not optional.

- Sources bookmarked: {{N}} / {{total non-discarded}}
- Failures: {{list or "none"}}

### Enrichment (after Tier 5)

- Sources enriched with ZK IDs: {{N}}
- Failures: {{list or "none"}}

---

## Tier 3: READ & UNDERSTAND

**Status**: pending
**Gate**: pending
**Started**: —
**Completed**: —
**Agent**: `deep-research.extract`

### Extraction Notes

#### {{Source Title}} (Tier {{X}})

- **Core claims**: {{list}}
- **Evidence type**: {{empirical/theoretical/anecdotal}}
- **Methodology**: {{how they reached their conclusions}}
- **Limitations acknowledged**: {{what they say they don't cover}}
- **Connection to other sources**: {{agreements, extensions, contradictions}}

#### {{Source Title}} (Tier {{X}})

- **Core claims**: {{list}}
- **Evidence type**: {{type}}
- **Key data points**: {{specific facts or figures}}

**Gate check**: [ ] All Tier 1-3 sources have extraction notes

---

## Tier 3b: PDF ANALYSIS

**Status**: pending
**Gate**: pending
**Started**: —
**Completed**: —
**Agent**: `deep-research.analyze-pdf`

### Papers Analyzed

| # | Title | PDF Source | AIC Completed | Analysis File | Archive Path |
|---|-------|-----------|---------------|---------------|-------------|
| 1 | {{title}} | {{url}} | {{yes/no}} | `pdf-analysis-{{slug}}.md` | `notes/papers/{{file}}` |
| 2 | {{title}} | {{url}} | {{yes/no}} | `pdf-analysis-{{slug}}.md` | `notes/papers/{{file}}` |

### Download Results

- PDFs successfully obtained: {{N}} / {{total identified}}
- Paywalled (abstracts only): {{N}}
- Not available: {{N}}

**Gate check**: [ ] All available PDFs have AIC analysis files [ ] Papers archived to notes/papers/

---

## Tier 4: EVALUATE

**Status**: pending
**Gate**: pending
**Started**: —
**Completed**: —
**Agent**: `deep-research.evaluate`

### Triangulation Results

{{Summary of which claims are well-supported vs. contested}}

### Key Contradictions Found

{{Brief description of conflicts and possible explanations}}

### Unanswered Questions

1. {{question}}
2. {{question}}

**Gate check**: [ ] Triangulation matrix done [ ] Confidence scores assigned

---

## Tier 5: SYNTHESIZE

**Status**: pending
**Gate**: pending
**Started**: —
**Completed**: —
**Agent**: `deep-research.synthesize`

### Artifacts Produced

- [ ] Research Brief → `{{path}}`
- [ ] Open Questions → `{{path}}`
- [ ] Hypotheses → `{{path}}`
- [ ] Further Research → `{{path}}`
- [ ] Source Assessment → `{{path}}`
- [ ] Synthesis Report → `{{path}}`
- [ ] PDF Analyses → `{{count}} files`
- [ ] Zettelkasten notes created: {{list of note IDs}}
- [ ] Links created: {{count}}

### Zettelkasten Integration

| Note ID | Title | Type | Tags | Linked To |
|---------|-------|------|------|-----------|
| {{id}} | {{title}} | permanent | {{tags}} | {{linked_ids}} |

---

## Tier 5b: DIAGRAM

**Status**: pending
**Gate**: pending
**Started**: —
**Completed**: —
**Agent**: `deep-research.diagram`

### Diagram Decision

- **Complex enough for diagram?**: {{yes/no — requires 3+ interrelated subfields}}
- **Diagram type**: {{field map | concept map | comparison | timeline}}

### Diagram Output

- [ ] Field map diagram → `field-map.drawio`
- Node count: {{N}}
- Edge count: {{N}}
- Node types used: {{list}}

**Gate check**: [ ] Diagram created (if applicable) [ ] All entities from research represented

---

## Session Output Manifest

All documents produced in this session:

| # | Document | Path | Status |
|---|----------|------|--------|
| 1 | Research Log | `research-log.md` | {{status}} |
| 2 | Research Brief | `research-brief.md` | {{status}} |
| 3 | Open Questions | `open-questions.md` | {{status}} |
| 4 | Hypotheses | `hypotheses.md` | {{status}} |
| 5 | Further Research | `further-research.md` | {{status}} |
| 6 | Source Assessment | `source-assessment.md` | {{status}} |
| 7 | Synthesis Report | `synthesis-report.md` | {{if applicable}} |
| 8 | Field Map Diagram | `field-map.drawio` | {{if applicable}} |
| 9 | PDF Analyses | `pdf-analysis-*.md` | {{count}} files |

---

## Session Summary

- **Total time**: {{duration}}
- **Sources surveyed**: {{N}}
- **Sources retained**: {{N}}
- **Sources bookmarked to Raindrop**: {{N}}
- **PDFs analyzed**: {{N}}
- **Hypotheses generated**: {{N}}
- **Open questions identified**: {{N}}
- **Further research directions**: {{N}}
- **Key insight**: {{one-line takeaway}}
- **Confidence in conclusions**: {{High/Medium/Low}}
- **Follow-up needed**: {{yes/no — what}}
- **Dimension coverage**: {{N}}/5 dimensions with sources
