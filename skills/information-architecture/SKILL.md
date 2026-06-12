---
name: information-architecture
description: "Comprehensive information architecture (IA) skill for designing, evaluating, and implementing information structures across digital products, knowledge management systems, and scientific domains. Covers IA design process, card sorting, tree testing, PARA, Zettelkasten, Hub-and-Spoke architecture, taxonomy/ontology design, and knowledge graph patterns. Use when asked to 'design an IA', 'structure information', 'organize content', 'card sort', 'tree test', 'create taxonomy', 'build a knowledge system', or any task involving information structure, navigation design, or knowledge organization."
license: MIT
---

# Information Architecture Skill

## When to Use This Skill

- Designing or restructuring site/app navigation
- Planning knowledge management systems (PKM, organizational KM)
- Creating taxonomies, ontologies, or metadata schemas
- Running card sorting or tree testing studies
- Evaluating IA for findability, usability, or scalability
- Designing AI-powered or zero-UI information architectures
- Structuring scientific knowledge domains or research corpora
- Any task where "how is this organized?" matters more than "what does it look like"

## Core Principles

### 1. Structure Serves Purpose

IA is not decoration — it is the scaffold that makes information usable. Every organizational decision must answer: *What task does this serve? For whom? Under what constraints?*

### 2. Design From the Outside In

Start with user mental models, not your internal structure. Card sorting reveals how people actually think, not how your org chart thinks.

### 3. Research Before Design

Never design IA from opinion alone. Use card sorting (generative) and tree testing (evaluative) in sequence. A tree test should always follow a card sort study.

### 4. Multiple Paths, Not One True Way

Good IA provides browsing, searching, tagging, and navigation. No single path serves all users or all tasks.

### 5. Respect Cognitive Limits

Working memory holds ~4 chunks (not 7). Use chunking, schemas, and progressive disclosure. Flat is often better than deep.

### 6. Label With User Language

Labels should use the user's vocabulary, not internal jargon. Information scent matters — a label should give users confidence a path leads where they want to go.

### 7. Design for Retrieval, Not Just Storage

The point of IA is enabling people to *find* and *use* information, not just accumulate it. A system that looks impressive but cannot be searched has failed.

### 8. Iterate Continuously

IA is never "done." Monitor analytics, re-card-sort as content grows, and refine based on real usage.

## The IA Design Process

```
┌─────────────────────────────────────────────────────┐
│                    IA DESIGN PROCESS                 │
├─────────────────────────────────────────────────────┤
│                                                     │
│  1. RESEARCH                                        │
│     ├── Understand user tasks and goals             │
│     ├── Identify user mental models                 │
│     ├── Inventory existing content/information      │
│     └── Define success criteria                     │
│                                                     │
│  2. GENERATE (Card Sorting)                         │
│     ├── Open sort: Users create categories          │
│     ├── Closed sort: Predefined categories          │
│     ├── Hybrid sort: Mix of both                    │
│     └── Output: Common groupings + matrices         │
│                                                     │
│  3. STRUCTURE (IA Design)                           │
│     ├── Organization systems (categories)           │
│     ├── Navigation systems (menus, paths)           │
│     ├── Labeling systems (clear, user language)     │
│     ├── Search and filtering                        │
│     └── Metadata and tagging systems                │
│                                                     │
│  4. VALIDATE (Tree Testing)                         │
│     ├── Text-only site structure                    │
│     ├── Users complete real tasks                   │
│     ├── Measure success rate (target: 75%+)         │
│     └── Iterate on labels and structure             │
│                                                     │
│  5. IMPLEMENT                                       │
│     ├── Build navigation and structure              │
│     ├── Ensure consistency in labeling              │
│     └── Document the IA for stakeholders            │
│                                                     │
│  6. MAINTAIN                                        │
│     ├── Monitor analytics for pain points           │
│     ├── Periodic card sorting as content grows      │
│     └── Archive obsolete content                    │
│                                                     │
└─────────────────────────────────────────────────────┘
```

## The 6 Elements of IA

| Element | What It Covers | Key Questions |
|---------|---------------|---------------|
| **Organization Systems** | How information is categorized | Hierarchical? Taxonomic? Ontological? Folksonomic? |
| **Labeling Systems** | How content is represented | Are labels clear? User-language? Consistent? |
| **Navigation Systems** | How users move around | Menus? Breadcrumbs? Links? Multi-path? |
| **Searching Systems** | How users find content | Search engine? Faceted filters? Synonyms? |
| **Tagging Systems** | How users assign labels | User-generated? Controlled vocabulary? Hybrid? |
| **Metadata** | Data about data | Descriptive? Structural? Administrative? |

## Research Methods

### Card Sorting

**Purpose**: Uncover users' mental models for how they expect content to be grouped.

| Aspect | Detail |
|--------|--------|
| **Type** | Open (users create categories), Closed (predefined), Hybrid |
| **Cards** | 30–50 items (pages, features, concepts, products) |
| **Participants** | 15+ for qualitative; 30–50 for quantitative |
| **Output** | Similarity matrices, dendrograms, common groupings |
| **Best practice** | Always follow with tree testing for validation |

### Tree Testing

**Purpose**: Validate findability of an existing or proposed IA.

| Aspect | Detail |
|--------|--------|
| **Format** | Text-only version of site structure (no design) |
| **Tasks** | 5–8 real user tasks |
| **Success metric** | 75%+ on primary tasks, 60%+ on secondary |
| **Answers** | Do labels make sense? Is content grouped logically? |
| **Best practice** | Always follows card sorting |

### Additional Methods

| Method | Type | When to Use |
|--------|------|-------------|
| First-click testing | Evaluative | Evaluating initial navigation choices |
| Content audit | Generative | Inventory and analysis of existing content |
| User interviews | Generative | Understand user mental models and tasks |
| Analytics review | Evaluative | Identify navigation pain points from real usage |

## Knowledge Management IA

### PARA Method (Action-Oriented Filing)

| Category | Description | Examples |
|----------|-------------|----------|
| **Projects** | Short-term efforts with a defined goal and deadline | "Ship Q3 Report," "Write Dissertation Chapter" |
| **Areas** | Ongoing responsibilities requiring a standard to be maintained | "Health," "Finances," "Team Management" |
| **Resources** | Topics of ongoing interest, not tied to a specific goal | "Machine Learning," "Woodworking," "Stoic Philosophy" |
| **Archives** | Inactive items from the first three categories | Completed projects, obsolete areas |

**Best for**: Anyone who manages projects or has clear ongoing responsibilities.
**Question it answers**: "Where does this go?" — Always one of 4 places.

### Zettelkasten Method (Connection-Oriented Thinking)

**Core principles**:
- **Atomicity**: Each note contains one idea only
- **Connectivity**: Every new note links to existing notes
- **Unique IDs**: Each note has a persistent identifier
- **Written for future self**: Notes are self-contained, written as if the reader forgot the context

**Note types**:
1. **Fleeting** — Quick, temporary captures (processed and discarded)
2. **Literature** — Summaries of external content in your own words
3. **Permanent** — Atomic, self-contained ideas; the core of the system
4. **Structure** — Organize clusters of 7–15 related notes
5. **Hub** — Entry points for broad topic areas

**Best for**: Researchers, thesis writers, writers, and anyone whose output is original ideas synthesized from many sources.

### Hub-and-Spoke Architecture (PARA + Zettelkasten)

The most robust IA for knowledge management separates systems physically while connecting them functionally.

| Component | Role | Location |
|-----------|------|----------|
| **PARA** | "Front Office" — Hub of Action | `00 Inbox` → `01 Projects` → `02 Areas` → `03 Resources` → `04 Archive` |
| **Zettelkasten** | "Research Library" — Spoke of Insight | `10 Zettelkasten` (top-level, co-equal) |
| **Links** | "Hallways" — Connect without displacement | Bidirectional links from project notes → permanent notes |

**Critical rules**:
1. Permanent notes NEVER leave `10 Zettelkasten`
2. Project notes link to permanent notes (not move them)
3. Zettelkasten is a top-level folder, NOT a subfolder of PARA

**Anti-patterns**:
- ❌ Subsuming ZK into PARA — treats timeless knowledge as temporary
- ❌ Atomizing PARA — creates ZK-style notes inside project folders, breaks the unified web of thought

### Building a Second Brain (BASB)

Built on CODE: **C**apture, **O**rganize, **D**istill, **E**xpress.

**Progressive summarization** (the load-bearing technique):
1. Read a document (e.g., 5,000 words)
2. Highlight key passages (e.g., 500 words)
3. Bold the most important lines (e.g., 100 words)
4. Summarize the gist in 20 words

**Best for**: Knowledge workers who consume massive content and need to reuse it without re-reading.

## Classification Systems

| Type | Structure | Control | Example |
|------|-----------|---------|---------|
| **Taxonomy** | Hierarchical | Controlled vocabulary | MeSH, Dewey Decimal |
| **Ontology** | Networked (graph) | Formal semantics, relationships | SNOMED CT, WordNet |
| **Folksonomy** | Tag-based, emergent | User-generated | Tags on social media |
| **Thesaurus** | Hierarchical + associative | Controlled, with cross-refs | ACM CCS |

## IA Best Practices Checklist

### For Digital Products
- [ ] User research completed (tasks, mental models, vocabulary)
- [ ] Card sorting study conducted (15+ participants)
- [ ] Tree testing conducted (75%+ success rate on primary tasks)
- [ ] Navigation tested with real users
- [ ] Labels use user language, not internal jargon
- [ ] Multiple paths provided (browse, search, tags)
- [ ] Hierarchy limited to 3–5 levels
- [ ] Information scent maintained throughout
- [ ] Accessibility considered (WCAG compliance)
- [ ] IA documentation created and shared
- [ ] Analytics monitoring established

### For Knowledge Management
- [ ] PARA structure implemented (4 top-level folders)
- [ ] Zettelkasten system implemented (atomic notes, dense linking)
- [ ] Hub-and-Spoke architecture (PARA + ZK as co-equal top-level)
- [ ] Capture workflow established (inbox → process → file)
- [ ] Weekly review ritual established
- [ ] Permanent notes have stable home (separate from projects)
- [ ] Literature notes processed into permanent notes
- [ ] Maps of Content created for major topics
- [ ] Tags limited to ~10 top-level categories
- [ ] Compounding is measurable (notes make other notes more useful)

### For Scientific/Thinking Domains
- [ ] Multi-dimensional classification designed (not just hierarchy)
- [ ] Cross-disciplinary access enabled
- [ ] Provenance tracking implemented
- [ ] Uncertainty represented (confidence levels)
- [ ] Knowledge evolution supported (versioning)
- [ ] Cognitive limits respected (working memory, chunking)
- [ ] Multiple views available (hierarchical, networked, faceted)
- [ ] Retrieval optimized (not just storage)
- [ ] Meta-cognitive support included
- [ ] Explicit knowledge surfaced (from tacit)

## Decision Frameworks

### Choosing an IA Method

```
Is your primary goal execution or insight?
├── Execution (action-oriented)
│   └── Use PARA (Projects, Areas, Resources, Archives)
│
└── Insight (thinking-oriented)
    └── Use Zettelkasten (atomic notes, dense linking)
    
Both?
└── Use Hub-and-Spoke: PARA for filing, Zettelkasten for thinking
    Connected by links, not by moving files
```

### Choosing Research Methods

```
Do you know how users categorize your content?
├── No → Card sorting (generative)
│   └── Then → Tree testing (validative)
│
└── Yes → Tree testing (validative)
    └── If problems found → Card sorting (generative)
        └── Iterate
```

### Choosing a PKM Tool

```
Are you Apple-only and want zero friction?
├── Yes → Apple Notes
└── No
    ├── Do you want local-first, plain-file portability?
    │   └── Yes → Obsidian
    ├── Do you need databases, templates, team collaboration?
    │   └── Yes → Notion
    ├── Do you want AI-grounded retrieval with cited answers?
    │   └── Yes → Atlas
    └── Do you live in a daily-journal outliner workflow?
        └── Yes → Logseq
```

## IA Templates

### Template 1: IA Project Charter

```markdown
Project: [Name]
Date: [Date]
IA Lead: [Name]

Objectives:
- [Primary goal]
- [Secondary goals]

User Tasks:
1. [Most important task]
2. [Second most important]
3. [Third most important]

Content Inventory:
- Total items: [Number]
- Content types: [List types]
- Growth rate: [Estimate]

Success Criteria:
- Findability: [Metric]
- Navigation: [Metric]
- User satisfaction: [Metric]

Timeline:
- Research: [Dates]
- Card sorting: [Dates]
- IA design: [Dates]
- Tree testing: [Dates]
- Implementation: [Dates]
```

### Template 2: Card Sort Study Brief

```markdown
Study Title: [Name]
Date: [Date]
Facilitator: [Name]

Content to Sort:
- [List of items, 30–50]
- Format: [Pages, features, products, concepts]

Study Type:
[ ] Open sort (users create categories)
[ ] Closed sort (predefined categories)
[ ] Hybrid sort

Participants: [Number] (15+ qualitative, 30–50 quantitative)

Instructions:
"Please organize these cards into groups that make sense to you.
There is no right or wrong way. Group sizes can vary.
You can rearrange cards at any time. If you don't know what
a card means, leave it off to the side."

Analysis Plan:
- Identify common groupings
- Note category names users create
- Flag difficult-to-place items
- Cross-reference with qualitative feedback
```

### Template 3: Tree Test Study Brief

```markdown
Study Title: [Name]
Date: [Date]

Site Structure:
[Text-only representation of navigation hierarchy]

Tasks (5–8 tasks):
1. [Task 1 — primary task]
2. [Task 2 — secondary task]
3. [Task 3 — edge case]

Success Criteria:
- Primary tasks: 75%+ success rate
- Secondary tasks: 60%+ success rate
- Average time on task: [Benchmark]

Participants: [Number] (5–8 for qualitative, 15+ for quantitative)
```

### Template 4: IA Documentation

```markdown
Site: [Name]
Version: [Version]
Date: [Date]

Organization Systems:
- Primary categories: [List]
- Subcategories: [List]
- Cross-references: [List]

Navigation Systems:
- Primary navigation: [Structure]
- Secondary navigation: [Structure]
- Breadcrumbs: [Pattern]
- Footer navigation: [Structure]

Labeling System:
- [Label] → [What it means]
- [Label] → [What it means]
- Avoid: [Jargon to avoid]
- Use: [User language to prefer]

Search System:
- Supported queries: [Examples]
- Filters: [Available filters]
- Synonyms: [Mapping]
- Fallback: [When search fails]

Metadata Schema:
- [Field]: [Type, purpose]
- [Field]: [Type, purpose]
```

### Template 5: Zettelkasten Note Templates

**Permanent Note**:
```markdown
# [Title: Declarative statement of the idea]

## Core Idea
[One paragraph summarizing the idea in your own words]

## Connections
- Related to: [[Related Note 1]]
- Related to: [[Related Note 2]]
- Contradicts: [[Contradicting Note]]
- Builds on: [[Foundational Note]]

## Context
- Source: [Where this idea came from]
- Date created: [Date]
- Last updated: [Date]

## Notes
[Additional thoughts, examples, applications]
```

**Literature Note**:
```markdown
# [Source Title]

## Source
- Author: [Name]
- Date: [Date]
- URL: [Link]
- Type: [Book, article, podcast, etc.]

## Key Points
1. [Point 1 — in your own words]
2. [Point 2 — in your own words]
3. [Point 3 — in your own words]

## Quotes
> "[Key quote]" — [Page/Timestamp]

## Connections
- Relates to: [[Related Permanent Note]]
- Relates to: [[Related Permanent Note]]

## Status
[processing | processed | archived]
```

## Anti-Patterns

| Anti-pattern | Why It Fails | Better Alternative |
|-------------|-------------|-------------------|
| IA from opinion alone | Misses real user mental models | Card sort → Tree test |
| Deep hierarchies (5+ levels) | Users get lost, information scent degrades | Flat is often better; 3–5 levels max |
| Labels from org chart | Internal jargon confuses users | User language from interviews |
| Single navigation path | Different users need different paths | Browse + search + tags + navigation |
| Subsuming ZK into PARA | Treats timeless knowledge as temporary | Hub-and-Spoke: co-equal top-level |
| Over-tagging | 50 tags become 500; loses signal | ~10 top-level tags max; tags for metadata |
| Design for storage, not retrieval | Gallery, not workshop | Optimize for finding things in <1 min |
| Capture without distill | 5,000 highlights never re-read | Progressive summarization |
| Tool-hopping | Rebuilding system every month | Commit 90 days minimum |
| Copying templates blindly | Their context is not yours | Adapt to your actual needs |

## Modern IA Challenges (2025–2026)

| Challenge | IA Implication |
|-----------|---------------|
| **AI-powered IA** | Personalized navigation, predictive placement, AI-generated taxonomy |
| **Zero UI / Voice interfaces** | Rethink navigation for conversational interactions |
| **Dynamic content** | Real-time information that changes based on context |
| **Enterprise IA** | Managing information across complex, multi-platform organizations |
| **Accessibility** | IA must serve users with diverse abilities and needs |
| **Scale** | Millions of content items with automated classification |
| **Knowledge graphs** | Networked knowledge with formal semantics and reasoning |
| **Epistemic architectures** | Structured cognitive loops for genuine understanding |

## Key References

- Rosenfeld, Morville & Arora: *Information Architecture for the World Wide Web* (3rd ed., 2015)
- Nielsen Norman Group: Card sorting, tree testing, IA articles
- Baymard Institute: IA UX research for e-commerce
- Information Architecture Institute: Professional community and standards
- Optimal Workshop: Card sorting and tree testing methodology
- Forte, Tiago: *The PARA Method* (2017), *Building a Second Brain* (2022)
- Ahrens, Sönke: *How to Take Smart Notes*
- Luhmann, Niklas: Zettelkasten / slip-box method (1950s)
- Kim, M.H.: *Executable Epistemology: The Structured Cognitive Loop*
- Sweller, J.: Cognitive Load Theory
- Stanford Encyclopedia of Philosophy: Cognitive Science, Mental Representation
