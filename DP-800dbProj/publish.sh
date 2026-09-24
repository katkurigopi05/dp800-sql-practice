#!/usr/bin/env bash
# Build the project into a .dacpac, then publish it to the existing Azure database.
#   ./publish.sh            build + publish to DP800Free
#   ./publish.sh --preview  build + write the change script only (nothing is deployed)
set -euo pipefail

cd "$(dirname "$0")"

SERVER="${SQL_SERVER:?Set SQL_SERVER to your Azure SQL server, e.g. myserver.database.windows.net}"
DATABASE="DP800Free"
PROFILE="DP-800dbProj_PublishProfile.publish.xml"
DACPAC="bin/Debug/DP-800dbProj.dacpac"
PREVIEW_FILE="bin/Debug/publish_preview.sql"
SQLPACKAGE="${SQLPACKAGE:-$HOME/.dotnet/tools/sqlpackage}"

echo "==> Building $DACPAC"
dotnet build --nologo -v quiet

echo "==> Getting Entra access token from az CLI"
TOKEN=$(az account get-access-token --resource https://database.windows.net/ --query accessToken -o tsv)

COMMON_ARGS=(
  /SourceFile:"$DACPAC"
  /Profile:"$PROFILE"
  /TargetServerName:"$SERVER"
  /TargetDatabaseName:"$DATABASE"
  /AccessToken:"$TOKEN"
)

if [[ "${1:-}" == "--preview" ]]; then
  echo "==> Writing change script for $DATABASE (no changes made)"
  "$SQLPACKAGE" /Action:Script "${COMMON_ARGS[@]}" /OutputPath:"$PREVIEW_FILE"
  echo "==> Review: $PREVIEW_FILE"
else
  echo "==> Publishing to $SERVER / $DATABASE"
  "$SQLPACKAGE" /Action:Publish "${COMMON_ARGS[@]}"
fi
