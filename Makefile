# Wikipeiredia — lokale Arbeitsbefehle.
# Voraussetzung: Hugo extended >= 0.141 (https://gohugo.io/installation/) und Git.
# Übersicht aller Befehle:  make help

HUGO ?= hugo

.DEFAULT_GOAL := help
.PHONY: help theme dev build check new new-chapter clean

help: ## Diese Übersicht anzeigen
	@echo "Wikipeiredia — verfügbare Befehle:"
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-14s\033[0m %s\n", $$1, $$2}'
	@echo
	@echo "Beispiele:"
	@echo "  make new t=anleitungen/backup"
	@echo "  make new-chapter t=betrieb"

# Holt das Theme nach, falls ohne --recurse-submodules geklont wurde.
theme:
	@git submodule update --init --recursive

dev: theme ## Vorschau auf http://localhost:1313 (zeigt auch Entwürfe)
	$(HUGO) server --buildDrafts --buildFuture --navigateToChanged

build: theme ## Website nach public/ bauen
	$(HUGO) --gc --minify

check: theme ## Bauen, jede Warnung gilt als Fehler (wie in der CI)
	$(HUGO) --gc --minify --panicOnWarning

new: ## Neue Seite anlegen — make new t=ordner/seitenname
	@test -n "$(t)" || { echo "Aufruf: make new t=ordner/seitenname"; exit 1; }
	$(HUGO) new content/$(t).md

new-chapter: ## Neues Kapitel anlegen — make new-chapter t=ordnername
	@test -n "$(t)" || { echo "Aufruf: make new-chapter t=ordnername"; exit 1; }
	$(HUGO) new content/$(t)/_index.md --kind chapter

clean: ## Build-Artefakte entfernen
	rm -rf public resources/_gen .hugo_build.lock
