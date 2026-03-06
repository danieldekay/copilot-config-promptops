# Known RSS Feeds & Substacks

A curated list of high-quality feeds organized by topic. These can all be passed directly
to `fetch_feed.py` — no manual `/feed` suffix needed for Substack URLs.

---

## AI / Machine Learning

| Author / Publication | Feed URL | Notes |
|----------------------|---------|-------|
| Ethan Mollick (One Useful Thing) | `https://www.oneusefulthing.org/feed` | AI in practice, education |
| Import AI (Jack Clark) | `https://importai.substack.com/feed` | Weekly AI research digest |
| The Gradient | `https://thegradient.pub/rss/` | Deep AI research commentary |
| AI Weirdness (Janelle Shane) | `https://www.aiweirdness.com/rss/` | Playful AI experiments |
| Interconnects (Nathan Lambert) | `https://www.interconnects.ai/feed` | RLHF, alignment, labs |
| Ahead of AI (Sebastian Raschka) | `https://magazine.sebastianraschka.com/feed` | ML engineering |
| Andrej Karpathy | `https://karpathy.github.io/feed.xml` | Blog + notes |

---

## Software Engineering / Tech

| Author / Publication | Feed URL | Notes |
|----------------------|---------|-------|
| Simon Willison | `https://simonwillison.net/atom/everything/` | Django auth, LLM tools |
| Pragmatic Engineer (Gergely Orosz) | `https://newsletter.pragmaticengineer.com/feed` | Engineering culture |
| Stratechery (Ben Thompson) | `https://stratechery.com/feed/` | Tech strategy (some paywalled) |
| Benedict Evans | `https://www.ben-evans.com/benedictevans.rss` | Tech macro trends |
| Daniel Miessler (Unsupervised Learning) | `https://danielmiessler.com/feed/` | Security + AI |
| Lenny's Newsletter | `https://www.lennysnewsletter.com/feed` | Product management |
| The Verge | `https://www.theverge.com/rss/index.xml` | Tech news |
| Hacker News (top stories) | `https://hnrss.org/frontpage` | Community aggregator |

---

## Research / Academia

| Author / Publication | Feed URL | Notes |
|----------------------|---------|-------|
| Distill.pub | `https://distill.pub/rss.xml` | Visual ML explanations |
| Research Briefings (Nature) | `https://www.nature.com/nature/articles?type=research-briefing&format=rss` | |
| arXiv cs.AI (newest) | `https://rss.arxiv.org/rss/cs.AI` | Daily AI papers |
| arXiv cs.LG (newest) | `https://rss.arxiv.org/rss/cs.LG` | Daily ML papers |

---

## Writing / Creativity / Productivity

| Author / Publication | Feed URL | Notes |
|----------------------|---------|-------|
| Anne-Laure Le Cunff (Ness Labs) | `https://nesslabs.com/feed` | Learning, thinking |
| Mike Crittenden | `https://critter.blog/feed/` | Engineering management |
| Paul Graham | `https://www. paulgraham.com/rss.html` | Essays |

---

## Finding Feed URLs

```bash
# Try the common patterns:
curl -sI https://example.com/feed     # RSS at /feed (WordPress, Substack, Ghost)
curl -sI https://example.com/rss.xml  # Generic
curl -sI https://example.com/atom.xml # Atom format

# Discover from page HTML:
uv run fetch_feed.py https://example.com --discover --format titles --limit 5
```
