---
name: "Literature Review Templates — Quick Guide (Pacheco-Vega Method)"
applyTo: ".github/skills/literature-review/templates/**"
---

# Literature Review Template Guide

## When to Use Which Template

| Template | Use When | Required? |
|----------|----------|-----------|
| `literature-matrix.md` | Starting a new literature review | Always — master tracker |
| `analytical-note.md` | After AIC reading each source | Always — per source |
| `conceptual-synthesis.md` | After processing 3+ sources | Always — living doc |
| `research-memo.md` | When a pattern emerges from CSE | Per theme — analytical essay |

## Pacheco-Vega Method Summary

1. **AIC Reading** (per source):
   - **A**nalytical: What does it say? → Facts only
   - **I**nterpretive: What does it mean? → Context and connections
   - **C**ritical: How strong is it? → Assessment and gaps

2. **CSE Matrix** (across sources):
   - Rows = sources, Columns = themes
   - Update after every 3-5 new sources
   - Empty cells are data — they show coverage gaps

3. **Research Memos** (per pattern):
   - Write when CSE reveals a clear pattern
   - Argue a position — don't just summarize
   - 500-1000 words, fully cited

## Template Workflow

```
Source received
  │
  ├─ AIC Reading → analytical-note.md
  │
  ├─ (every 3-5 sources) → Update conceptual-synthesis.md
  │
  ├─ (when patterns emerge) → Write research-memo.md
  │
  └─ (ongoing) → Update literature-matrix.md
```

## Quick Rules

1. **Never skip the A pass** — understand before you interpret
2. **The CSE is the backbone** — keep it updated, patterns emerge from it
3. **Memos argue, not summarize** — take a position based on evidence
4. **Track AIC status** in the literature matrix (A / AI / AIC)
5. **Replace all `{{placeholders}}`** — no template variables in final output

## Integration

- AIC notes → Zettelkasten `literature` notes with tags: `literature-review`, `aic-reading`
- Research memos → Zettelkasten `permanent` notes with tag: `research-memo`
- CSE matrix → Zettelkasten `structure` note with tag: `cse-matrix`
