#!/usr/bin/env sh
#MISE description="Test and generate results"

rm -rf tests.xcresult
tuist test --result-bundle-path tests.xcresult --clean
xcresultparser -o junit tests.xcresult > results.junit
xcresultparser -o cobertura tests.xcresult > coverage.xml