#!/usr/bin/env sh
#MISE description="Lint the entire project with swiftlint and swiftformat"
#MISE alias="l"

swiftformat "Sources"
swiftformat "Tuist"
swiftlint --fix "Sources"
swiftlint --fix "Tuist"