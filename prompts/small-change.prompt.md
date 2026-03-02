# Small Change Implementation Prompt

```yaml
agent: code-implementation
version: 1.0.0
project: tmd_core
purpose: Enforce pattern analysis and code reuse before implementing changes
```

## Mission

You WILL implement small code changes by first analyzing existing patterns, discovering reusable code, and following established architectural principles. You MUST analyze before implementing. You NEVER duplicate existing functionality or create new patterns when existing ones can be reused.

## Pre-Implementation Analysis (MANDATORY)

Before making ANY code change, you WILL complete these three steps:

### Step 1: Pattern Discovery

You MUST search for existing related code:

```bash
# Find similar implementations
semantic_search "query describing the feature"

# Find related files
file_search "**/*{relevant_pattern}*"

# Find specific patterns in code
grep_search "query: 'function_name|class_name|pattern'" isRegexp: true

# Find all usages of related code
list_code_usages symbolName "RelevantClass" filePaths ["/path/to/file.php"]
```

### Step 2: Code Reuse Hierarchy

You MUST follow this hierarchy when implementing:

1. **Existing Functions/Methods** - Use existing code if available
2. **Existing Traits** - Check `src/Traits/` for reusable trait code
3. **Helper Classes** - Check `src/Helpers/` for utility functions
4. **Shared Utilities** - Look in related manager classes
5. **Create New Code** - Only as last resort, following existing patterns

### Step 3: Architectural Compliance

You MUST verify compliance with constitution.md:

- **Principle XII**: Code Reusability & SOLID Principles
  - Don't duplicate functionality
  - Use dependency injection
  - Follow single responsibility principle
  
- **Principle XV**: Refactoring-First Development
  - Analyze existing code before changes
  - Identify improvement opportunities
  - Refactor duplicated patterns before adding new features

## Implementation Guidelines

### Code Reuse Patterns

**Example: Country Field Implementation**

❌ **WRONG - Hardcoded Data:**
```javascript
const countries = [
  { value: 'US', label: 'United States' },
  { value: 'DE', label: 'Germany' },
  // ... 200+ more countries
];
```

✅ **CORRECT - Reuse Existing Helper:**
```javascript
// 1. Find existing: grep_search "Countries::list"
// 2. Create API endpoint using existing helper
// 3. Fetch from API endpoint

// PHP: Create endpoint using existing helper
public function get_countries() {
    $countries = Countries::list(); // Reuse existing!
    return array_map(function($name, $code) {
        return ['value' => $code, 'label' => $name];
    }, $countries, array_keys($countries));
}

// JavaScript: Fetch from API
useEffect(() => {
    apiFetch({ path: '/tmd/v3/ics-import/countries' })
        .then(setCountryOptions);
}, []);
```

### Naming Conventions

You MUST follow existing naming patterns:

- **Meta Fields**: `tmd_{post_type}_{field_name}` (e.g., `tmd_dj_country`)
- **API Methods**: `get_{resource}`, `create_{resource}`, `update_{resource}`
- **Helper Methods**: Descriptive verbs (e.g., `normalize_country_code`)
- **React Components**: PascalCase (e.g., `EntityMatchSelector`)
- **Functions**: snake_case for PHP, camelCase for JavaScript

### File Structure Compliance

You MUST respect file size limits:

- **PHP Classes**: Maximum 500 lines
- **JavaScript Components**: Maximum 300 lines
- **If approaching limit**: Extract to traits, helpers, or separate components

You MUST check file size BEFORE adding code:

```bash
wc -l /path/to/file.php
```

If file is >450 lines, you MUST refactor before adding code.

## Quality Checklist

Before finalizing changes, verify:

- [ ] **Pattern Analysis**: Searched for existing similar code
- [ ] **Code Reuse**: Used existing functions/traits/helpers where possible
- [ ] **Naming Consistency**: Followed existing naming patterns
- [ ] **File Structure**: Respected file size limits and organization
- [ ] **Security**: Applied sanitization and escaping
- [ ] **Testing**: Verified functionality (manual or automated)
- [ ] **Documentation**: Updated relevant docs if needed
- [ ] **Build**: Run `npm run build` for JS changes
- [ ] **Quality**: Run `composer phpstan` for PHP changes

## Anti-Patterns to Avoid

You MUST NOT:

- ❌ Hardcode data that exists in helpers/constants
- ❌ Duplicate existing functionality in different files
- ❌ Create new patterns when existing patterns work
- ❌ Ignore file size limits and keep adding to large files
- ❌ Skip pattern analysis step
- ❌ Add features without checking related code first
- ❌ Create new helper classes without checking `src/Helpers/`
- ❌ Create new traits without checking `src/Traits/`

## Refactoring Before Implementing

If you discover during pattern analysis:

- **Duplicated Code**: Refactor to shared location FIRST, then implement feature
- **Large Files**: Extract components/traits FIRST, then add new code
- **Outdated Patterns**: Update to current standards FIRST, then implement
- **Missing Abstractions**: Create trait/helper FIRST, then use it

**Example Refactoring Workflow:**

```
1. User requests: "Add venue timezone field"
2. Pattern analysis finds: Similar timezone handling in Events
3. Refactor FIRST: Extract timezone logic to Trait
4. Implement SECOND: Use trait in Venue CPT
```

## Constitution Reference

This prompt enforces:

- **Principle XII**: Code Reusability & SOLID Principles
  - Located: `.specify/memory/constitution.md` lines 435-490
  - Requires: Reuse existing code, follow DRY principle
  
- **Principle XV**: Refactoring-First Development
  - Located: `.specify/memory/constitution.md` lines 575-615
  - Requires: Analyze existing code, refactor before new features

## Examples from Recent Work

### Example 1: DJ Country Field

**Request**: "make a country autocomplete field"

**Analysis Process:**
```bash
# Step 1: Search for existing country code
grep_search "query: 'Countries::list|country|iso'" isRegexp: true

# Step 2: Found existing helper
# Result: src/Helpers/Countries.php with ISO 3166-1 alpha-2 codes

# Step 3: Reuse instead of hardcode
# Created API endpoint using existing helper
# Frontend fetches from API
```

**Outcome**: Reused 200+ countries from existing helper instead of hardcoding.

### Example 2: API Endpoint Pattern

**Request**: "Create countries endpoint"

**Analysis Process:**
```bash
# Step 1: Find similar endpoints
grep_search "query: 'register_rest_route.*ics-import'" isRegexp: true

# Step 2: Found existing pattern in register_routes()
# Pattern: GET endpoints with callback methods

# Step 3: Follow existing pattern
# Added route following same structure as other GET endpoints
```

**Outcome**: Consistent API patterns across controller.

### Example 3: Avoiding Duplicate Methods

**Issue**: Fatal error - duplicate `create_entity()` method

**Resolution Process:**
```bash
# Step 1: Locate duplicates
grep -n "function create_entity" ICSImportController.php
# Found: lines 1924 and 2177

# Step 2: Compare implementations
# Line 1924: Original with proper field handling
# Line 2177: Duplicate copy (~250 lines)

# Step 3: Remove duplicate, keep original
# Deleted lines 2170-2417
```

**Outcome**: Single source of truth, proper DJ field handling preserved.

## Success Criteria

A successful implementation:

1. **Uses existing code** where possible
2. **Follows established patterns** from codebase
3. **Respects file structure** and size limits
4. **Complies with constitution.md** principles
5. **Passes quality checks** (phpstan, build)
6. **Documented decisions** when choosing between approaches

## Workflow Summary

```
Request → Analyze Patterns → Check Reuse Options → Refactor if Needed → Implement → Test → Quality Check
```

**Time Investment:**
- Analysis: 30% of time
- Implementation: 50% of time
- Testing/Quality: 20% of time

**This prompt ensures**: Quality through analysis, consistency through reuse, maintainability through refactoring.
