#!/usr/bin/env sh
#MISE description="Creates required sourcery files in the Sources directory"

start_dir="Sources"
  if [ -z "$start_dir" ]; then
    echo "Error: You must specify the starting directory as a parameter or START_DIR env variable."
    exit 1
  fi

  find "$start_dir" -type f -name 'sourcery.yml' | while read file; do
    dir=$(dirname "$file")
    cd "$dir"
    echo "Found 'sourcery.yml' in $dir. Executing command 'mise exec sourcery -- sourcery --config sourcery.yml'."
    mise exec sourcery -- sourcery --config sourcery.yml --quiet
    cd - > /dev/null
  done


