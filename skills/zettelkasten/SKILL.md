# Zettelkasten Knowledge Management Skill

## Overview

This skill provides comprehensive guidance for managing a personal knowledge management (PKM) system using the Zettelkasten method through MCP tools. It covers atomic note creation, semantic linking strategies, research integration, and knowledge emergence patterns.

## When to Use This Skill

- Creating, linking, or organizing notes in a Zettelkasten system
- Conducting research to create well-sourced permanent notes
- Building knowledge graphs and discovering emergent insights
- Processing fleeting notes into permanent knowledge
- Validating claims with external sources

## Core Principles

### 1. Atomicity

Each note contains exactly **one idea or concept**. This enables:

- Precise linking (link to exactly what you mean)
- Reusable knowledge units
- Clear thinking through forced decomposition
- Maximum connection potential

**Test**: If you can't summarize a note in one sentence, split it.

### 2. Connectivity

Notes gain value through meaningful connections. Links should:

- Explain the relationship (not just exist)
- Use semantic link types (supports, contradicts, extends, refines)
- Be bidirectional when relationships are mutual
- Create paths of thought, not just collections

### 3. Emergence

New insights emerge from the network. Foster this by:

- Looking for unexpected connections across domains
- Creating structure notes when clusters form (7-15 notes on a topic)
- Reviewing orphaned notes for integration opportunities
- Following link chains to discover implicit relationships

### 4. Source Integrity

Every factual claim must be traceable:

- Minimum 2 independent sources for significant claims
- Full bibliographic citations (author, year, title, source, URL, access date)
- Reliability indicators (✅ peer-reviewed, ⚠️ authoritative, ❌ anecdotal)
- Evidence strength assessment (strong/moderate/weak)

## Note Types

| Type           | Purpose                                    | Lifespan  | Tool Pattern                                  |
| -------------- | ------------------------------------------ | --------- | --------------------------------------------- |
| **Fleeting**   | Capture raw thoughts quickly               | Temporary | `zk_create_note note_type="fleeting"`         |
| **Literature** | Extract ideas from sources with citations  | Permanent | Include full citation in content              |
| **Permanent**  | Well-formulated, standalone, sourced ideas | Permanent | `note_type="permanent"` + research validation |
| **Structure**  | Organize clusters of 7-15 related notes    | Permanent | `note_type="structure"`                       |
| **Hub**        | Entry points for broad topic areas         | Permanent | `note_type="hub"`                             |

## Semantic Link Types

| Link Type     | Use When                               | Example Description                       |
| ------------- | -------------------------------------- | ----------------------------------------- |
| `reference`   | Simply connecting related information  | "See also for background"                 |
| `extends`     | One note builds upon another           | "Taking this idea further with..."        |
| `refines`     | One note clarifies or improves another | "More precise formulation of..."          |
| `contradicts` | Opposing views or evidence             | "Alternative perspective supported by..." |
| `questions`   | One note poses questions about another | "This raises the question of..."          |
| `supports`    | Evidence for another claim             | "Empirical validation from Zhang et al."  |
| `related`     | Generic relationship                   | "Shares conceptual overlap with..."       |

## MCP Tool Reference

### Knowledge Discovery

```plaintext
# Search existing knowledge before creating
zk_search_notes query="concept" tags="tag1,tag2" limit=10

# Find connection opportunities
zk_find_similar_notes note_id="[ID]" threshold=0.3 limit=5

# Explore central concepts
zk_find_central_notes limit=10

# Find integration opportunities
zk_find_orphaned_notes

# Follow knowledge paths
zk_get_linked_notes note_id="[ID]" direction="both"
```

### Knowledge Creation

```plaintext
# Create atomic note
zk_create_note title="Concept Title" content="..." note_type="permanent" tags="tag1,tag2"

# Create semantic link with explanation
zk_create_link source_id="[NEW]" target_id="[EXISTING]" link_type="supports" description="Research by X demonstrates..." bidirectional=true

# Update with new findings
zk_update_note note_id="[ID]" content="[updated content with new sources]"
```

### Knowledge Organization

```plaintext
# Review recent activity
zk_list_notes_by_date start_date="YYYY-MM-DD" use_updated=true limit=10

# Explore tag taxonomy
zk_get_all_tags

# Rebuild index after bulk changes
zk_rebuild_index
```

## Research Integration Workflow

### Phase 1: Concept Identification

1. **Search existing notes** to prevent duplication
2. **Formulate research questions**:
   - What do authoritative sources say?
   - Is there empirical evidence?
   - What are alternative perspectives?

### Phase 2: External Research

Use Tavily tools for comprehensive research:

```plaintext
# Academic/professional sources
tavily_search query="[concept] research evidence empirical" max_results=10

# Alternative perspectives
tavily_search query="[concept] critique limitations alternatives"

# Deep documentation crawl
tavily_crawl url="[authoritative_doc_url]" instructions="Extract key principles and evidence"

# Extract specific content
tavily_extract urls=["url1", "url2"] query="[specific aspect]"
```

### Phase 3: Synthesis

1. **Create permanent note** synthesizing multiple sources
2. **Include complete citations** for every claim
3. **Mark evidence strength** (strong/moderate/weak)
4. **Acknowledge limitations** and uncertainties

### Phase 4: Connection

1. **Link with research-backed descriptions**
2. **Choose appropriate link types** based on evidence
3. **Create bidirectional links** for important relationships

## Note Template

```markdown
# [Concept Title - Clear and Descriptive]

## Core Concept

[Explain the concept in your own words, synthesizing research findings]

## Supporting Evidence

- **Source 1**: [Finding with citation] [✅ Peer-reviewed]
- **Source 2**: [Evidence with citation] [⚠️ Authoritative]

## Alternative Perspectives

[Contrasting views or critiques, properly cited]

## Context and Limitations

[Boundary conditions, applicability constraints, uncertainties]

## Source

**Primary Sources**:

- [Full citation with URL]. Accessed: [Date].
- [Full citation with URL]. Accessed: [Date].

**Evidence Strength**: [Strong/Moderate/Weak]
**Research Date**: [YYYY-MM-DD]
```

## Citation Standards

### Required Elements

1. **Author(s)**
2. **Year**
3. **Title** (in quotes for articles, italics for books)
4. **Source** (journal, publisher, website)
5. **URL/DOI**
6. **Access date** (for web sources)

### Reliability Indicators

- ✅ **Peer-reviewed research** - Academic journals with peer review
- ✅ **Official documentation** - Standards bodies, authoritative organizations
- ⚠️ **Authoritative source** - Recognized experts, established organizations
- ⚠️ **Expert opinion** - Individual commentary without peer review
- ❌ **Anecdotal** - Personal accounts, social media (use sparingly)

### Quality Tiers

1. **Tier 1**: Peer-reviewed meta-analyses, official standards, landmark papers
2. **Tier 2**: Peer-reviewed articles, academic books, official documentation
3. **Tier 3**: Preprints, industry reports, conference proceedings
4. **Tier 4**: Expert blogs, news articles, white papers
5. **Tier 5**: Social media, anonymous sources, marketing materials

## Best Practices

### Note Creation

- [ ] One clear idea per note (atomic)
- [ ] Written in your own words (not copy-paste)
- [ ] 3-7 paragraphs maximum (concise)
- [ ] Can stand alone (includes context)
- [ ] 2-5 specific tags
- [ ] All claims have citations
- [ ] Sources have reliability indicators

### Linking

- [ ] Search for existing related notes first
- [ ] Use specific link types (not just "related")
- [ ] Add descriptions explaining the relationship
- [ ] Use bidirectional=true for mutual relationships
- [ ] Link based on evidence, not assumption

### Maintenance

- [ ] Process fleeting notes weekly
- [ ] Review orphaned notes monthly
- [ ] Update notes when new research emerges
- [ ] Verify URLs periodically
- [ ] Strengthen weak-evidence claims

## Common Patterns

### Processing Fleeting Notes

```plaintext
1. zk_search_notes note_type="fleeting" limit=10
2. For each: Research → Validate → Transform to permanent
3. zk_delete_note note_id="[fleeting_id]" after transformation
```

### Building Structure Notes

```plaintext
1. zk_search_notes tags="[topic]" limit=20
2. When 7-15 notes exist on topic:
3. zk_create_note note_type="structure" title="[Topic] — Structure Note"
4. Link to all component notes with descriptions
```

### Claim Verification

```plaintext
1. zk_get_note identifier="[ID]"
2. Identify unsourced or weak claims
3. tavily_search query="[claim] evidence research"
4. zk_update_note with verified data and citations
```

## Anti-Patterns to Avoid

❌ **Collector's Fallacy**: Saving information without processing it
❌ **Link Spam**: Creating links without meaningful relationships
❌ **Single-Source Notes**: Permanent notes relying on one source
❌ **Orphan Islands**: Notes with no connections
❌ **Copy-Paste**: Storing quotes without synthesis
❌ **Tag Overload**: More than 5 tags per note
❌ **Premature Structure**: Creating structure notes with < 7 component notes

## Integration with Other Skills

- **PDF Skill**: Extract content from PDFs for literature notes
- **Web Research**: Use Tavily for source gathering
- **OpenRouter**: Use AI models for synthesis assistance

## Resources

- Zettelkasten.de - Method documentation
- Sonke Ahrens - "How to Take Smart Notes"
- Niklas Luhmann - Original methodology
