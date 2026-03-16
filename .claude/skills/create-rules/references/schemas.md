# JSON Schemas for Skills

## evals.json

Located at `evals/evals.json` within skill directory.

```json
{
  "skill_name": "example-skill",
  "evals": [
    {
      "id": 1,
      "prompt": "Realistic user task description",
      "expected_output": "Description of successful result",
      "files": [],
      "assertions": [
        "Output contains expected element",
        "File was created at correct path",
        "No errors during execution"
      ]
    }
  ]
}
```

| Field | Required | Description |
|-------|----------|-------------|
| skill_name | Yes | Must match SKILL.md frontmatter name |
| evals[].id | Yes | Unique integer per test |
| evals[].prompt | Yes | Natural language task description |
| evals[].expected_output | Yes | What success looks like |
| evals[].files | No | Input file paths relative to skill root |
| evals[].assertions | No | Verifiable criteria for grading |

## trigger-eval.json

Located at `evals/trigger-eval.json`. Tests description triggering accuracy.

```json
[
  {"query": "realistic user request", "should_trigger": true},
  {"query": "near-miss that shouldn't trigger", "should_trigger": false}
]
```

Target: 8-10 should-trigger (varied phrasings) + 8-10 should-not-trigger (tricky near-misses).

## grading.json

Output from evaluating test runs against assertions.

```json
{
  "expectations": [
    {
      "text": "Assertion description",
      "passed": true,
      "evidence": "Supporting details or output snippet"
    }
  ]
}
```

Field names must be exactly `text`, `passed`, `evidence`.

## timing.json

Captured from test run metrics.

```json
{
  "total_tokens": 84852,
  "duration_ms": 23332,
  "total_duration_seconds": 23.3
}
```

## benchmark.json

Aggregate comparison between skill versions or with/without skill.

```json
{
  "metadata": {
    "skill_name": "my-skill",
    "timestamp": "2026-03-13T12:00:00Z"
  },
  "run_summary": {
    "with_skill": {
      "pass_rate": {"mean": 0.85, "stddev": 0.1},
      "time_seconds": {"mean": 23.3, "stddev": 5.2},
      "tokens": {"mean": 84852, "stddev": 12000}
    },
    "without_skill": {
      "pass_rate": {"mean": 0.45, "stddev": 0.15}
    }
  },
  "delta": {
    "pass_rate": "+0.40",
    "time_seconds": "+2.1"
  }
}
```

## eval_metadata.json

Per test case metadata for detailed analysis.

```json
{
  "eval_id": 0,
  "eval_name": "descriptive-name-here",
  "prompt": "The user's task prompt",
  "assertions": []
}
```

Use descriptive names based on what's being tested, not generic "eval-0".
