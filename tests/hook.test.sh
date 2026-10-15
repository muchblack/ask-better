#!/bin/sh
# Tests for hooks/ask-better.sh. Run: sh tests/hook.test.sh
set -u
ROOT=$(cd "$(dirname "$0")/.." && pwd)
HOOK="$ROOT/hooks/ask-better.sh"
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
fail=0

check() { # name, condition result
  if [ "$2" -eq 0 ]; then echo "ok   $1"; else echo "FAIL $1"; fail=1; fi
}

# 1. Default: emits valid JSON with UserPromptSubmit additionalContext.
out=$(echo '{"prompt":"fix the site"}' | XDG_CONFIG_HOME="$TMP" sh "$HOOK")
printf '%s' "$out" | python3 -c '
import json, sys
d = json.load(sys.stdin)["hookSpecificOutput"]
assert d["hookEventName"] == "UserPromptSubmit"
assert d["additionalContext"].startswith("[ask-better]")
'
check "emits valid hook JSON" $?

# 2. Off file present: no output, exit 0.
mkdir -p "$TMP/ask-better" && touch "$TMP/ask-better/off"
out=$(echo '{}' | XDG_CONFIG_HOME="$TMP" sh "$HOOK"); rc=$?
[ "$rc" -eq 0 ] && [ -z "$out" ]
check "silent when turned off" $?
rm "$TMP/ask-better/off"

# 3. Works the way hosts call it: through hooks.json with CLAUDE_PLUGIN_ROOT.
cmd=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["hooks"]["UserPromptSubmit"][0]["hooks"][0]["command"])' "$ROOT/hooks/hooks.json")
out=$(echo '{}' | CLAUDE_PLUGIN_ROOT="$ROOT" XDG_CONFIG_HOME="$TMP" sh -c "$cmd")
printf '%s' "$out" | python3 -c 'import json,sys; json.load(sys.stdin)'
check "hooks.json command runs" $?

# 4. Antigravity: root hooks.json command emits SessionStart injectSteps JSON,
#    run the way agy does (sh -c, cwd = directory holding hooks.json).
cmd=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["ask-better"]["SessionStart"][0]["command"])' "$ROOT/hooks.json")
out=$(cd "$ROOT" && echo '{}' | XDG_CONFIG_HOME="$TMP" sh -c "$cmd")
printf '%s' "$out" | python3 -c '
import json, sys
s = json.load(sys.stdin)["injectSteps"][0]["systemMessage"]["systemMessage"]
assert s.startswith("[ask-better]")
'
check "agy hooks.json emits injectSteps" $?

# 5. All manifests are valid JSON and agree on name and version.
python3 - "$ROOT" <<'PY'
import json, sys, os
root = sys.argv[1]
files = ["plugin.json", ".claude-plugin/plugin.json", ".codex-plugin/plugin.json"]
ms = [json.load(open(os.path.join(root, f))) for f in files]
json.load(open(os.path.join(root, ".claude-plugin/marketplace.json")))
assert {m["name"] for m in ms} == {"ask-better"}
assert len({m["version"] for m in ms}) == 1
PY
check "manifests consistent" $?

# 6. The copy-paste text in both READMEs matches what the hook emits.
echo '{}' | XDG_CONFIG_HOME="$TMP" sh "$HOOK" | python3 -c '
import json, os, sys
text = json.load(sys.stdin)["hookSpecificOutput"]["additionalContext"]
for f in ["README.md", "README.zh-TW.md"]:
    lines = open(os.path.join(sys.argv[1], f), encoding="utf-8").read().splitlines()
    assert text in lines, f
' "$ROOT"
check "README text matches hook" $?

exit $fail
