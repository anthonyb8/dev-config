#!/usr/bin/env bash
# Send stdin to the clipboard of the terminal the tmux client runs on, using
# the OSC 52 escape sequence.
#
# Used as a tmux copy-pipe target:
#   bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel '~/.tmux/osc52-copy.sh'
#
# Why this exists rather than relying on `set-clipboard on`:
#
# tmux is supposed to originate an OSC 52 sequence itself when it copies, and
# on tmux 3.7c it does not, even with set-clipboard on, an Ms entry present in
# the terminal description, and `clipboard` listed in the client's
# terminal-features. Verified by capturing a client's tty during a copy-mode
# yank: tmux writes nothing. The same tmux does correctly forward an OSC 52
# sequence that an inner application emits, so `set-clipboard on` is still
# worth keeping for applications that speak OSC 52 themselves.
#
# The sequence is written straight to the client's tty and is deliberately not
# wrapped in a DCS passthrough: these bytes never pass through tmux's parser,
# so a wrapper would reach the terminal literally and do nothing.
set -u

payload=$(base64 | tr -d '\n')

# The tty of the client that owns this copy. If that cannot be resolved, or
# names a tty that is gone, fall back to the most recently active client
# rather than an arbitrary one: with several clients attached they may be on
# different machines, and the active one is the terminal being typed at.
tty=$(tmux display-message -p '#{client_tty}' 2>/dev/null)
if [ -z "${tty:-}" ] || [ ! -w "${tty:-}" ]; then
  tty=$(tmux list-clients -F '#{client_activity} #{client_tty}' 2>/dev/null |
    sort -rn | head -1 | cut -d' ' -f2)
fi

[ -n "${tty:-}" ] || exit 1

printf '\033]52;c;%s\a' "$payload" > "$tty"
