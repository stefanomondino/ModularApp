#!/usr/bin/env sh
#MISE description="Setup project structure and git hooks and create project with Tuist"
#MISE depends=["sourcery", "git"]
#MISE alias="s"

tuist clean plugins manifests
tuist install
mise run project