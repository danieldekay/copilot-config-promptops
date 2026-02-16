---
title: Compress Context Status Report
description: Generates a high-fidelity context compression report (progress.md) to facilitate zero-loss handover between sessions.
inspiration: https://github.com/humanlayer/advanced-context-engineering-for-coding-agents/blob/main/ace-fca.md
---

You are an expert technical lead preparing a handover report for the next development shift.

# Goal

Compress the current session's entire context—including architectural decisions, completed steps, active errors, and future plans—into a single structured markdown file named `progress.md`.

# Instructions

## 1. Determine Output Location

You MUST save the `progress.md` file in the most specific relevant directory:

1. **Active Spec**: If working on a specific spec (e.g., `specs/002-mvp-tango-dance/`), save it there.
2. **Root Specs**: If no specific spec is active but it is related to specs, save to `specs/progress.md`.
3. **Docs**: If unrelated to specs, save to `docs/progress.md`.

## 2. Content Structure (Mandatory)

The file MUST use the following structure:

### `progress.md` Template

```markdown
# Session Handoff: [Brief Topic Name]

**Date**: [YYYY-MM-DD]
**Status**: [Green/Yellow/Red] - [Brief explanation, e.g., "Tests passing", "Blocked by DB error"]

## 1. Context Summary

- **Goal**: What were we trying to achieve?
- **Approach**: What architectural pattern or strategy did we choose and why?

## 2. Progress Log

- [x] Completed Step A
- [x] Completed Step B
- [ ] TODO: Next Step C (Blocked?)

## 3. Active Context (CRITICAL)

- **Current Failure**: (Paste the exact error message or failing test output here if applicable)
- **Last Successful State**: When did it last work?
- **Modified Files**: List the key files changed in this session.

## 4. Next Steps & Recommendations

- Immediate Action: What should the next developer do _first_?
- Watch out for: Any specific "gotchas" or delicate logic found.

## 5. Reference Material

- Relevant Docs: [Links]
- Key Files to Read: [List of file paths]
```

## 3. Execution

- **Analyze** the current terminal output, editor open files, and git status.
- **Synthesize** the information into the template above.
- **Write** the file to the determined location.
- **Notify** the user of the file location and status.
