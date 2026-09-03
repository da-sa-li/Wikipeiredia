+++
title = 'Formatierung'
description = 'Hinweisboxen, Reiter, Diagramme und die übrigen Bausteine im Überblick.'
weight = 2
tags = ['markdown', 'referenz']
+++

# Formatierung

Neben normalem Markdown stehen die Bausteine des Relearn-Themes zur
Verfügung. Diese Seite zeigt die wichtigsten — sie ist bewusst als
Spickzettel gedacht.

## Hinweisboxen

{{% notice style="info" title="Zur Information" %}}
Neutraler Hinweis für Zusatzinformationen.
{{% /notice %}}

{{% notice style="tip" title="Tipp" %}}
Etwas, das die Arbeit leichter macht.
{{% /notice %}}

{{% notice style="warning" title="Achtung" %}}
Etwas, das schiefgehen kann.
{{% /notice %}}

Geschrieben wird das so:

```markdown
{{%/* notice style="tip" title="Tipp" */%}}
Etwas, das die Arbeit leichter macht.
{{%/* /notice */%}}
```

Verfügbare Werte für `style`: `info`, `note`, `tip`, `warning` sowie
Farbnamen wie `blue`, `green`, `red`, `cyan`.

## Reiter

{{< tabs >}}
{{% tab title="Linux / macOS" %}}
```bash
make dev
```
{{% /tab %}}
{{% tab title="Windows" %}}
```powershell
hugo server -D
```
{{% /tab %}}
{{< /tabs >}}

## Ausklappbare Abschnitte

{{% expand title="Warum statische Websites?" %}}
Kein Server, der gewartet werden muss, keine Datenbank, die kaputtgehen
kann — und die Auslieferung über ein CDN ist schnell und günstig.
{{% /expand %}}

## Diagramme

Diagramme entstehen aus Text ([Mermaid](https://mermaid.js.org/)) und
liegen damit ebenfalls versioniert im Git:

```mermaid
flowchart LR
    A[Markdown in content/] --> B[Hugo Build]
    B --> C[public/]
    C --> D[Firebase Hosting]
    D --> E[wikipeiredia.web.app]
```

## Textauszeichnung

| Schreibweise | Ergebnis |
|---|---|
| `**fett**` | **fett** |
| `*kursiv*` | *kursiv* |
| `` `Code` `` | `Code` |
| `==markiert==` | ==markiert== |
| `++eingefügt++` | ++eingefügt++ |
| `~~gelöscht~~` | ~~gelöscht~~ |
| `H~2~O` | H~2~O |
| `x^2^` | x^2^ |

## Verweise auf andere Seiten

Interne Links werden mit `relref` gesetzt. Der Vorteil: Zeigt der Link ins
Leere, bricht der Build ab, statt einen toten Link zu veröffentlichen.

```markdown
[Einstieg]({{%/* relref "grundlagen/einstieg" */%}})
```

Ergebnis: [Einstieg]({{% relref "grundlagen/einstieg" %}})

## Abbildungen

Bilder gehören neben die Seite, die sie verwendet (Page Bundle), oder
für Seitenübergreifendes nach `static/`:

```markdown
![Beschreibung des Bildes](diagramm.png?width=40vw)
```

{{% notice style="note" title="Alternativtext nicht vergessen" %}}
Der Text in eckigen Klammern wird vorgelesen, wenn das Bild nicht
angezeigt werden kann. Er gehört zu jedem Bild dazu.
{{% /notice %}}
