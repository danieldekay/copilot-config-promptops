---
name: dk.v2.cite
description: >
  Citation management agent. Generates BibTeX entries, builds reading list,
  manages DOI resolution and citation keys.
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
    search,
    filesystem/read_file,
  ]
user-invocable: false
---

# Citation Manager

Generate BibTeX bibliography and curated reading list from source register.

## Input

- `sources/register.md` — rated source register
- All `extractions/*.md` — for detailed metadata

## Execution

1. **For each Tier 1–3 academic source**: generate BibTeX entry with DOI resolution
2. **For web sources**: generate `@misc` entries with URL and access date
3. **Build reading list** ordered by: foundational → seminal → current → supplementary
4. **Generate citation network** as Mermaid diagram

## Output → `references/citations.bib`

```bibtex
@article{Wang2025deepresearcher,
  title     = {DeepResearcher: Scaling Deep Research via RL},
  author    = {Wang, Yijie and others},
  year      = {2025},
  journal   = {arXiv preprint arXiv:2504.xxxxx},
  doi       = {10.xxxx/xxxxx}
}
```

## Output → `references/reading-list.md`

```markdown
# Reading List

## Foundational (read first)

1. {Author (Year)} — {Title} — {why foundational}

## Key Papers (core evidence)

1. {Author (Year)} — {Title} — {key contribution}

## Supporting (context)

1. {Author (Year)} — {Title} — {what it adds}

## Citation Network

​`mermaid
graph TB
    A["Paper A (2023)"] --> B["Paper B (2024)"]
    A --> C["Paper C (2025)"]
    B --> D["Paper D (2025)"]
​`
```

## Citation Key Format

Use `{FirstAuthor}{Year}{keyword}` pattern (e.g., `Wang2025deepresearcher`).
