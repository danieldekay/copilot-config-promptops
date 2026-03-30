---
description: 'Guidelines for GitHub Copilot to write comments to achieve self-explanatory code with less comments. Examples are in JavaScript but it should work on any language that has comments.'
applyTo: '**/*, **/*.js, **/*.jsx, **/*.ts, **/*.tsx, **/*.py, **/*.java, **/*.go, **/*.rb, **/*.php'
---

# Self-Explanatory Code Commenting

## Core Rule

- Write self-explanatory code first.
- Add comments only when they explain why, constraints, tradeoffs, or non-obvious behavior.
- If better naming or structure removes the need for a comment, refactor instead.

## Write Comments For

- Complex business rules.
- Non-obvious algorithms or implementation choices.
- Regexes, parsing rules, and tricky transformations.
- External system constraints, limits, or framework gotchas.
- Important assumptions, edge cases, mutation, performance, or security concerns.
- Public APIs when the language or project expects API documentation.
- Actionable annotations such as `TODO`, `FIXME`, `HACK`, `NOTE`, `WARNING`, `PERF`, `SECURITY`, `BUG`, `REFACTOR`, and `DEPRECATED`.

## Do Not Write Comments For

- Obvious statements of what the code already says.
- Comments that repeat variable names, function names, or control flow.
- Decorative divider comments.
- Changelog or authorship comments.
- Commented-out dead code.
- Comments that are likely to drift from the implementation.

## Comment Quality Rules

- Keep comments short, precise, and accurate.
- Place comments directly above the code they describe.
- Use professional language and correct grammar.
- Keep comments current when the code changes.
- Prefer one clear reason over multiple vague sentences.

## Review Checklist

- The code is clear without relying on comments.
- Each comment adds information the code does not already show.
- Each comment explains why or captures a real constraint.
- No redundant, stale, or decorative comments remain.
- The best comment is still the one you do not need to write.
