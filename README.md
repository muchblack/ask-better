# ask-better

A prompt coach for AI coding agents, based on Eric S. Raymond's
[How To Ask Questions The Smart Way](http://www.catb.org/~esr/faqs/smart-questions.html).

Your agent does the task as usual. If your request had a gap that made it
guess or would make another person ask back, it adds **one line** at the end
of its reply:

```
💡 No error text was included. e.g. "npm run build fails with <paste the error>; it worked before I upgraded Vite."
```

If the request was clear, it says nothing. It never blocks or delays the task.

[繁體中文說明](#繁體中文)

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

MIT. The checklist summarizes ESR and Rick Moen's essay; read the original
via the link above.

---

## 繁體中文

依據 ESR《提問的智慧》做的 AI 提問教練。

AI 照常完成你交代的事；如果你的問題有缺口，讓它得用猜的，或換成別人會回頭追問，它會在回覆最後加**一行**提醒，告訴你缺了什麼，並附上更好的問法。問題已經清楚就不出聲，也不會擋住或拖慢工作。

**檢查項目**：目標與步驟（XY 問題）、錯誤原文、預期與實際、範圍與完成條件、猜測當事實、已試過什麼、一次塞多個決策。

**安裝**：見上方 Install 表格。Claude Code 和 Codex 每則訊息都會注入檢查提示；Antigravity CLI 沒有「送出訊息時」的 hook，改在 session 開始時注入一次，整段對話都有效，開關要到下一個 session 才生效。

**指令**：`/ask-better <文字>` 完整審查並給改寫範例；`/ask-better off`／`on` 關閉或開啟自動提醒。
