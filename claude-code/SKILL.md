---
name: ask-perplexity
description: Ask Perplexity AI to get a consolidated, sourced answer from across the web. Use when you need synthesized information from many sources — not just a web search, but an analyzed answer with citations.
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

   **Exception for `sonar-deep-research`**: the script saves the full response to a file (to avoid flooding the chat) and prints only the file path. After running:
   - Read the saved file
   - Provide the user with a 3–5 point summary of the key findings
   - Tell the user the full path to the file for reference

## Model selection

Choose the model based on the nature of the request. Do not ask the user — decide yourself.

| Model | When to use |
|-------|-------------|
| `sonar` | Quick fact, API clarification, short question (default) |
| `sonar-pro` | Plan review, architectural decision, research question |
| `sonar-reasoning-pro` | Multi-step reasoning, complex analysis |
| `sonar-deep-research` | Comprehensive synthesis from many sources |

## When to use this skill

Use when you need a consolidated, analyzed answer from many web sources — not just a search result.

- Unfamiliar APIs, libraries, formats
- Third-party system behavior or platform quirks
- Up-to-date information not in training data
- External validation before planning or implementation
- Plan or architecture review from an external perspective