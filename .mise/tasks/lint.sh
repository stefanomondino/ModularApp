#!/usr/bin/env sh
#MISE description="Lint the entire project with swiftlint and swiftformat"
#MISE alias="l"

swiftformat "Sources" --swift-version 6.2
swiftformat "./Tuist" --swift-version 6.2
swiftlint --fix "Sources"
swiftlint --fix "./Tuist"