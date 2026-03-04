---
name: deep-research
description: "Multi-tiered deep research methodology — from raw data gathering through evaluation to synthesis. Use when conducting comprehensive research on any topic, building evidence-based arguments, or investigating complex questions."
---

# Deep Research Skill

## Overview

A structured multi-tier research pipeline that transforms raw information into evaluated, synthesized knowledge. Each tier has explicit quality gates that must be satisfied before proceeding. Every session explores five mandatory research dimensions and produces multiple structured output documents.

## When to Use This Skill

- Researching a new topic comprehensively (not just quick lookups)
- Building evidence-based arguments or positions
- Investigating complex, multi-faceted questions
- Preparing content that requires authoritative sourcing
- Conducting due diligence on technologies, methods, or ideas

## Mandatory Research Dimensions

Every research session MUST explore all five dimensions regardless of topic:

| # | Dimension | What to Explore |
|---|-----------|----------------|
| 1 | **Field Landscape** | What exists around this field? Key terms, subfields, adjacent areas, topology of the domain |
| 2 | **Key People & Publishers** | Who is publishing? What are they saying? Key voices, institutions, conferences, journals |
| 3 | **Alternative Approaches** | Competing methods, frameworks, tools — how do they compare? What are the trade-offs? |
| 4 | **Best Practices** | What is considered best practice? Consensus positions, standards, established guidelines |
| 5 | **Critical Essentials** | What is the most important thing to know? Non-negotiables, foundational concepts, common pitfalls |

## The Five Tiers

### Tier 1: GATHER — Cast the Net

**Objective**: Collect a broad, diverse set of raw sources covering all five mandatory dimensions.

**Method**:

1. **Formulate 15-20 search queries** covering all five dimensions:
   - Field Landscape queries (3-4): overview, subfields, adjacent areas, taxonomy
   - Key People queries (2-3): researchers, authors, institutions, conferences
   - Alternative Approaches queries (3-4): competing methods, comparisons, trade-offs
   - Best Practices queries (2-3): standards, guidelines, established methods
   - Critical Essentials queries (2-3): fundamentals, common mistakes, prerequisites
   - Cross-dimension queries (3-4): synthesis, debates, state-of-the-art
2. **Check internal knowledge** — search Zettelkasten for existing notes
3. **Check curated bookmarks** — search Raindrop.io for previously saved sources
4. **Academic source discovery** — target arXiv, Google Scholar, and academic databases; flag PDFs for Tier 3b
5. **Execute searches** using Tavily (web search, crawl, extract) and Brave
6. **Record everything** in the Research Log with dimension tags and quality ratings

**Search Strategy Template**:

```
# Field Landscape (dimension 1)
Query 1:  "[topic] overview landscape"              → Broad field survey
Query 2:  "[topic] taxonomy classification"          → Field structure
Query 3:  "[topic] related fields adjacent"          → Adjacent areas
Query 4:  "[topic] history evolution"                → How the field developed

# Key People & Publishers (dimension 2)
Query 5:  "[topic] leading researchers authors"      → Key voices
Query 6:  "[topic] conference journal publications"  → Academic venues
Query 7:  "[topic] influential papers cited"         → Seminal works

# Alternative Approaches (dimension 3)
Query 8:  "[topic] vs [alternative]"                 → Head-to-head comparison
Query 9:  "[topic] alternative methods approaches"   → Competing frameworks
Query 10: "[topic] comparison trade-offs"            → Trade-off analysis

# Best Practices (dimension 4)
Query 11: "[topic] best practices guidelines"        → Consensus methods
Query 12: "[topic] standards recommendations"        → Official guidance

# Critical Essentials (dimension 5)
Query 13: "[topic] fundamentals essentials"          → Core knowledge
Query 14: "[topic] common mistakes pitfalls"         → What not to do
Query 15: "[topic] prerequisites requirements"       → Foundations

# Cross-dimension
Query 16: "[topic] state of the art 2025"            → Current frontier
Query 17: "[topic] debate controversy"               → Open disputes
Query 18: "[topic] research evidence"                → Academic angle
Query 19: "[topic] critique limitations"             → Counter-arguments
Query 20: "[topic] case study"                       → Real-world evidence
```

**Academic Source Discovery**:

```
Query A1: "arxiv [topic] survey"                    → arXiv survey papers
Query A2: "[topic] systematic review meta-analysis"  → Systematic reviews
Query A3: "[key_author] [topic]"                    → Track key researchers
```

For each academic source found: note PDF URL, DOI, format (arXiv/journal/preprint).

**Curated Bookmarks Strategy** (Raindrop.io):

```
Search 1: search_bookmarks_by_text("[topic]")          → Direct matches
Search 2: search_bookmarks_by_tags(["<domain-tag>"])    → Tag-based discovery
Search 3: search_bookmarks(query, collection_id=<id>)  → Collection-scoped
```

Bookmark hits are first-class sources — they represent previously curated, human-vetted material.
Sources tagged `aic-processed` or with ZK links in excerpts have already been partially evaluated.

**Quality Gate**: Minimum 15 unique sources from at least 3 source categories. All 5 dimensions searched. At least 3 dimensions have sources found.

---

### Tier 2: PROCESS — Triage and Classify

**Objective**: Filter, deduplicate, and classify raw sources.

**Source Quality Matrix**:

| Tier | Type | Examples | Reliability |
|------|------|----------|-------------|
| 1 | Peer-reviewed research | Journals, meta-analyses | ✅ Highest |
| 2 | Official documentation | Standards bodies, official docs | ✅ High |
| 3 | Expert analysis | Conference proceedings, preprints, books | ⚠️ Good |
| 4 | Industry content | Reports, white papers, expert blogs | ⚠️ Moderate |
| 5 | General content | News, tutorials, social media | ❌ Low |

**Processing Steps**:

1. **Deduplicate**: Remove sources covering identical information
2. **Assess quality**: Rate each source using the matrix above
3. **Check recency**: Flag sources older than 3 years for verification
4. **Check authorship**: Identify author credentials where possible
5. **Classify relevance**: Core (directly answers question), Supporting (provides context), Peripheral (tangential but useful)

**Output**: Source Register artifact (see template)

**Quality Gate**: Source Register completed. At least 3 Tier 1-2 sources identified.

---

### Tier 3: READ & UNDERSTAND — Deep Extraction

**Objective**: Extract structured knowledge from each vetted source.

**Per-Source Extraction Protocol**:

For each source rated Tier 1-3 (full extraction):
1. **Core claims**: What specific claims does this source make?
2. **Evidence**: What evidence supports those claims?
3. **Methodology**: How was the evidence gathered/analyzed?
4. **Limitations**: What does the source acknowledge it doesn't cover?
5. **Connections**: How does this relate to other sources in the register?

For each source rated Tier 4-5 (light extraction):
1. **Key data points**: Specific facts, statistics, or quotes worth keeping
2. **Perspective**: What angle does this source add?

**Output**: Extraction notes (inline in Research Log or as separate artifacts)

**Quality Gate**: Every Tier 1-3 source has completed extraction notes.

---

### Tier 3b: PDF ANALYSIS — Academic Deep Reading

**Objective**: Download available PDFs and perform full Pacheco-Vega AIC analysis per paper.

**Activation**: Whenever Tier 1 identifies academic papers with available PDFs (arXiv, open-access journals, preprints). Skipped only when zero PDFs are available.

**Per-PDF Protocol** (Pacheco-Vega AIC method):

1. **PDF Acquisition**: Download PDFs. For arXiv, convert `/abs/` URLs to `/pdf/` format. For paywalled papers, extract abstract + metadata only.
2. **Pass 1 — Analytical Reading**: Structure map, data/evidence inventory, key terms defined
3. **Pass 2 — Interpretive Reading**: Core argument in own words, theoretical framework, implications, what's missing
4. **Pass 3 — Critical Reading**: Methodological assessment (rigor, sample quality, reproducibility), bias/conflict check, position in field, relevance to current research

**Per-PDF Output**: One `pdf-analysis-{{slug}}.md` file per paper (see template).

**Archival**: Download PDFs to `notes/papers/` for persistent access.

**Quality Gate**: Every available PDF has a completed AIC analysis file. Papers archived to `notes/papers/`.

---

### Tier 4: EVALUATE — Cross-Reference and Assess

**Objective**: Build a coherent evidence picture with explicit confidence levels.

**Evaluation Methods**:

1. **Triangulation Matrix**: For each major finding, list which sources support/contradict it:

   | Finding | Supporting Sources | Contradicting Sources | Confidence |
   |---------|-------------------|----------------------|------------|
   | [claim] | Source A, B, D | Source C | High/Med/Low |

2. **Conflict Analysis**: For each contradiction:
   - Why do sources disagree? (different timeframes, methodologies, contexts)
   - Which side has stronger evidence?
   - Can the contradiction be resolved?

3. **Gap Identification**: What questions remain unanswered?
   - Questions raised but not addressed by any source
   - Areas where only 1 source exists (needs more evidence)
   - Temporal gaps (no recent data)

4. **Preliminary Hypotheses** (3-7 required):
   - What the evidence suggests but doesn't prove
   - Each with: supporting evidence, counter-evidence, confidence, testability
   - Types: explanatory, predictive, prescriptive, comparative

5. **Open Questions Identification** (across 5 categories):
   - Evidence Gaps: questions the evidence doesn't answer
   - Unresolved Contradictions: conflicts without clear resolution
   - Emerging Questions: new questions raised by the findings
   - Practical Questions: how findings apply in practice
   - Definitional Questions: terms or boundaries that remain unclear

6. **Further Research Directions** (3 categories):
   - Deep Research Follow-ups: sub-topics for another research session
   - Academic Research Questions: questions requiring primary literature
   - Empirical Studies Needed: questions requiring original data collection

7. **Confidence Scoring**:
   - **High**: 3+ independent Tier 1-2 sources agree, no contradictions
   - **Medium**: 2+ sources agree, minor contradictions explained
   - **Low**: Single source, or significant unresolved contradictions
   - **Speculative**: No direct evidence, but logical inference from related findings

**Quality Gate**: Triangulation matrix and gap analysis completed. Minimum 3 hypotheses generated. Open questions identified across all 5 categories.

---

### Tier 5: SYNTHESIZE — Produce Knowledge

**Objective**: Transform evaluated evidence into structured, actionable outputs.

**Synthesis Outputs** (all four are ALWAYS produced):

1. **Research Brief** (ALWAYS):
   - Executive summary of findings
   - Field landscape overview: key terms, subfields, adjacent areas
   - Key people and publishers identified
   - Alternative approaches with trade-offs
   - Key findings with confidence levels
   - Best practices and critical essentials
   - Recommendations or conclusions

2. **Open Questions** (ALWAYS):
   - Evidence Gaps, Unresolved Contradictions, Emerging Questions, Practical Questions, Definitional Questions
   - Priority ranking by impact and tractability

3. **Hypotheses** (ALWAYS):
   - 3-7 hypotheses with supporting/counter-evidence, confidence, testability
   - Priority matrix (confidence × testability × impact)

4. **Further Research** (ALWAYS):
   - Deep Research Follow-ups with specific search parameters
   - Academic Research Questions with databases and search terms
   - Empirical Studies Needed with study type and effort estimates

5. **Zettelkasten Integration** (when findings are worth keeping):
   - Create permanent notes for key insights
   - Create literature notes for important sources
   - Link to existing knowledge network
   - Create structure note if cluster forms

6. **Detailed Synthesis Report** (for complex topics):
   - Full findings with evidence chains
   - Source-by-source contribution mapping
   - Methodology assessment
   - Limitations statement

**Quality Gate**: Research Brief, Open Questions, Hypotheses, and Further Research all completed.

---

### Tier 5b: DIAGRAM — Field Map Visualization

**Objective**: Create a draw.io XML diagram mapping the field's structure for complex topics.

**Activation**: When the research reveals 3+ interrelated subfields, competing approaches, or a complex landscape of actors and institutions. Skipped for narrowly focused topics.

**Diagram Types**:
- **Field Map**: Nodes for concepts, people, institutions, approaches; edges for relationships
- **Concept Map**: Hierarchical breakdown of a domain
- **Comparison Map**: Side-by-side alternative approaches with trade-offs

**Node Types**:

| Type | Shape | Color | Use For |
|------|-------|-------|---------|
| Core Concept | Rounded rectangle | `#dae8fc` blue | Central topic and key terms |
| Person/Group | Ellipse | `#d5e8d4` green | Key researchers, institutions |
| Approach | Hexagon | `#fff2cc` yellow | Methods, frameworks, tools |
| Subfield | Rectangle | `#e1d5e7` purple | Subfields, adjacent areas |
| Institution | Diamond | `#f8cecc` red | Organizations, conferences |
| Open Question | Cloud | `#f5f5f5` gray | Unresolved questions |

**Output**: `field-map.drawio` in the session folder (draw.io XML format).

**Quality Gate**: All key entities from the research represented. Relationships labeled.

## Templates

All templates are in `.github/skills/deep-research/templates/`:

| Template | Purpose | When to Use |
|----------|---------|-------------|
| `research-brief.md` | Executive summary of research | Always — final output |
| `open-questions.md` | Structured open questions across 5 categories | Always — identifies gaps |
| `hypotheses.md` | Research hypotheses with evidence and testability | Always — what the evidence suggests |
| `further-research.md` | Follow-up research directions (deep, academic, empirical) | Always — next steps |
| `source-assessment.md` | Source register with quality ratings | Tier 2 — tracking sources |
| `synthesis-report.md` | Detailed findings report | Complex topics |
| `research-log.md` | Process log for research session | Always — running log |
| `pdf-analysis.md` | Per-PDF Pacheco-Vega AIC analysis | Tier 3b — academic papers |
| `fact-check-report.md` | Per-claim verdicts with balanced evidence | Fact-check mode — auditing existing content |

## Agent Architecture

The deep research pipeline is implemented as an **orchestrator + subagent** system. The orchestrator (`deep-researcher`) is a manager only — it delegates all research work to dedicated subagents that communicate through the research log.

### Subagents

| Agent | Tier | Responsibility | Key Tools |
|-------|------|---------------|-----------|
| `deep-research.gather` | 1 | Broad data collection across 5 dimensions (web, bookmarks, ZK, academic) | tavily-search, brave-search, raindrop, zettelkasten |
| `deep-research.process` | 2 | Source triage, quality rating, deduplication | file operations only |
| `deep-research.bookmark` | Cross-cutting | Raindrop archival of ALL non-discarded sources | raindrop |
| `deep-research.extract` | 3 | Deep reading and structured knowledge extraction | tavily_extract, tavily_crawl |
| `deep-research.analyze-pdf` | 3b | PDF download + Pacheco-Vega AIC analysis per paper | fetch_webpage, file operations |
| `deep-research.evaluate` | 4 | Cross-referencing, triangulation, hypotheses, open questions | file operations only |
| `deep-research.synthesize` | 5 | Research Brief, Open Questions, Hypotheses, Further Research, ZK notes | zettelkasten |
| `deep-research.diagram` | 5b | draw.io field map diagram for complex topics | file operations only |

### IPC: Research Log as Shared State

All subagents communicate through the **research log** (`research-log.md`):

1. Each subagent reads the log for its inputs (previous tier's outputs)
2. Each subagent writes its results back to the log
3. The orchestrator reads the log between tiers to check quality gates
4. Status protocol: `**Status**: pending | in-progress | completed | failed`
5. Gate protocol: `**Gate**: pending | passed | failed | <reason>`

### Pipeline Flow

```
Orchestrator: Setup → create research-log.md
    ↓
[Gather Agent] → 15-20 queries across 5 dimensions → log sources → Gate check
    ↓
[Process Agent] → triage, classify, flag PDFs → log decisions → Gate check
    ↓
[Bookmark Agent] → archives ALL non-discarded sources to Raindrop
    ↓
[Extract Agent] → deep reading per source → log extraction notes → Gate check
    ↓
[Analyze-PDF Agent] → download PDFs → AIC analysis per paper → Gate check
    ↓
[Evaluate Agent] → triangulation, hypotheses, open questions, further research → Gate check
    ↓
[Synthesize Agent] → Research Brief + Open Questions + Hypotheses + Further Research + ZK notes → Gate check
    ↓
[Diagram Agent] → field map draw.io (if complex topic) → Gate check
    ↓
[Bookmark Agent] → enriches bookmarks with ZK IDs
    ↓
Orchestrator: Wrap-up → verify all documents produced → report to user
```

### Session Output Documents

Every session produces these documents in the session folder:

| Document | Required | Template |
|----------|----------|----------|
| Research Log | Always | `research-log.md` |
| Research Brief | Always | `research-brief.md` |
| Open Questions | Always | `open-questions.md` |
| Hypotheses | Always | `hypotheses.md` |
| Further Research | Always | `further-research.md` |
| Source Assessment | Always | `source-assessment.md` |
| PDF Analysis (per paper) | When PDFs available | `pdf-analysis.md` |
| Synthesis Report | Complex topics | `synthesis-report.md` |
| Field Map Diagram | Complex topics (3+ subfields) | draw.io XML |

### Gate Failure Recovery

The orchestrator handles failures by re-invoking upstream agents with refined guidance. Max 2 retries per tier before escalating to the user.

## Integration with Other Agents

- **Literature Reviewer** → Hand off academic sources for Pacheco-Vega AIC analysis
- **Zettelkasten Orchestrator** → Route permanent notes for integration into knowledge graph

## Mode: Fact-Check — Verify Claims in Existing Content

The deep research pipeline supports a **fact-check mode** for auditing existing content (blog posts, articles, proposals) against evidence. This mode reuses the same tiered pipeline but with a different entry point and output format.

### When to Use Fact-Check Mode

- Auditing blog posts or articles for factual accuracy before publication
- Validating claims made in proposals, pitches, or community communications
- Periodic evidence review of published content (facts go stale)
- After any content generation session — AI-generated content is especially prone to plausible-sounding but unsourced claims

### Fact-Check Pipeline

```
Step 0: EXTRACT CLAIMS — Scan content, identify every verifiable claim
    ↓
Step 1: CATEGORIZE — Classify claims by type and boldness
    ↓
Step 2: GATHER — Search for evidence (both supporting AND contradicting)
    ↓
Step 3: EVALUATE — Verdict per claim with balanced evidence
    ↓
Step 4: REPORT — Produce fact-check report with corrections and enrichments
    ↓
Step 5: APPLY — Propagate corrections back into the content
```

### Step 0: Claim Extraction

Scan the content and extract every statement a skeptical reader could ask "source?" about.

**Priority targets**: Any `<!-- NEEDS SOURCE: ... -->` markers in the content are pre-flagged claims from the writing phase. These are the author's own acknowledgment that evidence is needed — extract and prioritize them first.

**Also extract**: Assertions without markers that a skeptical reader could challenge — especially opinions, polemic statements, or emotional arguments presented as facts without evidence backing.

**Claim types to extract:**

| Type | Example | Boldness |
|------|---------|----------|
| **Statistic** | "organic reach dropped to 2%" | 🔴 High — must have Tier A/B source |
| **Historical event** | "MySpace lost 50 million songs in 2019" | 🔴 High — must have contemporaneous source |
| **Technical fact** | "ActivityPub is a W3C standard" | 🟡 Medium — link to spec suffices |
| **Attributed concept** | "Doctorow coined enshittification" | 🟡 Medium — credit originator with date |
| **Trend assertion** | "organic reach has been declining" | 🟡 Medium — directional evidence needed |
| **Platform behavior** | "the algorithm decides who sees your posts" | 🟢 Low — widely understood, light sourcing |
| **Legal/policy** | "Meta's ToS grants them a worldwide license" | 🔴 High — must quote actual document |

**Boldness determines search depth:**
- 🔴 High-boldness claims: actively search for BOTH supporting and contradicting evidence. Require 2+ independent sources.
- 🟡 Medium-boldness claims: search for supporting evidence; note contradictions if found.
- 🟢 Low-boldness claims: verify with at least one source; skip deep counter-evidence search.

### Step 1: Balanced Evidence Gathering

For each claim, the Gather agent searches for evidence in **both directions**:

**Supporting queries**: `"[claim topic] evidence"`, `"[claim topic] data"`, `"[claim topic] confirmed"`
**Contradicting queries**: `"[claim topic] myth"`, `"[claim topic] debunked"`, `"[claim topic] criticism"`, `"[claim topic] incorrect"`

This is the critical difference from standard research mode. Standard mode explores a topic. Fact-check mode **stress-tests specific assertions**.

### Step 2: Verdict Assignment

Each claim receives a verdict:

| Verdict | Criteria |
|---------|----------|
| ✅ **Verified** | 2+ independent sources confirm; no credible contradictions |
| ⚠️ **Partially correct** | Core claim directionally right but details wrong (date, number, scope) |
| ❌ **Incorrect** | Credible sources contradict the claim; correction needed |
| 🔍 **Unverifiable** | No sources found confirming or denying; recommend reframing |
| 🆕 **Enrichment** | Claim is correct but additional context/evidence strengthens it |

**For ⚠️ and ❌ verdicts**, the report MUST include:
- What the content currently says (exact quote)
- What the evidence says (with citations)
- A suggested corrected text ready for insertion
- The rationale for the correction

### Step 3: Balance Assessment

For each claim (especially 🔴 high-boldness), document the **evidence balance**:

```
Claim: "Facebook's organic reach dropped from 16% to 2% by 2024"
├── Supporting: CampaignPros (2025), Statista (2024) — Tier B
├── Contradicting: None found
├── Qualifying: AdSchoolMaster reports 5.2% in 2020, suggesting the decline was more gradual than implied
├── Balance: Supporting > Contradicting
└── Nuance: The 16% → 2% trajectory is correct but compressed multiple intermediate steps
```

This balance assessment appears in the fact-check report and informs how the claim should be presented in the content — not just whether it's "true" but whether the *framing* is fair.

### Step 4: Enrichment Discovery

During fact-checking, the research often uncovers relevant facts not present in the original content. These are captured as **enrichment opportunities**:

- Additional statistics that strengthen an argument
- Historical context that adds depth
- Counter-arguments that should be acknowledged for intellectual honesty
- More recent data that updates an older claim

Enrichments are optional additions, not corrections. They're tracked separately in the report.

### Step 5: Correction Propagation

The fact-check report includes ready-to-apply corrections:

1. **Exact current text** — the verbatim string to find in the content file
2. **Corrected replacement** — the new text with inline citations
3. **Sources section entries** — formatted entries to add to the article's `## Sources` section

This enables efficient batch application of corrections across multiple files.

### Fact-Check Output

Primary output: `fact-check-report.md` in the session folder, using the template at `.github/skills/deep-research/templates/fact-check-report.md`.

The report contains:
- Claim register with per-claim verdicts and balanced evidence
- Critical corrections table (ready-to-apply)
- Enrichment opportunities
- Unresolved claims with recommendations
- Source master list

### Fact-Check Quality Gate

- Every extracted claim has a verdict
- Every 🔴 high-boldness claim has both supporting AND contradicting evidence searched
- Every ⚠️/❌ verdict includes a suggested correction
- No claim has verdict "pending" at completion

## Anti-Patterns

- **Premature synthesis**: Jumping to conclusions before completing evaluation
- **Source monoculture**: Relying on a single type of source
- **Confirmation bias**: Searching only for evidence that supports initial hypothesis. In fact-check mode, actively search for counter-evidence — especially for claims you "know" are true.
- **Citation-free claims**: Making assertions without traceable evidence
- **Depth without breadth**: Going deep on first sources found without surveying the landscape
- **Orchestrator doing work**: The deep-researcher must ONLY delegate — never research directly
- **Skipping gate checks**: Always verify the research log status between tiers
- **Verification bias**: Accepting claims as correct because they "sound right" or appeared in AI-generated text. Every claim must face evidence, not assumptions.
- **Missing counter-evidence**: For bold claims, finding only supporting evidence is incomplete work. Actively seek contradictions, qualifications, and nuance.
- **Binary verdicts**: Claims aren't just "true" or "false." Most disputed claims are partially correct, correct but misleading, or correct but outdated. Capture the nuance.
- **Opinions as facts**: Polemic statements, emotional arguments, and value judgments presented without evidence must be flagged — they are claims that need sourcing. "Facebook is destroying communities" needs documented harms; "organizers report declining reach" does not.
- **Ignoring source markers**: `<!-- NEEDS SOURCE: ... -->` markers in content are the author's explicit request for evidence. Never skip them — they are the highest-priority targets for fact-check mode.
