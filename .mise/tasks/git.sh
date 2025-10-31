#!/usr/bin/env sh
#MISE description="Setup git and creates required webhooks"
#MISE depends=["sourcery"]

setupGit() {
  if [ -d ".git" ]; then
    cat > .git/hooks/pre-commit << ENDOFFILE
#!/bin/sh

source ~/.profile

FILES=\$(git diff --cached --name-only --diff-filter=ACMR "*.swift" | sed 's| |\\ |g')
[ -z "\$FILES" ] && exit 0

# Format
swiftformat \$FILES

# Lint
swiftlint --fix \$FILES
swiftlint lint \$FILES

# Add back the formatted/linted files to staging
echo "\$FILES" | xargs git add

exit 0
ENDOFFILE

    chmod +x .git/hooks/pre-commit
  fi
}

set -euo pipefail

git init
setupGit