#!/bin/bash
# Build / Validation stage: make sure every required file exists and is not empty
set -e
REQUIRED="index.html menu.html order.html css/style.css js/order.js"
for f in $REQUIRED; do
  if [ ! -s "$f" ]; then echo "FAIL: $f is missing or empty"; exit 1; fi
  echo "OK   : $f"
done
echo "Validation passed: all required files present."
