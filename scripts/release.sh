#!/usr/bin/env bash
# -----------------------------------------------------------------
# release.sh  –  Tag a release and promote the selected (or next)
#               blue/green stage to the production custom domain.
#
# Usage:
#   ./release.sh              # auto-detect next colour
#   ./release.sh blue         # force blue
#   ./release.sh green v0.2   # tag v0.2 and promote green
# -----------------------------------------------------------------
set -euo pipefail

COLOR_ARG=${1:-""}
VERSION=${2:-v0.1}

# ensure clean git working tree
if [[ -n $(git status --porcelain) ]]; then
  echo '❌  Working tree not clean. Commit or stash first.' >&2
  exit 1
fi

# tag release
if git rev-parse "$VERSION" >/dev/null 2>&1; then
  echo "ℹ️  Tag $VERSION already exists – skipping tag step"
else
  echo "🏷️  Tagging $VERSION"
  git tag -a "$VERSION" -m "Release $VERSION"
  git push origin "$VERSION"
fi

API_ID=$(terraform output -raw api_id)
PROD_DOMAIN=$(terraform output -raw prod_custom_domain)

CURRENT_COLOR=$(aws apigatewayv2 get-api-mappings --domain-name "$PROD_DOMAIN"                  --query 'Items[0].Stage' --output text 2>/dev/null || echo "blue")

if [[ -n "$COLOR_ARG" ]]; then
  NEXT_COLOR=$COLOR_ARG
else
  [[ "$CURRENT_COLOR" == "blue" ]] && NEXT_COLOR="green" || NEXT_COLOR="blue"
fi

if [[ "$NEXT_COLOR" == "$CURRENT_COLOR" ]]; then
  echo "ℹ️  $NEXT_COLOR already live – nothing to promote."
  exit 0
fi

echo "🔄  Promoting colour $NEXT_COLOR (current: $CURRENT_COLOR)"

MAPPING_ID=$(aws apigatewayv2 get-api-mappings --domain-name "$PROD_DOMAIN"               --query 'Items[0].ApiMappingId' --output text 2>/dev/null || echo "")

if [[ "$MAPPING_ID" == "None" || -z "$MAPPING_ID" ]]; then
  echo "➕  Creating new mapping"
  aws apigatewayv2 create-api-mapping     --api-id "$API_ID"     --domain-name "$PROD_DOMAIN"     --stage "$NEXT_COLOR"     --api-mapping-key ""
else
  echo "✏️  Updating mapping $MAPPING_ID"
  aws apigatewayv2 update-api-mapping     --domain-name "$PROD_DOMAIN"     --api-mapping-id "$MAPPING_ID"     --api-id "$API_ID"     --stage "$NEXT_COLOR"
fi

echo "✅  Production now points to stage $NEXT_COLOR"
