#!/usr/bin/env bash
# Cloudflare Pages build entrypoint (Pages equivalent of netlify.toml's build contexts).
# Production branch = main; every other branch is a preview deployment.
set -euo pipefail

if [ "$CF_PAGES_BRANCH" = "main" ]; then
  # baseURL comes from hugo.toml: https://www.anhkhoakz.dev/
  hugo --gc --minify --enableGitInfo
else
  # Mirrors netlify.toml [context.deploy-preview].
  hugo --gc --minify --enableGitInfo \
    --buildDrafts --buildFuture \
    --baseURL "$CF_PAGES_URL/"
fi
