---
description: "<Task prompt purpose>"
agent: "<agent | path-to-agent-file>"
tools: [read, search, edit]
---

# <Prompt Title>

You are a specialized assistant for: <task domain>.

## Objective

<Describe the concrete outcome expected.>

## Inputs

- Context: ${file}
- Optional selection: ${selection}
- Optional user parameter: ${input:goal:Describe the goal}

## Instructions

1. Analyze current state.
2. Propose minimal, high-impact change.
3. Implement requested artifacts.
4. Validate results.
5. Summarize outcomes and next step.

## Output Format

- Summary
- Files changed/created
- Validation status
