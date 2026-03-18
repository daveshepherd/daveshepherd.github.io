#!/usr/bin/env bash
set -euo pipefail

readonly HTMLPROOFER_IGNORE_URLS="/https:\/\/uk\.linkedin\.com\/in\/dashepherd/,/https:\/\/medium\.com\/@dave\.shepherd/,/https:\/\/dzone\.com\/articles\/creating-build-pipeline-using/,/https:\/\/medium\.com\/ww-engineering\/headers-propagation-with-hpropagate-27de8347f76a/,/https:\/\/medium\.com\/@pierre\.meunier/,/https:\/\/medium\.com\/r\/.*/"

bundle exec htmlproofer "$@" --ignore-urls "$HTMLPROOFER_IGNORE_URLS"