+++
title = 'Neue Seite anlegen'
description = 'Von der leeren Datei bis zur veröffentlichten Seite.'
weight = 1
tags = ['anleitung', 'schreiben']
+++

# Neue Seite anlegen

Es gibt zwei Wege — direkt im Browser oder lokal mit Vorschau.

## Im Browser

1. Im Repository nach `content/` wechseln und in den passenden Ordner gehen.
2. **Add file → Create new file** wählen und einen Dateinamen mit der Endung
   `.md` vergeben, zum Beispiel `serverumzug.md`.
3. Front Matter und Text einfügen:

   ```toml
   +++
   title = 'Serverumzug'
   description = 'Ablauf und Checkliste für den Umzug.'
   weight = 20
   tags = ['betrieb']
   +++
   ```

4. Änderung committen. Sobald sie auf `main` landet, baut GitHub Actions
   die Seite neu und veröffentlicht sie.

{{% notice style="tip" title="Dateinamen" %}}
Kleinbuchstaben, Bindestriche statt Leerzeichen, keine Umlaute — der
Dateiname wird zur Adresse der Seite. Aus `serverumzug.md` wird
`/anleitungen/serverumzug/`.
{{% /notice %}}

## Lokal mit Vorschau

Voraussetzung ist [Hugo **extended**](https://gohugo.io/installation/)
ab Version 0.141 sowie Git.

```bash
git clone --recurse-submodules https://github.com/da-sa-li/Wikipeiredia.git
cd Wikipeiredia
make dev
```

Die Vorschau läuft danach auf <http://localhost:1313> und lädt bei jeder
Änderung automatisch neu.

Eine neue Seite legt `make new` an — inklusive vorbereitetem Front Matter:

```bash
make new t=anleitungen/serverumzug
```

Ein neues Kapitel entsteht analog:

```bash
make new-chapter t=betrieb
```

## Vor dem Veröffentlichen

{{% expand title="Kurze Checkliste" %}}
* `title` und `description` gesetzt?
* `weight` vergeben, damit die Seite an der richtigen Stelle einsortiert wird?
* Interne Links mit `relref` statt fester Pfade?
* `make build` läuft ohne Fehler durch?
{{% /expand %}}

{{% notice style="warning" title="Entwürfe" %}}
Seiten mit `draft = true` erscheinen in der lokalen Vorschau (`make dev`
zeigt Entwürfe an), werden aber **nicht** veröffentlicht. Vor dem
Veröffentlichen also nicht vergessen, das Feld zu entfernen.
{{% /notice %}}
