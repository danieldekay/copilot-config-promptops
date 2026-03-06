---
name: limesurvey-survey-builder
description: Generate, validate, and deploy LimeSurvey surveys using the tango-tools markdown-first pipeline. Use when asked to create, edit, or deploy a LimeSurvey survey as a markdown file, when working with rnt-community-survey files, when running `limesurvey validate`, `limesurvey convert`, or `limesurvey api` CLI commands, or when writing surveys for survey.tangoresearch.net. Covers markdown schema, question types, relevance/branching logic, parser quirks, and the full validate→convert→deploy workflow.
license: Complete terms in LICENSE.txt
---

# LimeSurvey Survey Builder — Markdown-First Workflow

Build, validate, and deploy LimeSurvey surveys using the `tango-tools` markdown pipeline at `2ndBrain/code/src/limesurvey/`.

---

## Environment

```bash
# All commands run from 2ndBrain/code/
cd /Users/dekay/Dokumente/2ndBrain/code
PYTHONPATH=src uv run limesurvey <command>
```

**LimeSurvey instance**: `survey.tangoresearch.net`
**Config file**: `~/.limesurvey.conf` (url / username / password)

---

## Workflow: Survey Creation → Deployment

```
1. Write  →  projects/<name>/<name>.md        (markdown file)
2. Validate →  limesurvey validate survey.md
3. Convert  →  limesurvey convert markdown survey.md output.lss
4. Deploy   →  limesurvey api import-lss output.lss [--url ...]
              OR
              limesurvey api deploy survey.json [--url ...]
```

---

## Markdown Structure

### File Layout

```markdown
---                          ← YAML frontmatter (survey metadata)
title: "Survey Title"
language: "de"
...
---

## Group Name               ← Question group (`##`)

### Question Title          ← Question header (`###`)

```yaml                     ← Config block — MUST come before answer options
type: single_choice
code: MY_CODE
required: true
```

- [ ] Answer 1             ← Answer options (after config block)
- [ ] Answer 2
```

### ⚠️ Critical Parser Rule

The `yaml` config block **must appear immediately after the `### ` header** (a single blank line is allowed, but nothing else). Answer options (`- [ ]`) must come **after** the yaml block.

```markdown
# ✅ CORRECT — yaml before answers
### How old are you?

```yaml
type: single_choice
code: AGE
required: true
```

- [ ] Under 18
- [ ] 18–30
- [ ] 31–50
- [ ] Over 50

# ❌ WRONG — yaml after answers (codes will not be read, duplicates will occur)
### How old are you?

- [ ] Under 18
- [ ] 18–30

```yaml
type: single_choice
code: AGE         ← This will be IGNORED by the parser
```
```

---

## YAML Frontmatter Reference

```yaml
---
title: "Survey Title"                      # Required
description: "Short description"           # Optional, supports multiline |
language: "de"                             # Required: ISO 639-1 code
admin: "email@example.com"                 # Optional
welcome: |                                 # Optional: welcome text
  Welcome message here.
end_message: |                             # Optional: closing text
  Thank you!
format: "G"                                # G=group, S=single, A=all (default: G)
show_progress: true                        # default: true
allow_prev: true                           # default: true
---
```

---

## Question Types

Use the `type:` field in the yaml config block. Types are looked up **by name** (not by LimeSurvey code letter).

Important: this skill documents the **current** markdown→domain→LSS pipeline. Some LimeSurvey features exist in LimeSurvey, but are not exposed by the markdown format yet.

| `type:` value      | LimeSurvey Type | Status | Notes |
|--------------------|-----------------|--------|-------|
| `single_choice`    | L               | ✅ Supported | Requires answer options (`- [ ] ...`) |
| `multiple_choice`  | M               | ✅ Supported | Requires answer options (`- [ ] ...`) |
| `dropdown`         | !               | ✅ Supported | Requires answer options (`- [ ] ...`) |
| `short_text`       | S               | ✅ Supported | No answer options |
| `long_text`        | T               | ✅ Supported | No answer options |
| `huge_text`        | U               | ✅ Supported | No answer options |
| `numeric`          | N               | ⚠️ Supported (untested) | No answer options |
| `date`             | D               | ⚠️ Supported (untested) | No answer options |
| `ranking`          | R               | ⚠️ Supported (untested) | Requires answer options (`- [ ] ...`) |
| `yes_no`           | Y               | ⚠️ Supported (pipeline-specific) | Current domain validation expects explicit answers; include `- [ ] Ja` / `- [ ] Nein` |

Not currently supported by the markdown format (no syntax in the parser): array/matrix questions, subquestions, “other” option, per-option comments, min/max checkbox constraints, randomization.

---

## Question Config Block Reference

```yaml
type: single_choice                  # Required: see type table above
code: MY_CODE                        # Required: unique, A-Z/0-9/_, starts with letter, ≤20 chars
required: true                       # Optional: true/false (default: false)
relevance: "NEWSLETTER_ABO == 'A1'"  # Optional: ExpressionScript condition
help: "Helper text"                  # Optional
```

Only these keys are currently consumed by the markdown parser: `type`, `code`, `required`, `relevance`, `help`.

Other keys (e.g. `max_length`, `validation`, `validation_message`, `other_option`, min/max constraints) are currently **ignored** by the markdown pipeline.

---

## Answer Codes

Answer options are auto-assigned codes `A1`, `A2`, `A3`... in order of appearance. Use these codes in `relevance` expressions.

```markdown
- [ ] Ich tanze Tango                      ← A1
- [ ] Ich organisiere Veranstaltungen      ← A2
- [ ] Ich bin DJ                           ← A3
```

Example relevance using those codes:
```yaml
relevance: "ROLLE_A2 == 'Y' or ROLLE_A3 == 'Y'"
```

For `multiple_choice` questions, each checkbox is accessed as `QUESTIONCODE_ANSWERCODE`:
```yaml
# ROLLE is multiple_choice; check if first checkbox (A1) is ticked
relevance: "ROLLE_A1 == 'Y'"
```

Note: For `multiple_choice`, avoid `ROLLE == 'A1'` — that pattern is for `single_choice` questions.

---

## Conditional Logic (Relevance)

Every question can have a `relevance` expression. Default is `1` (always show).

| Scenario | Expression |
|----------|-----------|
| Show if single-choice answer A1 selected | `"CODE == 'A1'"` |
| Show if multiple-choice box A1 ticked | `"CODE_A1 == 'Y'"` |
| Combine multiple boxes | `"CODE_A1 == 'Y' or CODE_A2 == 'Y'"` |
| Always show | `"1"` or omit field |
| Never show (debug) | `"0"` |

---

## CLI Commands

### Validate

```bash
# Checks structure, unique codes, required fields
PYTHONPATH=src uv run limesurvey validate /path/to/survey.md

# JSON output
PYTHONPATH=src uv run limesurvey validate /path/to/survey.md --json
```

Exit codes: 0 = valid, 1 = invalid, 2 = error

### Convert to LSS

```bash
PYTHONPATH=src uv run limesurvey convert markdown survey.md output.lss
```

### Deploy via API (LSS import)

```bash
PYTHONPATH=src uv run limesurvey api import-lss output.lss \
  --url https://survey.tangoresearch.net \
  --username admin \
  --password SECRET
```

### Replace a live survey in-place (recommended for iterative edits)

LimeSurvey's `DestSurveyID`-style imports do **not** reliably replace an existing survey.
Use the CLI's `--replace-id` flag instead (it deletes the old ID first, then imports).

```bash
PYTHONPATH=src uv run limesurvey api import-lss output.lss --replace-id 1
```

### Deploy via API (JSON survey entity)

```bash
PYTHONPATH=src uv run limesurvey api deploy survey.json \
  --url https://survey.tangoresearch.net \
  --dry-run   # validate first
```

### List deployed surveys

```bash
PYTHONPATH=src uv run limesurvey api list \
  --url https://survey.tangoresearch.net \
  --username admin --password SECRET
```

### Credentials via env vars (avoids repeating flags)

```bash
export LIMESURVEY_URL=https://survey.tangoresearch.net
export LIMESURVEY_USERNAME=admin
export LIMESURVEY_PASSWORD=SECRET
PYTHONPATH=src uv run limesurvey api import-lss output.lss
```

### Credentials from 1Password (recommended)

The LimeSurvey admin credentials are stored in 1Password with item ID `sewp2rhkhlocijocmxchg3dlle`.

```bash
# One-liner: pull credentials inline and deploy
cd /Users/dekay/Dokumente/2ndBrain/code
LIMESURVEY_URL=https://survey.tangoresearch.net \
LIMESURVEY_USERNAME=$(op item get sewp2rhkhlocijocmxchg3dlle --fields label=username) \
LIMESURVEY_PASSWORD=$(op item get sewp2rhkhlocijocmxchg3dlle --fields label=password --reveal) \
PYTHONPATH=src uv run limesurvey api import-lss /tmp/output.lss
```

Requires an active 1Password session (`op whoami` to verify, `eval $(op signin)` to authenticate).

---

## Python API (for scripting)

```python
from pathlib import Path
from limesurvey.adapters.parsers.markdown_parser import MarkdownParser

parser = MarkdownParser()
result = parser.parse_content(Path("survey.md").read_text())

print("Valid:", result.is_valid)
if not result.is_valid:
    print("Error:", result.error)
else:
    survey = result.value
    for group in survey.groups:
        for q in group.questions:
            print(f"[{q.code}] {q.question_type.name}")
```

---

## Common Errors

| Error | Cause | Fix |
|-------|-------|-----|
| `Duplicate question code: Qn` | yaml config block positioned after answers — parser ignores it | Move yaml block to immediately after `### ` header |
| Type shows as `SINGLE_CHOICE` instead of `MULTIPLE_CHOICE` | Old parser used value lookup, couldn't match `multiple_choice` as type code | Updated parser uses name lookup — ensure tango-tools is current |
| `ValidationResult[Survey]` subscript error | Missing `from __future__ import annotations` in parser | Fixed in current version |
| Blank line breaks yaml detection | Parser skips one blank line — two blank lines will stop detection | Keep at most one blank line between `### ` and ` ```yaml` |
| Code starts with number or has spaces | Invalid question code | Use only letters, digits, underscores; start with a letter |

---

## Question Code Naming Conventions

- **SCREAMING_SNAKE_CASE**: `ROLLE`, `BESUCH_HAEUFIGKEIT`, `ANKU_NUTZWERT`
- Max 20 characters (LimeSurvey limit for display, longer may truncate)
- Unique across **all groups** in the survey (not just within a group)
- Descriptive: `FINANZIERUNG_BEWUSST` not `Q12`

---

## Complete Minimal Example

```markdown
---
title: "Community Feedback 2026"
language: "de"
admin: "admin@example.com"
format: "G"
show_progress: true
---

## Über dich

### Wie würdest du dich beschreiben?

```yaml
type: multiple_choice
code: ROLLE
required: true
```

- [ ] Tänzer:in
- [ ] Veranstalter:in
- [ ] DJ

### In welcher Stadt bist du aktiv?

```yaml
type: short_text
code: STADT
required: false
```

## Feedback

### Was wünschst du dir?

```yaml
type: long_text
code: WUNSCH
required: false
max_length: 1000
```
```

Validate and deploy:
```bash
cd /Users/dekay/Dokumente/2ndBrain/code
PYTHONPATH=src uv run limesurvey validate /path/to/survey.md
PYTHONPATH=src uv run limesurvey convert markdown /path/to/survey.md /tmp/survey.lss
PYTHONPATH=src uv run limesurvey api import-lss /tmp/survey.lss \
  --url https://survey.tangoresearch.net --username admin --password SECRET
```
