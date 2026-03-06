---
name: dk.v2.gather-knowledge
description: >
  Knowledge DB gather track. Searches configured knowledge DB (Zettelkasten/Obsidian/etc)
  for existing notes, linked concepts, and prior research.
tools:
  [
    edit/createFile,
    edit/editFiles,
    filesystem/edit_file,
    filesystem/read_file,
    filesystem/read_media_file,
    filesystem/read_multiple_files,
    filesystem/read_text_file,
    filesystem/search_files,
    filesystem/write_file,
    "zettelkasten/*",
  ]
---

# Gather: Knowledge DB Track

Search the user's existing knowledge base for prior research, connected concepts, and existing insights.

## Input

From orchestrator: research question, sub-questions, dimension assignments, knowledge DB plugin config.

## Execution

1. **Search by keywords** — key terms from question and sub-questions
2. **Search by tags** — relevant tag clusters
3. **Traverse links** up to `traversal_depth` hops:
   - `extends`/`extended_by` → conceptual chains
   - `supports`/`contradicts` → evidence for/against
   - `refines`/`refined_by` → refined versions
4. **Identify prior research** — flag notes from related previous sessions
5. **Map to dimensions**

## Output → `tracks/knowledge.md`

```markdown
# Knowledge DB Track

**Searches**: {n} | **Notes found**: {n} | **Traversed**: {n} | **Dimensions**: {list} | **Provider**: {name}

---

### S-K{n}: {Note Title}

- **ID**: {note_id}
- **Type**: permanent | literature | fleeting | structure | hub
- **Tags**: [tag1, tag2]
- **Created**: YYYY-MM-DD
- **Tier estimate**: 2–3
- **Relevance**: high | medium | low
- **Dimension**: {id}
- **Summary**: 2–3 sentences
- **Key insights**: bullet list
- **Links**: extends → {id}, contradicts → {id}
```

## Provider Abstraction

Read tool names from plugin config. Same output format regardless of backend (Zettelkasten, Obsidian, Logseq, Notion).
