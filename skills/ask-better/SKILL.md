---
name: ask-better
description: >-
  Prompt coach based on ESR's "How To Ask Questions The Smart Way". Reviews
  how the user phrased a request and shows how to make it clearer to another
  person or AI: what is missing and a rewritten version. Use when the user
  asks to review, improve or rewrite a question or prompt ("is this a good
  way to ask", "how should I ask this", "review my prompt"), or runs
  /ask-better. "/ask-better off" and "/ask-better on" toggle the automatic
  per-message hint.
---

# Ask Better

Coach the user to ask clearer questions, following ESR's
[How To Ask Questions The Smart Way](http://www.catb.org/~esr/faqs/smart-questions.html).
Never get in the way: the user's actual task always comes first.

## Commands

| Input | Action |
|-------|--------|
| `/ask-better <text>` | Full review of `<text>` |
| `/ask-better` | Full review of the user's previous message |
| `/ask-better off` | Create `${XDG_CONFIG_HOME:-$HOME/.config}/ask-better/off` (mkdir -p first). Stops the automatic hint. |
| `/ask-better on` | Delete that file. Restores the automatic hint. |

The automatic one-line hint after every reply comes from the plugin's
`UserPromptSubmit` hook, not from this skill.

## Checklist

Flag only gaps that would make the reader do the wrong thing or come back
with a question. Anything earlier context already supplies is not a gap.

1. **Goal vs step (XY problem)**: asks about one step without the end goal.
2. **Raw symptom**: reports a failure with no error text, command output or
   repro steps, only "it's broken".
3. **Expected vs actual**: doesn't say what should happen and what did.
4. **Scope and done-condition**: unclear whether to only analyze, edit, or
   commit; or which project, file or branch.
5. **Guesses as facts**: a suspected cause stated as known.
6. **Already tried**: a debugging request that doesn't say what was tried,
   inviting repeat suggestions.
7. **Bundled decisions**: several unrelated asks in one message, so one
   gets dropped.

## Full review output

Reply in the user's language:

```
## Prompt review

**Original**: <the user's text>

**Gaps** (most important first)
1. <checklist item> — <what exactly is missing>
(No gaps → say it's clear and stop.)

**Rewrite**
<a version the user can copy as-is>
```

Never invent facts the user didn't give. Mark missing information with a
placeholder such as `<paste the exact error here>`.
