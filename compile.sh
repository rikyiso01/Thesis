#!/usr/bin/env bash

set -euo pipefail

OUTDIR=./out
SRCDIR=./latex
FIGSDIR=./figs

mkdir -p "$OUTDIR"
cp $SRCDIR/* "$OUTDIR"
cp -r "$FIGSDIR" "$OUTDIR"

pandoc --defaults pandoc.yml -o "$OUTDIR/main.tex"

for file in ./chapters/*.md
do
    targetdir="$OUTDIR"
    mkdir -p "$targetdir"
    target="$targetdir/$(basename "$file" .md).tex"
    pandoc "$file" -o "$target" --biblatex
done

(cd "$OUTDIR" && nix run .)

cp "$OUTDIR/main.pdf" ./result.pdf
