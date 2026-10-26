#!/bin/bash
set -e

if [ -z "$AZP_URL" ]; then
  echo "Error: AZP_URL environment variable is not set." >&2
  exit 1
fi

if [ -z "$AZP_TOKEN_FILE" ]; then
  if [ -z "$AZP_TOKEN" ]; then
    echo "Error: AZP_TOKEN environment variable is not set." >&2
    exit 1
  fi

  AZP_TOKEN_FILE="/tmp/.token"
  echo -n "$AZP_TOKEN" > "$AZP_TOKEN_FILE"
fi

unset AZP_TOKEN

AZP_AGENT_NAME=${AZP_AGENT_NAME:-"$(hostname)"}
AZP_POOL=${AZP_POOL:-"default"}
AZP_WORK=${AZP_WORK:-"_work"}

cleanup() {
  trap "" EXIT

  if [ -e ./config.sh ]; then
    ./config.sh remove --unattended \
      --auth PAT \
      --token "$(cat "$AZP_TOKEN_FILE")"
  fi
}

print_header() {
  lightcyan='\033[1;36m'
  nocolor='\033[0m'
  echo -e "${lightcyan}$1${nocolor}"
}

print_header "1. Determining matching Azure Pipelines agent package..."

AZP_AGENT_RESPONSE=$(curl -LsS \
  -u "user:$(cat "$AZP_TOKEN_FILE")" \
  -H 'Accept:application/json' \
  "$AZP_URL/_apis/distributedtask/packages/agent?platform=linux-x64&top=1")

AZP_AGENT_PACKAGE_LATEST_URL=$(echo "$AZP_AGENT_RESPONSE" | jq -r '.value[0].downloadUrl')

if [ -z "$AZP_AGENT_PACKAGE_LATEST_URL" ] || [ "$AZP_AGENT_PACKAGE_LATEST_URL" = "null" ]; then
  echo "Error: Could not determine download URL for Azure Pipelines agent package." >&2
  exit 1
fi

print_header "2. Downloading and extracting Azure Pipelines agent..."

curl -LsS "$AZP_AGENT_PACKAGE_LATEST_URL" | tar -xz

source ./env.sh

trap 'cleanup; exit 0' EXIT
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

print_header "3. Configuring Azure Pipelines agent..."

./config.sh --unattended \
  --agent "$AZP_AGENT_NAME" \
  --url "$AZP_URL" \
  --auth PAT \
  --token "$(cat "$AZP_TOKEN_FILE")" \
  --pool "$AZP_POOL" \
  --work "$AZP_WORK" \
  --replace \
  --acceptTeeEula

print_header "4. Running Azure Pipelines agent..."

chmod +x ./run.sh
./run.sh "$@"