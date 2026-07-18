---
name: x-posting
description: "Draft and publish posts and threads on X via API v2."
version: 1.0.0
author: hermes-profiles maintainers
license: MIT
platforms: [linux, macos, windows]
required_environment_variables: [X_BEARER_TOKEN]
metadata:
  hermes:
    tags: [Content, X, Twitter, Social, Publishing, API]
    related_skills: [linkedin-posting]
---

# X Posting Skill

Draft X-native posts and threads and publish them with the official X API
v2 (`POST /2/tweets`) using `terminal` + `curl`. Publishing always requires
explicit human approval of the exact final text.

## When to Use

- "Post this on X" / "tweet this" / "turn this into a thread."
- Repurposing a LinkedIn post, blog post, or notes into X format.

## Prerequisites

- `X_BEARER_TOKEN` in the profile `.env` — an OAuth 2.0 **user-context**
  access token with `tweet.read`, `tweet.write`, and `users.read` scopes,
  from an app in the X developer portal (https://developer.x.com).
- IMPORTANT: the app-only bearer token from the portal's "Keys and tokens"
  page CANNOT post — posting returns 403 with it. You need a token from the
  OAuth 2.0 Authorization Code + PKCE flow (add `offline.access` scope to
  get a refresh token; access tokens expire in ~2 hours otherwise).
- Free API tier allows ~500 posts/month — budget threads accordingly.

## Format Rules (X-native)

- 280 characters max per post (weighted; URLs count as 23). Count before
  posting — the API rejects overlong text rather than truncating.
- Hook in the first line; no "thread 🧵 1/12" filler unless the user's
  style uses it. Hashtags: 0-2, only when genuinely searchable terms.
- Threads: one idea per post, each post must stand alone when screenshotted.

## Procedure

1. Draft 2-3 variants (or a numbered thread outline); user approves the
   exact final text.
2. Publish a single post (write JSON to a temp file to avoid quoting bugs):

```bash
cat > /tmp/x-post.json <<'JSON'
{"text": "POST TEXT HERE"}
JSON

curl -s -X POST https://api.x.com/2/tweets \
  -H "Authorization: Bearer $X_BEARER_TOKEN" \
  -H "Content-Type: application/json" \
  --data @/tmp/x-post.json
# -> {"data": {"id": "1808...", "text": "..."}}
```

3. For a thread, post sequentially, chaining each reply to the previous id:

```bash
cat > /tmp/x-post2.json <<'JSON'
{"text": "SECOND POST", "reply": {"in_reply_to_tweet_id": "PREVIOUS_ID"}}
JSON
curl -s -X POST https://api.x.com/2/tweets \
  -H "Authorization: Bearer $X_BEARER_TOKEN" \
  -H "Content-Type: application/json" \
  --data @/tmp/x-post2.json
```

4. Report the URL `https://x.com/i/web/status/<id>` for the first post, and
   log it (date, text, id) to `workspace/content-calendar.md`.

## Pitfalls

- 403 `oauth1-permissions` or "not permitted" = wrong token type (app-only
  bearer, or app lacks write permission) — fix the token, don't retry.
- 401 = expired user token; refresh it via the refresh-token grant. Never
  print tokens.
- Duplicate text is rejected ("duplicate content") — vary reposts.
- Rate limited (429): stop and report; do not loop.
- Delete-on-mistake exists (`DELETE /2/tweets/:id`) but only use it when the
  user explicitly asks.

## Verification

The API returns `data.id`, and the post is visible at the reported URL.
