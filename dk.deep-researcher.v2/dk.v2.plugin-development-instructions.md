---
description: How to add new plugins, gather tracks, knowledge DBs, and pipeline phases
applyTo: "manifest.yaml"
---

# Plugin Development

## Architecture

The pipeline uses slot-based plugins. Core defines abstract slots, manifest binds concrete tools.

```
Core Pipeline (immutable) → Plugin Slot: search_web → Binding: tavily (configurable)
```

## Adding a New Gather Track

### 1. Create agent

Create `agents/dk.v2.gather-{name}.agent.md`:

- Same input contract as all gather tracks (question, sub-questions, dimensions, config)
- Track-specific execution logic
- Standard output format to `tracks/{name}.md`

### 2. Register in manifest

```yaml
plugins:
  search_{name}:
    provider: { provider }
    enabled: true
    config: { ... }
```

The orchestrator auto-dispatches any enabled `search_*` plugin. No orchestrator changes needed.

## Swapping Knowledge DB

Every knowledge DB must expose:

| Operation | Required?         |
| --------- | ----------------- |
| search    | Yes               |
| get       | Yes               |
| create    | Yes (for capture) |
| link      | Recommended       |
| linked    | Recommended       |

Configure in manifest:

```yaml
search_knowledge_db:
  provider: obsidian
  config:
    tools:
      search: obsidian_search
      get: obsidian_read_note
      create: obsidian_create_note
```

## Swapping Search Provider

```yaml
search_web:
  provider: brave
  config: { api_key_env: "BRAVE_API_KEY" }
```

Update the agent's tools list to match.

## Adding a Pipeline Phase

1. Add phase to `pipeline.phases` in manifest
2. Define gate criteria if needed
3. Create agent file
4. Update orchestrator dispatch logic
5. Update gate-checks prompt

## Adding an Output Sub-Artifact

1. Define the schema in the relevant agent
2. If mandatory, add to `gates.gate_5.criteria.required_artifacts`
3. Update the synthesize agent that produces it
