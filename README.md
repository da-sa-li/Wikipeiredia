# Wikipeiredia

Quellcode der Doku-/Wiki-Website. Die Seiten sind Markdown-Dateien unter
`content/`, gebaut wird mit [Hugo](https://gohugo.io/), ausgeliefert über
[GitHub Pages](https://docs.github.com/pages).

| | |
|---|---|
| **Live** | https://wiki.fertigs.bike |
| **Theme** | [Relearn](https://mcshelby.github.io/hugo-theme-relearn/) 9.0.3 (Git-Submodule) |
| **Hugo** | extended, ab 0.141 — die CI baut mit 0.169.0 |
| **Deploy** | automatisch bei jedem Push auf `main` |

## Wie es zusammenhängt

```
   LOKAL                        GITHUB
 ┌──────────────┐           ┌──────────────────┐
 │ content/*.md │           │  Push auf main   │
 │ hugo.toml    │─ push ──> │        │         │
 │ themes/      │           │        ▼         │
 │  (Submodule) │           │  Actions:        │      wiki.fertigs.bike
 └──────┬───────┘           │   checkout       │
        │                   │   hugo --minify  │      ┌──────────────┐
    make dev                │   → public/      │      │ GitHub Pages │
        │                   │   deploy ────────┼────> │              │
        ▼                   └──────────────────┘      └──────────────┘
   localhost:1313
```

## Lokal loslegen

Gebraucht werden nur **Git** und **Hugo extended** – Node ist zum Schreiben
nicht nötig.

```bash
git clone --recurse-submodules https://github.com/da-sa-li/Wikipeiredia.git
cd Wikipeiredia
make dev
```

Die Vorschau läuft auf <http://localhost:1313> und lädt bei jeder Änderung neu.

> Das `--recurse-submodules` vergessen? Kein Problem — jedes `make`-Ziel holt
> das Theme bei Bedarf selbst nach.

### Befehle

```
make help          Übersicht aller Befehle
make dev           Vorschau starten (zeigt auch Entwürfe)
make build         Website nach public/ bauen
make check         Bauen, wobei jede Warnung als Fehler gilt (wie in der CI)
make new t=…       Neue Seite anlegen, z. B. make new t=anleitungen/backup
make new-chapter t=…  Neues Kapitel anlegen, z. B. make new-chapter t=betrieb
make clean         Build-Artefakte entfernen
```

## Aufbau des Repos

```
├── content/              Die eigentlichen Wiki-Seiten (Markdown)
│   ├── _index.md         Startseite
│   ├── grundlagen/       Kapitel — je Ordner eine _index.md
│   ├── anleitungen/
│   └── referenz/
├── archetypes/           Vorlagen für „make new“
├── layouts/              Eigene Ergänzungen am Theme (robots.txt, head)
├── static/               Dateien, die unverändert ausgeliefert werden (inkl. CNAME)
├── themes/…relearn/      Theme als Submodule, auf Tag 9.0.3 festgenagelt
├── hugo.toml             Hugo- und Theme-Konfiguration
└── .github/workflows/    Build- und Deploy-Automatik
```

Wie Seiten geschrieben werden, steht im Wiki selbst unter
**Grundlagen → Einstieg** und **Anleitungen → Neue Seite anlegen**.

## Einmalige Einrichtung des Deployments

Es sind keine Secrets nötig, die Anmeldung übernimmt GitHub selbst.

**1. Pages aktivieren**

Im Repository unter **Settings → Pages → Build and deployment → Source**
den Eintrag **GitHub Actions** wählen.

**2. Eigene Domain eintragen**

Unter **Settings → Pages → Custom domain** `wiki.fertigs.bike` eintragen
(die Datei `static/CNAME` hält die Domain zusätzlich im Repo fest). Beim
DNS-Anbieter muss der Eintrag `wiki` als **CNAME** auf `da-sa-li.github.io`
zeigen; bisher zeigte er auf Firebase. Danach **Enforce HTTPS** aktivieren,
sobald das Zertifikat bereitsteht (das kann einige Minuten dauern).

Danach veröffentlicht jeder Push auf `main` die Seite automatisch. Ein Deploy
lässt sich zusätzlich jederzeit im Tab **Actions** von Hand auslösen.

## Sichtbarkeit für Suchmaschinen

Standardmäßig darf die Website indiziert werden. Umstellen in `hugo.toml`:

```toml
[params]
  noindex = true   # robots.txt sperrt alles + noindex-Meta-Tag auf jeder Seite
```

Einzelne Seiten lassen sich über `noindex = true` in ihrem Front Matter
ausnehmen. Das ist eine Bitte an Suchmaschinen, **kein Zugriffsschutz** —
Details und Alternativen stehen im Wiki unter
**Anleitungen → Sichtbarkeit für Suchmaschinen**.

## Domain ändern

Neue Adresse in `static/CNAME`, in der `baseURL` von `hugo.toml` und unter
**Settings → Pages → Custom domain** eintragen und den DNS-Eintrag anpassen.

## Theme aktualisieren

```bash
cd themes/hugo-theme-relearn
git fetch --tags
git checkout <neuer-tag>      # verfügbare Versionen: git tag --sort=-v:refname | head
cd ../..
make check                    # muss ohne Warnung durchlaufen
git add themes/hugo-theme-relearn
git commit -m "Theme auf Relearn <neuer-tag> aktualisiert"
```

Der [Changelog des Themes](https://github.com/McShelby/hugo-theme-relearn/blob/main/CHANGELOG.md)
nennt bei größeren Sprüngen die nötigen Anpassungen an `hugo.toml`.

### Strenge Build-Prüfung

`make check` (und die CI) bauen mit `hugo --gc --minify --panicOnWarning`:
**Jede** Warnung lässt den Build fehlschlagen, auch Abkündigungen durch Hugo
oder das Theme. Bricht der Build nach einem Theme- oder Hugo-Update ab, zeigt
die Warnung meist direkt, was zu ändern ist.

Unabhängig davon brechen kaputte interne Links und fehlende Bilder den Build
immer ab — dafür sorgen `link.errorlevel` und `image.errorlevel` in
`hugo.toml`.
