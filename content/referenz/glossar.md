+++
title = 'Glossar'
description = 'Begriffe, die in diesem Wiki immer wieder vorkommen.'
weight = 1
tags = ['referenz']
+++

# Glossar

**Front Matter**
: Der Konfigurationsblock zwischen `+++` am Anfang jeder Markdown-Datei.
  Steuert Titel, Reihenfolge, Schlagwörter und Sichtbarkeit einer Seite.

**Hugo**
: Der Generator, der aus den Markdown-Dateien die fertige Website baut.
  Dieses Wiki benötigt die *extended*-Variante.

**Firebase Hosting**
: Der Dienst, der die gebaute Website ausliefert — inklusive CDN und
  HTTPS-Zertifikat.

**Kapitel**
: Ein Ordner unter `content/` mit einer `_index.md`. Erscheint in der
  Seitenleiste als aufklappbarer Eintrag.

**Page Bundle**
: Ein Ordner, der eine `index.md` und die zugehörigen Bilder gemeinsam
  enthält. Praktisch, wenn eine Seite eigene Abbildungen mitbringt.

**Shortcode**
: Ein Baustein in geschweiften Klammern, der mehr kann als reines
  Markdown — etwa Hinweisboxen oder Reiter. Siehe
  [Formatierung]({{% relref "grundlagen/formatierung" %}}).

**Submodule**
: Ein fremdes Git-Repository, das in dieses eingebunden ist. Hier das
  Relearn-Theme unter `themes/hugo-theme-relearn`.

**weight**
: Zahl im Front Matter, die die Reihenfolge in der Seitenleiste bestimmt.
  Kleinere Werte stehen weiter oben.
