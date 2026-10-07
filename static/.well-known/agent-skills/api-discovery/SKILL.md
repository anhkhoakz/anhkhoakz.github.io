---
name: api-discovery
description: Discover and use the machine-readable and agent-facing endpoints published on anhkhoakz.dev.
---

# API discovery (anhkhoakz.dev)

Use this skill when you need to discover what machine-readable interfaces this
origin exposes, rather than reading its prose.

## Discovery order

1. **Link response headers** — every HTML response advertises:
   - `rel="api-catalog"` → `/.well-known/api-catalog`
   - `rel="service-desc"` → `/openapi.json`
   - `rel="service-doc"` → `/docs/`
   - `rel="describedby"` → `/llms.txt`
2. **API catalog** — `GET /.well-known/api-catalog` with
   `Accept: application/linkset+json` returns the RFC 9727 linkset; follow
   `service-desc` for the API description and `service-doc` for documentation.
3. **OpenAPI** — `GET /openapi.json` (OpenAPI 3.1) lists the read-only content
   operations: `/llms.txt`, `/llms-full.txt`, `/atom.xml`, `/sitemap.xml`,
   `/robots.txt`, `/.well-known/api-catalog`, `/auth.md`.
4. **Auth** — `GET /auth.md` explains credential use: none is required, and
   this origin publishes no OAuth metadata because it has no protected
   resource or authorization server.

## Conventions

- All content operations are `GET`, unauthenticated and cache-friendly.
- Responses are static assets; conditional requests (`If-None-Match`) are
  supported by the CDN.
- Errors return the site's HTML 404 page with status `404`; there is no JSON
  error envelope because there is no application server.

## Caching guidance

- `llms.txt`, `llms-full.txt`, feeds and discovery documents change at most
  daily — revalidate at most once per hour.
- Do not hammer the origin: every response is a cacheable static file.
