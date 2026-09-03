+++
title = 'Sichtbarkeit für Suchmaschinen'
description = 'Steuern, ob und welche Seiten in Google & Co. auftauchen.'
weight = 10
tags = ['anleitung', 'betrieb']
+++

Standardmäßig darf jede Seite indiziert werden. Das lässt sich für die
gesamte Website oder für einzelne Seiten umstellen.

{{% notice style="warning" title="Kein Zugriffsschutz" %}}
Alles auf dieser Seite sind **Bitten an Suchmaschinen**, keine Sperre. Wer
die Adresse kennt, kann die Seite weiterhin aufrufen — auch bei `noindex`.
Für wirklich vertrauliche Inhalte reicht das nicht aus; siehe
[Wenn es wirklich nicht öffentlich sein darf](#wenn-es-wirklich-nicht-öffentlich-sein-darf).
{{% /notice %}}

## Die ganze Website ausnehmen

In `hugo.toml` unter `[params]`:

```toml
noindex = true
```

Das bewirkt zweierlei:

* `robots.txt` liefert `Disallow: /` und bittet damit alle Crawler, die
  Website gar nicht erst zu durchsuchen.
* Jede Seite bekommt zusätzlich `<meta name="robots" content="noindex, nofollow">`
  in den Kopfbereich — das greift auch dann, wenn eine Adresse einem Crawler
  über einen externen Link bekannt wird.

Zurück auf sichtbar: `noindex = false` (oder die Zeile entfernen).

## Nur einzelne Seiten ausnehmen

Im Front Matter der betreffenden Seite:

```toml
+++
title = 'Interne Notizen'
noindex = true
+++
```

Die Seiteneinstellung hat Vorrang vor der Website-Einstellung. Ist die
Website als Ganzes gesperrt, kann eine einzelne Seite mit `noindex = false`
also gezielt freigegeben werden.

{{% notice style="note" title="Warum beides?" %}}
`robots.txt` verhindert das *Crawlen*, der Meta-Tag das *Indizieren*. Eine
per `robots.txt` gesperrte Seite kann trotzdem in Suchergebnissen
auftauchen — nämlich dann, wenn andere Websites auf sie verlinken, denn den
Meta-Tag sieht der Crawler dann gar nicht erst. Deshalb setzt der Schalter
konsequent beides.
{{% /notice %}}

## Kontrollieren, was ausgeliefert wird

Nach `make build` lässt sich das Ergebnis direkt nachsehen:

```bash
cat public/robots.txt
grep -o '<meta name=robots[^>]*>' public/referenz/glossar/index.html
```

## Seiten ganz aus der Navigation nehmen

Unabhängig von Suchmaschinen kann eine Seite auch im Wiki selbst versteckt
werden — sie bleibt erreichbar, taucht aber nicht in Menü, Suche und
Übersichten auf:

```toml
+++
title = 'Entwurf'
hidden = true
+++
```

## Wenn es wirklich nicht öffentlich sein darf

Firebase Hosting liefert statische Dateien ohne Anmeldung aus — ein
Passwortschutz lässt sich dort nicht einfach vorschalten. Wenn Inhalte
tatsächlich nicht öffentlich sein dürfen, sind das die üblichen Wege:

* Das Wiki **nicht** auf Firebase Hosting veröffentlichen, sondern intern
  betreiben (z. B. hinter dem Firmen-VPN).
* Die Auslieferung über einen Dienst mit Zugriffsprüfung leiten
  (Cloud Run mit Identity-Aware Proxy vor dem Hosting).
* Die betroffenen Inhalte gar nicht erst ins Repository aufnehmen — ein
  öffentliches GitHub-Repository ist ohnehin für alle lesbar.
