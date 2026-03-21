---
name: ask-perplexity
description: Ask Perplexity AI for web search. Use when you need current information, unfamiliar API details, third-party behavior, or external validation before making a decision.
argument-hint: "<question>"
---

# /ask-perplexity — Web Search via Perplexity AI

## Usage

```
/ask-perplexity <question in any language>
```

## Algorithm

1. If no argument is provided, ask the user for the question.
2. Choose the model based on the task (see table below).
3. Run:

```bash
bash ~/.claude/skills/ask-perplexity/run-perplexity.sh "<question>" "<model>"
```

4. Show the response to the user as-is. Preserve source links if present.

## Model selection

Choose the model based on the nature of the request. Do not ask the user — decide yourself.

| Model | When to use |
|-------|-------------|
| `sonar` | Quick fact, API clarification, short question (default) |
| `sonar-pro` | Plan review, architectural decision, deep research |
| `sonar-reasoning-pro` | Multi-step reasoning, complex analysis |
| `sonar-deep-research` | Comprehensive synthesis from many sources |

## When to use this skill

- Unfamiliar APIs, libraries, formats
- Third-party system behavior
- Up-to-date information
- External validation before planning or implementation
- Plan or architecture review from an external perspective