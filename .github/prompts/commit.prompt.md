---
model: Raptor mini (Preview)
---

You are an expert developer following strict Git best practices and Conventional Commits.

# Goal

Analyze the current changes and generate one or more `git commit` commands to commit all changes.

# Instructions

## 1. Analysis & Grouping (Atomic Commits)

- Analyze the `git status` and `git diff` of the workspace.
- **Group related files together**: Do not blindly commit everything at once unless they are all part of the same logical change.
- Split unrelated changes (e.g., a bug fix and a formatting change) into separate commits.

## 2. Commit Message Format

Use the **Conventional Commits** standard:

```
<type>(<scope>): <subject>

[optional body]

[optional footer(s)]
```

### Types

- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code (white-space, formatting, etc)
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `chore`: Changes to the build process or auxiliary tools and libraries
- `ci`: Changes to CI configuration files and scripts

### Style Rules

- **Subject**:
  - Imperative mood ("Add feature" not "Added feature").
  - No period at the end.
  - Maximum 50 characters ideally, 72 absolute max.
  - Lowercase (unless proper noun).
- **Body**:
  - Explain **what** and **why** (context), not just *how*.
  - Wrap lines at 72 characters.
- **Scope**:
  - Optional but recommended (e.g., `auth`, `api`, `deps`).

## 3. Execution

- Output the `git commit` commands.
- Use `git add <files>` followed by `git commit -m "..."`.
