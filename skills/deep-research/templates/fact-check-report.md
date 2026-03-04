# Fact-Check Report — {{Content Title or Set}}

---
type: fact-check-report
created_date: "{{YYYY-MM-DD}}"
created_time: "{{HH:MM:SS}} UTC"
author: "Daniel"
research_agent: "deep-researcher"
mode: "fact-check"
status: "{{draft|final}}"
content_audited:
  - "{{file_path_1}}"
  - "{{file_path_2}}"
tags: ["fact-check", "{{topic_tag}}"]
---

## Executive Summary

{{2-3 sentences: how many claims extracted, how many verified/corrected/flagged, overall confidence.}}

## Verdicts Overview

| Verdict | Count |
|---------|-------|
| ✅ Verified | {{N}} |
| ⚠️ Partially correct | {{N}} |
| ❌ Incorrect | {{N}} |
| 🔍 Unverifiable | {{N}} |
| 🆕 Enrichment opportunity | {{N}} |

---

## Claim Register

### Claim {{N}}: "{{verbatim claim from content}}"

- **Source file**: `{{file_path}}`
- **Claim type**: {{statistic | historical event | technical fact | attributed concept | trend assertion | platform behavior | legal/policy}}
- **Verdict**: {{✅ Verified | ⚠️ Partially correct | ❌ Incorrect | 🔍 Unverifiable}}

#### Supporting Evidence

| # | Source | Tier | Key Detail |
|---|--------|------|------------|
| 1 | {{citation + URL}} | {{A/B/C}} | {{what it confirms}} |

#### Contradicting / Qualifying Evidence

| # | Source | Tier | Key Detail |
|---|--------|------|------------|
| 1 | {{citation + URL}} | {{A/B/C}} | {{what it contradicts or qualifies}} |

#### Balance Assessment

- **Evidence weight**: {{supporting > contradicting | balanced | contradicting > supporting}}
- **Confidence**: {{High / Medium / Low / Speculative}}
- **Nuance required?**: {{Yes — describe | No}}

#### Correction (if needed)

- **Current text**: "{{exact quote from content}}"
- **Corrected text**: "{{suggested replacement with inline citation}}"
- **Rationale**: {{why the correction is needed}}

#### Enrichment (if applicable)

- **Additional context available**: {{new facts, stats, or perspectives not in the original}}
- **Suggested addition**: "{{text to add, with citation}}"
- **Placement**: {{after paragraph X / in section Y / new subsection}}

---

## Critical Corrections Required

Claims where the verdict is ❌ Incorrect or ⚠️ Partially correct with material impact.

| # | Claim | File | Current | Corrected | Confidence |
|---|-------|------|---------|-----------|------------|
| {{N}} | "{{short claim}}" | `{{file}}` | {{current value}} | {{corrected value}} | {{High/Med}} |

## Enrichment Opportunities

New evidence discovered during fact-checking that would strengthen the content.

| # | Topic | File | Suggested Addition | Source |
|---|-------|------|--------------------|--------|
| {{N}} | {{topic}} | `{{file}}` | {{brief description}} | {{citation + URL}} |

## Unresolved Claims

Claims where evidence is insufficient for a confident verdict.

| # | Claim | File | Issue | Recommendation |
|---|-------|------|-------|----------------|
| {{N}} | "{{claim}}" | `{{file}}` | {{why unverifiable}} | {{reframe as opinion / add "according to" / remove / research further}} |

## Source Master List

All sources consulted during this fact-check, deduplicated.

| # | Citation | URL | Tier | Used For Claims |
|---|----------|-----|------|-----------------|
| 1 | {{author, title, date}} | {{url}} | {{A/B/C}} | {{claim numbers}} |

## Methodology Note

- **Claims extracted**: {{N}} from {{N}} files
- **Claim types covered**: {{list}}
- **Sources consulted**: {{N}} unique sources
- **Search tools used**: {{Tavily, Brave, Raindrop, Zettelkasten}}
- **Known blind spots**: {{any areas where sourcing was weak}}
- **Balance approach**: For each claim rated ⚠️ or ❌, both supporting AND contradicting evidence was actively sought. Claims rated ✅ include at least one source; bold claims (statistics, historical events) require 2+ independent sources.
