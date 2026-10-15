# ask-better

**English** | [正體中文](README.zh-TW.md)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

A prompt coach for AI coding agents, based on Eric S. Raymond's
[How To Ask Questions The Smart Way](http://www.catb.org/~esr/faqs/smart-questions.html).

Your agent does the task as usual. If your request had a gap that made it
guess or would make another person ask back, it adds **one line** at the end
of its reply:

```
💡 No error text was included. e.g. "npm run build fails with <paste the error>; it worked before I upgraded Vite."
```

If the request was clear, it says nothing. It never blocks or delays the task.

## What it checks

1. **Goal vs step** — asking about one step without the end goal (the XY problem)
2. **Raw symptom** — "it's broken" with no error text, output or repro
3. **Expected vs actual** — what should happen, and what did
4. **Scope and done-condition** — analyze only, edit, or commit? Which project or file?
5. **Guesses as facts** — a suspected cause stated as known
6. **Already tried** — what you ruled out, so it isn't suggested again
7. **Bundled decisions** — several unrelated asks in one message

## Install

| Host | Command | Per-message hint | `/ask-better` review |
|------|---------|:---:|:---:|
| Claude Code | `/plugin marketplace add muchblack/ask-better`<br>`/plugin install ask-better@ask-better` | ✅ | ✅ |
| Codex CLI | `codex plugin marketplace add https://github.com/muchblack/ask-better.git`<br>`codex plugin add ask-better@ask-better` | ✅ | ✅ (`$ask-better:ask-better`) |
| Antigravity CLI | `agy plugin install https://github.com/muchblack/ask-better` | ✅ ¹ | ✅ |

- **Codex** asks you to trust the hook the first time it runs.
- ¹ **Antigravity CLI** has no hook for each sent message, so the instruction
  is injected once at `SessionStart` and stays in the conversation. Turning it
  off or on takes effect from the next session.
- The hook is a POSIX `sh` script with no other dependencies. On Windows,
  Claude Code runs hooks through Git Bash.

## Usage

| Command | What it does |
|---------|--------------|
| `/ask-better <text>` | Full review of `<text>`: gaps plus a rewrite you can copy |
| `/ask-better` | Full review of your previous message |
| `/ask-better off` | Turn off the per-message hint |
| `/ask-better on` | Turn it back on |

`off` creates `${XDG_CONFIG_HOME:-~/.config}/ask-better/off`; you can also
create or delete that file yourself.

## How it works

`hooks/ask-better.sh` runs on `UserPromptSubmit` and adds a short
instruction to the turn's context. The agent applies it after finishing your
task. There is no extra model call; the cost is roughly 200 input tokens per
message.

## Development

```sh
sh tests/hook.test.sh
```

## License

ask-better is released under the [MIT License](LICENSE).

- **You may** use, copy, modify, merge, publish, distribute, sublicense and
  sell it, in personal and commercial projects alike.
- **You must** keep the copyright notice and the license text in all copies
  or substantial portions of the software.
- **No warranty**: it is provided "as is", and the authors are not liable for
  any damages arising from its use.

### Third-party content

*How To Ask Questions The Smart Way* is copyright © Eric S. Raymond and Rick
Moen, and is **not** covered by this project's MIT License. ask-better
contains no text from the essay; the checklist is an original summary of its
ideas, and the essay is linked rather than copied. Read the original at
<http://www.catb.org/~esr/faqs/smart-questions.html>.
