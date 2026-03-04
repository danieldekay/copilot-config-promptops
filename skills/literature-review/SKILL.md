---
name: literature-review
description: "Academic literature review using Raul Pacheco-Vega's methods (AIC reading, Conceptual Synthesis Excel, research memos). Use for systematic reading and synthesis of academic or professional literature on a topic."
---

# Literature Review Skill (Pacheco-Vega Method)

## Overview

A systematic methodology for reading, analyzing, and synthesizing academic and professional literature, based on the methods developed by **Raul Pacheco-Vega** (raulpacheco.org). The core tools are the AIC reading method, the Conceptual Synthesis Excel (CSE), and research memos.

## When to Use This Skill

- Conducting a literature review for a research project or article
- Systematically reading and processing multiple academic papers
- Building understanding of a scholarly field or debate
- Preparing to write a research-grounded piece
- Understanding the state of knowledge on a complex topic

## The AIC Reading Method

The AIC method structures how you read each individual source. Three passes, each with a distinct purpose:

### A — Analytical Reading (Pass 1)

**Question**: "What does this text actually say?"

Extract:
- **Thesis/main argument**: What is the author claiming?
- **Structure**: How is the argument organized?
- **Methodology**: How did they gather/analyze evidence?
- **Key data**: What specific evidence do they present?
- **Definitions**: How do they define key terms?
- **Scope**: What does the paper explicitly cover and exclude?

**Output**: Factual summary — no interpretation yet.

### I — Interpretive Reading (Pass 2)

**Question**: "What does this mean in context?"

Analyze:
- **Implications**: What follows from these findings?
- **Connections**: How does this relate to other sources you've read?
- **Context**: How does this fit in the broader scholarly conversation?
- **Assumptions**: What unstated assumptions does the author make?
- **Significance**: Why does this matter for your research question?
- **Surprises**: What was unexpected or counterintuitive?

**Output**: Interpretive layer added to the analytical notes.

### C — Critical Reading (Pass 3)

**Question**: "How strong is this, and what's missing?"

Assess:
- **Evidence quality**: Is the evidence sufficient for the claims?
- **Methodology strength**: Are there methodological limitations?
- **Bias indicators**: Does the author have evident biases or conflicts?
- **Gaps**: What doesn't this source address that it should?
- **Counter-arguments**: What would opponents say?
- **Contribution**: What does this uniquely add to the field?

**Output**: Complete AIC note (see template: `analytical-note.md`)

## The Conceptual Synthesis Excel (CSE)

The CSE is a matrix that tracks how different sources address shared themes. It's the main tool for detecting patterns across the literature.

### Structure

```
              | Theme A    | Theme B    | Theme C    | Theme D    |
Source 1      | [how S1    | [how S1    |            | [how S1    |
              |  addresses |  addresses |            |  addresses |
              |  Theme A]  |  Theme B]  |            |  Theme D]  |
Source 2      |            | [how S2    | [how S2    | [how S2    |
              |            |  addresses |  addresses |  addresses |
              |            |  Theme B]  |  Theme C]  |  Theme D]  |
Source 3      | [how S3    |            | [how S3    |            |
              |  addresses |            |  addresses |            |
              |  Theme A]  |            |  Theme C]  |            |
```

### How to Build

1. **Start after 3 sources** — you need enough to see patterns
2. **Themes emerge from reading** — don't predefine them all
3. **Add columns as new themes appear** — the matrix grows horizontally
4. **Each cell is a brief summary** — not a full note, just how that source addresses that theme
5. **Empty cells are data** — they show which sources DON'T address which themes
6. **Review the matrix after every 3-5 new sources** — look for patterns

### Pattern Detection

After building the CSE, look for:

- **Vertical patterns**: A theme that every source addresses → core concept
- **Empty columns**: A theme only one source addresses → unique contribution or niche
- **Contradictory cells**: Sources that disagree on a theme → tension to investigate
- **Empty rows**: A source that doesn't fit themes → outlier, possibly irrelevant
- **Clustering**: Groups of sources that address the same themes → schools of thought

## Research Memos

Memos are short analytical essays (500-1000 words) that synthesize what you've learned. They are NOT summaries — they are arguments.

### When to Write

- After processing 3-5 related sources
- When a clear pattern emerges from the CSE
- When you find a contradiction you can analyze
- When you have enough evidence to make an argument

### Memo Structure

1. **Opening statement**: Your argument or observation (1-2 sentences)
2. **Evidence**: What the sources show (with citations)
3. **Analysis**: Why this matters, what it means
4. **Tensions**: Where sources disagree and why
5. **Implications**: What follows from this analysis
6. **Open questions**: What still needs investigation

### Memo Rules

- **Argue, don't summarize** — memos take a position
- **Cite every claim** — trace everything to sources
- **Keep it focused** — one main idea per memo
- **Connect to your question** — how does this serve your research?
- **Write for your future self** — you'll re-read this months later

## The Literature Matrix

A master tracking document for the entire review. More comprehensive than the CSE, more structured than a bibliography.

### Fields Tracked

| Field | Purpose |
|-------|---------|
| Citation | Full bibliographic reference |
| Type | Empirical / Theoretical / Review / Commentary |
| Methodology | How evidence was gathered |
| Key findings | Main contributions |
| Relevance | How it connects to your question |
| AIC Status | Which passes completed |
| Quality | Tier 1-5 assessment |
| Themes | Which CSE themes it addresses |

## Integration with Zettelkasten

Every piece of this methodology maps to Zettelkasten note types:

| Pacheco-Vega Artifact | Zettelkasten Note Type | Tags |
|----------------------|----------------------|------|
| AIC reading note | `literature` | `literature-review`, `aic-reading` |
| CSE matrix | `structure` | `literature-review`, `cse-matrix` |
| Research memo | `permanent` | `literature-review`, `research-memo` |
| Literature matrix | `structure` | `literature-review`, `lit-matrix` |

### Link Types for Literature Review

- `supports` — Source provides evidence for a claim in another note
- `contradicts` — Source disagrees with another source's findings
- `extends` — Source builds on or deepens another's work
- `refines` — Source clarifies or nuances another's argument
- `questions` — Source raises doubts about another's methodology or conclusions

## Templates

All templates in `.github/skills/literature-review/templates/`:

| Template | Artifact | Usage |
|----------|----------|-------|
| `analytical-note.md` | AIC reading note | Per source, during Phase 2 |
| `conceptual-synthesis.md` | CSE matrix | Living document, Phase 3 |
| `research-memo.md` | Synthesis memo | Per theme, Phase 4 |
| `literature-matrix.md` | Source tracker | Living document, Phase 1-5 |

## Anti-Patterns

- **Reading without structure**: Reading papers without the AIC framework — leads to shallow understanding
- **Summarizing instead of synthesizing**: Creating summaries instead of memos — misses the point
- **CSE neglect**: Not updating the matrix — you'll miss patterns
- **Isolated notes**: Creating literature notes without linking — defeats Zettelkasten purpose
- **Premature synthesis**: Writing memos before reading enough sources — conclusions won't be grounded
- **Scope creep**: Following every citation chain — stay within review boundaries
