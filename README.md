# Wikipeiredia

Quellcode der Doku-/Wiki-Website. Die Seiten sind Markdown-Dateien unter
`content/`, gebaut wird mit [Hugo](https://gohugo.io/), ausgeliefert über
[Firebase Hosting](https://firebase.google.com/docs/hosting).

| | |
|---|---|
| **Live** | https://wikipeiredia-393f3.web.app |
| **Theme** | [Relearn](https://mcshelby.github.io/hugo-theme-relearn/) 9.0.3 (Git-Submodule) |
| **Hugo** | extended, ab 0.141 — die CI baut mit 0.165.0 |
| **Deploy** | automatisch bei jedem Push auf `main` |

## Wie es zusammenhängt

```
   LOKAL                        GITHUB                       FIREBASE
 ┌──────────────┐          ┌──────────────────┐         ┌───────────────┐
 │ content/*.md │          │  Push auf main   │         │   Hosting     │
 │ hugo.toml    │─ push ──▶│        │         │         │               │
 │ themes/      │          │        ▼         │         │ wikipeiredia- │
 │  (Submodule) │          │  Actions:        │         │ 393f3.web.app │
 └──────┬───────┘          │   checkout       │         └───────▲───────┘
        │                  │   hugo --minify  │                 │
    make dev               │   → public/      │                 │
        │                  │   deploy ────────┼─────────────────┘
        ▼                  └──────────────────┘  Auth über Secret
   localhost:1313                                FIREBASE_SERVICE_ACCOUNT
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
make deploy        Bauen und von Hand veröffentlichen
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
├── scripts/              Build-Prüfung, von Makefile und CI gemeinsam genutzt
├── static/               Dateien, die unverändert ausgeliefert werden
├── themes/…relearn/      Theme als Submodule, auf Tag 9.0.3 festgenagelt
├── hugo.toml             Hugo- und Theme-Konfiguration
├── firebase.json         Hosting: Verzeichnis, Caching, Header
├── .firebaserc           Firebase-Projekt-ID
└── .github/workflows/    Build- und Deploy-Automatik
```

Wie Seiten geschrieben werden, steht im Wiki selbst unter
**Grundlagen → Einstieg** und **Anleitungen → Neue Seite anlegen**.

## Einmalige Einrichtung des Deployments

Damit der automatische Deploy funktioniert, sind drei Dinge nötig:

**1. Firebase-Projekt**

Angelegt und mit aktiviertem Hosting: **`wikipeiredia-393f3`**.

Die Projekt-ID steht im Repo an **genau einer Stelle** — in `.firebaserc`. Der
Deploy-Workflow gibt bewusst keine ID vor, sondern übernimmt sie von dort. Bei
einem Projektwechsel ist also nur diese eine Datei anzupassen.

Die ID muss zum hinterlegten Dienstkonto passen. Nachsehen lässt sie sich im
Feld `project_id` der Dienstkonto-JSON oder in der Firebase Console unter
⚙️ Projekteinstellungen → Allgemein.

> Nicht die Projekt-ID raten: Weicht sie vom tatsächlichen Projekt ab, schlägt
> der Deploy mit `403 PERMISSION_DENIED` fehl. Zeigt sie auf ein *gelöschtes*
> Projekt, hilft auch Neuanlegen nicht — Google sperrt die IDs gelöschter
> Projekte dauerhaft, sie lassen sich nie wieder vergeben.

**2. Dienstkonto-Schlüssel erzeugen**

Firebase Console → ⚙️ **Projekteinstellungen** → **Dienstkonten** →
**Neuen privaten Schlüssel generieren**. Es wird eine JSON-Datei
heruntergeladen.

**3. Schlüssel als GitHub-Secret hinterlegen**

Im Repository unter **Settings → Secrets and variables → Actions →
New repository secret**:

* Name: `FIREBASE_SERVICE_ACCOUNT`
* Wert: der **komplette** Inhalt der JSON-Datei

> Die JSON-Datei ist ein Zugangsschlüssel. Sie gehört nicht ins Repository —
> nur ins Secret.

Danach veröffentlicht jeder Push auf `main` die Seite automatisch. Ein Deploy
lässt sich zusätzlich jederzeit im Tab **Actions** von Hand auslösen.

### Von Hand veröffentlichen

Alternativ direkt vom eigenen Rechner, dafür wird Node benötigt:

```bash
npx firebase-tools login
make deploy
```

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

## Eigene Domain

Domain in der Firebase Console unter **Hosting → Eigene Domain hinzufügen**
verbinden, anschließend die `baseURL` in `hugo.toml` auf die neue Adresse
setzen — sonst zeigen Sitemap, RSS-Feed und absolute Links weiterhin auf
`wikipeiredia-393f3.web.app`. Die Projekt-ID in `.firebaserc` bleibt dabei
unverändert: Sie sagt, *wohin* deployed wird, die `baseURL` sagt, *unter
welcher Adresse* die Seite erreichbar ist.

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

### Bekannte Einschränkung: Abkündigungswarnungen

Relearn 9.0.3 verwendet noch vier Template-Funktionen, die Hugo in 0.156
bzw. 0.158 abgekündigt hat (`.Language.LanguageCode`,
`.Language.LanguageDirection`, `site.Sites`, `site.Languages`). Sie
funktionieren weiterhin, erzeugen aber Warnungen — Hugos `--panicOnWarning`
ist deshalb hier nicht nutzbar.

`scripts/check-build.sh` löst das: Es duldet genau diese
Abkündigungswarnungen und lässt den Build bei **jeder anderen** Warnung
fehlschlagen. Sobald Relearn nachzieht, kann das Skript entfallen und
`hugo --gc --minify --panicOnWarning` direkt verwendet werden.

Unabhängig davon brechen kaputte interne Links und fehlende Bilder den Build
immer ab — dafür sorgen `link.errorlevel` und `image.errorlevel` in
`hugo.toml`.
