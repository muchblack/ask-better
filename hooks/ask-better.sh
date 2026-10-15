#!/bin/sh
# ask-better hook: inject a short prompt-coaching instruction. Never blocks.
#   sh ask-better.sh       Claude Code / Codex UserPromptSubmit (every message)
#   sh ask-better.sh agy   Antigravity CLI SessionStart (once per session)
# Turn off by creating the off file (see README).

[ -e "${XDG_CONFIG_HOME:-$HOME/.config}/ask-better/off" ] && exit 0

# JSON-escaped string.
TEXT='[ask-better] For each user message: do the task normally first. Then, ONLY if the message has a gap that would make another person or AI misread it or need a follow-up question, and earlier context does not already fill it, append ONE final line in the user'"'"'s language: `💡 <what is missing>. e.g. \"<better phrasing>\"` (translate the label naturally). Gaps: goal vs step (XY problem); missing raw error, output or repro; expected vs actual; unclear scope or done-condition (analyze only / edit / commit); guesses stated as facts; what was already tried; several unrelated decisions in one message. Stay silent if the message is clear, a short reply, an option pick, a slash command, chit-chat, or the same gap was already pointed out this session. Never refuse or delay the task because of this.'

if [ "${1:-}" = agy ]; then
  printf '{"injectSteps":[{"systemMessage":{"systemMessage":"%s"}}]}\n' "$TEXT"
else
  printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"%s"}}\n' "$TEXT"
fi
