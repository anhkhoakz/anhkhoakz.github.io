+++
description = "Machine-readable endpoints and agent discovery documents published on this site: API catalog, OpenAPI, llms.txt, feeds, auth.md and skills."
title = "Docs"
weight = 5
+++

# Machine-readable resources

This site is static, public and read-only.
Everything below is a plain `GET` with no authentication,
designed so people, crawlers and automated agents can work with it.

## Discovery

| Relation | URL | Notes |
| --- | --- | --- |
| `api-catalog` | [/.well-known/api-catalog](/.well-known/api-catalog) | API catalog, [RFC 9727](https://www.rfc-editor.org/rfc/rfc9727), `application/linkset+json` |
| `service-desc` | [/openapi.json](/openapi.json) | [OpenAPI 3.1](https://spec.openapis.org/oas/v3.1.0) description of the content endpoints |
| `service-doc` | [/docs/](/docs/) | This page |
| `describedby` | [/llms.txt](/llms.txt) | Site index for language models |

Every HTML response also carries these as `Link` response headers
([RFC 8288](https://www.rfc-editor.org/rfc/rfc8288)):

```http
Link: </.well-known/api-catalog>; rel="api-catalog"; type="application/linkset+json",
      </openapi.json>; rel="service-desc"; type="application/json",
      </docs/>; rel="service-doc"; type="text/html",
      </llms.txt>; rel="describedby"; type="text/plain"
```

## Content endpoints

| Endpoint | Format | Purpose |
| --- | --- | --- |
| [/llms.txt](/llms.txt) | Markdown | Site index: title, summary and important pages |
| [/llms-full.txt](/llms-full.txt) | Markdown | Every published page and post in one file |
| [/atom.xml](/atom.xml) | Atom 1.0 | Recent posts |
| [/index.xml](/index.xml) | RSS 2.0 | Recent posts |
| [/sitemap.xml](/sitemap.xml) | XML | Every canonical URL |
| [/robots.txt](/robots.txt) | Text | Crawler rules, AI bot rules and Content Signals |

## Agent discovery documents

| Document | URL |
| --- | --- |
| Auth.md (authentication notes) | [/auth.md](/auth.md) |
| Agent Skills discovery index | [/.well-known/agent-skills/index.json](/.well-known/agent-skills/index.json) |
| Web Bot Auth key directory (RFC 9421) | [/.well-known/http-message-signatures-directory](/.well-known/http-message-signatures-directory) |

This origin has no OAuth authorization server, no MCP server and no A2A
agent endpoint, so no OAuth, MCP or A2A discovery documents are published —
advertising endpoints that do not exist would waste an agent's round trips.

## Content preferences

`/robots.txt` declares [Content Signals](https://contentsignals.org/):

```http
Content-Signal: ai-train=no, search=yes, ai-input=yes
```

Search and answer products may index and quote this material with
attribution; training on it is not permitted.

## Authentication

None is required — see [/auth.md](/auth.md) for credential use and the
supported (anonymous) access methods.
