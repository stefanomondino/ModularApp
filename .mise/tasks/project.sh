#!/usr/bin/env sh
# mise description="Generate project with Tuist"
#MISE alias="p"
rm -rf Sources/Apps/*/Sources/Environments
tuist scaffold environments
tuist generate --open --verbose
