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

This origin issues **no credentials for reading**: all content is public.
The registration surface below is the anonymous, agent-initiated flow
declared in the `agent_auth` block of the authorization server metadata
([/.well-known/oauth-authorization-server](/.well-known/oauth-authorization-server)).

**Supported registration method: `anonymous` → `api_key`**

1. `POST https://anhkhoakz.dev/agent/auth` with
   `Content-Type: application/x-www-form-urlencoded` and body
   `type=anonymous&requested_credential_type=api_key&requested_scopes=read`
   → returns a scoped credential plus a `claim_url`.
2. Optional claim: `POST https://anhkhoakz.dev/agent/auth/claim` with
   `claim_token` and the user's e-mail; the user confirms the one-time code
   at `.../claim/complete`.
3. Use the credential as `Authorization: Bearer <credential>`.
4. Revocation is provider-driven: expect a `logout+jwt` POST to
   `https://anhkhoakz.dev/agent/auth/revoke`, or simply drop the credential
   on `401`.

### Implementation status

The registration endpoints (`/agent/auth*`) are declared for machine
discovery but are **not yet implemented on this static origin** — they
currently answer `404`. Nothing on this site requires a credential, so an
agent never needs them to read content.

## agent_auth

```yaml
agent_auth:
  skill: https://anhkhoakz.dev/auth.md
  register_uri: https://anhkhoakz.dev/agent/auth
  claim_uri: https://anhkhoakz.dev/agent/auth/claim
  revocation_uri: https://anhkhoakz.dev/agent/auth/revoke
  identity_types_supported:
    - anonymous
  anonymous:
    credential_types_supported:
      - api_key
  events_supported:
    - https://schemas.workos.com/events/agent/auth/identity/assertion/revoked
```

## Revocation

No tokens are issued by this origin today, so there is nothing to revoke.
Should tokens be issued later, revocation will be advertised through
`events_supported` in the authorization server metadata, as above.
