#!/bin/bash

# Runs every time the codespace is opened (postAttachCommand).
# Each codespace has its own RStudio address, so print it where students can
# see it, then start RStudio Server.

# Codespaces created before myLabs/ existed don't check it out yet.
if [ "$(git config core.sparseCheckout)" = true ] &&
   ! grep -qxF '/myLabs/' .git/info/sparse-checkout; then
  git sparse-checkout add '/myLabs/'
fi

# Get the latest course material. --ff-only never touches students' work:
# their own files are untracked, and if they edited a file we also changed,
# git refuses the whole pull and leaves everything as it was.
timeout 60 git pull --ff-only --quiet ||
  echo "Could not update the course files. Your own files are unchanged."

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

    Stuck on "authenticating" / "getting your codespace ready"?
    Refresh the page (F5).

    Tip: bookmark it. It stays the same for this codespace.
  ============================================================

EOF

# Re-attaching (e.g. reopening the VS Code tab) must not start a second server.
if pgrep -x rserver >/dev/null; then
  exit 0
fi

exec rserver
