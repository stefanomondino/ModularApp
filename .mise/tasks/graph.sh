#!/usr/bin/env sh

#MISE description="Print project graph"
TUIST_SKIP_RECURSIVE_DEPENDENCIES=1 tuist graph --skip-external-dependencies --skip-test-targets --no-open --format svg
TUIST_SKIP_RECURSIVE_DEPENDENCIES=1 tuist graph --no-open --format dot
