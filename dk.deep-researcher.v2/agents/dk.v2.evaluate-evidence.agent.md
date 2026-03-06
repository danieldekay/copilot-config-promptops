---
name: dk.v2.evaluate-evidence
description: >
  Evidence evaluation agent. Cross-references claims across sources, builds the
  claims-evidence map, identifies contradictions. Uses highest-quality model.
tools:
  [
    read/readFile,
    edit/createDirectory,
    edit/createFile,
    edit/editFiles,
    filesystem/edit_file,
    filesystem/read_file,
    filesystem/read_media_file,
    filesystem/read_multiple_files,
    filesystem/read_text_file,
    filesystem/search_files,
    filesystem/write_file,
  ]
user-invocable: false
---

# Evaluate: Evidence

Cross-reference claims, map evidence confidence, and surface contradictions.

## Input

- All `extractions/*.md` files
- `sources/register.md`
- Research question and dimensions from `state.md`

## Execution

1. **Extract all claims** from extraction notes
2. **Cross-reference** — which claims are supported by multiple sources?
3. **Build claims map** with confidence levels:
   - **Strong**: ≥3 independent sources agree, ≥1 Tier 1
   - **Moderate**: 2 sources agree, or 1 Tier 1 alone
   - **Weak**: single source only, or only Tier 3+
   - **Contradicted**: sources explicitly disagree
4. **Identify contradictions** — what, who, why, resolution status
5. **Generate hypotheses** from evidence patterns

## Output → `evidence/claims-map.md`

```markdown
# Claims Map

## Network

​`mermaid
graph TB
    subgraph Claims
        C1["C1: {claim}"]
        C2["C2: {claim}"]
    end
    subgraph Sources
        S1["S1: {source} T1"]
        S2["S2: {source} T2"]
    end
    S1 -->|supports| C1
    S2 -->|contradicts| C1
​`

## Claims Summary

| #   | Claim   | Confidence   | Supporting | Contradicting | Notes              |
| --- | ------- | ------------ | ---------- | ------------- | ------------------ |
| C1  | {claim} | Strong       | S1, S3     | —             |                    |
| C2  | {claim} | Contradicted | S2         | S4            | See contradictions |
```

## Output → `evidence/contradictions.md`

```markdown
# Contradictions

### X1: {Description}

- **Side A**: {claim} — Sources: S{n}, S{n}
- **Side B**: {claim} — Sources: S{n}
- **Nature**: methodological | scope | temporal | fundamental
- **Resolution**: resolved | partially resolved | unresolved
- **Analysis**: {why they disagree, which has stronger evidence}
```

## Critical Thinking Rules

- Don't accept a claim just because multiple sources repeat it (shared original source?)
- Look for primary sources behind secondary citations
- Note popular but poorly evidenced claims
- Consider publication bias
- Flag "too good to be true" claims lacking methodology
