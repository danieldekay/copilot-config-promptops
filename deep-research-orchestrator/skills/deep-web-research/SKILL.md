---
name: deep-web-research
description: >
  End-to-end deep web research with scientific rigor. Combines multi-source search
  (Tavily, Semantic Scholar, CrossRef), academic paper processing (three-pass reading,
  PDF archiving, arXiv protocol), citation management (BibTeX, DOI extraction),
  bookmark management (Raindrop auto-categorization, rich notes), critical evaluation
  (evidence hierarchy, bias detection, GRADE), and Zettelkasten knowledge synthesis.
  Use when researching any topic, reading papers, conducting literature reviews,
  evaluating evidence, building bibliographies, processing arXiv papers, bookmarking
  sources, or synthesizing research into actionable knowledge. Triggers: "research X",
  "find papers on", "literature review", "investigate", "evaluate evidence",
  "what does the research say about", "read this paper", "deep dive into".
license: Apache-2.0
tools:
  - mcp_tavily_tavily-search
  - mcp_tavily_tavily-extract
  - mcp_semanticschol_search_papers
  - mcp_semanticschol_get_paper
  - mcp_semanticschol_get_paper_citations
  - mcp_semanticschol_get_paper_references
  - mcp_semanticschol_autocomplete_query
  - mcp_raindrop_create_bookmarks
  - mcp_raindrop_search_bookmarks
  - mcp_raindrop_get_collections
  - mcp_zettelkasten_zk_create_note
  - mcp_zettelkasten_zk_create_link
  - mcp_zettelkasten_zk_search_notes
  - mcp_zettelkasten_zk_find_similar_notes
  - mcp_zettelkasten_zk_find_central_notes
  - mcp_zettelkasten_zk_find_orphaned_notes
  - mcp_zettelkasten_zk_get_linked_notes
  - mcp_zettelkasten_zk_get_all_tags
related-skills:
  - scientific-brainstorming
  - scientific-critical-thinking
  - zettelkasten-management
metadata:
  category: research
  version: "1.0.0"
  consolidates:
    - research-web-rigorous
    - reading-literature
    - citation-management
    - bookmark-management
---

# Deep Web Research

## Overview

Conduct systematic, evidence-based research from discovery through knowledge synthesis.
Every claim is backed by sources. Every source is bookmarked. Every insight is captured
in Zettelkasten. Every paper gets a BibTeX entry.

**Core Principle**: Search → Acquire → Process → Synthesize → Expand.

## When to Use This Skill

- Investigating unfamiliar topics
- Technology or framework evaluation
- Literature reviews (academic or professional)
- Reading and analyzing papers or articles
- Competitive intelligence / market research
- Policy, standards, or regulatory research
- Building evidence-based recommendations
- Processing arXiv papers (mandatory full-PDF protocol)
- Any task requiring verifiable, well-documented research

## Research Modes

| Mode         | Time    | Scope                                    | Output                             |
| ------------ | ------- | ---------------------------------------- | ---------------------------------- |
| **Quick**    | ~30 min | Discovery + first pass + bookmark        | Bookmarked sources, fleeting notes |
| **Standard** | ~2 hr   | Full reading + source zettel + BibTeX    | Literature notes, bibliography     |
| **Deep**     | ~5+ hr  | Everything + permanent notes + synthesis | Complete knowledge graph with MOC  |

## Unified Research Workflow

### Phase 1: Discovery

**Goal**: Find relevant sources across academic and web domains.

**Academic Search** (Semantic Scholar):

```
1. autocomplete_query("topic") → refine terms
2. search_papers(query, year=YYYY, limit=30, fields=[title, authors, year, abstract, citationCount, url])
3. get_paper(paper_id, fields=[...references, citations]) → for key papers
```

**Web Search** (Tavily):

```
1. tavily_search(query, search_depth="advanced", include_raw_content=true, max_results=20)
2. tavily_extract(urls=[...], extract_depth="advanced") → full content from top results
```

**Evidence Quality Hierarchy** (prioritize sources):

- **Tier 1**: Peer-reviewed journals, systematic reviews, official standards (ISO, IEEE, W3C)
- **Tier 2**: Conference proceedings, technical documentation, industry reports
- **Tier 3**: Expert blog posts, case studies, reputable news, Stack Overflow
- **Tier 4**: Social media, marketing materials, unverified claims

**Cross-Verification**: 2+ independent sources for critical claims. Check original sources, not secondary citations.

**Output**: Candidate source list with quality tier annotations.

### Phase 2: Acquisition

For each valuable source, acquire metadata and archive content.

#### 2a. Metadata Extraction

Auto-detect source type and extract accordingly:

| Source Type | Action                          |
| ----------- | ------------------------------- |
| arXiv paper | Full arXiv protocol (see below) |
| DOI         | CrossRef API → BibTeX           |
| PMID        | PubMed E-utilities → BibTeX     |
| Web URL     | Tavily extract → bookmark       |
| PDF URL     | Download + bookmark             |

**BibTeX** generation goes to `notes/references.bib`. Citekey format: `@lastnameYEAR` (e.g., `@hong2023`).

#### 2b. arXiv Protocol (MANDATORY for arXiv papers)

```bash
# 1. Extract metadata
tavily_extract(["https://arxiv.org/abs/[ID]"], extract_depth="advanced")

# 2. Download PDF
curl -L -o "notes/literature/Author-Year-Title.pdf" "https://arxiv.org/pdf/[ID].pdf"

# 3. Read FULL PDF (not just abstract)
pdftotext notes/literature/Author-Year-Title.pdf -

# 4. Verify download
file notes/literature/Author-Year-Title.pdf
```

**Why full PDF**: Abstracts miss 80%+ of value (methodology, limitations, figures, ablations).

#### 2c. Bookmark Creation (MANDATORY for every source)

Every source gets a bookmark via `mcp_raindrop_create_bookmarks`.

**Auto-categorize** using collection matcher — see [bookmark-collections.md](references/bookmark-collections.md).

**Bookmark format**:

```json
{
  "link": "URL",
  "title": "Paper Title - Author Year",
  "excerpt": "2-3 sentence summary (MAX 250 chars for Raindrop)",
  "note": "## Key Insights\n- ...\n## Key Extracts\n> \"...\"\n## Connections\n- ...",
  "collection": COLLECTION_ID
}
```

**Storage Strategy**:

- Raindrop excerpt (~250 chars) → quick reference
- Raindrop note field → structured insights and extracts
- Zettelkasten note → comprehensive analysis (unlimited)
- PDF download → full source preservation

### Phase 3: Processing

Read and analyze each source using evidence-based methods.

#### Reading Method: Three-Pass (Keshav 2007)

| Pass    | Time      | Focus                                            | Output                                     |
| ------- | --------- | ------------------------------------------------ | ------------------------------------------ |
| **1st** | 5-10 min  | Title, abstract, headings, figures, conclusions  | Five Cs assessment, continue/stop decision |
| **2nd** | 30-60 min | Full content grasp, key excerpts, AIC extraction | Draft source zettel                        |
| **3rd** | 1-5 hr    | Deep understanding, virtual re-implementation    | Complete source zettel                     |

**Five Cs Assessment** (always do on first pass):

- **Category**: Measurement / Analysis / Survey / Implementation / Theory
- **Context**: How it relates to other work
- **Correctness**: Are assumptions valid?
- **Contributions**: Main contributions
- **Clarity**: Writing quality

**AIC Content Abstraction** (Pacheco-Vega):

- **A**bstract: Key claims
- **I**ntroduction: Problem, contribution, research questions
- **C**onclusion: Findings, limitations, future work

For detailed reading methodology, see [reading-methods.md](references/reading-methods.md).

#### Source Zettel Creation (MANDATORY)

Every reading produces a comprehensive literature note via `zk_create_note(note_type="literature")`.

Use the template at [source-zettel-template.md](assets/templates/source-zettel-template.md).

**Minimum requirements**:

- [ ] Full citation with DOI/URL
- [ ] Verbatim abstract
- [ ] 5+ direct quotes with page numbers
- [ ] Five Cs assessment
- [ ] Methodology documented
- [ ] 2+ strengths and 2+ weaknesses
- [ ] 2+ assumptions identified
- [ ] 2+ hypotheses generated
- [ ] 3+ research questions formulated
- [ ] Links to existing Zettelkasten notes

#### Critical Evaluation

Apply proportionate to source importance:

**Quick check** (all sources): Evidence tier, cross-verification status, bias red flags.

**Standard evaluation** (key sources): Methodology critique, bias detection, argument structure.

**Deep evaluation** (critical sources): Full GRADE assessment, statistical validity, logical fallacy check.

For detailed evaluation frameworks, see [evidence-hierarchy.md](references/evidence-hierarchy.md).

### Phase 4: Synthesis

Transform information into interconnected knowledge.

#### 4a. Permanent Notes

Extract atomic concepts from literature notes into permanent notes:

```
zk_create_note(
  title="Declarative Concept Title",    # e.g., "Role Specialization Improves Multi-Agent Task Decomposition"
  content="[Concept in own words + evidence from multiple sources]",
  note_type="permanent",
  tags="concept-type, domain, application"
)
```

**Quality gate**: Single idea, own words, self-contained, declarative title, 3-7 tags, linked to 2+ notes.

#### 4b. Semantic Linking

Connect notes using typed relationships:

| Link Type     | Use When              | Weight |
| ------------- | --------------------- | ------ |
| `supports`    | Evidence for a claim  | High   |
| `contradicts` | Opposing views        | High   |
| `extends`     | Building on a concept | High   |
| `refines`     | Clarifying/improving  | Medium |
| `questions`   | Raising doubts        | Medium |
| `reference`   | Simple citation       | Low    |
| `related`     | Generic connection    | Low    |

Always use `bidirectional=true`. Always include description explaining WHY notes connect.

#### 4c. Structure Notes

Create Maps of Content (MOCs) when 7+ notes cluster around a theme:

```
zk_create_note(
  title="MOC: Topic Name",
  note_type="structure",
  content="## Core Concepts\n- [[id1]]: Concept A\n- [[id2]]: Concept B\n..."
)
```

#### 4d. Triple Cross-Reference

Every source maintains three linked records:

```
Bookmark (Raindrop) ⟷ BibTeX (@citekey in references.bib) ⟷ Literature Note (Zettelkasten)
```

### Phase 5: Expansion

Grow the knowledge graph through citation mining and gap identification.

**Citation Mining**:

```
get_paper_references(paper_id) → foundational work (backward)
get_paper_citations(paper_id)  → subsequent developments (forward)
```

**Knowledge Discovery**:

```
zk_find_similar_notes(note_id, threshold=0.3)  → semantic neighbors
zk_find_central_notes(limit=10)                → knowledge hubs
zk_find_orphaned_notes()                       → unconnected notes to link or delete
```

**Gap Analysis**: Identify unanswered questions, contradictions, and areas needing deeper investigation. Document in structure notes.

## Research Report Template

```markdown
# Research Report: [Topic]

## Executive Summary

[2-3 paragraphs: key findings and recommendations]

## Research Question(s)

## Methodology (sources, date range, quality threshold)

## Key Findings (with evidence, cross-verification, confidence)

## Alternative Approaches Considered

## Recommended Approach (with rationale)

## Zettelkasten Integration (notes created, links established)

## Bookmarks (collection URL, total sources)

## References (academic, professional, documentation)

## Gaps and Future Research
```

## Workflow Patterns

### Pattern 1: Single Paper Processing

```
Discovery → Get metadata → Download PDF (if arXiv) → Bookmark →
First pass (Five Cs) → Second pass (excerpts) → Third pass (if important) →
Source zettel → BibTeX entry → Link to existing notes
```

### Pattern 2: Literature Survey

```
Seed search → Identify 3-5 quality papers → Citation mining →
Batch first-pass all candidates → Filter → Second-pass selected →
Third-pass key papers → Create MOC → Map themes and gaps
```

### Pattern 3: Technology Evaluation

```
Define requirements → Academic search → Web search for implementations →
Bookmark all → Extract features → Create comparison notes →
Link: supports/contradicts → Recommend with evidence
```

### Pattern 4: Quick Assessment

```
Fast first pass (5 min) → Five Cs → Targeted read (10-20 min) →
Decision (deep dive / bookmark / discard) → Fleeting note if keeping
```

## Quality Checklist

### Evidence Quality

- [ ] All claims backed by 2+ sources for critical claims
- [ ] Sources assigned quality tier (1-4)
- [ ] Contradicting evidence acknowledged
- [ ] Confidence level stated per finding

### Documentation Completeness

- [ ] All sources bookmarked with rich notes
- [ ] Academic papers have literature notes in Zettelkasten
- [ ] PDFs archived to `notes/literature/` with standardized names
- [ ] BibTeX entries in `notes/references.bib`
- [ ] Key concepts extracted to permanent notes
- [ ] Notes linked with semantic relationships

### Synthesis Quality

- [ ] Findings in own words (not copy-paste)
- [ ] Atomic concepts properly separated
- [ ] Structure notes created for mature topics
- [ ] Research questions documented for future work

## Common Pitfalls

| Pitfall                | Solution                                         |
| ---------------------- | ------------------------------------------------ |
| Abstract-only reading  | Always read full PDF for arXiv papers            |
| Single-source reliance | Require 2+ for critical claims                   |
| Confirmation bias      | Search for contradicting evidence                |
| Bookmark without notes | Use rich note template every time                |
| Outdated information   | Use time_range filters, check dates              |
| Synthesis paralysis    | Set time limits, start notes after 10-15 sources |
| Citation chain errors  | Check original sources, not secondary            |

## Integration with Other Skills

- **scientific-brainstorming**: Question → _this skill for research_ → Insight → Hypothesis
- **scientific-critical-thinking**: Use for deep methodological critique beyond standard evaluation
- **zettelkasten-management**: Core knowledge operations; this skill is the primary research _producer_

## Integration with Deep Research Agents

This skill is the knowledge foundation for the **Deep Research Orchestrator** agent system.
Agents that load this skill:

| Agent                                                                            | Role                                 | Uses From This Skill                                     |
| -------------------------------------------------------------------------------- | ------------------------------------ | -------------------------------------------------------- |
| [research-web-track](../../agents/research-web-track.agent.md)                   | Web search via Tavily                | Search strategies, evidence hierarchy, bookmark creation |
| [research-scholar-track](../../_agents/research-scholar-track.agent.md)          | Academic papers via Semantic Scholar | Three-pass reading, arXiv protocol, citation formats     |
| [research-evidence-evaluator](../../agents/research-evidence-evaluator.agent.md) | Source credibility assessment        | Evidence hierarchy, CRAAP test, bias detection           |
| [research-citation-manager](../../agents/research-citation-manager.agent.md)     | BibTeX and citation networks         | Citation formats, BibTeX generation, citekey conventions |
| [research-synthesis-writer](../../agents/research-synthesis-writer.agent.md)     | Narrative writing                    | Research report template, synthesis patterns             |

**Orchestrator**: [deep-research-orchestrator](../../agents/deep-research-orchestrator.agent.md) coordinates all agents.

**Quick Start**: See [docs/deep-research-quick-start.md](../../../docs/deep-research-quick-start.md) for usage guide.

## Reference Files

| File                                                          | Content                                           | Load When               |
| ------------------------------------------------------------- | ------------------------------------------------- | ----------------------- |
| [search-strategies.md](references/search-strategies.md)       | Tavily, Semantic Scholar, CrossRef query patterns | Complex searches        |
| [reading-methods.md](references/reading-methods.md)           | Three-pass, SQ3R, AIC, synthetic notes detail     | Deep paper reading      |
| [evidence-hierarchy.md](references/evidence-hierarchy.md)     | GRADE, bias detection, quality assessment         | Evaluating evidence     |
| [citation-formats.md](references/citation-formats.md)         | BibTeX types, metadata APIs, validation           | Building bibliography   |
| [bookmark-collections.md](references/bookmark-collections.md) | Raindrop collection IDs, URL pattern matching     | Every bookmark creation |

## Templates

| Template                                                                | Purpose                             |
| ----------------------------------------------------------------------- | ----------------------------------- |
| [source-zettel-template.md](assets/templates/source-zettel-template.md) | Comprehensive reading documentation |
| [bookmark-note-template.md](assets/templates/bookmark-note-template.md) | Rich bookmark note structure        |
