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
2. Run:

```bash
bash ~/.claude/skills/ask-perplexity/run-perplexity.sh "$ARGUMENTS"
```

3. Show the response to the user as-is.
4. Preserve source links if they are present in the output.

## When to use

- Unfamiliar APIs, libraries, formats
- Third-party system behavior
- Up-to-date information
- External validation before planning or implementation
