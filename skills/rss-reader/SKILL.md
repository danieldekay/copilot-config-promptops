---
name: rss-reader
description: >
  Read, fetch, and process RSS/Atom feeds and Substack newsletters. Use this skill whenever
  the user wants to fetch articles from a blog, newsletter, or RSS feed; read Substack posts;
  follow a publication; extract article content; filter articles by keyword or date; or
  save feed content to research notes. Triggers on mentions of "RSS", "feed", "newsletter",
  "Substack", "blog posts", "fetch articles", "read posts from", or when any Substack or
  blog URL is provided with the intent to read or process its content.
---

# RSS / Substack Feed Reader

## Overview

Fetch, filter, and format content from any RSS/Atom feed or Substack newsletter using the
bundled [fetch_feed.py](./scripts/fetch_feed.py) script. No prior package installation
required — `uv` handles dependencies inline.

The script handles:
- Any RSS or Atom feed URL
- Substack publications (auto-appends `/feed` if needed)
- Custom-domain Substack sites (feed is always at `<domain>/feed`)
- Full article content retrieval (optional, for feeds that only publish summaries)
- Output as Markdown, JSON, or a plain title list

---

## Quick Start

```bash
# Fetch latest 10 posts from a Substack
uv run --with feedparser --with requests --with beautifulsoup4 --with markdownify \
  python /Users/dekay/Dokumente/projects/programmieren/copilot-config-promptops/skills/rss-reader/scripts/fetch_feed.py \
  https://ethanmollick.substack.com --limit 5

# Fetch full content (not just summaries)
uv run --with feedparser --with requests --with beautifulsoup4 --with markdownify \
  python /Users/dekay/Dokumente/projects/programmieren/copilot-config-promptops/skills/rss-reader/scripts/fetch_feed.py \
  https://simonwillison.net/atom/everything/ --full-content --limit 3

# Filter by keyword and save as Markdown
uv run --with feedparser --with requests --with beautifulsoup4 --with markdownify \
  python /Users/dekay/Dokumente/projects/programmieren/copilot-config-promptops/skills/rss-reader/scripts/fetch_feed.py \
  https://ethanmollick.substack.com --filter "agent" --format markdown \
  --output /Users/dekay/Dokumente/2ndBrain/notes/research-tracking/sessions/<SESSION>/articles.md

# Only titles (for quick overview)
uv run --with feedparser --with requests --with beautifulsoup4 --with markdownify \
  python .../fetch_feed.py https://newsletter.pragmaticengineer.com/feed --format titles --limit 20

# Multiple feeds at once
uv run --with feedparser --with requests --with beautifulsoup4 --with markdownify \
  python .../fetch_feed.py \
  https://ethanmollick.substack.com \
  https://simonwillison.net/atom/everything/ \
  https://www.oneusefulthing.org/feed \
  --limit 5 --format titles
```

---

## Substack URL Patterns

Substack publications all follow predictable URL patterns:

| Publication URL | RSS Feed URL |
|----------------|-------------|
| `https://author.substack.com` | `https://author.substack.com/feed` |
| `https://author.substack.com/` | auto-detected |
| Custom domain `https://blog.example.com` | `https://blog.example.com/feed` |

The script auto-detects Substack URLs and appends `/feed` automatically. You can also
pass the publication root URL without `/feed`.

**Finding Substack RSS for custom domains**: If a Substack uses a custom domain, the feed
is still at `<custom-domain>/feed`. You can verify by visiting `<url>/feed` in a browser.

**Substack API** (alternative, more structured):
```bash
# Direct JSON API — works for public posts without auth
curl "https://publication.substack.com/api/v1/posts?limit=10" | python -m json.tool
```

---

## CLI Reference

```
fetch_feed.py <url...> [options]

Positional:
  url                   One or more feed URLs (RSS, Atom, or Substack publication root)

Options:
  --limit N             Max articles per feed (default: 10)
  --filter KEYWORD      Only include articles where title or body contains KEYWORD
  --since YYYY-MM-DD    Only include articles published after this date
  --format FORMAT       Output format: markdown (default), json, titles
  --full-content        Fetch full article HTML; parse to Markdown (slower, more requests)
  --output FILE         Write output to FILE instead of stdout
```

---

## Output Formats

### `markdown` (default)
One `##` section per article with author, date, URL, tags, and summary/content as Markdown.
Best for saving to research notes or reading in context.

### `json`
Machine-readable array of objects — title, url, author, published, summary, tags, and
optionally `full_content`. Best for downstream processing or feeding another agent.

### `titles`
Plain list of `- [Title](URL) — date` lines. Best for quick overviews or link lists.

---

## Integration with Research Tracking

When reading feeds as part of a research session, save output directly into the session folder:

```bash
SESSION="/Users/dekay/Dokumente/2ndBrain/notes/research-tracking/sessions/YYYYMMDD-topic"
SCRIPT="/Users/dekay/Dokumente/projects/programmieren/copilot-config-promptops/skills/rss-reader/scripts/fetch_feed.py"

uv run --with feedparser --with requests --with beautifulsoup4 --with markdownify \
  python "$SCRIPT" https://ethanmollick.substack.com \
  --limit 10 --filter "AI" \
  --output "$SESSION/feed-articles.md"
```

Then reference `feed-articles.md` from the `research-log.md` in that session folder.

---

## Finding RSS Feeds for Any Site

Not every site advertises its RSS feed. Common locations to try:

| Site type | Typical feed URL |
|-----------|----------------|
| WordPress | `/feed` or `/rss.xml` |
| Substack | `/feed` |
| Ghost | `/rss/` |
| Jekyll/Hugo | `/feed.xml` or `/atom.xml` |
| Medium | `medium.com/feed/@username` |
| YouTube channel | Use channel ID: `https://www.youtube.com/feeds/videos.xml?channel_id=<ID>` |
| Podcast | Usually listed in podcast app — often `<site>/feed` |

Browser trick: visit `<site>/feed` — if the browser shows XML, that's the feed URL.

RSS auto-discovery: many sites embed a `<link rel="alternate" type="application/rss+xml">` tag
in their HTML `<head>`. The script can detect this automatically with `--discover`:

```bash
uv run ... fetch_feed.py https://example.com --discover
```

---

## Useful AI / Tech / Research Substacks

| Author / Publication | Feed URL |
|----------------------|---------|
| Ethan Mollick (One Useful Thing) | `https://www.oneusefulthing.org/feed` |
| Simon Willison | `https://simonwillison.net/atom/everything/` |
| Pragmatic Engineer | `https://newsletter.pragmaticengineer.com/feed` |
| Stratechery | `https://stratechery.com/feed/` |
| Import AI (Jack Clark) | `https://importai.substack.com/feed` |
| The Gradient | `https://thegradient.pub/rss/` |
| Lenny's Newsletter | `https://www.lennysnewsletter.com/feed` |
| Benedict Evans | `https://www.ben-evans.com/benedictevans.rss` |

---

## Troubleshooting

| Problem | Solution |
|---------|---------|
| `Failed to parse feed` | Try appending `/feed`, `/rss`, or `/atom.xml` to the base URL |
| Empty results with `--filter` | Keyword is case-insensitive but must be in title or summary; try a shorter keyword |
| Summary is truncated | Use `--full-content` to retrieve full article HTML |
| `403 Forbidden` on full content | Site blocks programmatic access; content is only in feed summary |
| Substack paywalled posts | Only free/preview content is available via RSS without a subscription |
| `--since` returns nothing | Date must be ISO format: `2026-01-15`; check feed has `published` dates |

---

## See Also

- [fetch_feed.py](./scripts/fetch_feed.py) — the bundled Python script
- [references/known-feeds.md](./references/known-feeds.md) — curated feed list
- `raindrop` skill — bookmark articles found via feeds
- `deep-research` skill — full research pipeline that can incorporate feed content
