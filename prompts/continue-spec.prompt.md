---
description: Continue implementing a spec-kit feature with strict adherence to workflow, quality standards, and progress tracking
---

# Continue Spec Implementation

## Context Reload

You are continuing implementation of a spec-kit feature. Before proceeding, you MUST refresh your context and verify the current state.

## User Request

```text
$ARGUMENTS
```

## Mandatory Workflow Steps

### 1. Load Current State (REQUIRED)

**Run prerequisite check:**

```bash
.specify/scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks
```

This provides:

- `FEATURE_DIR`: Absolute path to current spec directory
- `AVAILABLE_DOCS`: List of available specification documents

**If this fails**: STOP and report what's missing. Do not proceed.

### 2. Review Task Progress (REQUIRED)

**Scan tasks.md to determine current state:**

1. Count completed tasks: `grep "^\- \[x\]" tasks.md | wc -l`
2. Identify last completed task by ID
3. Identify next pending task(s)
4. Note any parallel tasks `[P]` that can run together
5. Check which phase you're in (Setup/Foundational/User Story)

**Report to user:**

```
📊 Current Progress:
- Phase: [Phase name]
- Completed: X/Y tasks (Z%)
- Last completed: [Task ID] [Description]
- Next pending: [Task ID] [Description]
- Parallel opportunities: [List any [P] tasks that can run together]
```

### 3. Verify Implementation Context (REQUIRED)

**Load or refresh these documents:**

**Always read:**

- `tasks.md` - Complete task list and execution order
- `plan.md` - Architecture, tech stack, file structure

**Read if you haven't yet or if they've changed:**

- `data-model.md` - Entity relationships (if exists)
- `contracts/` - API specs and test contracts (if exists)
- `research.md` - Technical decisions and constraints (if exists)

### 4. Check Checklists (if applicable)

**If `{FEATURE_DIR}/checklists/` exists:**

1. Scan all checklist files
2. Count incomplete items `- [ ]`
3. **If ANY incomplete:**
   - Display status table
   - Ask user: "Some checklists incomplete. Proceed? (yes/no)"
   - WAIT for response
4. **If all complete:** Proceed automatically

### 5. Resume Implementation

**Follow the spec-kit implementation workflow:**

#### Quality Standards (NON-NEGOTIABLE)

**Clean Architecture Layers:**

```
domain/          # Pure business logic, zero framework imports
  entities/      # Pydantic models, value objects
  services/      # Domain validation, business rules
use_cases/       # Application orchestration (imports domain only)
adapters/        # External interfaces (no infrastructure imports)
  parsers/       # Input adapters
  generators/    # Output adapters
infrastructure/  # Framework, CLI, I/O, external services
  cli/           # Click/Typer commands
  file_io/       # File operations
```

**SOLID Principles:**

- **S**ingle Responsibility: One reason to change per class/function
- **O**pen/Closed: Extend behavior via composition, not modification
- **L**iskov Substitution: Subtypes must be fully substitutable
- **I**nterface Segregation: Small, focused interfaces
- **D**ependency Inversion: Depend on abstractions, not implementations

**Code Quality Metrics:**

- ✅ Functions ≤ 20 lines (prefer ≤ 15)
- ✅ Cyclomatic complexity ≤ 10
- ✅ Test coverage ≥ 80%
- ✅ Type hints on ALL function signatures
- ✅ Docstrings explain WHY, not WHAT
- ✅ Self-documenting variable/function names
- ✅ No code duplication (DRY)
- ✅ Ruff linting passes (no violations)

**TDD Workflow (MANDATORY):**

For each task marked as a test:

1. **Write test first** (should fail correctly)
2. **Run test** to verify red state
3. **Write minimal implementation** to pass
4. **Run test** to verify green state
5. **Refactor** while keeping tests green
6. **Mark task [x]** in tasks.md

For implementation tasks with existing tests:

1. **Run existing tests** (should fail)
2. **Implement minimal code** to pass
3. **Verify tests pass**
4. **Refactor** for quality
5. **Mark task [x]** in tasks.md

#### Task Execution Rules

**Sequential Tasks:**

- Execute in order listed in tasks.md
- Complete one before starting next
- Verify each step before proceeding

**Parallel Tasks [P]:**

- Can run simultaneously if:
  - Different files
  - No shared dependencies
  - Both marked `[P]`
- Ask user: "Tasks TX and TY can run parallel. Execute both?"

**Task Dependencies:**

- Foundational phase BLOCKS all user stories
- Architecture tests run before implementation
- Domain entities before use cases
- Use cases before adapters
- Adapters before infrastructure
- Unit tests before integration tests

#### Progress Tracking (CRITICAL)

**After EVERY completed task, you MUST:**

1. ✅ **Mark task [x] in tasks.md** - NO EXCEPTIONS
2. ✅ Run relevant tests to verify completion
3. ✅ Check `problems` panel for errors
4. ✅ Report status: "✅ TX complete - [brief description]"
5. ✅ Move to next task or report completion

**Use TODO tool for complex work (5+ tasks in a row):**

```markdown
## Current Implementation Plan

- [x] T026 Architecture test: use case dependencies
- [x] T027 Architecture test: adapter boundaries
- [ ] T028 Create markdown schema documentation
- [ ] T029 Implement MarkdownParser adapter
- [ ] T030 Implement LSSGenerator adapter
```

Update TODO:

- Mark as `in-progress` BEFORE starting
- Mark as `completed` IMMEDIATELY after finishing
- Keep only ONE task `in-progress` at a time

### 6. Validation and Error Handling

**Before marking phase complete:**

- [ ] All phase tasks marked `[x]` in tasks.md
- [ ] All tests pass (`runTests`)
- [ ] No errors in `problems` panel
- [ ] Code quality standards met (run ruff)
- [ ] Architecture boundaries verified
- [ ] Implementation matches spec

**If error encountered:**

```
❌ Task TX failed:
- Error: [Specific error message]
- Location: [File and line]
- Context: [What you were doing]

Suggested fix:
- [Specific action to resolve]
- [Why this should work]

Waiting for guidance...
```

**STOP and wait for user input.** Do not proceed with other tasks.

### 7. Tools You Must Use

**Investigation:**

- `codebase` - Search for relevant code
- `search` - Find patterns across workspace
- `usages` - Find where symbols are used

**Testing:**

- `runTests` - Execute test suite
- `testFailure` - Analyze test failures
- `problems` - Check for errors/warnings

**Implementation:**

- `edit/editFiles` - Modify code files
- `new` - Create new files
- `pylance` - Run Python code snippets

**Validation:**

- `runCommands` - Run ruff, pytest, type checks
- `changes` - Review modifications
- `git_add_or_commit` - Commit completed phases

**Planning:**

- `think` - Analyze complex decisions
- `todos` - Track multi-step work

### 8. Communication Protocol

**Be concise and transparent:**

✅ **Good:**

```
🎯 Starting T029: Implement MarkdownParser

Actions:
1. Create src/limesurvey/adapters/parsers/markdown_parser.py
2. Implement parse_yaml() method
3. Add error handling for invalid YAML

[implements code]

✅ T029 complete. Tests pass. Marked [x] in tasks.md.
Moving to T030...
```

❌ **Bad:**

```
I'll work on the markdown parser now. This is an important component that will parse markdown files and extract YAML frontmatter using the yaml library. Let me think about the best approach...

[long explanation without action]
```

**Status updates:**

- Report what you're doing (1 line)
- Execute actions
- Report completion (1 line)
- Move to next task

**Don't:**

- Explain what you're about to do at length
- Ask permission for standard workflow steps
- Repeat information from specs
- Provide summaries unless requested

### 9. Quality Checkpoints

**After each task:**

```bash
# Run linting
ruff check src/

# Run type checking
pyright src/

# Run tests
pytest tests/ -v

# Check coverage
pytest tests/ --cov=src --cov-report=term-missing
```

**If any fail:** Fix before proceeding to next task.

### 10. Completion Criteria

**You're done with current session when:**

1. ✅ All requested tasks completed and marked `[x]`
2. ✅ All tests passing
3. ✅ No linting/type errors
4. ✅ Code quality metrics met
5. ✅ User explicitly says "stop" or "that's enough"

**Final report:**

```
✅ Implementation Session Complete

Completed:
- Tasks: TX, TY, TZ (3 total)
- Tests: All passing (coverage: 87%)
- Quality: No violations

Phase Status:
- Setup: 10/10 ✅
- Foundational: 15/15 ✅
- User Story 1: 8/12 (67%)

Next Steps:
- Continue with T031: Implement ConvertMarkdownUseCase
- Then T032-T034: Unit tests for markdown conversion
```

## Key Reminders

1. **ALWAYS check tasks.md first** - Know where you are
2. **ALWAYS mark tasks [x] immediately** - Track progress religiously
3. **NEVER skip tests** - TDD is mandatory
4. **NEVER violate architecture** - Domain stays pure
5. **ALWAYS use type hints** - Explicit types required
6. **ALWAYS run quality checks** - Ruff, pyright, pytest
7. **ALWAYS commit after phase completion** - Save progress
8. **BE CONCISE** - Actions over explanations

## Anti-Patterns to Avoid

❌ **Don't:**

- Start coding without checking tasks.md state
- Complete tasks without marking [x]
- Skip prerequisite checks
- Ignore checklist validation
- Write implementation before tests (when test task exists)
- Put framework code in domain layer
- Skip type hints "for now"
- Commit code with failing tests
- Explain what you're about to do instead of doing it

✅ **Do:**

- Check current state first
- Mark progress immediately
- Follow TDD workflow strictly
- Respect architecture boundaries
- Add type hints to everything
- Run quality checks after each task
- Report concisely and move forward

## Success Metrics

You succeed when:

- ✅ All tasks in tasks.md checked `[x]`
- ✅ Progress accurately tracked
- ✅ All tests green
- ✅ No quality violations
- ✅ Clean architecture maintained
- ✅ Implementation matches spec
- ✅ Code is self-documenting and maintainable

---

**Now proceed with continuing the implementation. Start with step 1 (prerequisite check).**
