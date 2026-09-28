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

# Idle R sessions pause after 30 minutes instead of RStudio's default 2 hours.
# This also ends the keep-alive below.
conf=/etc/rstudio/rsession.conf
if ! grep -qs '^session-timeout-minutes=' "$conf"; then
  echo 'session-timeout-minutes=30' | sudo tee -a "$conf" >/dev/null
fi

# Re-attaching (e.g. reopening the VS Code tab) must not start a second server.
if ! pgrep -x rserver >/dev/null; then
  rserver --server-daemonize=1
fi

# A codespace stops after 30 idle minutes, and working in RStudio doesn't count
# as activity: only using VS Code or output in its terminal does. So while an R
# session is open, print to this terminal every few minutes. A forgotten
# RStudio tab still lets the codespace stop: its R session pauses (above).
# Capped at 4 hours per opening in case a session never pauses.
pidfile=/tmp/rstudio-keepalive.pid
old=$(cat "$pidfile" 2>/dev/null)
if [ -n "$old" ] && ps -p "$old" -o args= | grep -q start-rstudio; then
  kill "$old"
fi
echo $$ >"$pidfile"

end=$((SECONDS + 4 * 3600))
while [ "$SECONDS" -lt "$end" ]; do
  sleep 300
  if pgrep -u "$(id -u)" -x rsession >/dev/null; then
    printf '\r  %s  RStudio in use: keeping your codespace awake.' "$(date +%H:%M)"
  fi
done
