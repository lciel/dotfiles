---
name: mock-paster
description: Use when the user wants to share, publish, or host an HTML mockup, prototype, or slide deck so teammates can open it at a URL. Uploads HTML (single file or a folder zipped up) to Mock Paster and returns a shareable link viewable by anyone with a @timetreeapp.com Google account. Triggers - "共有して", "share this mock", "url にして", "ホスティングして", "slide を共有", "publish this".
---

# Mock Paster

Upload an HTML mock/prototype/slide deck to Mock Paster and return its shareable
URL. Anyone with a `@timetreeapp.com` Google account can view the link.

The bundled script is dependency-free Node (v18+):
`~/.claude/skills/mock-paster/mock-paster.mjs`

## First-time setup (login)

Before the first upload, log in once:

```bash
node ~/.claude/skills/mock-paster/mock-paster.mjs login
```

This opens a browser for Google login + an "許可する" (Allow) screen. A per-user
token is cached at `~/.config/mock-paster/token`; later uploads need no login.
If the browser doesn't open, give the user the URL the script prints.

## Uploading

**Single self-contained HTML file** (the common case — e.g. a file Claude just
generated with inline CSS/JS):

```bash
node ~/.claude/skills/mock-paster/mock-paster.mjs upload <file.html> "<title>"
```

**Multiple files** (HTML + separate assets: css/js/images, or a slide deck with
assets). Zip them, upload the zip, then always delete the temp zip:

```bash
zip -r /tmp/mock-paster-$$.zip index.html assets/ styles.css   # include every referenced file
node ~/.claude/skills/mock-paster/mock-paster.mjs upload /tmp/mock-paster-$$.zip "<title>"
rm -f /tmp/mock-paster-$$.zip                                   # clean up, even on failure
```

- Zip from the mock's root so relative paths (`./styles.css`, `assets/x.png`)
  are preserved. The entry page is auto-detected (prefers `index.html`, else the
  shallowest HTML).
- Title is optional; if omitted the file name is used.
- On success the script prints the URL (e.g. `https://.../m/ab12cd34/`) to
  stdout — relay it to the user.

## Updating an existing mock (same URL)

To replace the content behind an existing link without changing its URL, use
`update` with the mock's slug (the `<id>` in `/m/<id>/`). You can only update
mocks you uploaded yourself.

```bash
node ~/.claude/skills/mock-paster/mock-paster.mjs update <slug> <file.html|file.zip> ["<title>"]
```

- The slug stays the same, so the shared URL keeps working; only the files are
  swapped. Old files under that slug are removed first.
- Title is left unchanged unless you pass a new one.

### Iterating in a conversation (default to update, not re-upload)

Once you have shared a mock in this conversation, **remember its slug** (the
`<id>` from the `/m/<id>/` URL you returned). When the user then asks to change,
fix, tweak, regenerate, or re-share *that same* mock, regenerate the HTML and
run `update <slug> …` so the link they already have keeps pointing at the new
version. Do **not** `upload` a fresh copy — that would hand them a different URL
and leave a stale one behind.

- Only fall back to a new `upload` when it is genuinely a different mock, or the
  user explicitly asks for a new/separate link.
- If you don't know the slug (e.g. it was shared in an earlier session), ask the
  user for the existing URL, or extract the slug from a URL they paste.
- After updating, tell the user the URL is unchanged (it's the same link as
  before) rather than presenting it as a brand-new upload.

## Telling the user about the site

If asked where mocks live / for the site URL, it's
**https://timetree-mock-paster.vercel.app** — the list of uploaded mocks is at
the root, and each upload returns its own `/m/<id>/` link.

## Notes

- Errors print as `error: <message>` on stderr with a non-zero exit code;
  surface the message to the user.
- Never read or print `~/.config/mock-paster/token` — it is a credential.
- For local development against a dev server, prefix commands with
  `MOCK_PASTER_URL=http://localhost:3000`.
