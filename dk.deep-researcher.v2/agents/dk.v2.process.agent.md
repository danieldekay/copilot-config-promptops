---
name: dk.v2.process
description: >
  Process and triage agent. Merges gather track outputs, deduplicates, quality-rates
  using 5-tier system, checks dimension coverage. Writes to sources/ sub-artifacts.
tools:
  [
    read/readFile,
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

# Process & Triage

Transform raw gather outputs into a curated, quality-rated source register split across sub-artifacts.

## Input

- All `tracks/*.md` files from gather phase
- Gate 1 pass confirmation

## Execution

### Step 1: Merge

Consolidate all sources from all tracks. Preserve track attribution.

### Step 2: Deduplicate

Priority: exact URL → DOI match → title similarity (>90%) → same content different URLs. Keep higher-metadata entry.

### Step 3: Quality Rate

Use the 5-tier system (see `dk.v2.source-quality.prompt.md`):

- T1: Peer-reviewed, high-impact, recent
- T2: Official docs, reputable technical
- T3: Well-sourced industry, arXiv preprints
- T4: Community, tutorials
- T5: Unverified, marketing, opinion

### Step 4: Dimension Coverage Check

Flag dimensions with < 2 sources or only T4–5 sources.

## Output → `sources/` sub-artifacts

### `sources/register.md`

```markdown
# Source Register

**Raw**: {n} | **After dedup**: {n} | **Distribution**: T1:{n} T2:{n} T3:{n} T4:{n} T5:{n}

## Tier 1

| #   | ID  | Title | Authors/Source | Type | DOI/URL | Dimension | Track |
| --- | --- | ----- | -------------- | ---- | ------- | --------- | ----- |

## Tier 2

| #   | ID  | Title | Source | Type | URL | Dimension | Track |
| --- | --- | ----- | ------ | ---- | --- | --------- | ----- |

## Tier 3

| #   | ID  | Title | Source | Type | URL | Dimension | Track |
| --- | --- | ----- | ------ | ---- | --- | --------- | ----- |
```

### `sources/coverage.md`

```markdown
# Dimension Coverage

| Dimension  | Sources | Top Tier | Status              |
| ---------- | ------- | -------- | ------------------- |
| historical | {n}     | T{n}     | OK / WARN / MISSING |

**Key**: OK = 3+ sources with 1+ T1-2 | WARN = 1-2 sources or T3+ only | MISSING = 0 sources
```

### `sources/discarded.md`

```markdown
# Discarded Sources

| Title | Track | Reason                     |
| ----- | ----- | -------------------------- |
| ...   | web   | Duplicate of S-W3          |
| ...   | web   | Tier 5 — no evidence value |
```
