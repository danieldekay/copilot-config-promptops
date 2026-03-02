---
description: 'Documentation and content creation standards'
applyTo: '**/*.md'
---

## Markdown Content Rules

The following markdown content rules are enforced in the validators:

1. **Headings**: Use appropriate heading levels (H2, H3, etc.) to structure your content. Do not use an H1 heading, as this will be generated based on the title.
2. **Lists**: Use bullet points or numbered lists for lists. Ensure proper indentation and spacing.
3. **Code Blocks**: Use fenced code blocks for code snippets. Specify the language for syntax highlighting.
4. **Links**: Use proper markdown syntax for links. Ensure that links are valid and accessible.
5. **Images**: Use proper markdown syntax for images. Include alt text for accessibility.
6. **Tables**: Use markdown tables for tabular data. Ensure proper formatting and alignment.
7. **Line Length**: Limit line length to 400 characters for readability.
8. **Whitespace**: Use appropriate whitespace to separate sections and improve readability.
9. **Front Matter**: Include YAML front matter at the beginning of the file with required metadata fields.

## Formatting and Structure

Follow these guidelines for formatting and structuring your markdown content:

- **Headings**: Use `##` for H2 and `###` for H3. Ensure that headings are used in a hierarchical manner. Recommend restructuring if content includes H4, and more strongly recommend for H5.
- **Lists**: Use `-` for bullet points and `1.` for numbered lists. Indent nested lists with two spaces.
- **Code Blocks**: Use triple backticks (`) to create fenced code blocks. Specify the language after the opening backticks for syntax highlighting (e.g., `csharp).
- **Links**: Use `[link text](URL)` for links. Ensure that the link text is descriptive and the URL is valid.
- **Images**: Use `![alt text](image URL)` for images. Include a brief description of the image in the alt text.
- **Tables**: Use `|` to create tables. Ensure that columns are properly aligned and headers are included.
- **Line Length**: Break lines at 80 characters to improve readability. Use soft line breaks for long paragraphs.
- **Whitespace**: Use blank lines to separate sections and improve readability. Avoid excessive whitespace.

## Validation Requirements

Ensure compliance with the following validation requirements:

- **Front Matter**: Include the following fields in the YAML front matter:

  - `post_title`: The title of the post.
  - `author1`: The primary author of the post.
  - `post_slug`: The URL slug for the post.
  - `microsoft_alias`: The Microsoft alias of the author.
  - `featured_image`: The URL of the featured image.
  - `categories`: The categories for the post. These categories must be from the list in /categories.txt.
  - `tags`: The tags for the post.
  - `ai_note`: Indicate if AI was used in the creation of the post.
  - `summary`: A brief summary of the post. Recommend a summary based on the content when possible.
  - `post_date`: The publication date of the post.

- **Content Rules**: Ensure that the content follows the markdown content rules specified above.
- **Formatting**: Ensure that the content is properly formatted and structured according to the guidelines.
- **Validation**: Run the validation tools to check for compliance with the rules and guidelines.
description: "Documentation and content creation standards"
applyTo: "**/*.md"
---

## Mandatory Metadata Headers

**ALL markdown files MUST include YAML front matter with required metadata fields.**

### Critical Rule: Headers Required for ALL Operations

- **When CREATING a markdown file**: Add complete YAML front matter header immediately
- **When EDITING a markdown file**: Check for YAML front matter header first
  - If header exists: Update `updated_date` and `updated_time` fields
  - If header missing: Add complete YAML front matter header before making edits
  - Never edit a markdown file without ensuring it has proper metadata

**No exceptions**: Every markdown file operation must verify/add/update headers.

### Universal Metadata Fields (Required for ALL .md files)

```yaml
---
title: "Document Title"
type: "document_type" # One of: issue, adr, prd, epic, feature, task, research, guide, readme
created_date: "YYYY-MM-DD"
created_time: "HH:MM:SS TIMEZONE"
updated_date: "YYYY-MM-DD"
updated_time: "HH:MM:SS TIMEZONE"
author: "Author Name"
version: "semantic_version" # e.g., "1.0", "2.1", "1.0.3"
status: "document_status" # One of: draft, review, approved, implemented, deprecated
tags: ["tag1", "tag2", "tag3"]
---
```

### Document-Type Specific Metadata

#### Issues and Tasks

```yaml
---
issue_number: "3.1" # or GitHub issue number
parent_epic: "Database Architecture and Data Models"
priority: "P0" # P0-Critical, P1-High, P2-Medium, P3-Low
size: "M" # XS, S, M, L, XL
estimated_duration: "3-4 days"
dependencies: ["issue-3.0", "adr-0001"]
assignee: "team_member"
sprint: "sprint_name"
---
```

#### Architecture Decision Records (ADRs)

```yaml
---
adr_number: "0001"
decision_status: "Accepted" # Proposed, Accepted, Rejected, Superseded, Deprecated
supersedes: "adr-0000" # If applicable
superseded_by: "" # If applicable
stakeholders: ["architect", "team_lead"]
decision_date: "YYYY-MM-DD"
review_date: "YYYY-MM-DD" # When to review this decision
impact_level: "High" # Low, Medium, High, Critical
---
```

#### Product Requirements Documents (PRDs)

```yaml
---
feature_name: "Feature Name"
parent_epic: "Epic Name"
business_value: "High" # Low, Medium, High, Critical
technical_complexity: "Medium" # Low, Medium, High, Critical
target_release: "v1.2.0"
product_owner: "owner_name"
stakeholders: ["stakeholder1", "stakeholder2"]
success_metrics: ["metric1", "metric2"]
---
```

#### Epics

```yaml
---
epic_name: "Epic Name"
parent_epic: "Parent Epic Name" # If applicable
epic_size: "M" # XS, S, M, L, XL
estimated_duration: "3-4 weeks"
estimated_team_size: "2-3 developers"
business_value: "High"
technical_complexity: "Medium"
phase: "1" # Development phase
priority: "P0"
dependencies: ["dependency1", "dependency2"]
---
```

## Mandatory Reference Standards

**ALL markdown documents MUST include proper references to related artifacts.**

### Reference Format Requirements

#### Issue References

- **Format**: `Issue #3.1`, `GitHub Issue #123`, `Task T-456`
- **Link Format**: `[Issue #3.1](path/to/issue-3-1.md)`, `[GitHub Issue #123](https://github.com/repo/issues/123)`
- **Context Required**: Always explain why the issue is referenced

#### ADR References

- **Format**: `ADR-0001`, `Architecture Decision Record 0001`
- **Link Format**: `[ADR-0001: Database Architecture](docs/adr/adr-0001-database-architecture.md)`
- **Context Required**: Explain how the ADR influences the current document

#### PRD References

- **Format**: `PRD: Feature Name`, `Product Requirements Document`
- **Link Format**: `[PRD: CLI Foundation](docs/prds/cli-foundation-prd.md)`
- **Context Required**: Explain requirement relationship

#### Commit References

- **Format**: `Commit abc123f`, `Git Commit abc123f - Description`
- **Link Format**: `[Commit abc123f](https://github.com/repo/commit/abc123f)`
- **Context Required**: Explain what the commit accomplished

### Reference Sections (Required)

#### Related Documentation Section Example

```markdown
## Related Documentation

### Dependencies

- [ADR-0001: Database Architecture](../adr/adr-0001-database-architecture.md) - Database technology selection
- [Issue #3.0: Database Epic](../issues/issue-3-0.md) - Parent epic requirements

### References

- [PRD: CLI Foundation](../prds/cli-foundation.md) - Feature requirements
- [GitHub Issue #45](https://github.com/owner/repo/issues/45) - Original feature request

### Implementation Evidence

- [Commit abc123f](https://github.com/owner/repo/commit/abc123f) - Initial implementation
- [Commit def456g](https://github.com/owner/repo/commit/def456g) - Test coverage addition
```

#### Traceability Section Example

```markdown
## Traceability Matrix

| Requirement         | Source                         | Implementation                                             | Tests                               | Status      |
| ------------------- | ------------------------------ | ---------------------------------------------------------- | ----------------------------------- | ----------- |
| Database Connection | [ADR-0001](../adr/adr-0001.md) | [database_service.py](../src/services/database_service.py) | [test_db.py](../tests/test_db.py)   | ✅ Complete |
| CLI Interface       | [PRD: CLI](../prds/cli.md)     | [cli/main.py](../src/cli/main.py)                          | [test_cli.py](../tests/test_cli.py) | 🟡 Partial  |
```

## Enhanced Content Rules

### 1. Document Structure Standards

- **MUST** start with mandatory metadata header (check/add on EVERY edit)
- **MUST** update `updated_date` and `updated_time` when editing existing files
- **MUST** include Related Documentation section
- **SHOULD** include Traceability Matrix for implementation documents
- **MUST** use hierarchical headings (H2, H3 - no H1, avoid H4+)

### 1.1 Slides & Presentation Conventions (Pandoc + reveal.js)

- **Body Headings**: Use H2/H3 in body. The YAML title is the only H1. Slides are separated by H2 when building with `--slide-level 2`.
- **Ordering**: Name slide files with a numeric prefix (e.g., `00-abstract.md`, `01-introduction.md`, `02-main-content.md`, `03-conclusion.md`). Build in ascending order.
- **Incremental Lists**: Prefer fenced divs to stage bullets:
  - `::: incremental` … bullets … `:::`
- **Speaker Notes**: Include presenter notes using a notes block where applicable (for reveal.js notes). Keep notes concise and adjacent to the relevant slide.
- **Theming & Template**:
  - Use Pandoc variables to set theme and reveal.js location when building (e.g., `-V theme=black`, `-V revealjs-url=https://unpkg.com/reveal.js@5`).
  - Default HTML export template lives in `pandoc-templates/presentation-template.html`.
- **Title Slide Options**: When needed, set `title-slide-attributes` in metadata to control backgrounds and layout for the title slide.
- **Assets & Links**: Use relative paths. Place shared styles in `assets/styles.css`. Verify all images/diagrams exist.
- **Diagrams**: Prefer Mermaid sources in `diagrams/`. Inline Mermaid may require a Pandoc filter; otherwise render to image and link relatively.

Note: For slide sources, the "Related Documentation" and "Traceability Matrix" sections are recommended at the deck level (e.g., abstract, README, or a deck index), not per individual slide file.

### 2. Reference Integration Rules

- **Every claim MUST be backed by a reference** (issue, ADR, PRD, or commit)
- **Every decision MUST reference the deciding ADR**
- **Every requirement MUST link to source PRD or issue**
- **Every implementation claim MUST reference specific commits**

### 3. Cross-Reference Validation

- **Bidirectional Links**: If document A references document B, document B should acknowledge the relationship
- **Link Integrity**: All internal links must use relative paths and be verified
- **Reference Currency**: All references must be to current, non-deprecated documents

### 4. Metadata Consistency Rules

- **Dates**: Use ISO 8601 format (YYYY-MM-DD)
- **Times**: Use 24-hour format with timezone (HH:MM:SS TIMEZONE)
- **Versions**: Use semantic versioning (major.minor.patch)
- **Status Values**: Use standardized status vocabularies
- **Tags**: Use consistent tagging taxonomy across all documents
- **Updates**: Always update `updated_date` and `updated_time` when editing files

## Document Lifecycle Management

### Version Control Integration

```yaml
---
# Track document evolution
git_tracking:
  created_commit: "abc123f"
  last_updated_commit: "def456g"
  related_commits: ["ghi789h", "jkl012i"]
  created_by_pr: "45"
  last_updated_by_pr: "67"
---
```

### Status Progression

- **Draft** → **Review** → **Approved** → **Implemented** → **Deprecated**
- Each status change MUST be documented with date, author, and justification
- Status changes MUST reference the commit or PR that triggered the change

## Validation Requirements

### Pre-Edit Checks (MUST perform before ANY markdown edit)

- [ ] Check if YAML front matter exists
- [ ] If missing: Add complete YAML front matter before editing
- [ ] If present: Update `updated_date` and `updated_time` fields
- [ ] Verify all required metadata fields are populated

### Automated Checks (MUST pass)

- [ ] YAML front matter present and valid
- [ ] All required metadata fields populated
- [ ] `updated_date` reflects last modification date
- [ ] All internal links resolve correctly
- [ ] All referenced issues/ADRs/PRDs exist
- [ ] Reference format compliance
- [ ] Bidirectional reference consistency
- [ ] Slide files (under `slides/`) use only H2/H3 in body (no H1)
- [ ] Slide ordering follows numeric prefixes and builds with `--slide-level 2`
- [ ] Incremental fenced divs (`::: incremental`) are properly closed (if used)
- [ ] All assets referenced by slides exist (images, diagrams, CSS)
- [ ] For slide decks, deck-level document includes a Related Documentation section (README, abstract, or deck index)

### Content Quality Checks (SHOULD pass)

- [ ] Every claim has supporting reference
- [ ] Traceability matrix complete for implementation docs
- [ ] Related documentation section comprehensive
- [ ] Status and version information current
- [ ] Tags consistent with project taxonomy
- [ ] Slides are concise (one central idea per slide) and use speaker notes where helpful
- [ ] Theme and template usage consistent with repository defaults

### Cross-Document Validation (MUST pass)

- [ ] Referenced documents exist and are current
- [ ] Dependency chains are acyclic
- [ ] Status consistency across related documents
- [ ] Version compatibility verified

### Slides Build Example (Informative)

The following example illustrates a typical Pandoc invocation for reveal.js using repository conventions (use as reference; adapt as needed):

```bash
pandoc -t revealjs -s \
  --slide-level=2 \
  -V theme=black \
  -V revealjs-url=https://unpkg.com/reveal.js@5 \
  --template=pandoc-templates/presentation-template.html \
  -o dist/deck.html \
  slides/00-abstract.md slides/01-introduction.md slides/02-main-content.md slides/03-conclusion.md
```

### Issue Template Example

```markdown
---
title: "Issue #3.1: Database Infrastructure Setup"
type: "issue"
issue_number: "3.1"
parent_epic: "Database Architecture and Data Models"
created_date: "2025-08-14"
created_time: "09:30:00 CEST"
updated_date: "2025-08-14"
updated_time: "15:45:00 CEST"
author: "Development Team"
version: "1.2"
status: "approved"
priority: "P0"
size: "M"
estimated_duration: "3-4 days"
dependencies: ["adr-0001", "adr-0003"]
assignee: "backend_team"
tags: ["database", "infrastructure", "docker"]
---

# Issue #3.1: Database Infrastructure Setup

## Context

This issue implements the database infrastructure decisions from ADR-0001: Database Architecture and ADR-0003: Docker Compose Development.

## Related Documentation

### Dependencies

- ADR-0001: Database Architecture (../../docs/adr/adr-0001-database-architecture.md)
- Issue #3.0: Database Epic (./issue-3-0-database-epic.md)

### Implementation Evidence

- Commit abc123f: Add database service
- Commit def456g: Add Docker configuration
```

This enhanced standard ensures all markdown files have proper metadata and complete traceability throughout the project documentation.
