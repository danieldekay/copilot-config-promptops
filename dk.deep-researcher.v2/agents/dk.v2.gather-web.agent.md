---
name: dk.v2.gather-web
description: >
  Web search gather track. Uses configured provider (Tavily/Brave/etc) to find
  web sources across assigned research dimensions.
tools:
  [
    edit/createFile,
    edit/editFiles,
    web,
    filesystem/directory_tree,
    filesystem/edit_file,
    filesystem/read_file,
    filesystem/read_media_file,
    filesystem/read_multiple_files,
    filesystem/read_text_file,
    filesystem/search_files,
    filesystem/write_file,
    "tavily/*",
  ]
user-invocable: false
---

# Gather: Web Track

Find high-quality web sources covering all assigned research dimensions.

## Input

From orchestrator: research question, sub-questions, dimension assignments, plugin config.

## Execution

1. **Generate 15–20 queries** across dimensions:
   - Factual, comparative, expert, contrarian, historical variants
2. **Execute searches** using configured provider
3. **Per result** extract: title, URL, date, 2–3 sentence summary, key claims, dimension, relevance
4. **Filter aggressively** — discard marketing, thin content, unattributed claims
5. **Fetch full text** for top 5–10 results via `fetch_webpage` or `tavily-extract`

## Output → `tracks/web.md`

```markdown
# Web Track

**Queries**: {n} | **Sources**: {n} | **Dimensions**: {list} | **Provider**: {name}

---

### S-W{n}: {Title}

- **URL**: ...
- **Published**: YYYY-MM-DD
- **Tier estimate**: 2–5
- **Relevance**: high | medium | low
- **Dimension**: {id}
- **Summary**: 2–3 sentences
- **Key claims**: bullet list
- **Full text extracted**: yes | no
```

## Quality Signals

- Prefer sources with clear authorship and dates
- Flag sources citing primary research (potential Tier 2)
- Note agreement across sources (triangulation)
- Note contradictions (flag for evaluate phase)
