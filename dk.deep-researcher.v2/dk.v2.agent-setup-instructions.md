---
description: Installation and setup guide for the v2 deep research pipeline
applyTo: "**"
---

# Setup Guide

## Prerequisites

- VS Code with GitHub Copilot (agent mode)
- At least one web search MCP tool (Tavily recommended)
- Python 3.10+ (for PDF processing, if used)

## Installation

### 1. Copy to workspace

```bash
cp -r v2/ .github/deep-research-v2/
```

### 2. Configure manifest

Edit `manifest.yaml` — enable/disable plugins to match your environment:

```yaml
plugins:
  search_web:
    provider: tavily
    enabled: true
  search_scholar:
    provider: semantic_scholar
    enabled: false # disable if no Semantic Scholar MCP
  search_knowledge_db:
    provider: zettelkasten
    enabled: true # or obsidian, logseq, notion
```

### 3. Register agents

```bash
cp agents/*.agent.md .github/agents/
```

### 4. Register skill

```bash
cp -r skills/dk.v2.deep-research/ .github/skills/dk.v2.deep-research/
```

### 5. Copy prompts and instructions

```bash
cp prompts/*.md .github/instructions/
cp instructions/*.md .github/instructions/
```

## MCP Server Configuration

Add to `.vscode/mcp.json`:

```json
{
  "servers": {
    "tavily": {
      "command": "npx",
      "args": ["@anthropic/mcp-server-tavily"],
      "env": { "TAVILY_API_KEY": "<key>" }
    },
    "raindrop": {
      "command": "npx",
      "args": ["@anthropic/mcp-server-raindrop"],
      "env": { "RAINDROP_API_KEY": "<key>" }
    },
    "zettelkasten": {
      "command": "uv",
      "args": ["run", "python", "-m", "zettelkasten_mcp"],
      "env": {
        "ZETTELKASTEN_NOTES_DIR": "/path/to/notes",
        "ZETTELKASTEN_DATABASE_PATH": "/path/to/db/zettelkasten.db"
      }
    }
  }
}
```

## Verification

1. Open VS Code agent mode
2. Ask: `@dk.v2.orchestrator What is retrieval-augmented generation?`
3. Verify: session folder created, tracks dispatched, gates evaluated, artifacts produced

## Minimal Setup

For web-only research:

```yaml
plugins:
  search_web: { provider: tavily, enabled: true }
  search_scholar: { enabled: false }
  search_codebase: { enabled: false }
  search_knowledge_db: { enabled: false }
  search_bookmarks: { enabled: false }
gates:
  gate_1:
    criteria:
      min_sources: 8
      min_source_categories: 1
```

## Troubleshooting

| Issue                  | Solution                                               |
| ---------------------- | ------------------------------------------------------ |
| MCP server unavailable | Check server running + mcp.json config                 |
| Gate 1 fails           | Lower `min_sources` or enable more tracks              |
| Token budget exceeded  | Increase `max_total_tokens` or reduce extraction depth |
| Agent not found        | Ensure .agent.md files in correct directory            |
