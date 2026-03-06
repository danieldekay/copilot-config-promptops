#!/usr/bin/env python3
# /// script
# requires-python = ">=3.11"
# dependencies = [
#   "feedparser",
#   "requests",
#   "beautifulsoup4",
#   "markdownify",
# ]
# ///
"""RSS and Substack newsletter reader — fetch, filter, and format feed content.

Usage:
    uv run fetch_feed.py <url...> [options]

    # Fetch latest posts from a Substack
    uv run fetch_feed.py https://ethanmollick.substack.com --limit 5

    # Filter by keyword and save as Markdown
    uv run fetch_feed.py https://simonwillison.net/atom/everything/ \\
        --filter "LLM" --output articles.md

    # Fetch full article content (not just feed summaries)
    uv run fetch_feed.py https://newsletter.pragmaticengineer.com/feed \\
        --full-content --limit 3

    # Multiple feeds, titles only
    uv run fetch_feed.py https://ethanmollick.substack.com \\
        https://simonwillison.net/atom/everything/ --format titles --limit 10
"""

from __future__ import annotations

import argparse
import json
import sys
from datetime import datetime, timezone
from typing import Optional
from urllib.parse import urlparse

import feedparser
import requests
from bs4 import BeautifulSoup
from markdownify import markdownify as md


# --- URL normalization ----------------------------------------------------------


def normalize_feed_url(url: str) -> str:
    """Convert a publication root URL to its RSS/Atom feed URL.

    Handles:
    - Substack publications (appends /feed)
    - Sites already pointing to a feed path (returns as-is)
    - Generic sites (appends /feed as a first guess)
    """
    parsed = urlparse(url)

    # Already looks like a feed path
    if any(seg in parsed.path for seg in ["/feed", "/rss", "/atom"]):
        return url

    # Substack (hosted or custom domain detected by netloc pattern)
    if "substack.com" in parsed.netloc:
        return url.rstrip("/") + "/feed"

    # Generic fallback: append /feed
    return url.rstrip("/") + "/feed"


def discover_feed_url(base_url: str, timeout: int = 10) -> Optional[str]:
    """Try to find the RSS feed URL embedded in a page's <head> link tags."""
    try:
        resp = requests.get(
            base_url,
            timeout=timeout,
            headers={"User-Agent": "Mozilla/5.0 (feed-reader)"},
        )
        resp.raise_for_status()
        soup = BeautifulSoup(resp.text, "html.parser")
        for rel_type in ("application/rss+xml", "application/atom+xml"):
            tag = soup.find("link", rel="alternate", type=rel_type)
            if tag and tag.get("href"):
                href = tag["href"]
                # Resolve relative URLs
                if href.startswith("/"):
                    parsed = urlparse(base_url)
                    href = f"{parsed.scheme}://{parsed.netloc}{href}"
                return href
    except Exception:
        pass
    return None


# --- Feed fetching and filtering -----------------------------------------------


def parse_published(entry: feedparser.FeedParserDict) -> Optional[datetime]:
    """Extract publication datetime from a feed entry as a UTC-aware datetime."""
    tp = entry.get("published_parsed") or entry.get("updated_parsed")
    if tp:
        return datetime(*tp[:6], tzinfo=timezone.utc)
    return None


def fetch_entries(
    url: str,
    limit: int = 10,
    keyword: Optional[str] = None,
    since: Optional[datetime] = None,
    discover: bool = False,
    timeout: int = 15,
) -> tuple[str, list[dict]]:
    """Fetch filtered entries from a feed URL.

    Returns:
        (feed_title, list of entry dicts)

    Raises:
        ValueError: if the feed cannot be parsed and contains no entries.
    """
    feed_url = normalize_feed_url(url)

    if discover:
        discovered = discover_feed_url(url, timeout)
        if discovered:
            feed_url = discovered

    feed = feedparser.parse(feed_url)

    if feed.bozo and not feed.entries:
        raise ValueError(
            f"Could not parse feed at {feed_url}: {getattr(feed, 'bozo_exception', 'unknown error')}"
        )

    feed_title: str = feed.feed.get("title", url)
    entries: list[dict] = []

    for raw in feed.entries:
        pub_dt = parse_published(raw)

        if since and pub_dt and pub_dt < since:
            continue

        # Prefer full content element; fall back to summary
        content_html = ""
        if raw.get("content"):
            content_html = raw.content[0].get("value", "")
        if not content_html:
            content_html = raw.get("summary", "")

        # Keyword filter: check title + raw HTML content
        if keyword:
            haystack = f"{raw.get('title', '')} {content_html}".lower()
            if keyword.lower() not in haystack:
                continue

        entries.append(
            {
                "title": raw.get("title", "(no title)"),
                "url": raw.get("link", ""),
                "author": raw.get("author", ""),
                "published": raw.get("published", raw.get("updated", "")),
                "published_dt": pub_dt.isoformat() if pub_dt else "",
                "content_html": content_html,
                "tags": [t.get("term", "") for t in raw.get("tags", [])],
                "feed_title": feed_title,
            }
        )

        if len(entries) >= limit:
            break

    return feed_title, entries


# --- Full content retrieval ----------------------------------------------------


def fetch_full_content(url: str, timeout: int = 15) -> str:
    """Fetch a full article page and return the main content as Markdown."""
    try:
        resp = requests.get(
            url,
            timeout=timeout,
            headers={"User-Agent": "Mozilla/5.0 (feed-reader)"},
        )
        resp.raise_for_status()
        soup = BeautifulSoup(resp.text, "html.parser")

        # Remove navigation/footer noise
        for tag in soup.select("nav, footer, header, aside, script, style"):
            tag.decompose()

        # Try common article containers in priority order
        for selector in [
            "article",
            '[class*="post-content"]',
            '[class*="article-body"]',
            '[class*="entry-content"]',
            ".body",
            "main",
        ]:
            container = soup.select_one(selector)
            if container:
                return md(str(container), heading_style="ATX").strip()

        return md(str(soup.body or soup), heading_style="ATX").strip()
    except Exception as exc:
        return f"*(Could not retrieve full content: {exc})*"


# --- Output formatters ---------------------------------------------------------


def html_to_md(html: str) -> str:
    """Convert HTML to Markdown, stripping noise."""
    if not html:
        return ""
    return md(html, heading_style="ATX").strip()


def format_markdown(feed_title: str, entries: list[dict]) -> str:
    """Format entries as a Markdown document."""
    lines: list[str] = [f"# {feed_title}\n"]

    for entry in entries:
        lines.append(f"## {entry['title']}\n")

        meta: list[str] = []
        if entry["author"]:
            meta.append(f"**Author**: {entry['author']}")
        if entry["published"]:
            meta.append(f"**Published**: {entry['published']}")
        if entry["url"]:
            meta.append(f"**URL**: <{entry['url']}>")
        if entry["tags"]:
            meta.append(f"**Tags**: {', '.join(entry['tags'])}")
        if meta:
            lines.append("\n".join(meta) + "\n")

        body = entry.get("full_content") or html_to_md(entry["content_html"])
        if body:
            lines.append(body)

        lines.append("\n---\n")

    return "\n".join(lines)


def format_titles(entries: list[dict]) -> str:
    """Format entries as a plain list of linked titles."""
    rows: list[str] = []
    for e in entries:
        date = (e["published"] or "")[:10]
        rows.append(f"- [{e['title']}]({e['url']}) — {date}")
    return "\n".join(rows)


def format_json(entries: list[dict]) -> str:
    """Format entries as pretty-printed JSON (strips internal html field)."""
    clean = []
    for e in entries:
        item = {k: v for k, v in e.items() if k not in ("content_html",)}
        if "full_content" not in item:
            # Include summary as plain text
            item["summary"] = html_to_md(e["content_html"])
        clean.append(item)
    return json.dumps(clean, indent=2, ensure_ascii=False)


# --- CLI -----------------------------------------------------------------------


def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(
        description="Fetch RSS/Atom feeds and Substack newsletters.",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    p.add_argument("urls", nargs="+", help="Feed or publication URLs")
    p.add_argument("--limit", type=int, default=10, metavar="N", help="Max articles per feed (default: 10)")
    p.add_argument("--filter", dest="keyword", metavar="KEYWORD", help="Case-insensitive keyword filter")
    p.add_argument("--since", metavar="YYYY-MM-DD", help="Only articles published after this date")
    p.add_argument(
        "--format",
        choices=["markdown", "json", "titles"],
        default="markdown",
        help="Output format (default: markdown)",
    )
    p.add_argument(
        "--full-content",
        action="store_true",
        help="Fetch full article HTML (slower; use when feeds only publish summaries)",
    )
    p.add_argument("--discover", action="store_true", help="Auto-discover feed URL via page <link> tags")
    p.add_argument("--output", metavar="FILE", help="Write output to FILE instead of stdout")
    return p


def main() -> None:
    parser = build_parser()
    args = parser.parse_args()

    since_dt: Optional[datetime] = None
    if args.since:
        try:
            since_dt = datetime.fromisoformat(args.since).replace(tzinfo=timezone.utc)
        except ValueError:
            print(f"ERROR: --since must be in YYYY-MM-DD format, got: {args.since}", file=sys.stderr)
            sys.exit(1)

    all_entries: list[dict] = []
    last_feed_title = ""

    for url in args.urls:
        try:
            feed_title, entries = fetch_entries(
                url,
                limit=args.limit,
                keyword=args.keyword,
                since=since_dt,
                discover=args.discover,
            )
            last_feed_title = feed_title

            if args.full_content:
                for entry in entries:
                    if entry["url"]:
                        entry["full_content"] = fetch_full_content(entry["url"])

            all_entries.extend(entries)
            print(f"Fetched {len(entries)} article(s) from: {feed_title}", file=sys.stderr)

        except ValueError as exc:
            print(f"WARNING: {exc}", file=sys.stderr)

    if not all_entries:
        print("No articles found matching the given criteria.", file=sys.stderr)
        sys.exit(0)

    combined_title = last_feed_title if len(args.urls) == 1 else "Feed Digest"

    if args.format == "json":
        output = format_json(all_entries)
    elif args.format == "titles":
        output = format_titles(all_entries)
    else:
        output = format_markdown(combined_title, all_entries)

    if args.output:
        with open(args.output, "w", encoding="utf-8") as fh:
            fh.write(output)
        print(f"Saved {len(all_entries)} article(s) to {args.output}", file=sys.stderr)
    else:
        print(output)


if __name__ == "__main__":
    main()
