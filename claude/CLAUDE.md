# General instructions

## Language

- Always use English for code (variable names, function declarations, ...) and comments.
- Reply to the user in the language used by the user.

## Code

### Guidelines

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:

- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- Ask before you implement "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" or remove adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:

- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

### Comments

Focus on intent and current state. Avoid historical references to past bugs.

| Style            | Example                                                       |
| :--------------- | :------------------------------------------------------------ |
| **Anti-Pattern** | `// Workaround for yyyy not working in NL locale`             |
| **Preferred**    | `// Use language-neutral date format for locale independence` |

### Documentation

- If the project has a README.md and a new feature is introduced that is noteworthy, ask to add this feature to the README.md.

### Python

- Use `uv` for dependency management, running scripts, and virtual environments.
- Always add type annotations to function signatures (parameters and return type).
- Use `ty` (https://github.com/astral-sh/ty) as the static type checker.
- Every function must have a docstring directly under the `def` line, using `"""..."""`, as a short one-line description.
- Variables, identifiers, docstrings, and comments are always in English.
- Use `ruff` for linting and `ruff format` for formatting, following ruff's default guidelines.
- Use `pytest` as the default testing framework.
- Keep all tool configuration (ruff, ty, pytest) centralized in `pyproject.toml` rather than scattered config files.
- Prefer `pathlib` over `os.path` for filesystem path handling.

### Go

- Always format code with `gofmt`/`goimports` — non-negotiable, no style debates.
- Use `golangci-lint` (aggregates `go vet`, `staticcheck`, etc.) as the standard linter.
- Handle errors explicitly with `if err != nil`; wrap with `fmt.Errorf("...: %w", err)` for context; never silently swallow errors.
- Use the standard library `testing` package with table-driven tests; no external assertion library (no `testify`).
- Doc comments start with the identifier name (e.g. `// FuncName does X`) so `go doc`/godoc render correctly.
- Use `go mod` for module and dependency management.
- Use idiomatic short names for local scope; capitalize exported identifiers and give them doc comments.
- Follow standard Go project layout: `cmd/` for entrypoints, `internal/` for private packages, `pkg/` for exported/reusable packages.

## Git

- Always ask before committing.
- When the user starts asking about a new feature and the previous one is uncommitted, ask if they want to commit first.
- Always use the format `(commit type): description` for commits.
- Use one of the following commit types: (feat), (fix), (bug), (chore), (refactor), (style), (doc), (sec), (perf)
