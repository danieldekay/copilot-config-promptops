# LimeSurvey Survey Generation Skill

> Comprehensive skill for creating, designing, and deploying LimeSurvey surveys using the API, XML import formats, and the workspace's FastMCP server.

---

## When to Use This Skill

Use when the user wants to:
- Create a new LimeSurvey survey (fully or partially)
- Design a survey structure with multiple question types
- Add branching/skip logic using ExpressionScript
- Import a survey via LSS/LSQ XML files
- Interact with LimeSurvey programmatically via the LSRC2 API
- Use the workspace MCP tools (`list_surveys`, `create_question`, etc.)

---

## Quick Reference: Two Deployment Methods

| Method | Best For | Tools |
|--------|----------|-------|
| **Step-by-step API** | Small/dynamic surveys, incremental construction | `create_survey` → `create_question_group` → `create_question` × N → `activate_survey` |
| **Bulk LSS import** | Complete survey design, migration, batch creation | Generate LSS XML → `import_survey_structure` → `activate_survey` |

**Rule of thumb**: Use step-by-step for ≤10 questions. Use LSS import for complete survey designs.

---

## Part 1: LimeSurvey LSRC2 API Reference

### Authentication

```
POST /admin/remotecontrol
Content-Type: application/json
```

**Session flow** (mandatory for every session):
```json
// 1. Get session key
{"method":"get_session_key","params":["admin","password"],"id":1}
→ returns: "abc123sessionkey"

// 2. ... do work using session_key ...

// 3. Always release when done
{"method":"release_session_key","params":["abc123sessionkey"],"id":99}
```

Session keys expire after ~2 hours of inactivity. Always release explicitly.

### Core Survey Methods

| Method | Params | Returns | Notes |
|--------|--------|---------|-------|
| `add_survey` | `session_key, survey_id, title, default_language, survey_format` | survey_id | `survey_id=0` → auto-assign; `survey_format`: `G`, `S`, `A` |
| `set_survey_properties` | `session_key, survey_id, {properties}` | `true`/errors | See survey properties table below |
| `get_survey_properties` | `session_key, survey_id, [prop_names]` | property dict | Empty list = all properties |
| `list_surveys` | `session_key, username` | list of survey dicts | `username` = filter by owner (`null` = all) |
| `activate_survey` | `session_key, survey_id` | status dict | Survey must have at least one group+question |
| `copy_survey` | `session_key, survey_id, new_name` | new survey_id | Full deep copy |
| `delete_survey` | `session_key, survey_id` | `true`/`false` | Permanent — no undo |
| `import_survey` | `session_key, base64_lss_xml, new_name, convert_resources` | survey_id | `convert_resources`: `true`/`false`; LSS or LSA accepted |

### Group Methods

| Method | Params | Returns |
|--------|--------|---------|
| `add_group` | `session_key, survey_id, group_title, group_description` | group_id |
| `list_groups` | `session_key, survey_id` | list of group dicts |
| `get_group_properties` | `session_key, gid, [prop_names]` | property dict |
| `set_group_properties` | `session_key, gid, {properties}` | bool |
| `import_group` | `session_key, survey_id, base64_lsg_xml` | group_id |
| `delete_group` | `session_key, survey_id, gid` | bool |

### Question Methods

| Method | Params | Returns | Notes |
|--------|--------|---------|-------|
| `import_question` | `session_key, survey_id, gid, base64_lsq_xml, mandatory, new_title, new_text, new_help` | question_id | Primary creation method |
| `list_questions` | `session_key, survey_id, gid, language` | list of question dicts | `gid=null` = all groups |
| `get_question_properties` | `session_key, qid, [prop_names], language, short` | property dict | |
| `set_question_properties` | `session_key, qid, {properties}, language` | dict of results | |
| `delete_question` | `session_key, qid` | question_id or error | |

### Response Methods

| Method | Params | Returns |
|--------|--------|---------|
| `export_responses` | `session_key, survey_id, doc_type, language_code, completion_status, heading_type, response_type` | base64 data |
| `import_responses` | `session_key, survey_id, base64_csv` | import count |
| `export_responses_by_token` | `session_key, survey_id, doc_type, token, language_code, ...` | base64 data |
| `get_responses_statistics` | `session_key, survey_id, groupby, statistics_data` | dict |

`doc_type` for export: `csv`, `xls`, `pdf`, `htmlpdf`, `json`

### Participant Methods

| Method | Params | Returns |
|--------|--------|---------|
| `add_participants` | `session_key, survey_id, [{participant_data}], create_token` | list |
| `get_participant_properties` | `session_key, survey_id, token_query_properties, properties` | participant dict |
| `invite_participants` | `session_key, survey_id, [token_ids]` | list |
| `remind_participants` | `session_key, survey_id, [token_ids]` | list |
| `delete_participants` | `session_key, survey_id, [token_ids]` | bool |
| `initialize_token_table` | `session_key, survey_id` | token table info |

Participant dict keys: `firstname`, `lastname`, `email`, `token`, `attribute_1`, etc.

### Survey Properties Reference

Key properties for `set_survey_properties`:

| Property | Type | Values | Description |
|----------|------|--------|-------------|
| `anonymized` | string | `Y`/`N` | Anonymize responses |
| `format` | string | `G`/`S`/`A` | Group-by-group / Single / All-in-one |
| `allowprev` | bool | `0`/`1` | Allow back button |
| `showprogress` | bool | `0`/`1` | Show progress bar |
| `showqnumcode` | bool | `0`/`1` | Show question numbers |
| `startdate` | datetime | ISO format | Survey open date |
| `expires` | datetime | ISO format | Survey close date |
| `active` | string | `Y`/`N` | Survey active status |
| `tokenanswerspersistence` | bool | `0`/`1` | Resume from token |
| `ipanonymize` | bool | `0`/`1` | Anonymize IPs |
| `savetimings` | string | `Y`/`N` | Record timing data |
| `admin` | string | name | Admin name shown to respondents |
| `adminemail` | string | email | Admin contact email |

---

## Part 2: Question Types — Complete Reference

### Type Code Lookup Table

| Code | Name | Input Style | Needs Answers? | Needs Subquestions? |
|------|------|------------|---------------|---------------------|
| `S` | Short free text | Single text line | No | No |
| `T` | Long free text | Textarea | No | No |
| `U` | Huge free text | Large textarea | No | No |
| `Q` | Multiple short text | Multiple labeled textboxes | No | Yes (as answers) |
| `N` | Numerical input | Number field | No | No |
| `K` | Multiple numerical input | Multiple number fields | No | Yes (as answers) |
| `D` | Date/Time | Date picker | No | No |
| `5` | 5 point choice | 1–5 horizontal scale | No | No |
| `L` | List (Radio) | Radio button list | Yes | No |
| `!` | List (Dropdown) | Dropdown select | Yes | No |
| `O` | List with comment | Radio + text comment | Yes | No |
| `M` | Multiple choice | Checkboxes | No | Yes (as answers) |
| `P` | Multiple choice with comments | Checkboxes + text | No | Yes (as answers) |
| `Y` | Yes/No | Yes / No radio | No | No |
| `G` | Gender | Male / Female | No | No |
| `F` | Array | Subquestions × answer scale | Yes (scale) | Yes (rows) |
| `B` | Array (10 point choice) | Subquestions × 1–10 | No (prefilled) | Yes |
| `A` | Array (5 point choice) | Subquestions × 1–5 | No (prefilled) | Yes |
| `C` | Array (Yes/No/Uncertain) | Subquestions × Y/N/U | No (prefilled) | Yes |
| `E` | Array (Increase/Same/Decrease) | Subquestions × I/S/D | No (prefilled) | Yes |
| `H` | Array by column | Transposed array | Yes | Yes |
| `1` | Array dual scale | Two scales per subquestion | Yes (both scales) | Yes |
| `:` | Array (Numbers) | Subquestions × numeric dropdowns | No | Yes (both axes) |
| `;` | Array (Texts) | Subquestions × text inputs | No | Yes (both axes) |
| `R` | Ranking | Drag-to-rank list | Yes | No |
| `I` | Language switch | Language dropdown | No | No |
| `X` | Text display | Display-only (no response stored) | No | No |
| `*` | Equation | Calculated/stored expression | No | No |
| `\|` | File upload | File attachment | No | No |

### Choosing the Right Question Type

| Requirement | Recommended Type |
|-------------|-----------------|
| Short open-ended | `S` |
| Long/detailed open-ended | `T` |
| Multiple separate text inputs | `Q` |
| Single number (age, score) | `N` |
| Multiple numbers | `K` |
| Date or time | `D` |
| Quick 1–5 rating | `5` |
| Single choice from list | `L` (radio) or `!` (dropdown) |
| Single choice + allow comment | `O` |
| Multi-select | `M` |
| Multi-select + want comments | `P` |
| Yes/No | `Y` |
| Likert grid (N items × scale) | `F` |
| Rating grid 1–10 | `B` |
| Rating grid 1–5 | `A` |
| Agree/Neutral/Disagree grid | `C` |
| Preference ranking | `R` |
| Invisible calculation/score | `*` |
| Instructions/separator text | `X` |
| File attachment from user | `\|` |

---

## Part 3: ExpressionScript — Branching & Relevance

### Core Concept

Every question has a `relevance` field (default: `1` = always show).

- If `{expression}` is truthy → question is **shown**
- If `{expression}` is falsy → question is **hidden** and stores `NULL`

Set relevance in the question's `relevance` attribute in LSQ XML or via `set_question_properties`.

### Variable Referencing

| Reference Pattern | Meaning |
|------------------|---------|
| `{Q1}` | Value of question with code `Q1` |
| `{Q1.NAOK}` | Value, treating N/A as OK (prevents cascading errors) |
| `{Q1_SQ001}` | Subquestion `SQ001` within array question `Q1` |
| `{Q1[SQ001]}` | Alternative subquestion notation |
| `{Q1_A1}` | Answer `A1` selected status in multiple choice `Q1` |
| `{Q1_other}` | "Other" text value for question `Q1` |

### Relevance Expression Examples

```
1                              → Always show (default)
!is_empty(Q1)                  → Show only if Q1 has been answered
Q1 == "Y"                      → Show if Yes/No question Q1 is "Yes"
Q1 == "A1"                     → Show if List question Q1 selected answer code A1
Q1 >= 18                       → Show if numeric Q1 is 18 or more
Q1 == "A" && Q2 != ""          → Both conditions must be true
Q1 == "A" || Q1 == "B"         → Either condition
!is_empty(Q1) && !is_empty(Q2) → Both questions answered
Q1_M1 == "Y"                   → Specific checkbox M1 checked in multiple-choice Q1
count(M1.NAOK, M2.NAOK) > 0    → At least one checkbox selected
sum(A1.NAOK, A2.NAOK) >= 3     → Sum of array responses >= 3
```

### Common ExpressionScript Functions

| Function | Signature | Description |
|----------|-----------|-------------|
| `is_empty(x)` | `bool` | True if empty, NULL, or not answered |
| `if(cond, t, f)` | value | Conditional expression |
| `count(...)` | `int` | Count non-empty values in list |
| `sum(...)` | `num` | Sum of numeric values |
| `min(...)` | `num` | Minimum value |
| `max(...)` | `num` | Maximum value |
| `strlen(str)` | `int` | String length |
| `substr(str, start, len)` | `str` | Substring |
| `strpos(haystack, needle)` | `int`/`false` | Find substring |
| `strtolower(str)` | `str` | Lowercase |
| `implode(sep, list)` | `str` | Join with separator |
| `in_array(needle, arr)` | `bool` | Array membership |
| `round(n, decimals)` | `num` | Round to decimal places |
| `abs(n)` | `num` | Absolute value |
| `intval(x)` | `int` | Convert to integer |

### Validation Equations

For `em_validation_q` (question-level validation):
```
is_number(Q1)              → Q1 must be a number
Q1_1 + Q1_2 + Q1_3 == 100 → Sum of subquestions must equal 100
strlen(Q1) <= 200          → Max 200 characters
```

For `em_validation_sq` (subquestion-level validation in arrays):
```
intval(this) >= 1 && intval(this) <= 10   → Each cell must be 1–10
is_empty(this) || intval(this) >= 0       → Zero or positive only
```

---

## Part 4: LSS/LSQ XML Format

### LSS File Structure

```xml
<?xml version="1.0" encoding="UTF-8"?>
<document>
  <LimeSurveyDocType>Survey</LimeSurveyDocType>
  <DBVersion>600</DBVersion>
  <languages><language>en</language></languages>

  <surveys>
    <rows>
      <row>
        <sid><![CDATA[123456]]></sid>
        <gsid>0</gsid>
        <owner_id>1</owner_id>
        <admin><![CDATA[Admin Name]]></admin>
        <adminemail><![CDATA[admin@example.com]]></adminemail>
        <anonymized><![CDATA[N]]></anonymized>
        <format><![CDATA[G]]></format>
        <language><![CDATA[en]]></language>
        <active><![CDATA[N]]></active>
      </row>
    </rows>
  </surveys>

  <surveys_languagesettings>
    <rows>
      <row>
        <surveyls_survey_id><![CDATA[123456]]></surveyls_survey_id>
        <surveyls_language><![CDATA[en]]></surveyls_language>
        <surveyls_title><![CDATA[My Survey Title]]></surveyls_title>
        <surveyls_welcometext><![CDATA[Welcome message here.]]></surveyls_welcometext>
        <surveyls_endtext><![CDATA[Thank you for completing this survey.]]></surveyls_endtext>
        <surveyls_description><![CDATA[Survey description.]]></surveyls_description>
      </row>
    </rows>
  </surveys_languagesettings>

  <groups>
    <rows>
      <row>
        <gid><![CDATA[1]]></gid>
        <sid><![CDATA[123456]]></sid>
        <group_name><![CDATA[Group 1: Demographics]]></group_name>
        <group_order>0</group_order>
        <description><![CDATA[]]></description>
        <randomization_group><![CDATA[]]></randomization_group>
        <grelevance><![CDATA[1]]></grelevance>
      </row>
    </rows>
  </groups>

  <questions>
    <rows>
      <row>
        <qid><![CDATA[1]]></qid>
        <parent_qid>0</parent_qid>
        <sid><![CDATA[123456]]></sid>
        <gid><![CDATA[1]]></gid>
        <type><![CDATA[L]]></type>
        <title><![CDATA[Q1]]></title>
        <preg><![CDATA[]]></preg>
        <help><![CDATA[]]></help>
        <other><![CDATA[N]]></other>
        <mandatory><![CDATA[N]]></mandatory>
        <question_order>1</question_order>
        <scale_id>0</scale_id>
        <same_default>0</same_default>
        <relevance><![CDATA[1]]></relevance>
        <modulename><![CDATA[]]></modulename>
      </row>
    </rows>
  </questions>

  <question_l10ns>
    <rows>
      <row>
        <id><![CDATA[1]]></id>
        <qid><![CDATA[1]]></qid>
        <question><![CDATA[What is your age group?]]></question>
        <help><![CDATA[]]></help>
        <language><![CDATA[en]]></language>
      </row>
    </rows>
  </question_l10ns>

  <answers>
    <rows>
      <row>
        <qid><![CDATA[1]]></qid>
        <code><![CDATA[A1]]></code>
        <sortorder>1</sortorder>
        <assessment_value>0</assessment_value>
        <scale_id>0</scale_id>
      </row>
      <!-- more answer rows -->
    </rows>
  </answers>

  <answer_l10ns>
    <rows>
      <row>
        <id><![CDATA[1]]></id>
        <aid><![CDATA[1]]></aid>
        <answer><![CDATA[18–24 years]]></answer>
        <language><![CDATA[en]]></language>
      </row>
      <!-- more answer l10n rows -->
    </rows>
  </answer_l10ns>

  <question_attributes><rows></rows></question_attributes>
  <defaultvalues><rows></rows></defaultvalues>
</document>
```

### LSQ File Structure (Individual Question)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<document>
  <LimeSurveyDocType>Question</LimeSurveyDocType>
  <DBVersion>600</DBVersion>
  <languages><language>en</language></languages>
  <questions><rows>
    <row>
      <qid>1</qid>
      <parent_qid>0</parent_qid>
      <type><![CDATA[L]]></type>
      <title><![CDATA[Q1]]></title>
      <other><![CDATA[N]]></other>
      <mandatory><![CDATA[N]]></mandatory>
      <question_order>1</question_order>
      <scale_id>0</scale_id>
      <relevance><![CDATA[1]]></relevance>
    </row>
  </rows></questions>
  <question_l10ns><rows>
    <row>
      <qid>1</qid>
      <question><![CDATA[Your question text here?]]></question>
      <language><![CDATA[en]]></language>
    </row>
  </rows></question_l10ns>
  <answers><rows>
    <!-- For L, M, F, etc. — answer rows with code, sortorder, scale_id -->
  </rows></answers>
  <answer_l10ns><rows>
    <!-- answer text per language -->
  </rows></answer_l10ns>
  <question_attributes><rows></rows></question_attributes>
  <defaultvalues><rows></rows></defaultvalues>
</document>
```

**Sending to API**:
```python
import base64
lsq_bytes = lsq_xml_string.encode("utf-8")
base64_lsq = base64.b64encode(lsq_bytes).decode("utf-8")
# Then pass to import_question(session_key, survey_id, gid, base64_lsq, ...)
```

### Subquestions in Arrays/Multiple Choice

For question types that need subquestions (`F`, `M`, `P`, `Q`, `K`, `A`, `B`, `C`, `E`, `:`, `;`), subquestions are represented as `<row>` entries in `<questions>` with `<parent_qid>` pointing to the parent question, and `<scale_id>` = 0 (rows) or 1 (columns for dual-axis types).

---

## Part 5: Workspace MCP Server

**Path**: `code/src/limesurvey/mcp_server/`

**Requirements**:
```bash
# Install package
cd code && uv sync

# Set env vars
export LIMESURVEY_URL="http://your-limesurvey/index.php"
export LIMESURVEY_USERNAME="admin"
export LIMESURVEY_PASSWORD="password"

# Run server
uv run python -m limesurvey.mcp_server.server
```

**Claude Desktop config snippet** (from quickstart.md):
```json
{
  "mcpServers": {
    "limesurvey": {
      "command": "uv",
      "args": ["run", "--directory", "/path/to/code", "python", "-m", "limesurvey.mcp_server.server"],
      "env": {
        "LIMESURVEY_URL": "http://your-limesurvey/index.php",
        "LIMESURVEY_USERNAME": "admin",
        "LIMESURVEY_PASSWORD": "password"
      }
    }
  }
}
```

### Available MCP Tools

| Tool | Description |
|------|-------------|
| `list_surveys` | List all surveys (id, title, status) |
| `get_survey` | Get survey details by survey_id |
| `create_survey` | Create a new bare survey |
| `update_survey` | Set survey properties |
| `activate_survey` | Activate survey for responses |
| `copy_survey` | Clone an existing survey |
| `delete_survey` | Permanently delete a survey |
| `list_question_groups` | List all groups in a survey |
| `create_question_group` | Add a question group |
| `delete_question_group` | Remove a question group |
| `list_questions` | List questions (optionally per group) |
| `create_question` | Add a question via LSQ XML generation |
| `delete_question` | Remove a question |
| `export_survey_structure` | Export survey as LSS/LSA file |
| `import_survey_structure` | Import survey from LSS/LSA |
| `list_participants` | List participant token records |
| `add_participants` | Add participants to survey |
| `create_participant_table` | Initialize participant token table |
| `export_responses` | Export responses (csv/json) |

### create_question Input Schema

```python
{
    "survey_id": 123456,
    "group_id": 1,
    "question_data": {
        "code": "Q1",           # Required: starts with letter, alphanumeric only
        "text": "Question?",    # Required: question text
        "type": "L",            # Required: type code from table above
        "mandatory": "Y",       # "Y" or "N"
        "help_text": "",        # Optional helper text
        "other": "N",           # Add "Other:" option ("Y"/"N")
        "relevance": "1",       # ExpressionScript relevance equation
        "answers": [            # Required for L, !, M, P, O, F, ...
            {"code": "A1", "text": "Option 1"},
            {"code": "A2", "text": "Option 2"}
        ]
    }
}
```

---

## Part 6: Alternative Implementations

### TonisOrmisson/limesurvey-mcp (TypeScript MCP)

For Node.js/TypeScript environments or when full LSRC2 API coverage is needed.

```bash
# Install
npm install -g limesurvey-mcp

# Configure .env
LIMESURVEY_API_URL=http://your-server/index.php/admin/remotecontrol
LIMESURVEY_USERNAME=admin
LIMESURVEY_PASSWORD=password
READONLY_MODE=true  # Optional: safe exploration mode
```

**Additional tools vs workspace MCP**: quota management, language management, file upload, participant invitation/reminders.

Source: https://github.com/TonisOrmisson/limesurvey-mcp

### citric (Python Low-Level Client)

For custom scripts or when building new tools outside the MCP framework.

```python
import citric

with citric.Client(
    "http://your-limesurvey/index.php/admin/remotecontrol",
    "admin",
    "password"
) as client:
    # Create survey
    sid = client.add_survey(0, "Survey Title", "en", "G")

    # Add group
    gid = client.add_group(sid, "Group 1", "Description")

    # Import question from LSQ bytes
    with open("question.lsq", "rb") as f:
        qid = client.import_question(f, sid, gid)

    # Activate
    client.activate_survey(sid)

    # Export responses as CSV
    data = client.export_responses(sid, "csv")
    # data is raw bytes, decode as needed
```

Install: `pip install citric`
Docs: https://citric.readthedocs.io

---

## Part 7: AI Survey Design Workflow

Use this structured workflow when an AI assistant (Claude, Copilot) generates a survey.

### Step 1: Requirements Elicitation

Ask the user for:
1. **Topic & purpose** — What is the survey measuring? Who are the respondents?
2. **Scale** — Estimated number of questions (ballpark)
3. **Language** — Primary language (default: `en`)
4. **Format** — All on one page, group-by-group, or one question at a time?
5. **Branching needs** — Any conditional logic? (e.g., "skip section B if answer is X")
6. **Question types needed** — Open text, scales, multiple choice, grids?
7. **Mandatory fields** — All required, or selective?
8. **Response collection** — Tokens/participants, or open/anonymous?
9. **Activation** — Should the survey be activated immediately or left as draft?

### Step 2: Survey Structure Design

Organize questions into logical groups. Recommended structure:

```
Group 1: Introduction / screening
  → Qualifying question with branching if needed
Group 2: Core topic section 1
  → Related questions, consistent type theme
Group N: Demographics (if needed)
  → Standard demographic questions
```

Validate before generating:
- [ ] Each group has a descriptive name
- [ ] Question codes are unique across ALL groups
- [ ] Question codes start with a letter, alphanumeric only (no spaces, no special chars)
- [ ] Question codes are ≤20 characters ideally
- [ ] All `relevance` expressions reference existing question codes
- [ ] Array/multiple-choice questions have appropriate answers defined

### Step 3: Select Question Types

Match each requirement to a type code using the table in Part 2.

**Common patterns**:

| Survey Design Pattern | Types to Use |
|-----------------------|-------------|
| NPS / satisfaction score | `5` or `L` with 1–10 answers |
| Demographic profile | `L` (age group), `G` (gender), `S` (free text for location) |
| Likert scale feedback | `F` (array) or multiple `5`/`L` per item |
| Screening question with skip | `L` or `Y` + ExpressionScript on next group |
| Multi-topic assessment | `F` per section or `A`/`B` arrays |
| Open qualitative feedback | `T` or `U` with optional `M` for category selection |
| Event/time collect | `D` |
| Document upload | `\|` |

### Step 4: Write ExpressionScript Logic

For each branching requirement:

1. Identify the **trigger question** (the one whose answer controls display)
2. Identify the **target question(s)** to show/hide
3. Write the relevance equation for each target

**Template**:
```
Requirement: "Show Q5 only if Q3 answer is 'Yes'"
  Q3 type: Y (Yes/No)
  Q5 relevance: {Q3 == "Y"}

Requirement: "Skip section B if Q1 says 'No'"
  Group 2 (section B) grelevance: {Q1 == "Y"}

Requirement: "Show follow-up if checkbox M1 is selected"
  Q1 type: M (multiple choice), code Q1, subquestion code SQ001
  Q2 relevance: {Q1_SQ001 == "Y"}
```

### Step 5: Choose Deployment Method

| Condition | Use |
|-----------|-----|
| ≤10 linear questions, no complex grouping | Step-by-step MCP tools |
| Full survey design, complex structure | LSS import |
| Modifying existing survey | Targeted `create_question` + `delete_question` |
| Survey template reuse | `copy_survey` + modifications |

**Step-by-step flow**:
```
1. create_survey(title, language, format)
   → survey_id

2. For each group:
   create_question_group(survey_id, group_name)
   → group_id

3. For each question in group:
   create_question(survey_id, group_id, question_data)
   → question_id

4. activate_survey(survey_id)  ← only when ready
```

**LSS import flow**:
```
1. Generate complete LSS XML (use lss_generator.py or write manually)
2. import_survey_structure(base64_lss)
   → survey_id
3. get_survey(survey_id)  ← verify structure
4. activate_survey(survey_id)  ← only when ready
```

### Step 6: Validation Checklist

Before calling `activate_survey`:
- [ ] All questions visible in `list_questions`
- [ ] Spot-check relevance expressions reference valid question codes
- [ ] Mandatory questions marked `"Y"` where intended
- [ ] Answer codes for `L`, `M`, `F` etc. are non-empty
- [ ] Survey has at least one group and one question
- [ ] `format` is set appropriately (`G`/`S`/`A`)

---

## Part 8: Common Errors and Fixes

| Error | Cause | Fix |
|-------|-------|-----|
| `Invalid session key` | Session expired or not obtained | Re-call `get_session_key` |
| `Error: No permission` | Wrong credentials or insufficient rights | Check username/password, ensure admin role |
| `import_question` returns error | Invalid LSQ XML or wrong Base64 encoding | Validate XML structure; check `DBVersion`; verify Base64 |
| `Survey not found` | Wrong survey_id | Call `list_surveys` to confirm correct ID |
| Question code error | Code contains spaces or special chars, or starts with number | Fix: alphanumeric, starts with letter |
| ExpressionScript not working | Variable name mismatch | Check exact question `title` (code) in database; use `get_question_properties` |
| `delete_survey` fails | Survey is active | Deactivate first via `set_survey_properties(sid, {"active": "N"})` |
| Import fails silently | `DBVersion` mismatch | Update `DBVersion` in LSS XML to match LS version (600 for LS 6.x, 500 for LS 5.x) |

---

## Part 9: Related Tools and Libraries

### citric (Python)
- Install: `pip install citric`
- Docs: https://citric.readthedocs.io
- Full LSRC2 coverage; context manager; no XML generation

### TonisOrmisson/limesurvey-mcp (TypeScript)
- GitHub: https://github.com/TonisOrmisson/limesurvey-mcp
- npm: `limesurvey-mcp`
- ~40 tools; good for Node.js environments; no LSS/LSQ generation

### limonaid (R)
- CRAN: https://cran.r-project.org/package=limonaid
- R6 OOP survey generation; exports to LSS/LSQ XML
- API integration available but had issues with LS 6.x JSON parsing changes
- Best for academic/R workflows

### aitoolsforsurvey.com
- Commercial SaaS: AI-to-LSS conversion
- Closed source; no API/skill equivalent open-sourced

---

## Research Notes

- **Gap confirmed**: No open-source Claude/Copilot/AI skill for LimeSurvey survey generation exists (as of 2026-03-01)
- **This SKILL.md is novel**: First documented AI workflow skill for LimeSurvey
- **Research session**: `notes/research-tracking/sessions/20260301-limesurvey-api-mcp/`
- **Sources**: 10 sources across official docs, open-source libraries, community Q&A
