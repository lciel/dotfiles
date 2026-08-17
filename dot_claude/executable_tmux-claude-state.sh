#!/bin/sh
# Publish this Claude session's state onto the tmux window it runs in, so the
# status bar can show which tabs are working, finished, or waiting for input.
#
# Driven by the hooks in settings.json:
#   UserPromptSubmit -> running   Stop         -> done
#   Notification     -> waiting   SessionEnd   -> (cleared)
#
# Read back by window-status-format in ~/.tmux.conf via #{@claude_state}.
# .tmux.conf also clears a non-running state when you select the window, so the
# marker means "finished since you last looked", not merely "has finished".
#
# TMUX_PANE is inherited from the shell Claude was started in, which is what
# makes this correct with several sessions open at once: each one only ever
# touches its own window. Outside tmux there is nothing to update, so exit
# quietly — a hook that fails is noise on every single prompt.

[ -n "$TMUX_PANE" ] || exit 0
command -v tmux >/dev/null 2>&1 || exit 0

tmux set-option -w -t "$TMUX_PANE" @claude_state "${1:-}" 2>/dev/null || true
exit 0
