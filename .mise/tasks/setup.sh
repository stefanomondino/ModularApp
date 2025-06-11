#!/usr/bin/env sh
#MISE description="Setup project structure and git hooks and create project with Tuist"
#MISE depends=["sourcery"]
#MISE alias="s"

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

git init
setupGit
mise install
tuist install
tuist generate