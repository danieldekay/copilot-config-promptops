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
template: "fruity"                        # Optional: LS theme/template name
show_progress: true                        # default: true
show_welcome: true                         # default: true
allow_prev: true                           # default: true
start_date: "2026-03-06 09:00"           # Optional
expiry_date: "2026-03-20 18:00"          # Optional
use_tokens: true                           # Optional
assessments: true                          # Optional
bounce_email: "bounce@example.com"       # Optional
email_response_to: "reply@example.com"   # Optional
email_notification_to: "notify@example.com" # Optional
email_invite_subject: "Please join"      # Optional
email_invite_body: "Invitation body"     # Optional
email_remind_subject: "Reminder"         # Optional
email_remind_body: "Reminder body"       # Optional
email_register_subject: "Registration"   # Optional
email_register_body: "Registration body" # Optional
email_confirm_subject: "Confirmed"       # Optional
email_confirm_body: "Confirmation body"  # Optional
email_admin_notification_subject: "New response" # Optional
email_admin_notification_body: "Admin notification body" # Optional
email_admin_responses_subject: "Responses export" # Optional
email_admin_responses_body: "Responses body" # Optional
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
| `list_with_comment`| O               | ✅ Supported | Single choice with comment |
| `dropdown`         | !               | ✅ Supported | Requires answer options (`- [ ] ...`) |
| `short_text`       | S               | ✅ Supported | No answer options |
| `long_text`        | T               | ✅ Supported | No answer options |
| `huge_text`        | U               | ✅ Supported | No answer options |
| `numeric`          | N               | ⚠️ Supported (untested) | No answer options |
| `date`             | D               | ⚠️ Supported (untested) | No answer options |
| `ranking`          | R               | ⚠️ Supported (untested) | Requires answer options (`- [ ] ...`) |
| `yes_no`           | Y               | ✅ Supported | No explicit answer options needed |
| `text_display`     | X               | ✅ Supported | Display-only boilerplate text |
| `equation`         | *               | ✅ Supported | Computed / ExpressionScript-backed field |
| `array_5point`     | A               | ⚠️ Supported | Use `Rows:` syntax for subquestions |
| `array_yes_no_uncertain` | C         | ⚠️ Supported | Use `Rows:` syntax for subquestions |
| `array_dual_scale` | 1               | ⚠️ Declared, not fully documented | Advanced array export path |

Still not currently supported end-to-end: full multi-language authoring in one markdown file, quotas, full LS admin parity.

---

## Question Config Block Reference

```yaml
type: single_choice                  # Required: see type table above
code: MY_CODE                        # Required: unique, A-Z/0-9/_, starts with letter, ≤20 chars
required: true                       # Optional: true/false (default: false)
relevance: "NEWSLETTER_ABO == 'A1'"  # Optional: ExpressionScript condition
help: "Helper text"                  # Optional
other_option: true                   # Optional: add LimeSurvey "Other"
other_replace_text: "Other"         # Optional: label text for Other field
min_answers: 1                       # Optional: checkbox minimum
max_answers: 3                       # Optional: checkbox maximum
randomize_answers: true              # Optional: randomize answer order
css_class: "survey-question"        # Optional: exported CSS class
display_type: list                   # Optional: display hint (`default`, `inline`, `table`, `list`)
hide_tip: true                       # Optional: hide tip/help icon
validation: '^[^@]+@[^@]+\\.[^@]+$' # Optional: regex validation
validation_message: "Invalid email" # Optional: shown on validation failure
min_length: 5                        # Optional: text minimum length
max_length: 250                      # Optional: text maximum length
min_value: 0                         # Optional: numeric minimum
max_value: 100                       # Optional: numeric maximum
```

These keys are currently consumed by the markdown parser: `type`, `code`, `required`, `relevance`, `help`, `other_option`, `other_replace_text`, `min_answers`, `max_answers`, `randomize_answers`, `css_class`, `display_type`, `hide_tip`, `validation`, `validation_message`, `min_length`, `max_length`, `min_value`, `max_value`.

---

## Answer Codes

Answer options are auto-assigned codes `A1`, `A2`, `A3`... in order of appearance. Use these codes in `relevance` expressions.

You can also set explicit codes and assessment values inline:

```markdown
- [A1] Newsletter
- [A2|10] WhatsApp
- [CUSTOM_CODE|5] Local community
```

Format:
- `[CODE] Answer text`
- `[CODE|ASSESSMENT_VALUE] Answer text`

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

## Group-Level Config

Group descriptions are plain text immediately after the `## Group Title` header.

You can also attach a yaml block before the first `###` question:

```markdown
## Newsletter

Only shown to subscribers.

```yaml
group_relevance: "NEWSLETTER_ABO == 'A1'"
randomize_questions: false
```
```

Currently supported group keys:
- `group_relevance`
- `randomize_questions`

## Array Rows Syntax

Selected array-style questions support a `Rows:` section for subquestions:

```markdown
### Please rate the following

```yaml
type: array_5point
code: RATE_ITEMS
```

Rows:
- [ ] Navigation
- [ ] Search
- [ ] Mobile usability
```

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

### Create a new survey

```bash
# Create with default settings (German, group-by-group)
PYTHONPATH=src uv run limesurvey api create-survey "Community Feedback 2026"

# Custom language and format
PYTHONPATH=src uv run limesurvey api create-survey "Quick Poll" --language en --survey-format S
```

### Delete a survey

```bash
# With confirmation prompt
PYTHONPATH=src uv run limesurvey api delete-survey 123456

# Skip confirmation
PYTHONPATH=src uv run limesurvey api delete-survey 123456 --yes
```

### Activate a survey

Activating a survey starts response collection. Structure changes are disabled after activation.

```bash
PYTHONPATH=src uv run limesurvey api activate 123456 --yes
```

### Copy a survey

```bash
PYTHONPATH=src uv run limesurvey api copy-survey 123456 "Survey Copy 2026"
```

### Update survey properties

```bash
# Single property
PYTHONPATH=src uv run limesurvey api update-survey 123456 --property admin=admin@example.com

# Multiple properties
PYTHONPATH=src uv run limesurvey api update-survey 123456 \
  --property admin=admin@example.com \
  --property format=S

# From JSON file
PYTHONPATH=src uv run limesurvey api update-survey 123456 --properties-file props.json
```

### Export a survey

```bash
# Export to default file (survey_123456.lss in current directory)
PYTHONPATH=src uv run limesurvey api export 123456

# Export to specific file
PYTHONPATH=src uv run limesurvey api export 123456 -o /tmp/backup.lss
```

### Create a question group

```bash
PYTHONPATH=src uv run limesurvey api create-group 123456 "Demographics" --description "Basic info"
```

### List question groups

```bash
PYTHONPATH=src uv run limesurvey api list-groups 123456
```

### Add participants

```bash
# From JSON file
PYTHONPATH=src uv run limesurvey api add-participants 123456 -f participants.json

# Inline JSON
PYTHONPATH=src uv run limesurvey api add-participants 123456 \
  -i '[{"email":"test@example.com","firstname":"Test","lastname":"User"}]'

# Add and send invitations immediately
PYTHONPATH=src uv run limesurvey api add-participants 123456 -f list.json --send-invitation
```

### Invite participants

```bash
# Invite all uninvited participants
PYTHONPATH=src uv run limesurvey api invite-participants 123456 --yes

# Invite specific tokens
PYTHONPATH=src uv run limesurvey api invite-participants 123456 --token abc123 --token def456 --yes
```

### List participants

```bash
PYTHONPATH=src uv run limesurvey api list-participants 123456

# Only show who hasn't completed
PYTHONPATH=src uv run limesurvey api list-participants 123456 --unused-only
```

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
