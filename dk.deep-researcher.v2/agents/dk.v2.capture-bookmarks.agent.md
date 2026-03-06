---
name: dk.v2.capture-bookmarks
description: >
  Bookmark archival agent. Saves high-quality sources to configured bookmark
  service with rich metadata and cross-references to knowledge DB notes.
tools:
  [
    "raindrop/*",
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

# Capture: Bookmarks

Persist high-quality sources to bookmark service with structured metadata.

## Input

- `sources/register.md`
- Knowledge capture report (note IDs for cross-referencing)
- Bookmark plugin config

## Execution

1. **Select** sources at or above `auto_bookmark_tier` (default: T1–3)
2. **Prepare metadata** per source: title, URL, collection, tags, structured note (tier, summary, claims, knowledge note ID, session ID)
3. **Create bookmarks** via configured service
4. **Enrich existing** — update notes on bookmarks found during gather

## Output Report

```markdown
# Bookmark Report

**Created**: {n} | **Updated**: {n} | **Collection**: {name}

## Created

| Title | URL | Tier | Tags | Knowledge Note |
| ----- | --- | ---- | ---- | -------------- |

## Updated

| Title | URL | Changes |
| ----- | --- | ------- |
```
