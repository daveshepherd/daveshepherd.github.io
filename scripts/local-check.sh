#!/usr/bin/env bash
set -euo pipefail

RUN_PERCY=false

for arg in "$@"; do
  case "$arg" in
    --percy)
      RUN_PERCY=true
      ;;
    *)
      echo "Unknown option: $arg"
      echo "Usage: scripts/local-check.sh [--percy]"
      exit 1
      ;;
  esac
done

echo "==> Installing gems (if needed)"
bundle install

echo "==> Running Jekyll doctor"
bundle exec jekyll doctor

echo "==> Building site in production mode"
JEKYLL_ENV=production bundle exec jekyll build

echo "==> Running html-proofer on generated site"
bundle exec htmlproofer ./_site --disable-external

if [[ "$RUN_PERCY" == "true" ]]; then
  if [[ -z "${PERCY_TOKEN:-}" ]]; then
    echo "PERCY_TOKEN is not set. Export it before running with --percy."
    exit 1
  fi

  echo "==> Running Percy snapshot"
  npx --yes @percy/cli snapshot _site
fi

echo "==> Local checks passed"
