#!/bin/bash
# Test stage: basic automated checks on the website files
set -e
fail=0
for page in index.html menu.html order.html; do
  grep -qi "<!DOCTYPE html>" "$page"      || { echo "FAIL: $page has no DOCTYPE"; fail=1; }
  grep -q  "<title>"        "$page"      || { echo "FAIL: $page has no <title>"; fail=1; }
  grep -q  'css/style.css'  "$page"      || { echo "FAIL: $page does not link the stylesheet"; fail=1; }
  grep -q  'href="menu.html"' "$page"    || { echo "FAIL: $page is missing nav link to menu"; fail=1; }
  grep -q  'href="order.html"' "$page"   || { echo "FAIL: $page is missing nav link to order"; fail=1; }
  echo "Checked $page"
done
grep -q 'js/order.js' order.html || { echo "FAIL: order.html does not load order.js"; fail=1; }
grep -q "Saoji Mutton" menu.html || { echo "FAIL: menu is missing expected dishes"; fail=1; }
# every local href in the pages must point to a real file
for page in index.html menu.html order.html; do
  for link in $(grep -o 'href="[^"#:]*\.html"' "$page" | cut -d'"' -f2); do
    [ -f "$link" ] || { echo "FAIL: broken link $link in $page"; fail=1; }
  done
done
if [ $fail -ne 0 ]; then echo "TESTS FAILED"; exit 1; fi
echo "All tests passed."
