#!/bin/bash

# Runs every time the codespace is opened (postAttachCommand).
# Each codespace has its own RStudio address, so print it where students can
# see it, then start RStudio Server.

if [ -n "$CODESPACE_NAME" ]; then
  url="https://${CODESPACE_NAME}-8787.${GITHUB_CODESPACES_PORT_FORWARDING_DOMAIN:-app.github.dev}/"
else
  url="http://localhost:8787/"
fi

cat <<EOF

  ============================================================
    RStudio is ready. Open it with Ctrl+click (Cmd+click on Mac),
    or copy this address into a new browser tab:

    $url

    Tip: bookmark it. It stays the same for this codespace.
  ============================================================

EOF

# Re-attaching (e.g. reopening the VS Code tab) must not start a second server.
if pgrep -x rserver >/dev/null; then
  exit 0
fi

exec rserver
