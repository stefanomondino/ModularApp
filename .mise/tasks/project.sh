#!/usr/bin/env sh
#MISE description="Generate project with Tuist"
#MISE alias="p"

set -euo pipefail

rm -rf Sources/Apps/*/Sources/Environments
tuist scaffold environments
tuist generate --open
