---
author: danieldekay
---

````chatagent
---
description: Analyze UI requirements and create frontend implementation plan with component mapping and integration points.
handoffs: 
  - label: Continue to Technical Plan
    agent: speckit.plan
    prompt: Continue with the technical plan using UI artifacts
    send: true
  - label: Create Tasks
    agent: speckit.tasks
    prompt: Generate tasks including UI components
    send: true
  - label: Clarify UI Requirements
    agent: speckit.clarify
    prompt: Clarify UI specification requirements
    send: true
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

This agent analyzes UI requirements from a feature specification and creates frontend implementation artifacts that integrate with existing JS/CSS/component libraries in the project.

1. **Setup**: Run `.specify/scripts/bash/check-prerequisites.sh --json` from repo root and parse FEATURE_DIR, FEATURE_SPEC, and AVAILABLE_DOCS list. All paths must be absolute.

2. **Load context**: Read from FEATURE_DIR:
   - **Required**: spec.md (user stories, acceptance scenarios)
   - **Optional**: plan.md (if exists, extract tech stack), research.md (decisions)
   
3. **Analyze existing frontend architecture**:
   - Search for existing CSS/SCSS files and extract design tokens (colors, spacing, typography)
   - Search for existing JavaScript/TypeScript files and identify component patterns
   - Identify UI frameworks in use (Bootstrap, Tailwind, Quasar, React, Vue, etc.)
   - Catalog existing reusable components
   - Map CSS class conventions and naming patterns
   - Identify existing form patterns, validation approaches
   - Note admin vs frontend separation if applicable

4. **Execute UI analysis workflow**: Follow the process defined in Phase 0-2 below.

5. **Generate UI artifacts** in FEATURE_DIR:
   - `ui-analysis.md` - UI requirements extracted from spec
   - `ui-components.md` - Component hierarchy and mapping
   - `ui-integration.md` - Integration points with existing code
   - Update plan.md with UI section (if plan.md exists)

6. **Report**: Output paths to generated artifacts and summary of:
   - Screens/views identified
   - New components needed vs existing components to reuse
   - CSS/styling approach
   - JavaScript functionality requirements
   - Integration complexity assessment

## Phase 0: UI Requirements Extraction

**Input**: spec.md (user stories, acceptance scenarios)

1. **Extract UI touchpoints from each user story**:
   - For each user story, identify:
     - User actions requiring UI (buttons, forms, selections)
     - Data displayed to user (lists, tables, cards, details)
     - Navigation flows between screens/views
     - Feedback mechanisms (success/error messages, progress indicators)
     - Input validation requirements

2. **Identify screens/views**:
   ```text
   For each user story:
     - What screen(s) does this story require?
     - What existing screens can be extended?
     - What new screens must be created?
   ```

3. **Extract UI acceptance criteria**:
   - Parse "Given/When/Then" scenarios for UI-specific behavior
   - Identify loading states, empty states, error states
   - Note accessibility requirements

4. **Generate `ui-analysis.md`** with:
   - Screen inventory (new and modified)
   - UI acceptance criteria per user story
   - Interaction patterns identified
   - State management requirements (forms, selections, loading)

**Output**: `ui-analysis.md`

## Phase 1: Frontend Architecture Analysis

**Input**: Existing project files, ui-analysis.md

1. **Scan project for frontend architecture**:
   
   a. **CSS/SCSS Analysis**:
      - Find all `.css`, `.scss`, `.sass` files
      - Extract color variables/custom properties
      - Identify spacing system (if any)
      - Note breakpoints for responsive design
      - Catalog utility classes available
      - Identify component-specific styles
   
   b. **JavaScript/TypeScript Analysis**:
      - Find all `.js`, `.ts`, `.jsx`, `.tsx`, `.vue` files
      - Identify UI framework (React, Vue, vanilla, jQuery, etc.)
      - Catalog existing components
      - Note state management approach (hooks, stores, etc.)
      - Identify API integration patterns
      - Map event handling patterns
   
   c. **Asset Analysis**:
      - Identify icon systems in use
      - Note image handling patterns
      - Find existing animation/transition patterns

2. **Map existing components to new requirements**:
   ```text
   For each UI element from ui-analysis.md:
     - Does a reusable component exist? → Reference it
     - Does a similar component exist? → Extend/modify
     - No match exists? → Mark as NEW
   ```

3. **Generate `ui-components.md`** with:
   - Component hierarchy diagram (ASCII or markdown)
   - Per-component specification:
     - Purpose and user story linkage
     - Props/inputs required
     - Events/outputs emitted
     - Existing component to reuse (if any)
     - New component needed (if any)
     - Styling approach
   - Component dependency tree

**Output**: `ui-components.md`

## Phase 2: Integration Planning

**Input**: ui-analysis.md, ui-components.md, existing codebase

1. **Map integration points**:
   
   a. **Backend Integration**:
      - REST API endpoints needed
      - GraphQL queries/mutations needed
      - Data transformation requirements
      - Error handling patterns to follow
   
   b. **Existing UI Integration**:
      - Navigation changes required
      - Shared state modifications
      - Existing component extensions
      - CSS file modifications
   
   c. **WordPress/CMS Integration** (if applicable):
      - Admin page registration
      - Meta box UI integration
      - Frontend template modifications
      - Script/style enqueuing

2. **Assess complexity**:
   - Count new files to create
   - Count existing files to modify
   - Identify high-risk changes
   - Note testing requirements

3. **Generate `ui-integration.md`** with:
   - File-by-file integration plan
   - API contracts needed (reference to contracts/ if exists)
   - Event flow diagrams
   - Risk assessment
   - Suggested implementation order

4. **Update plan.md** (if exists) with UI section:
   ```markdown
   ## UI Implementation
   
   ### Frontend Stack
   **Framework**: [identified from analysis]
   **CSS**: [identified from analysis]
   **Build**: [identified from analysis]
   
   ### Screens
   - [List screens from ui-analysis.md]
   
   ### New Components
   - [List from ui-components.md]
   
   ### Integration Points
   - [Summary from ui-integration.md]
   ```

**Output**: `ui-integration.md`, updated plan.md

## Key Rules

- Use absolute paths for all file references
- Preserve existing design patterns - don't suggest changes to established conventions
- Prefer extending existing components over creating new ones
- Reference specific files when suggesting modifications
- Include line numbers when referencing existing code patterns
- Mark unclear requirements with [NEEDS CLARIFICATION: specific question]
- ERROR if no spec.md exists in feature directory
- Respect project-specific coding standards (.github/instructions/*.instructions.md)

## WordPress-Specific Patterns (TMD Projects)

If project is WordPress-based, also analyze:

1. **Admin UI patterns**:
   - `@wordpress/components` usage
   - `@wordpress/element` (React) patterns
   - Meta Box form integration
   - Admin page structure

2. **Frontend patterns**:
   - Genesis hooks and templates
   - Bootstrap components
   - jQuery patterns
   - Enqueued script dependencies

3. **Asset management**:
   - `wp_enqueue_script` / `wp_enqueue_style` usage
   - Asset versioning
   - Conditional loading

## Quasar/Vue-Specific Patterns (TMD Quasar)

If project is Quasar-based, also analyze:

1. **Component patterns**:
   - Quasar component usage (Q-prefixed)
   - Composition API with `<script setup>`
   - Pinia store integration

2. **Page structure**:
   - Route configuration
   - Layout system
   - Navigation integration

3. **Styling**:
   - Quasar variables
   - SCSS organization
   - Responsive utilities

## Output Templates

### ui-analysis.md Template

```markdown
# UI Analysis: [FEATURE NAME]

**Feature**: `[###-feature-name]`
**Created**: [DATE]
**Spec**: [link to spec.md]

## Screens Inventory

### New Screens
| Screen | User Stories | Primary Purpose |
|--------|-------------|-----------------|
| [name] | US1, US2    | [purpose]       |

### Modified Screens
| Screen | User Stories | Modifications |
|--------|-------------|---------------|
| [name] | US3         | [changes]     |

## UI Requirements by User Story

### User Story 1: [Title]

**UI Touchpoints**:
- [action] → [component type]
- [display] → [component type]

**States Required**:
- Loading: [description]
- Empty: [description]
- Error: [description]
- Success: [description]

**Accessibility**:
- [requirement]

---

[Repeat for each user story]

## Interaction Patterns

### Form Handling
- [pattern identified]

### Data Display
- [pattern identified]

### Navigation
- [flow description]
```

### ui-components.md Template

```markdown
# UI Components: [FEATURE NAME]

**Feature**: `[###-feature-name]`
**Created**: [DATE]

## Component Hierarchy

```
[Screen/Page]
├── [Component 1]
│   ├── [Subcomponent]
│   └── [Subcomponent]
└── [Component 2]
```

## Existing Components to Reuse

| Component | Location | Usage in Feature |
|-----------|----------|------------------|
| [name]    | [path]   | [how used]       |

## New Components Required

### [ComponentName]

**Purpose**: [user story linkage]
**Type**: [page/container/presentational/form]
**Location**: [suggested file path]

**Props**:
| Name | Type | Required | Description |
|------|------|----------|-------------|
| [prop] | [type] | [yes/no] | [desc]   |

**Events**:
| Event | Payload | Description |
|-------|---------|-------------|
| [evt] | [type]  | [desc]      |

**Styling**:
- [approach, classes to use]

---

[Repeat for each new component]

## Component Dependencies

```
[Dependency graph or list]
```
```

### ui-integration.md Template

```markdown
# UI Integration Plan: [FEATURE NAME]

**Feature**: `[###-feature-name]`
**Created**: [DATE]

## Integration Summary

| Aspect | New | Modified | Risk |
|--------|-----|----------|------|
| JS/TS files | [n] | [n] | [L/M/H] |
| CSS/SCSS files | [n] | [n] | [L/M/H] |
| Templates | [n] | [n] | [L/M/H] |

## File-by-File Plan

### New Files

| File | Purpose | Dependencies |
|------|---------|--------------|
| [path] | [purpose] | [deps] |

### Modified Files

| File | Changes | Risk | Notes |
|------|---------|------|-------|
| [path] | [desc] | [L/M/H] | [notes] |

## API Integration

### Endpoints Required
| Endpoint | Method | Component | Notes |
|----------|--------|-----------|-------|
| [path]   | [GET/POST] | [component] | [notes] |

### Data Transformations
- [transformation needed]

## Event Flows

### [Flow Name]
```
[User Action] → [Component] → [API/Store] → [UI Update]
```

## Implementation Order

1. **Phase 1**: [foundational UI]
2. **Phase 2**: [user story N UI]
3. **Phase 3**: [user story N+1 UI]

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| [risk] | [impact] | [mitigation] |
```

````
