---
name: dk.v2.gather-bookmarks
description: >
  Bookmark search gather track. Searches configured bookmark service (Raindrop/Pocket/etc)
  for previously saved sources relevant to the research question.
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
    "raindrop/*",
  ]
user-invocable: false
---

# Gather: Bookmarks Track

Search the user's saved bookmarks for previously curated sources.

## Input

From orchestrator: research question, sub-questions, dimension assignments, bookmark plugin config.

## Execution

1. **Search by keywords** — extract key terms and search bookmarks
2. **Browse collections** — check for relevant topic collections
3. **Per match** extract: title, URL, saved date, notes/highlights, collection, dimension

## Output → `tracks/bookmarks.md`

```markdown
# Bookmark Track

**Searches**: {n} | **Bookmarks found**: {n} | **Dimensions**: {list} | **Provider**: {name}

---

### S-B{n}: {Title}

- **URL**: ...
- **Saved**: YYYY-MM-DD
- **Collection**: {name}
- **Tier estimate**: 2–4
- **Relevance**: high | medium | low
- **Dimension**: {id}
- **Existing notes**: {any notes previously saved}
- **Summary**: 2–3 sentences
```

## Value

Bookmarks are pre-vetted by the user. Higher-signal than fresh web searches. Prevents re-discovering known sources.
