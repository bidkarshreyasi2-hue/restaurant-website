#!/bin/bash
set -e
TARGET="/c/restaurant-site"
mkdir -p "$TARGET"
rm -rf "$TARGET"/*
cp -r index.html menu.html order.html css js "$TARGET"/
echo "Deployed to C:/restaurant-site"
ls "$TARGET"
