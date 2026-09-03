#!/usr/bin/env bash
#
# Baut die Website und wertet die Ausgabe streng aus.
#
# Hintergrund: Hugos --panicOnWarning ist hier nicht nutzbar. Das Relearn-Theme
# verwendet noch Template-Funktionen, die Hugo in 0.156/0.158 abgekündigt hat
# (.Language.LanguageCode, .Language.LanguageDirection, site.Sites,
# site.Languages). Sie funktionieren weiterhin, erzeugen aber Warnungen — mit
# --panicOnWarning bräche der Build daran ab, ohne dass an unseren Inhalten
# etwas falsch wäre.
#
# Deshalb: Abkündigungswarnungen des Themes werden geduldet, jede andere
# Warnung lässt den Build fehlschlagen. Sobald Relearn nachzieht, kann diese
# Ausnahme entfallen und --panicOnWarning direkt verwendet werden.

set -euo pipefail

HUGO="${HUGO:-hugo}"
LOG="$(mktemp)"
trap 'rm -f "$LOG"' EXIT

"$HUGO" --gc --minify 2>&1 | tee "$LOG"

# Abkündigungen des Themes herausfiltern, alles andere zählt.
UNEXPECTED="$(grep -E '^WARN' "$LOG" | grep -v 'deprecated:' || true)"

if [ -n "$UNEXPECTED" ]; then
  echo
  echo "FEHLER: Unerwartete Warnungen im Build:" >&2
  echo "$UNEXPECTED" >&2
  exit 1
fi

DEPRECATED_COUNT="$(grep -cE '^WARN.*deprecated:' "$LOG" || true)"
echo
echo "Build in Ordnung — keine unerwarteten Warnungen."
echo "(${DEPRECATED_COUNT} geduldete Abkündigungswarnung(en) aus dem Relearn-Theme)"
