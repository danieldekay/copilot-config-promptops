---
description: 'Python coding conventions and guidelines'
applyTo: '**/*.py'
---

# Python Coding Conventions

## Python Instructions

- Write clear and concise comments for each function.
- Ensure functions have descriptive names and include type hints.
- Provide docstrings following PEP 257 conventions.
- Use the `typing` module for type annotations (e.g., `List[str]`, `Dict[str, int]`).
- Break down complex functions into smaller, more manageable functions.

## General Instructions

- Always prioritize readability and clarity.
- For algorithm-related code, include explanations of the approach used.
- Write code with good maintainability practices, including comments on why certain design decisions were made.
- Handle edge cases and write clear exception handling.
- For libraries or external dependencies, mention their usage and purpose in comments.
- Use consistent naming conventions and follow language-specific best practices.
- Write concise, efficient, and idiomatic code that is also easily understandable.

## Code Style and Formatting

- Follow the **PEP 8** style guide for Python.
- Maintain proper indentation (use 4 spaces for each level of indentation).
- Ensure lines do not exceed 79 characters.
- Place function and class docstrings immediately after the `def` or `class` keyword.
- Use blank lines to separate functions, classes, and code blocks where appropriate.

## Edge Cases and Testing

- Always include test cases for critical paths of the application.
- Account for common edge cases like empty inputs, invalid data types, and large datasets.
- Include comments for edge cases and the expected behavior in those cases.
- Write unit tests for functions and document them with docstrings explaining the test cases.

## Example of Proper Documentation

```python
def calculate_area(radius: float) -> float:
    """
    Calculate the area of a circle given the radius.
    
    Parameters:
    radius (float): The radius of the circle.
    
    Returns:
    float: The area of the circle, calculated as π * radius^2.
    """
    import math
    return math.pi * radius ** 2
```
description: 'Python coding conventions and guidelines with Clean Code and Clean Architecture principles'
applyTo: '**/*.py'
---

# Python Coding Standards

## Core Principles

This project adheres to **Clean Code**, **Clean Architecture**, and **SOLID principles**. Every Python file must meet these standards without exception.

### Clean Architecture Layers (MANDATORY)

**Layer Dependency Rule**: Dependencies point INWARD only. Outer layers can import inner layers, never the reverse.

```python
domain/              # Layer 1: Enterprise Business Rules
  entities/          # Pure domain models (Pydantic, dataclasses)
  services/          # Domain logic and validation
  # ✅ No imports from other layers
  # ✅ No framework dependencies
  # ✅ Pure Python + Pydantic only

use_cases/           # Layer 2: Application Business Rules
  # ✅ Can import from: domain/
  # ❌ Cannot import from: adapters/, infrastructure/
  # ✅ Orchestrates domain logic
  # ❌ No framework dependencies

adapters/            # Layer 3: Interface Adapters
  parsers/           # Input adapters
  generators/        # Output adapters
  repositories/      # Data access interfaces
  # ✅ Can import from: domain/, use_cases/
  # ❌ Cannot import from: infrastructure/
  # ✅ Converts data between use cases and external systems

infrastructure/      # Layer 4: Frameworks & Drivers
  cli/               # Click/Typer commands
  api/               # FastAPI routes
  database/          # SQLAlchemy models
  file_io/           # File operations
  # ✅ Can import from: domain/, use_cases/, adapters/
  # ✅ Contains all framework code
```

**Architecture Validation**: Every project MUST have architecture tests verifying layer boundaries.

### SOLID Principles (MANDATORY)

**Single Responsibility Principle (SRP)**:

- One class/function has ONE reason to change
- Functions do ONE thing and do it well
- Maximum 20 lines per function (prefer ≤15)

```python
# ❌ BAD: Multiple responsibilities
def process_user(data: dict) -> None:
    # Validates, transforms, saves, sends email
    if not data.get("email"):
        raise ValueError("Email required")
    user = User(**data)
    db.save(user)
    send_welcome_email(user.email)

# ✅ GOOD: Single responsibility each
def validate_user_data(data: dict) -> None:
    """Validate user data meets requirements."""
    if not data.get("email"):
        raise ValueError("Email required")

def create_user(data: dict) -> User:
    """Create user entity from validated data."""
    return User(**data)

def save_user(user: User) -> None:
    """Persist user to database."""
    db.save(user)
```

**Open/Closed Principle (OCP)**:

- Open for extension, closed for modification
- Use composition, protocols, and inheritance strategically

```python
# ✅ GOOD: Extensible via composition
from typing import Protocol

class Parser(Protocol):
    """Parser interface for extending behavior."""
    def parse(self, content: str) -> dict:
        ...

class MarkdownParser:
    """Parse markdown content."""
    def parse(self, content: str) -> dict:
        # Implementation
        pass

class YAMLParser:
    """Parse YAML content."""
    def parse(self, content: str) -> dict:
        # Implementation
        pass
```

**Liskov Substitution Principle (LSP)**:

- Subtypes must be substitutable for base types
- Inheritance must preserve behavior contracts

**Interface Segregation Principle (ISP)**:

- Many small, focused interfaces over one large interface
- Clients shouldn't depend on methods they don't use

```python
# ✅ GOOD: Focused protocols
class Readable(Protocol):
    def read(self) -> str: ...

class Writable(Protocol):
    def write(self, content: str) -> None: ...

class Seekable(Protocol):
    def seek(self, position: int) -> None: ...
```

**Dependency Inversion Principle (DIP)**:

- Depend on abstractions (protocols), not concretions
- High-level modules don't depend on low-level modules

```python
# ✅ GOOD: Depend on abstraction
class FileReader(Protocol):
    def read(self, path: str) -> str: ...

class MarkdownConverter:
    """Convert markdown using any file reader."""
    def __init__(self, reader: FileReader) -> None:
        self._reader = reader

    def convert(self, path: str) -> dict:
        content = self._reader.read(path)
        # Convert content
        return {}
```

## Type Hints (MANDATORY)

**ALL functions, methods, and class attributes MUST have explicit type hints.**

```python
from typing import Protocol, TypeVar, Generic
from collections.abc import Sequence, Mapping, Callable

# ✅ Required: Explicit return type
def process_data(items: list[str]) -> dict[str, int]:
    """Process items and return frequency count."""
    return {item: items.count(item) for item in set(items)}

# ✅ Required: Protocols for dependency injection
class Repository(Protocol):
    """Data repository interface."""
    def save(self, entity: dict[str, Any]) -> None: ...
    def find(self, id: str) -> dict[str, Any] | None: ...

# ✅ Required: Generic types
T = TypeVar("T")

class Result(Generic[T]):
    """Result wrapper for success/failure."""
    def __init__(self, value: T | None = None, error: str | None = None) -> None:
        self.value = value
        self.error = error

    @property
    def is_success(self) -> bool:
        """Check if result represents success."""
        return self.error is None
```

**Use modern type hint syntax** (Python 3.10+):

- ✅ `list[str]` not `List[str]`
- ✅ `dict[str, int]` not `Dict[str, int]`
- ✅ `tuple[int, ...]` not `Tuple[int, ...]`
- ✅ `X | Y` not `Union[X, Y]`
- ✅ `X | None` not `Optional[X]`

## Code Quality Metrics (MANDATORY)

**ALL code must meet these thresholds:**

- ✅ **Cyclomatic complexity**: ≤ 10 per function (prefer ≤ 7)
- ✅ **Function length**: ≤ 20 lines (prefer ≤ 15)
- ✅ **Test coverage**: ≥ 80% (prefer ≥ 90%)
- ✅ **Type coverage**: 100% (all signatures typed)
- ✅ **Ruff linting**: Zero violations
- ✅ **Pyright/mypy**: Zero type errors

**Validation commands**:

```bash
# Linting and formatting
ruff check src/          # Must pass
ruff format src/         # Auto-format

# Type checking
pyright src/             # Must pass with 0 errors
# or
mypy src/ --strict       # Must pass

# Complexity analysis
radon cc src/ -a -nb     # All functions ≤ 10

# Test coverage
pytest tests/ --cov=src --cov-report=term-missing --cov-fail-under=80
```

## Docstrings and Comments

**Docstrings explain WHY, not WHAT. Code should be self-documenting for WHAT.**

```python
# ❌ BAD: Docstring states the obvious
def calculate_total(items: list[float]) -> float:
    """Calculate the total of items."""
    return sum(items)

# ✅ GOOD: Docstring explains WHY and context
def calculate_total(items: list[float]) -> float:
    """
    Calculate total cost including any zero-value promotional items.

    Zero-value items are included in the count for inventory tracking
    but don't affect the monetary total. This supports our "buy one,
    get one free" promotion tracking.
    """
    return sum(items)

# ✅ GOOD: Self-documenting code needs no comment
def is_eligible_for_discount(
    total_spent: float,
    membership_years: int,
) -> bool:
    """
    Determine discount eligibility based on loyalty program rules.

    Business rule: Customers qualify if they've spent over $1000
    OR have been members for 5+ years. This dual criteria ensures
    both high-value and long-term customers receive benefits.
    """
    MIN_SPENDING_THRESHOLD = 1000.0
    MIN_MEMBERSHIP_YEARS = 5

    return (
        total_spent >= MIN_SPENDING_THRESHOLD
        or membership_years >= MIN_MEMBERSHIP_YEARS
    )
```

**Comment guidelines**:

```python
# ✅ GOOD: Explain WHY, not WHAT
# Using cached property to avoid recalculating on every access
# because SHA-256 hashing is expensive for large files
@cached_property
def file_hash(self) -> str:
    return hashlib.sha256(self.content.encode()).hexdigest()

# ❌ BAD: States the obvious
# Calculate hash
def file_hash(self) -> str:
    return hashlib.sha256(self.content.encode()).hexdigest()

# ✅ GOOD: Explain non-obvious decisions
# Retry with exponential backoff because API rate limits
# are based on sliding 60-second windows
@retry(max_attempts=3, backoff=exponential)
def fetch_data(self) -> dict:
    return api.get("/data")

# ✅ GOOD: Warn about edge cases
def parse_date(date_str: str) -> datetime:
    """
    Parse ISO 8601 date string.

    Note: Timezone-naive strings are interpreted as UTC
    to maintain consistency across distributed systems.
    """
    # Explicit UTC timezone prevents ambiguity in database storage
    return datetime.fromisoformat(date_str).replace(tzinfo=timezone.utc)
```

## Self-Documenting Code

**Variable and function names should eliminate need for comments.**

```python
# ❌ BAD: Cryptic names need comments
def proc(d: dict) -> bool:
    # Check if user is admin
    return d.get("r") == "a"

# ✅ GOOD: Self-documenting
def is_administrator(user_data: dict[str, str]) -> bool:
    """Check if user has administrative privileges."""
    ADMIN_ROLE = "administrator"
    return user_data.get("role") == ADMIN_ROLE

# ❌ BAD: Magic numbers
if age > 18 and score > 70:
    approve()

# ✅ GOOD: Named constants
MINIMUM_AGE = 18
PASSING_SCORE = 70

if age > MINIMUM_AGE and score > PASSING_SCORE:
    approve_application()
```

## Pydantic for Validation (REQUIRED in Domain Layer)

**Use Pydantic for all domain entities and value objects.**

```python
from pydantic import BaseModel, Field, field_validator, ConfigDict

class Survey(BaseModel):
    """Survey entity with validation rules."""

    model_config = ConfigDict(frozen=True)  # Immutable

    title: str = Field(min_length=1, max_length=200)
    description: str | None = Field(default=None, max_length=1000)
    language: str = Field(pattern=r"^[a-z]{2}$")  # ISO 639-1

    @field_validator("title")
    @classmethod
    def title_must_not_be_whitespace(cls, v: str) -> str:
        """Ensure title contains non-whitespace characters."""
        if not v.strip():
            raise ValueError("Title cannot be empty or whitespace")
        return v.strip()

    @field_validator("language")
    @classmethod
    def language_must_be_lowercase(cls, v: str) -> str:
        """Ensure language code is lowercase per ISO standard."""
        return v.lower()
```

## Error Handling

**Use explicit exception types. Never catch bare `except:`.**

```python
# ✅ GOOD: Specific exceptions with context
class ValidationError(Exception):
    """Domain validation failed."""
    def __init__(self, message: str, field: str | None = None) -> None:
        super().__init__(message)
        self.field = field

def validate_survey(data: dict) -> None:
    """
    Validate survey data meets domain requirements.

    Raises:
        ValidationError: When data fails validation rules
    """
    if not data.get("title"):
        raise ValidationError(
            "Survey title is required",
            field="title"
        )

# ✅ GOOD: Narrow exception handling
def load_config(path: str) -> dict:
    """
    Load configuration from file.

    File not found is acceptable (returns defaults).
    Other errors indicate corruption and should fail fast.
    """
    try:
        with open(path) as f:
            return json.load(f)
    except FileNotFoundError:
        return DEFAULT_CONFIG
    except json.JSONDecodeError as e:
        raise ConfigurationError(
            f"Configuration file corrupted: {e}"
        ) from e
```

## Testing Requirements

**TDD is mandatory. Write tests BEFORE implementation.**

```python
# tests/unit/domain/test_survey.py
"""Unit tests for Survey entity."""

from src.domain.entities.survey import Survey
from pydantic import ValidationError
import pytest

def test_survey_requires_non_empty_title() -> None:
    """Survey validation should reject empty titles.

    Business rule: All surveys must have meaningful titles
    for display in survey lists.
    """
    with pytest.raises(ValidationError, match="Title cannot be empty"):
        Survey(title="   ", language="en")

def test_survey_normalizes_language_code() -> None:
    """Survey should convert language codes to lowercase.

    Ensures consistency with ISO 639-1 standard and prevents
    duplicate language entries in the database.
    """
    survey = Survey(title="Test", language="EN")
    assert survey.language == "en"

def test_survey_is_immutable() -> None:
    """Survey entities should be immutable after creation.

    Immutability prevents accidental state changes and makes
    the domain model easier to reason about.
    """
    survey = Survey(title="Test", language="en")
    with pytest.raises(AttributeError):
        survey.title = "Changed"  # type: ignore
```

## Code Formatting (Ruff)

**Configuration in `pyproject.toml`**:

```toml
[tool.ruff]
line-length = 100
target-version = "py310"

[tool.ruff.lint]
select = [
    "E",   # pycodestyle errors
    "W",   # pycodestyle warnings
    "F",   # pyflakes
    "I",   # isort
    "N",   # pep8-naming
    "UP",  # pyupgrade
    "B",   # flake8-bugbear
    "C4",  # flake8-comprehensions
    "SIM", # flake8-simplify
    "TCH", # flake8-type-checking
]

[tool.ruff.lint.per-file-ignores]
"tests/**/*.py" = ["S101"]  # Allow assert in tests

[tool.pyright]
typeCheckingMode = "strict"
reportMissingTypeStubs = false
```

## Project Structure Example

```
src/
  domain/
    entities/
      survey.py           # Pydantic models, no framework imports
      question.py
    services/
      validator.py        # Domain validation logic

  use_cases/
    convert_markdown.py   # Orchestrates domain services
    # Imports: domain/ only

  adapters/
    parsers/
      markdown_parser.py  # Input adapter
    generators/
      lss_generator.py    # Output adapter
    # Imports: domain/, use_cases/

  infrastructure/
    cli/
      main.py             # Click application
      commands.py         # CLI commands
    file_io/
      file_handler.py     # File operations
    # Imports: domain/, use_cases/, adapters/

tests/
  architecture/
    test_domain_isolation.py     # Verify no framework in domain
    test_dependency_direction.py # Verify layer dependencies

  unit/
    domain/
      test_survey.py
    use_cases/
      test_convert_markdown.py

  integration/
    test_markdown_to_lss.py
```

## Anti-Patterns to Avoid

❌ **Framework in domain layer**:

```python
# ❌ WRONG: Domain importing Click
from click import echo

class Survey:
    def display(self) -> None:
        echo(self.title)  # Framework leak!
```

✅ **Keep domain pure**:

```python
# ✅ CORRECT: Domain returns data, infrastructure displays
class Survey:
    def to_display_format(self) -> str:
        """Format survey for display."""
        return f"Survey: {self.title}"

# In infrastructure/cli/commands.py
click.echo(survey.to_display_format())
```

❌ **God objects**:

```python
# ❌ WRONG: Class does everything
class SurveyManager:
    def parse(self): ...
    def validate(self): ...
    def convert(self): ...
    def save(self): ...
    def send_email(self): ...  # 500 lines total
```

✅ **Single responsibility**:

```python
# ✅ CORRECT: Focused classes
class MarkdownParser: ...
class SurveyValidator: ...
class LSSGenerator: ...
class SurveyRepository: ...
class EmailNotifier: ...
```

❌ **Missing type hints**:

```python
# ❌ WRONG: No types
def process(data):
    return [x for x in data if x > 0]
```

✅ **Explicit types**:

```python
# ✅ CORRECT: Clear types
def process(data: list[int]) -> list[int]:
    """Filter positive integers from input list."""
    return [x for x in data if x > 0]
```

## Summary Checklist

Before committing ANY Python code, verify:

- [ ] Clean Architecture layers respected (no upward dependencies)
- [ ] SOLID principles applied (especially SRP)
- [ ] All functions have type hints (100% coverage)
- [ ] Docstrings explain WHY, not WHAT
- [ ] Code is self-documenting (clear names)
- [ ] Functions ≤ 20 lines (prefer ≤ 15)
- [ ] Cyclomatic complexity ≤ 10
- [ ] Tests written BEFORE implementation (TDD)
- [ ] Test coverage ≥ 80%
- [ ] Ruff linting passes (zero violations)
- [ ] Pyright/mypy passes (zero errors)
- [ ] No framework code in domain layer
- [ ] Pydantic used for domain entities
- [ ] Error handling is explicit and narrow
- [ ] No god objects or god functions

**Quality is non-negotiable. Every line of code must meet these standards.**
