# ask-better

[English](README.md) | **正體中文**

給 AI coding agent 用的提問教練，依據 Eric S. Raymond 的
[《提問的智慧》（How To Ask Questions The Smart Way）](http://www.catb.org/~esr/faqs/smart-questions.html)。

AI 會照常完成你交代的事。如果你的問題有缺口，讓它只能用猜的，或換成別人會回頭追問，它會在回覆最後加**一行**提醒：

```
💡 沒附錯誤原文。例如：「npm run build 失敗，錯誤是 <貼上錯誤訊息>；升級 Vite 之前是正常的。」
```

問題已經清楚就不出聲，也不會擋住或拖慢你的工作。

## 檢查哪些缺口

1. **目標與步驟**：只問卡住的那一步，沒說最終想達成什麼（XY 問題）
2. **原始症狀**：只說「壞了」，沒附錯誤原文、輸出或重現步驟
3. **預期與實際**：沒說應該發生什麼、實際發生了什麼
4. **範圍與完成條件**：只要分析、要修改，還是要 commit？哪個專案、哪個檔案？
5. **把猜測當事實**：把推測的原因說成已經確定
6. **已經試過什麼**：沒說排除過哪些做法，對方可能又建議一次
7. **一次塞多個決策**：好幾個不相干的要求擠在同一則訊息，容易漏掉其中一個

## 安裝

| 工具 | 指令 | 每則訊息自動提醒 | `/ask-better` 審查 |
|------|------|:---:|:---:|
| Claude Code | `/plugin marketplace add muchblack/ask-better`<br>`/plugin install ask-better@ask-better` | ✅ | ✅ |
| Codex CLI | `codex plugin marketplace add https://github.com/muchblack/ask-better.git`<br>`codex plugin add ask-better@ask-better` | ✅ | ✅（`$ask-better:ask-better`） |
| Antigravity CLI | `agy plugin install https://github.com/muchblack/ask-better` | ✅ ¹ | ✅ |

- **Codex** 第一次執行 hook 時會要求你信任它（在 `/hooks` 裡按 `t`）。
- ¹ **Antigravity CLI** 沒有「每送出一則訊息」的 hook，所以改在 session 開始時（`SessionStart`）注入一次，之後整段對話都有效。開關要到下一個 session 才會生效。
- hook 是 POSIX `sh` 腳本，沒有其他依賴。在 Windows 上，Claude Code 會透過 Git Bash 執行 hook。

## 使用方式

| 指令 | 作用 |
|------|------|
| `/ask-better <文字>` | 完整審查 `<文字>`：列出缺口，並給一段可以直接複製的改寫 |
| `/ask-better` | 完整審查你的上一則訊息 |
| `/ask-better off` | 關閉每則訊息的自動提醒 |
| `/ask-better on` | 重新開啟 |

`off` 會建立 `${XDG_CONFIG_HOME:-~/.config}/ask-better/off` 這個檔案，你也可以自己建立或刪除它。

## 運作原理

`hooks/ask-better.sh` 在 `UserPromptSubmit` 時執行，把一段簡短的指示加進這一輪的 context。AI 完成你的任務後，再依照這段指示判斷要不要加提醒。不會多呼叫一次模型，每則訊息大約多花 200 個 input token。

## 開發

```sh
sh tests/hook.test.sh
```

## 授權

MIT。檢查清單整理自 ESR 與 Rick Moen 的文章，原文請見上方連結。
