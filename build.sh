#!/usr/bin/env bash
# Cloudflare Pages build entrypoint (Pages equivalent of netlify.toml's build contexts).
# Production branch = main; every other branch is a preview deployment.
#
# Cloudflare documents CF_PAGES_BRANCH / CF_PAGES_URL as injected by default, but we
# default them anyway so `set -u` can never abort the build if they're missing.
set -euo pipefail

BRANCH="${CF_PAGES_BRANCH:-}"
BASE_URL="${CF_PAGES_URL:-}"

# Fallback: derive the branch from the clone if Cloudflare didn't inject it.
if [ -z "$BRANCH" ] && command -v git >/dev/null 2>&1 && git rev-parse --verify --quiet HEAD >/dev/null; then
  BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  # Detached HEAD (common on CI clones) gives us nothing usable.
  [ "$BRANCH" = "HEAD" ] && BRANCH=""
fi

echo "build.sh: CF_PAGES_BRANCH=${CF_PAGES_BRANCH:-<unset>} CF_PAGES_URL=${CF_PAGES_URL:-<unset>} resolved_branch=${BRANCH:-<unknown>}"

if [ -z "$BRANCH" ] || [ "$BRANCH" = "main" ]; then
  # Production: baseURL comes from hugo.toml (https://www.anhkhoakz.dev/)
  echo "build.sh: production build"
  hugo --gc --minify --enableGitInfo
else
  # Mirrors netlify.toml [context.deploy-preview]: drafts + future posts, preview URL.
  echo "build.sh: preview build for $BRANCH"
  args=(--gc --minify --enableGitInfo --buildDrafts --buildFuture)
  if [ -n "$BASE_URL" ]; then
    args+=(--baseURL "$BASE_URL/")
  fi
  hugo "${args[@]}"
fi
