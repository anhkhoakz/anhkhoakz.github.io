# auth.md

Authentication and registration notes for automated agents interacting with
`https://anhkhoakz.dev`.

## Audience

This origin is a **public, read-only personal site**. Every published
resource — articles, feeds, `llms.txt`, the sitemap, the API catalog and the
OpenAPI description — is served without credentials.

**Agents do not need to authenticate to read this site.** No cookie, token or
API key is required, and no endpoint returns `401` for anonymous requests.

## Endpoints

| Purpose | URL |
| --- | --- |
| Site root | `https://anhkhoakz.dev/` |
| API catalog (RFC 9727) | `https://anhkhoakz.dev/.well-known/api-catalog` |
| OpenAPI description | `https://anhkhoakz.dev/openapi.json` |
| Site index for models | `https://anhkhoakz.dev/llms.txt` |
| Full content | `https://anhkhoakz.dev/llms-full.txt` |
| Discovery docs | `https://anhkhoakz.dev/docs/` |
| OAuth authorization server metadata | `https://anhkhoakz.dev/.well-known/oauth-authorization-server` |
| Protected resource metadata (RFC 9728) | `https://anhkhoakz.dev/.well-known/oauth-protected-resource` |
| JWKS | `https://anhkhoakz.dev/.well-known/jwks.json` |

## Credential use

- **Method:** none for public content.
- **If a `401` is ever returned**, it will carry:
  `WWW-Authenticate: Bearer resource_metadata="https://anhkhoakz.dev/.well-known/oauth-protected-resource"`
  — fetch that document, follow `authorization_servers`, complete the flow and
  send the resulting token as `Authorization: Bearer <token>`.
- **Scopes:** the only advertised scope is `read`.
- Never send credentials in query strings.

## Registration

<a id="registration"></a>

`register_uri: https://anhkhoakz.dev/auth.md#registration`

Registration methods, in order of preference:

1. **`none` (public client)** — the default. Reading this site is anonymous;
   no client registration, client secret or token is issued or needed.
2. **`manual`** — if a private or write endpoint is ever exposed, request a
   public client id by opening an issue on the site's source repository; the
   issued client uses `token_endpoint_auth_method: none` with the
   `client_credentials` grant and the `read` scope.

## agent_auth

```yaml
agent_auth:
  skill: https://anhkhoakz.dev/.well-known/agent-skills/site-index/SKILL.md
  register_uri: https://anhkhoakz.dev/auth.md#registration
  registration_methods:
    - type: none
      description: Public read-only access; no registration or token required.
      token_endpoint_auth_method: none
      grant_type: client_credentials
      scopes: [read]
    - type: manual
      description: Request a public client id via the site source repository issue tracker.
      token_endpoint_auth_method: none
      grant_type: client_credentials
      scopes: [read]
```

## Revocation

No tokens are issued by this origin today, so there is nothing to revoke.
Should tokens be issued later, revocation will be advertised through
`events_supported` in the authorization server metadata.
