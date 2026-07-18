---
name: linkedin-posting
description: "Draft and publish LinkedIn posts via the REST API."
version: 1.0.0
author: hermes-profiles maintainers
license: MIT
platforms: [linux, macos, windows]
required_environment_variables: [LINKEDIN_ACCESS_TOKEN]
metadata:
  hermes:
    tags: [Content, LinkedIn, Social, Publishing, API]
    related_skills: [x-posting]
---

# LinkedIn Posting Skill

Draft LinkedIn-native posts and publish them to the member's own feed with
the official LinkedIn API, using `terminal` + `curl`. Publishing always
requires explicit human approval of the exact final text.

## When to Use

- "Post this to LinkedIn" / "draft a LinkedIn post about X."
- Turning a blog post, launch note, or thread into a LinkedIn version.

## Prerequisites

- `LINKEDIN_ACCESS_TOKEN` in the profile `.env` — an OAuth 2.0 member token
  with `openid` and `w_member_social` scopes. Create an app at
  https://developer.linkedin.com/ (add the "Share on LinkedIn" and
  "Sign In with LinkedIn using OpenID Connect" products), then generate a
  token via the OAuth flow or the developer portal's token generator.
- Tokens expire (~60 days). On a 401, tell the user to re-generate; never
  print the token itself.

## Format Rules (LinkedIn-native)

- Hook in the first 2 lines — that's all that shows before "...see more".
- 900-1,300 characters is the sweet spot; hard API limit is 3,000.
- Short paragraphs (1-2 lines), generous line breaks, no markdown (LinkedIn
  renders plain text; `**bold**` shows literally).
- 0-3 hashtags at the end. Links: put in the post or first comment per the
  user's preference — ask once and remember it.

## Procedure

1. Draft 2-3 variants per the SOUL rules; user picks and approves the exact
   final text.
2. Resolve the author URN (cache it in memory after the first call):

```bash
curl -s -H "Authorization: Bearer $LINKEDIN_ACCESS_TOKEN" \
  https://api.linkedin.com/v2/userinfo
# -> {"sub": "<member-id>", ...}   author URN = urn:li:person:<member-id>
```

3. Publish with the Posts API (escape the text as JSON — write the payload
   to a temp file rather than inlining complex quoting):

```bash
cat > /tmp/li-post.json <<'JSON'
{
  "author": "urn:li:person:MEMBER_ID",
  "commentary": "POST TEXT HERE",
  "visibility": "PUBLIC",
  "distribution": {"feedDistribution": "MAIN_FEED", "targetEntities": [], "thirdPartyDistributionChannels": []},
  "lifecycleState": "PUBLISHED",
  "isReshareDisabledByAuthor": false
}
JSON

curl -s -i -X POST https://api.linkedin.com/rest/posts \
  -H "Authorization: Bearer $LINKEDIN_ACCESS_TOKEN" \
  -H "LinkedIn-Version: 202506" \
  -H "X-Restli-Protocol-Version: 2.0.0" \
  -H "Content-Type: application/json" \
  --data @/tmp/li-post.json
```

4. Success = HTTP 201 with an `x-restli-id` header like
   `urn:li:share:71234...`. Report the post URL:
   `https://www.linkedin.com/feed/update/<x-restli-id>/`.
5. Log the post (date, text, URN) to `workspace/content-calendar.md`.

## Pitfalls

- A 401 means expired/insufficient token; a 403 usually means the app lacks
  the "Share on LinkedIn" product or `w_member_social` scope.
- `commentary` treats `{`, `}`, `@`, and `\` as special (little-format
  syntax) — escape literal braces/backslashes or rewrite around them.
- Don't retry a POST blindly after a timeout — check the feed first;
  duplicate posts are the classic failure.
- `LinkedIn-Version` is required on `/rest/*` endpoints and must be a valid
  YYYYMM version; if LinkedIn retires 202506, use a current one.

## Verification

201 + `x-restli-id` header, and the post visible at the reported URL.
