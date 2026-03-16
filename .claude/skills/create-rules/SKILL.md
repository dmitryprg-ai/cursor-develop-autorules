---
name: create-rules
description: "Create new skills, modify and improve existing skills, create or update AI rules. Use when creating rules, building skills, adding coding standards, updating .claude/rules/ or .claude/skills/, converting Cursor rules to Claude Code, measuring skill performance, running evals, or optimizing skill descriptions."
allowed-tools: Read, Write, Bash, Grep, Glob
model: sonnet
user-invocable: true
---

# Create Rules and Skills

Build AI instructions that actually trigger and work. Follow the iterative loop: **draft -> test -> evaluate -> improve -> repeat**.

## Core Loop

1. **Capture intent** — what capability, when to trigger, what output format
2. **Draft** the rule or skill
3. **Create test cases** (evals) — 2-3 realistic prompts
4. **Evaluate** results qualitatively
5. **Improve** based on feedback
6. **Optimize description** for triggering accuracy

## Writing a Rule (.claude/rules/)

Claude Code uses `.md` files with YAML frontmatter:

```yaml
---
description: "Apply when [specific context]. [What it does] for [outcome]."
paths:
  - "src/**/*.ts"
  - "apps/web/**/*.tsx"
---
```

| Trigger Type | Config | When Loaded |
|-------------|--------|-------------|
| Always | No description, no paths | Every conversation |
| Path-scoped | `paths: [globs]` | When matching file is active |
| Agent-decided | `description: "..."` | AI decides from description |

## Writing a Skill (.claude/skills/)

```
skill-name/
├── SKILL.md          # Required: frontmatter + instructions
├── scripts/          # Optional: executable scripts
├── references/       # Optional: heavy templates, detailed docs
├── assets/           # Optional: templates, icons
└── evals/
    └── evals.json    # Test cases with assertions
```

### Frontmatter

```yaml
---
name: my-skill                # kebab-case, max 64 chars
description: "Max 1024 chars, no angle brackets (<>). Be pushy — list
  contexts, triggers, error patterns, user-observable symptoms."
allowed-tools: Read, Write, Bash, Grep, Glob
model: sonnet
user-invocable: true          # appears in /commands
---
```

### Pushy Descriptions

Descriptions determine when the skill triggers. Write them "a little bit pushy" to combat under-triggering because skills that don't activate are useless:

```
BAD:  "Deploy the application"
GOOD: "Deploy backend and/or frontend services. Use after npm run build
       completes, when restarting services, when user mentions deploy/build/
       restart, or when page shows Application error. Trigger on: build
       success, 502/503 errors, service health check failures."
```

Include: task names, error patterns, user phrases, observable symptoms.

### Body Writing Principles

1. **Explain WHY** — reasoning helps the model understand importance. Reframe rigid demands:
   - Instead of: "NEVER use empty catch blocks"
   - Write: "Avoid empty catch blocks because errors disappear silently, making bugs compound over time"

2. **Lean instructions** — remove anything that doesn't change behavior. Read transcripts: if the model wastes time on a step, eliminate it.

3. **Progressive disclosure** — SKILL.md under 500 lines. Move templates, checklists, and examples to `references/` with explicit pointers.

4. **Bundle repeated work** — if tests always create the same helper script, move it to `scripts/` and reference it.

5. **Theory of mind** — write instructions that generalize, not narrow examples. The skill will be used in millions of contexts.

## Creating Evals

After drafting, create test cases representing real user language:

```json
// evals/evals.json
{
  "skill_name": "my-skill",
  "evals": [
    {
      "id": 1,
      "prompt": "Realistic user request in natural language",
      "expected_output": "Description of successful result",
      "assertions": [
        "Output includes specific element X",
        "File was created at correct path",
        "No errors in execution"
      ]
    }
  ]
}
```

### Trigger Eval Queries

Test whether the description triggers correctly with 20 realistic queries:

```json
// evals/trigger-eval.json
[
  {"query": "specific realistic user request", "should_trigger": true},
  {"query": "near-miss that should NOT trigger", "should_trigger": false}
]
```

Make should-trigger queries varied (formal, casual, with typos). Make should-not-trigger queries tricky near-misses, not obviously irrelevant.

## When Rule vs Skill

| Use Case | Format | Why |
|----------|--------|-----|
| Short constraint (<50 lines) | Rule | Always/auto loaded, low token cost |
| Multi-step workflow | Skill | Structured, scriptable, loaded on demand |
| Needs scripts/templates | Skill | Can include scripts/, references/ |
| Specific task type | Skill | Only loaded when relevant |

## Validation Checklist

After creating/updating:
1. Re-read the file (verify content matches intent)
2. Frontmatter: name is kebab-case, description < 1024 chars, no `<>`
3. SKILL.md: under 500 lines
4. Evals: at least 2-3 test cases with assertions
5. Description: includes contextual triggers, not just task names

## References

- [rule-template.md](assets/rule-template.md) — standard rule template
- [schemas.md](references/schemas.md) — JSON schemas for evals, grading, benchmarks
