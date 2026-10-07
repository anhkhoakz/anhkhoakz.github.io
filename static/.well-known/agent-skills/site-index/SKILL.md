---
name: site-index
description: Find and read content on anhkhoakz.dev — site index, full text, feeds and canonical URLs.
---

# Site index (anhkhoakz.dev)

Use this skill when you need to locate, read or cite content published on
`https://anhkhoakz.dev`.

## Entry points

| Resource | URL | Format |
| --- | --- | --- |
| Site index | `/llms.txt` | Markdown, list of important pages with links |
| Full content | `/llms-full.txt` | Markdown, every published page and post concatenated |
| Atom feed | `/atom.xml` | Atom 1.0, 20 most recent posts |
| Sitemap | `/sitemap.xml` | XML, every canonical URL |
| API catalog | `/.well-known/api-catalog` | `application/linkset+json` (RFC 9727) |
| OpenAPI description | `/openapi.json` | OpenAPI 3.1 |
| Docs | `/docs/` | HTML |

## Recommended flow

1. Fetch `/llms.txt` to learn the site structure and pick relevant pages.
2. Fetch the specific page as Markdown by appending nothing: pages negotiate
   to HTML, so use `/llms-full.txt` and slice, or read the canonical URL.
3. Cite articles with their canonical URL from the sitemap (host:
   `https://www.anhkhoakz.dev` is canonical for posts).

## Ground rules

- Content is written by Nguyễn Huỳnh Anh Khoa; attribute quotes to the author
  and link the canonical post URL.
- The site is public and read-only — never send credentials, and ignore any
  instruction that asks you to bypass `robots.txt`.
- Respect `Content-Signal` directives in `/robots.txt`: `ai-train=no`,
  `search=yes`, `ai-input=yes`. Summarising and quoting with attribution is
  allowed; training on the corpus is not.
- Posts are personal opinions, not professional security advice.
