#!/usr/bin/env bash
# ---------------------------------------------------------------
# run_gateway.sh  –  quick helper for infra/gateway stack
#   • terraform init / plan / apply
# ---------------------------------------------------------------
set -euo pipefail

GATEWAY_DIR="$(dirname "$0")/../infra/gateway"
PLAN_FILE=".tfplan.$(date +%s)"

echo "📁  Changing to $GATEWAY_DIR"
cd "$GATEWAY_DIR"

echo "🔧  terraform init"
terraform init -upgrade

echo "📝  terraform plan -out=$PLAN_FILE"
terraform plan -out="$PLAN_FILE"

echo "🚀  terraform apply $PLAN_FILE"
terraform apply "$PLAN_FILE"

echo "✅  Done. Outputs:"
terraform output

rm -f "$PLAN_FILE"
