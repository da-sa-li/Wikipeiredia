+++
title = 'Einstieg'
description = 'Wie dieses Wiki aufgebaut ist und wo was hingehört.'
weight = 1
tags = ['einstieg']
+++

# Einstieg

Dieses Wiki ist eine statische Website: Aus Markdown-Dateien im Ordner
`content/` erzeugt [Hugo](https://gohugo.io/) fertiges HTML, das auf
Firebase Hosting ausgeliefert wird. Es gibt keine Datenbank und kein
Login — die Git-Historie ist die Versionsverwaltung.

## Aufbau

Jeder Ordner unter `content/` wird zu einem Kapitel in der Seitenleiste,
jede Markdown-Datei darin zu einer Seite.

```text
content/
├── _index.md          → Startseite
├── grundlagen/
│   ├── _index.md      → Kapitelseite "Grundlagen"
│   └── einstieg.md    → diese Seite
├── anleitungen/
└── referenz/
```

Die Datei `_index.md` beschreibt jeweils das Kapitel selbst. Fehlt sie,
taucht der Ordner nicht sauber in der Navigation auf.

## Front Matter

Jede Seite beginnt mit einem Block zwischen `+++`. Er steuert Titel,
Reihenfolge und Schlagwörter:

```toml
+++
title = 'Einstieg'
description = 'Kurzer Satz, der in Übersichten erscheint.'
weight = 1
tags = ['einstieg']
+++
```

| Feld | Bedeutung |
|---|---|
| `title` | Überschrift in Navigation, Browser-Tab und Suchergebnis |
| `description` | Kurztext in Kapitelübersichten und Social-Media-Vorschauen |
| `weight` | Reihenfolge in der Seitenleiste — kleiner heißt weiter oben |
| `tags` | Schlagwörter, gesammelt unter [Schlagwörter](/tags/) |
| `draft` | `true` blendet die Seite in der veröffentlichten Fassung aus |

{{% notice style="note" title="Reihenfolge" %}}
Seiten ohne `weight` landen hinter allen anderen und werden alphabetisch
einsortiert. Es lohnt sich, `weight` in Zehnerschritten zu vergeben
(10, 20, 30 …) — dann lässt sich später bequem etwas dazwischenschieben.
{{% /notice %}}

## Wo gehört was hin?

* **Grundlagen** — Begriffe und Konzepte, die man einmal versteht und dann kennt.
* **Anleitungen** — konkrete Abläufe mit einem klaren Ziel am Ende.
* **Referenz** — Nachschlagewerke, in denen man punktuell etwas sucht.
