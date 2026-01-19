---
description: 'Reusable prompt for running, analyzing, and fixing tests following Uncle Bob FIRST principles and TangoAtlas standards'
version: '1.0.0'
date: '2026-01-08'
---

# Test Fix Prompt

## Context

You WILL analyze and fix test failures in the TangoAtlas project, following Uncle Bob's FIRST principles, Clean Architecture boundaries, and high-quality test standards. You WILL focus on fixing real issues in application code, NOT working around framework behavior or adding superficial fixes.

## Core Principles

### Uncle Bob's FIRST Principles (NON-NEGOTIABLE)

You MUST ensure all tests adhere to:

- **F**ast: Unit tests run in milliseconds, integration tests in seconds
- **I**ndependent: No test depends on another; order doesn't matter
- **R**epeatable: Same results in any environment (dev, CI, production)
- **S**elf-validating: Boolean pass/fail; no manual inspection needed
- **T**imely: Tests written BEFORE implementation code (TDD)

### Test Quality Standards (NON-NEGOTIABLE)

You WILL maintain these standards:

- **Test Application Logic Only**: NEVER test framework code (Django ORM, DRF serializers, pytest itself)
- **No Hacks or Shims**: Fixes MUST address real issues, not bypass them with mocks that don't add value
- **Meaningful Assertions**: Every assertion MUST verify actual business logic or requirements
- **Reflect Specifications**: Tests MUST validate requirements documented in `.specify/specs/`
- **Clean Architecture Boundaries**: Tests MUST respect layer separation (domain tests have ZERO Django imports)

## Test Structure Overview

```
tests/
├── unit/               # Fast, isolated tests (NO database, NO framework)
│   ├── domain/         # Pure Python: 100% coverage target
│   └── application/    # Mocked dependencies: 100% coverage target
├── integration/        # Real database, real infrastructure
│   ├── repositories/   # Django ORM, repository implementations
│   ├── presentation/   # Views, serializers, API endpoints
│   └── geodata/        # External services (with proper isolation)
└── contract/          # API contracts, Playwright browser tests
```

### Coverage Requirements

| Layer | Coverage Target | Tool | Command |
|-------|----------------|------|----------|
| Domain | 100% | pytest | `./run.sh test-domain` |
| Application | 100% | pytest | `./run.sh test-application` |
| Unit Combined | ≥95% | pytest | `./run.sh test-unit` |
| Integration | ≥95% | pytest-django | `./run.sh test` |
| Mutation (domain) | ≥80% | mutmut | `uv run mutmut run` |
| Browser (UI) | All features | Playwright | `uv run pytest tests/contract/` |

## Execution Process

### Phase 1: Run Tests and Gather Information

You WILL execute tests in this order:

1. **Run all tests with verbose output**:

   ```bash
   uv run pytest -v --tb=short
   ```

2. **Analyze output and categorize issues**:
   - **ERRORS**: Test collection failures, import errors, setup failures
   - **FAILURES**: Assertion failures, unexpected exceptions
   - **WARNINGS**: Deprecation warnings, pytest warnings

3. **Gather context for failures**:
   - Read failing test files
   - Read tested code (domain/application/infrastructure/presentation)
   - Read related specification files in `.specify/specs/`
   - Check recent changes with `get_changed_files`

### Phase 2: Fix Errors (First Priority)

You WILL address test collection errors and setup failures:

**Common Error Types**:

- **Import errors**: Missing dependencies, circular imports, incorrect paths
- **Fixture errors**: Missing fixtures, incorrect fixture scope
- **Setup errors**: Database not configured, migrations not run

**Fix Strategy**:

1. Verify imports follow Clean Architecture rules (`uv run lint-imports`)
2. Check fixture definitions in `tests/conftest.py` and test-local files
3. Ensure test database is properly configured (`@pytest.mark.django_db` for integration tests)
4. Validate test file paths mirror source structure

**You WILL NEVER**:

- Add Django imports to domain layer tests
- Skip error investigation with `pytest.skip()` without documented reason
- Create global mocks that hide architectural violations

### Phase 3: Fix Failures (Second Priority)

You WILL fix assertion failures and test logic issues:

**Failure Analysis Checklist**:

1. **Is this testing application logic or framework behavior?**
   - ✅ Application logic: Fix the issue
   - ❌ Framework behavior: Remove or refactor test

2. **Does the test reflect current specifications?**
   - ✅ Spec exists and current: Fix implementation or test logic
   - ❌ Spec outdated: Document assumption, update test, flag for spec update
   - ❌ Spec missing: Document expected behavior in test docstring, flag for spec creation

3. **Is the test properly isolated?**
   - ✅ Unit test: Uses fixtures, NO database/external services
   - ✅ Integration test: Uses `@pytest.mark.django_db`, real infrastructure
   - ❌ Mixed: Refactor to proper test type

4. **Are assertions meaningful?**
   - ✅ Validates business rules, domain logic, API contracts
   - ❌ Tests `assert True`, `assert obj is not None` without business meaning

**Test Type Decision Tree**:

```
Is database/external service needed to test this?
├─ NO → Unit Test (tests/unit/)
│   ├─ Tests domain entity? → tests/unit/domain/
│   │   - Pure Python only
│   │   - Use fixtures for test data
│   │   - ZERO Django/DRF imports
│   └─ Tests application service? → tests/unit/application/
│       - Mock repository interfaces (Protocol)
│       - Test orchestration logic only
│       - No real database/cache/external APIs
└─ YES → Integration Test (tests/integration/)
    ├─ Use @pytest.mark.django_db
    ├─ Test repository implementations
    └─ Test API endpoints with Django test client
```

**Fix Strategy by Test Type**:

#### Domain Layer Tests (Pure Python)

```python
# ✅ CORRECT - Pure Python, tests business logic
from tangoatlas.domain.auth.user import User
from tangoatlas.domain.auth.value_objects import UserId, Role

def test_admin_can_approve_submissions() -> None:
    """Admin users can approve any submission."""
    admin = User(
        id=UserId("admin-1"),
        username="admin",
        role=Role.ADMIN,
        is_active=True
    )
    assert admin.can_approve_submissions()

# ❌ WRONG - Django imports in domain test
from django.test import TestCase  # FORBIDDEN
from tangoatlas.infrastructure.django.models import UserModel  # FORBIDDEN
```

#### Application Layer Tests (Mocked Dependencies)

```python
# ✅ CORRECT - Mocked repository interface
from unittest.mock import Mock
from tangoatlas.application.links.submit_link_service import SubmitLinkService

def test_submit_link_creates_pending_link(mocker: MockerFixture) -> None:
    """Submitting a link creates pending link via repository."""
    mock_repo = Mock()
    service = SubmitLinkService(link_repository=mock_repo)

    link = service.submit(url="https://example.com", title="Test")

    assert link.status == ApprovalStatus.PENDING
    mock_repo.save.assert_called_once()

# ❌ WRONG - Real database in application test
@pytest.mark.django_db  # Should be integration test
def test_submit_link(self) -> None:
    ...
```

#### Integration Tests (Real Infrastructure)

```python
# ✅ CORRECT - Tests Django ORM implementation
@pytest.mark.django_db
class TestDjangoLinkRepository:
    """Integration tests for Django link repository."""

    def test_save_and_retrieve_link(self) -> None:
        """Link can be saved and retrieved from database."""
        repo = DjangoLinkRepository()
        link = Link(...)

        repo.save(link)
        retrieved = repo.get_by_id(link.id)

        assert retrieved == link

# ❌ WRONG - Testing Django's ORM behavior
@pytest.mark.django_db
def test_django_save_method_works() -> None:
    """Django save() method saves to database."""  # NOT application logic
    model = LinkModel(...)
    model.save()
    assert LinkModel.objects.count() == 1  # Testing Django, not our code
```

**You WILL NEVER**:

- Add `try/except` blocks to make tests pass without fixing root cause
- Mock entire classes when only specific methods are needed
- Skip tests with `pytest.skip()` without architectural reason
- Change production code to make bad tests pass

### Phase 4: Run Mutation Tests (Domain Layer)

You SHOULD run mutation tests for critical domain logic after unit tests pass:

**When to Run Mutation Tests**:

- Domain entities with complex business rules
- Value objects with validation logic
- After fixing domain layer test failures
- Before marking domain features as complete

**Command**:

```bash
# Run mutation tests on specific domain file
uv run mutmut run --paths-to-mutate=src/tangoatlas/domain/entities/link.py

# View results
uv run mutmut results

# Show surviving mutants
uv run mutmut show

# Generate HTML report
uv run mutmut html
```

**Interpreting Results**:

- **Target**: ≥80% mutation score
- **Killed**: Test caught the mutation (good)
- **Survived**: Mutation didn't break tests (missing test coverage)
- **Timeout**: Mutation caused infinite loop (review code)

**Fixing Surviving Mutants**:

1. **Read the mutant**: `uv run mutmut show <id>`
2. **Identify gap**: What business rule isn't tested?
3. **Add test**: Write test that would fail with this mutation
4. **Re-run**: Verify mutant is now killed

Example:

```python
# Original: if user.age >= 18:
# Mutant: if user.age > 18:  # Changed >= to >
# Fix: Add test for exactly age 18

def test_user_age_18_is_adult() -> None:
    """User at exactly 18 years old is considered adult."""
    user = User(age=18)
    assert user.is_adult() is True  # Would fail with > mutation
```

**You WILL SKIP mutation testing if**:

- Time constraints exist (document as technical debt)
- Code is infrastructure/presentation layer (mutation testing is for domain logic)

### Phase 5: Fix Warnings (Fourth Priority)

You WILL address deprecation and pytest warnings:

**Common Warning Types**:

- **DeprecationWarnings**: Update to current Django/Python/library APIs
- **PytestUnknownMarkWarning**: Register custom marks in `pyproject.toml`
- **PytestCollectionWarning**: Fix test discovery issues

**Fix Strategy**:

1. Read warning message and documentation for replacement API
2. Update code to use current API (consult official docs)
3. For custom pytest marks, register in `pyproject.toml`:

   ```toml
   [tool.pytest.ini_options]
   markers = [
       "slow: marks tests as slow (deselect with '-m \"not slow\"')",
       "integration: integration tests requiring database",
   ]
   ```

### Phase 5.5: Debug Integration Tests (If Applicable)

You WILL address integration test-specific issues:

**Integration Test Characteristics**:

- Located in `tests/integration/` (NOT `tests/unit/`)
- Use `@pytest.mark.django_db` decorator
- Test against REAL PostgreSQL database (NOT SQLite, NOT mocks)
- Verify database state after operations
- Use Django test client for API endpoint tests

**Common Integration Test Issues**:

#### IT-001: Database Connection Refused

**Symptoms**: `psycopg.OperationalError: connection refused`

**Diagnosis**:

```bash
# Check PostgreSQL is running
pg_isready -U dekay

# Check test settings loaded
echo $DJANGO_SETTINGS_MODULE  # Should be tangoatlas.config.settings_test
```

**Fix**:

1. Start PostgreSQL: `brew services start postgresql@16` (macOS)
2. Verify settings_test.py exists and is properly configured
3. Check database credentials in settings_test.py match running PostgreSQL

#### IT-002: Test Database Not Auto-Created

**Symptoms**: `django.db.utils.OperationalError: database "test_tangoatlas" does not exist`

**Diagnosis**:

```bash
# Check pytest-django configured
grep -A 5 "\[tool.pytest.ini_options\]" pyproject.toml

# Verify DJANGO_SETTINGS_MODULE set
grep DJANGO_SETTINGS_MODULE pyproject.toml
```

**Fix**:

1. Ensure pyproject.toml has `DJANGO_SETTINGS_MODULE = "tangoatlas.config.settings_test"`
2. Add `--create-db` flag to pytest command
3. Verify test user has CREATE DATABASE permission

#### IT-003: Data Leakage Between Tests

**Symptoms**: Test passes alone but fails when run with other tests

**Diagnosis**:

```bash
# Run test in isolation
uv run pytest tests/integration/infrastructure/test_link_repository.py::test_save_link -v

# Run with other tests
uv run pytest tests/integration/infrastructure/ -v
```

**Fix**:

1. Ensure ALL integration tests use `@pytest.mark.django_db`
2. Remove `@pytest.fixture(scope="session")` for data fixtures (use function scope)
3. Verify no tests commit transactions explicitly
4. Check for leftover test data from previous runs:

   ```python
   # BAD: Assumes clean database
   def test_count_links():
       assert LinkModel.objects.count() == 0  # Fails if data exists

   # GOOD: Creates and counts specific data
   def test_count_links():
       LinkModel.objects.create(url="https://test.com", title="Test")
       assert LinkModel.objects.filter(url="https://test.com").count() == 1
   ```

#### IT-004: Fixture Not Found

**Symptoms**: `fixture 'authenticated_client' not found`

**Diagnosis**:

```bash
# Check conftest.py locations
find tests/integration -name conftest.py

# Verify fixture defined
grep -n "def authenticated_client" tests/integration/conftest.py
```

**Fix**:

1. Create `tests/integration/conftest.py` if missing
2. Define shared fixtures (`authenticated_client`, `admin_client`) in shared conftest.py
3. Import fixtures explicitly if needed: `from ..conftest import authenticated_client`

#### IT-005: Repository Test Mocking Database (Anti-Pattern)

**Symptoms**: Repository test uses `@patch` for database operations

**Diagnosis**:

```python
# ANTI-PATTERN: Mocking database in integration test
@pytest.mark.django_db
@patch("tangoatlas.infrastructure.django.links.models.LinkModel.objects.create")
def test_repository_save(mock_create):
    mock_create.return_value = Mock()
    # This is NOT testing real database behavior!
```

**Fix**: Remove mocks, use REAL database

```python
# CORRECT: Test against real database
@pytest.mark.django_db
def test_repository_save(link_repository):
    link = Link(url="https://example.com", title="Test")
    link_repository.save(link)

    # Verify ACTUAL database state
    saved = LinkModel.objects.get(url="https://example.com")
    assert saved.title == "Test"
```

**Remember**: "Mocks test assumptions, real databases test reality"

#### IT-006: API Test Not Verifying Database Side Effects

**Symptoms**: API test only checks response status, not database changes

**Diagnosis**:

```python
# INCOMPLETE: Only checks response
@pytest.mark.django_db
def test_submit_link(authenticated_client):
    response = authenticated_client.post("/api/links/", {...})
    assert response.status_code == 201
    # Missing: Did link actually save to database?
```

**Fix**: Always verify database state

```python
# COMPLETE: Checks response AND database
@pytest.mark.django_db
def test_submit_link(authenticated_client):
    response = authenticated_client.post("/api/links/", {
        "url": "https://example.com",
        "title": "Test Link"
    }, content_type="application/json")

    # Verify response
    assert response.status_code == 201
    assert response.data["status"] == "pending"

    # Verify database side effect
    link = LinkModel.objects.get(url="https://example.com")
    assert link.status == "pending"
    assert link.title == "Test Link"
```

### Phase 6: Validate Fixes

You WILL verify fixes are complete and proper:

1. **Run tests again with coverage**:

   ```bash
   uv run pytest --cov=src/tangoatlas --cov-report=term --cov-report=html
   ```

2. **Verify Clean Architecture boundaries**:

   ```bash
   uv run lint-imports
   ```

3. **Check type safety**:

   ```bash
   uv run pyright
   ```

4. **Confirm coverage targets**:
   - Domain: 100% (`./run.sh test-domain`)
   - Application: 100% (`./run.sh test-application`)
   - Unit combined: ≥95% (`./run.sh test-unit`)
   - Overall: ≥95% (`./run.sh coverage`)

5. **Run specific test suites**:

   ```bash
   # Layer-specific with coverage enforcement
   ./run.sh test-domain                     # Domain: 100% required
   ./run.sh test-application                # Application: 100% required
   ./run.sh test-unit                       # Both: ≥95% required

   # Without coverage enforcement
   uv run pytest tests/unit/domain/ -v      # Domain layer
   uv run pytest tests/unit/application/ -v # Application layer
   uv run pytest tests/integration/ -v      # Integration layer
   ```

## Anti-Patterns to AVOID

### ❌ Testing Framework Code

```python
# ❌ WRONG - Testing Django's validation
def test_model_validates_required_fields() -> None:
    """Model raises ValidationError for missing required fields."""
    with pytest.raises(ValidationError):
        LinkModel().full_clean()  # Testing Django, not our code

# ✅ CORRECT - Testing our domain validation
def test_link_requires_url() -> None:
    """Link entity validates URL is required."""
    with pytest.raises(InvalidLinkError, match="URL is required"):
        Link(url=None, title="Test")  # Testing our business rule
```

### ❌ Superficial Mocks

```python
# ❌ WRONG - Mock that doesn't test anything
def test_service_calls_repository(mocker: MockerFixture) -> None:
    """Service calls repository save method."""
    mock_repo = mocker.Mock()
    service = LinkService(repository=mock_repo)

    service.submit_link(...)

    mock_repo.save.assert_called()  # So what? Doesn't test business logic

# ✅ CORRECT - Test actual business logic
def test_submit_link_sets_pending_status() -> None:
    """Submitted links default to PENDING approval status."""
    mock_repo = Mock()
    service = LinkService(repository=mock_repo)

    result = service.submit_link(url="https://example.com", title="Test")

    assert result.approval_status == ApprovalStatus.PENDING  # Business rule verified
    saved_link = mock_repo.save.call_args[0][0]
    assert saved_link.approval_status == ApprovalStatus.PENDING
```

### ❌ Order-Dependent Tests

```python
# ❌ WRONG - Test depends on execution order
def test_create_user() -> None:
    user = User.create(username="test")
    assert user.id is not None

def test_find_user() -> None:
    user = User.find_by_username("test")  # Depends on previous test
    assert user is not None

# ✅ CORRECT - Independent tests with fixtures
@pytest.fixture
def created_user() -> User:
    """Create user for testing."""
    return User.create(username="test")

def test_find_user(created_user: User) -> None:
    """User can be found by username."""
    user = User.find_by_username(created_user.username)
    assert user == created_user
```

### ❌ Slow Unit Tests

```python
# ❌ WRONG - Unit test hitting database
def test_validate_email() -> None:
    """Email validation works correctly."""
    user = User.objects.create(email="test@example.com")  # Database call in unit test
    assert user.email == "test@example.com"

# ✅ CORRECT - Pure Python validation
def test_validate_email() -> None:
    """Email value object validates format."""
    email = Email("test@example.com")  # Pure Python
    assert email.value == "test@example.com"

    with pytest.raises(InvalidEmailError):
        Email("invalid-email")  # Tests validation logic
```

## Reporting Format

You WILL provide clear, actionable reports:

### After Each Phase

```markdown
## Phase N: [Phase Name] - [Status]

### Summary
- [X] errors fixed
- [Y] failures fixed
- [Z] warnings fixed

### Issues Addressed
1. **[Test Name]** - [Issue Type]
   - **Problem**: [Clear description of failure]
   - **Root Cause**: [Why it failed]
   - **Fix**: [What was changed]
   - **Validation**: [How fix was verified]

### Remaining Issues
- [Issue 1]: [Brief description]
- [Issue 2]: [Brief description]
```

### Final Report

```markdown
## Test Fix Summary - [Date]

### Results
- ✅ All tests passing: [X passed / X total]
- ✅ Coverage: [X]% (target: ≥95%)
- ✅ Architecture boundaries: PASSING
- ✅ Type checking: PASSING

### Changes Made
- Fixed [X] errors (imports, setup, fixtures)
- Fixed [Y] failures (assertions, logic)
- Fixed [Z] warnings (deprecations, marks)

### Test Quality Improvements
- [Improvement 1]
- [Improvement 2]

### Technical Debt Identified
- [Debt Item 1]: [Impact] - [Recommendation]
- [Debt Item 2]: [Impact] - [Recommendation]
```

## Key Commands Reference

```bash
# Run with layer-specific coverage enforcement
./run.sh test-domain                          # Domain: 100% required
./run.sh test-application                     # Application: 100% required
./run.sh test-unit                            # Unit combined: ≥95% required
./run.sh coverage                             # All tests with full report

# Run all tests with coverage
uv run pytest --cov=src/tangoatlas --cov-report=term --cov-report=html

# Run specific test types (no coverage enforcement)
uv run pytest tests/unit/domain/ -v           # Domain tests only
uv run pytest tests/unit/application/ -v      # Application tests only
uv run pytest tests/integration/ -v           # Integration tests only
uv run pytest tests/contract/ -v              # Contract tests only

# Run tests matching pattern
uv run pytest -k "test_user" -v               # All user-related tests
uv run pytest -k "not slow" -v                # Exclude slow tests

# Run with different verbosity
uv run pytest -v                               # Verbose
uv run pytest -vv                              # Very verbose
uv run pytest --tb=short                       # Short traceback
uv run pytest --tb=long                        # Long traceback

# Stop on first failure
uv run pytest -x

# Run last failed tests
uv run pytest --lf

# Collect tests without running
uv run pytest --collect-only

# Show available fixtures
uv run pytest --fixtures

# Validate architecture
uv run lint-imports

# Type checking
uv run pyright

# Mutation testing (domain only, slow)
uv run mutmut run --paths-to-mutate=src/tangoatlas/domain/
uv run mutmut results
uv run mutmut html
```

## Success Criteria

Before completing test fix task, you MUST verify:

- [ ] Zero errors (no collection failures)
- [ ] Zero failures (all assertions pass)
- [ ] Zero critical warnings (all deprecations addressed)
- [ ] Coverage ≥95% overall, 100% domain/application
- [ ] Architecture boundaries enforced (`lint-imports` passes)
- [ ] Type checking passes (`pyright` clean)
- [ ] All tests are FAST, INDEPENDENT, REPEATABLE, SELF-VALIDATING, TIMELY
- [ ] No superficial mocks or hacks introduced
- [ ] All tests validate application logic (not framework behavior)
- [ ] Tests reflect current specifications

---

**Version**: 1.0.0 | **Date**: 2026-01-08 | **Constitution**: v1.8.0
