# auth.md

Authentication notes for automated agents interacting with
`https://anhkhoakz.dev`.

## Audience

This origin is a **public, read-only personal site**. Every published
resource — articles, feeds, `llms.txt`, the sitemap, the API catalog, the
OpenAPI description and the discovery documents below — is served without
credentials.

**Agents do not need to authenticate to read this site.** No cookie, token or
API key is required, no endpoint returns `401`, and nothing here issues
credentials.

## Supported methods

| Method | When to use |
| --- | --- |
| `none` (anonymous) | Always. All content is public and cacheable; send no `Authorization` header. |
| `manual` | Only if a private endpoint ever appears: request access through the site's public source repository. |

There are **no registration or provisioning endpoints on this origin** — no
user accounts, no client registration, no token endpoint. An agent that is
asked to "register" here should report that the service needs no
registration rather than attempting a flow.

## Endpoints

| Purpose | URL |
| --- | --- |
| Site root | `https://anhkhoakz.dev/` |
| API catalog (RFC 9727) | `https://anhkhoakz.dev/.well-known/api-catalog` |
| OpenAPI description | `https://anhkhoakz.dev/openapi.json` |
| Site index for models | `https://anhkhoakz.dev/llms.txt` |
| Full content | `https://anhkhoakz.dev/llms-full.txt` |
| Discovery docs | `https://anhkhoakz.dev/docs/` |
| Agent Skills index | `https://anhkhoakz.dev/.well-known/agent-skills/index.json` |
| Web Bot Auth key directory (RFC 9421) | `https://anhkhoakz.dev/.well-known/http-message-signatures-directory` |

## Credential use

- Send no credentials; if a future response ever returns `401`, honour the
  `WWW-Authenticate` challenge it carries instead of guessing.
- Never send credentials in query strings.
- Respect `robots.txt`, including its `Content-Signal` directives.

## Discovery

Every HTML response on this origin advertises machine-readable entry points:

```http
Link: </.well-known/api-catalog>; rel="api-catalog", </openapi.json>; rel="service-desc",
      </docs/>; rel="service-doc", </llms.txt>; rel="describedby"
```

OAuth Protected Resource Metadata (RFC 9728) and authorization server
metadata (RFC 8414) are deliberately **not** published: there is no
protected resource and no authorization server on this origin to advertise.
