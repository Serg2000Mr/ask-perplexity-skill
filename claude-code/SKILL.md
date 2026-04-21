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

## Hallucinations — fact-check every factual claim

Perplexity composes its answer from retrieved sources plus an LLM, and it regularly hallucinates. Typical failure modes:

- **Invented CVE numbers, paper titles, product names, version tags** that look plausible but do not exist.
- **Misattributed quotes** — a statement that is real is attached to the wrong source.
- **Stale or fixed issues presented as current** — a patched vulnerability described as active.
- **Misstated APIs, flags, exit codes** — "use exit 2 to block" when the doc says "exit 0 + JSON".
- **Composite fabrications** — two real facts are stitched together into a claim that is false as a whole.

**Required discipline when using this skill**:

1. Treat every factual claim as a hypothesis, not as ground truth — especially when the claim would change your plan, your code, or an architectural decision.
2. Verify any named entity before acting on it: CVE IDs against the NVD or the original advisory, product names on vendor sites, APIs against official docs, version tags in the actual changelog.
3. Prefer primary sources from the `Sources:` block over Perplexity's paraphrase. If Perplexity claims a quote from a doc, open that doc and re-read the relevant section.
4. Do not copy assertions into code, plans, or reports without an independent confirmation.
5. If the same claim is critical and cannot be independently verified, mark it explicitly as unverified when you relay it to the user, or drop it.

The skill is valuable as an external synthesizer and pointer to sources. Its summaries are not evidence.