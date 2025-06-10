#!/usr/bin/env sh
# mise description="Setup project structur and git hooks and create project with Tuist"

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
tuist generate