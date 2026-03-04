---
name: raindrop
description: "Store and retrieve bookmarks in Raindrop.io using the local MCP server. Use when saving research sources, PDFs, articles, or any URL encountered during work. Also use when searching or browsing existing bookmarks by tag, text, or collection."
---

# Raindrop Bookmarking Skill

## Overview

Use the local `raindrop/*` MCP tools to save, tag, and retrieve bookmarks in the user's Raindrop.io account. Every useful URL discovered during research, every PDF downloaded, and every tool or documentation page referenced should be bookmarked with structured metadata.

## MCP Tools Available

| Tool | Purpose |
|------|---------|
| `mcp_raindrop_create_bookmark` | Save a single URL with title, excerpt, tags, collection |
| `mcp_raindrop_update_bookmark` | Update excerpt/tags on an existing bookmark (e.g. after processing) |
| `mcp_raindrop_list_bookmarks` | List recent bookmarks, optionally by collection |
| `mcp_raindrop_search_bookmarks` | Search by text query, tags, and/or collection |
| `mcp_raindrop_search_bookmarks_by_text` | Quick full-text search |
| `mcp_raindrop_search_bookmarks_by_tags` | Filter by tag(s) |
| `mcp_raindrop_bulk_create_bookmarks` | Save a list of raw URLs in one call |
| `mcp_raindrop_scan_and_add_links` | Scan markdown files/dirs for URLs and bookmark them |
| `mcp_raindrop_analyze_research_links` | Analyze files for link patterns — use before bulk-saving |
| `mcp_raindrop_delete_bookmark` | Remove a bookmark by ID |

## Collections Reference

Use `collection_id` to file bookmarks into the right folder:

| ID | Name | Use for |
|----|------|---------|
| `40439354` | GenAI | AI tools, prompts, model docs, MCP servers |
| `41549186` | Technology & Coding | Dev tools, libraries, APIs, architecture |
| `40382707` | Tango | Argentine tango — culture, music, community, events |
| `42699482` | Writing | Writing craft, editorial, style, blogging |
| `40472140` | Import | Unreviewed / inbox — use when unsure |
| `40347642` | FreeWeb | Open web, decentralisation, digital sovereignty |
| `43275086` | Home | Home & living |
| `40752578` | Photography | Photography, visual arts |
| `42531296` | Health | Health & wellness |
| `42371686` | Cooking | Food & recipes |
| `47359880` | Work | Work-related, productivity |
| `47359882` | Me | Personal, self-development |
| `43083400` | Astro | Astronomy, astrophysics |

> For research sessions: prefer the most specific collection. Unsorted (`collection_id` omitted or `-1`) lands in "All Bookmarks".

## Standard Excerpt Format

Always write excerpts in this structured format so they are searchable and self-documenting:

```
[CATEGORY] YYYY-MM-DD | <one-line purpose>. <key claim or finding>. ZK: [[note-id]]. Session: <path-or-topic>.
```

**Examples:**

```
[research][methodology] 2026-02-28 | Pacheco-Vega AIC reading method. Core digestion protocol for literature-reviewer agent. ZK: [[20260228T...md]]. Session: .github/agents/literature-reviewer.agent.md

[tools][mcp] 2026-02-28 | FastMCP v3 stdio transport for VS Code. run_stdio_async() pattern. Session: code/src/raindrop/mcp_server/

[tango][community] 2026-02-15 | Study on milonga attendance decline in European cities. Key: COVID accelerated pre-existing trends. ZK: [[20260215T...md]]. Session: content/blog/01/
```

## Standard Tag Taxonomy

Apply tags from multiple levels — always at least one from each applicable level:

### Level 1 — Domain (pick one)
`research` · `tools` · `tango` · `writing` · `tech` · `home` · `health` · `work` · `personal`

### Level 2 — Content Type
`methodology` · `tutorial` · `reference` · `paper` · `pdf` · `video` · `thread` · `tool` · `api` · `mcp` · `book`

### Level 3 — Processing State
`inbox` — not yet read
`lit-review` — being processed via AIC
`aic-processed` — AIC note created, ZK link in excerpt
`tier-1` through `tier-4` — deep-research tier classification

### Level 4 — Topic Tags
Free-form, specific: `pacheco-vega` · `fastmcp` · `zettelkasten` · `clean-architecture` · `raindrop` · `limesurvey` · etc.

## Workflows

### Save a source during research

```
1. mcp_raindrop_create_bookmark(
       url=<url>,
       title=<title>,
       excerpt="[domain][type] YYYY-MM-DD | <summary>. Session: <path>",
       tags=["research", "inbox", "<topic>"],
       collection_id=<id>   # pick from collections table above
   )
2. After AIC note created → mcp_raindrop_update_bookmark(
       bookmark_id=<id>,
       excerpt="... ZK: [[note-id]]. AIC: complete.",
       tags=[..., "aic-processed"]   # replace "inbox" with "aic-processed"
   )
```

### Save a downloaded PDF

```
1. mcp_raindrop_create_bookmark(
       url=<original-pdf-url>,
       title=<paper-title>,
       excerpt="[research][pdf] YYYY-MM-DD | <abstract-summary>. PDF: notes/papers/YYYY-Author-keyword.pdf. Session: <path>",
       tags=["research", "pdf", "lit-review", "<topic>"],
       collection_id=<most-relevant-id>
   )
```

### Bulk-save URLs from markdown files

```
1. mcp_raindrop_analyze_research_links(
       file_paths=["/path/to/notes"],
       file_patterns=["*.md"]
   )
   # Review output — check which URLs are new/relevant
2. mcp_raindrop_bulk_create_bookmarks(
       urls=["https://...", "https://..."],
       default_tags=["research", "inbox"],
   )
```

### Retrieve bookmarks by topic

```
# By tag
mcp_raindrop_search_bookmarks_by_tags(tags=["aic-processed"])

# By text
mcp_raindrop_search_bookmarks_by_text(text_query="pacheco vega")

# By collection
mcp_raindrop_list_bookmarks(collection_id=40439354)  # GenAI

# Combined
mcp_raindrop_search_bookmarks(query="tango community", tags=["research"], collection_id=40382707)
```

## Rules

1. **Bookmark on first encounter** — don't wait until the end of a session.
2. **Always include an excerpt** — a URL without context is useless later.
3. **Use `inbox` tag** on first save; replace with `aic-processed` after digestion.
4. **Pick a collection** — avoid leaving everything in "All Bookmarks".
5. **Update after AIC** — add ZK note ID to excerpt when a Zettelkasten note is created.
6. **Deduplicate first** — run `search_bookmarks_by_text` before creating to avoid duplicates.
