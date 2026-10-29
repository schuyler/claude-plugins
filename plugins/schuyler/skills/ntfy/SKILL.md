---
name: ntfy
description: Send Schuyler a push notification to his phone via ntfy. Use only when he asks to be pinged, notified, or alerted (e.g. "ping me when the build finishes", "notify me when done"). Do not send notifications on your own initiative.
---

# ntfy

Pings go to the ntfy topic URL in `~/.claude/ntfy-url.txt`, which Schuyler's
phone subscribes to. The access token is in `~/.claude/ntfy-token.txt`.
Neither file is part of this plugin. If either is missing, this machine isn't
set up for pings: tell Schuyler and don't retry.

```bash
curl -fsS -m 15 \
  -H "Authorization: Bearer $(cat ~/.claude/ntfy-token.txt)" \
  -H "Title: <short title>" \
  -H "Priority: <1-5>" \
  -d "<message>" \
  "$(cat ~/.claude/ntfy-url.txt)"
```

- Priority defaults to 3. Use 4 or 5 when you are blocked on his input; omit
  the header otherwise.
- Run it with `run_in_background: true`. Success prints a JSON message
  object; any other output or a non-zero exit means the ping was not
  delivered. Tell Schuyler, with the error text.
- Never print the token or put its value in the command text.
