# Wikipeiredia

Quellcode der Doku-/Wiki-Website. Die Seiten sind Markdown-Dateien unter
`content/`, gebaut wird mit [Hugo](https://gohugo.io/), ausgeliefert über
[Firebase Hosting](https://firebase.google.com/docs/hosting).

| | |
|---|---|
| **Live** | https://wikipeiredia.web.app |
| **Theme** | [Relearn](https://mcshelby.github.io/hugo-theme-relearn/) 9.0.3 (Git-Submodule) |
| **Hugo** | extended, ab 0.141 — die CI baut mit 0.165.0 |
| **Deploy** | automatisch bei jedem Push auf `main` |

## Wie es zusammenhängt

```
   LOKAL                        GITHUB                       FIREBASE
 ┌──────────────┐          ┌──────────────────┐         ┌───────────────┐
 │ content/*.md │          │  Push auf main   │         │   Hosting     │
 │ hugo.toml    │─ push ──▶│        │         │         │               │
 │ themes/      │          │        ▼         │         │  wikipeiredia │
 │  (Submodule) │          │  Actions:        │         │   .web.app    │
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

**1. Firebase-Projekt anlegen**

In der [Firebase Console](https://console.firebase.google.com/) ein Projekt
mit der ID `wikipeiredia` erstellen und darin **Hosting** aktivieren.
Heißt das Projekt anders, müssen die ID in `.firebaserc`, das Feld
`projectId` in `.github/workflows/deploy.yml` und die `baseURL` in
`hugo.toml` entsprechend angepasst werden.

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

## Eigene Domain

Domain in der Firebase Console unter **Hosting → Eigene Domain hinzufügen**
verbinden, anschließend die `baseURL` in `hugo.toml` auf die neue Adresse
setzen — sonst zeigen Sitemap, RSS-Feed und absolute Links weiterhin auf
`wikipeiredia.web.app`.

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
