# Makefile pour git-fleet Homebrew formula
# Usage: make update VERSION=v0.4.3

FORMULA_FILE = git-fleet.rb
REPO = qskkk/git-fleet
GITHUB_API = https://api.github.com/repos/$(REPO)/releases/latest

# Version par défaut (peut être surchargée avec make update VERSION=vX.X.X)
VERSION ?= $(shell curl -s $(GITHUB_API) | jq -r '.tag_name')

# URLs des binaires
DARWIN_AMD64_URL = https://github.com/$(REPO)/releases/download/$(VERSION)/git-fleet-$(VERSION)-darwin-amd64.tar.gz
DARWIN_ARM64_URL = https://github.com/$(REPO)/releases/download/$(VERSION)/git-fleet-$(VERSION)-darwin-arm64.tar.gz
LINUX_AMD64_URL = https://github.com/$(REPO)/releases/download/$(VERSION)/git-fleet-$(VERSION)-linux-amd64.tar.gz
LINUX_ARM64_URL = https://github.com/$(REPO)/releases/download/$(VERSION)/git-fleet-$(VERSION)-linux-arm64.tar.gz

# Répertoire temporaire pour les téléchargements
TEMP_DIR = /tmp/git-fleet-checksums

.PHONY: help update clean check-deps download-binaries calculate-checksums update-formula

help: ## Affiche cette aide
	@echo "Commandes disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

check-deps: ## Vérifie que les dépendances sont installées
	@command -v curl >/dev/null 2>&1 || { echo "curl est requis mais non installé. Aborting." >&2; exit 1; }
	@command -v jq >/dev/null 2>&1 || { echo "jq est requis mais non installé. Installez avec: brew install jq" >&2; exit 1; }
	@command -v shasum >/dev/null 2>&1 || { echo "shasum est requis mais non installé. Aborting." >&2; exit 1; }

latest-version: check-deps ## Affiche la dernière version disponible
	@echo "Dernière version disponible: $(VERSION)"

download-binaries: check-deps ## Télécharge tous les binaires
	@echo "Téléchargement des binaires pour la version $(VERSION)..."
	@mkdir -p $(TEMP_DIR)
	@echo "  - darwin-amd64..."
	@curl -sL $(DARWIN_AMD64_URL) -o $(TEMP_DIR)/darwin-amd64.tar.gz
	@echo "  - darwin-arm64..."
	@curl -sL $(DARWIN_ARM64_URL) -o $(TEMP_DIR)/darwin-arm64.tar.gz
	@echo "  - linux-amd64..."
	@curl -sL $(LINUX_AMD64_URL) -o $(TEMP_DIR)/linux-amd64.tar.gz
	@echo "  - linux-arm64..."
	@curl -sL $(LINUX_ARM64_URL) -o $(TEMP_DIR)/linux-arm64.tar.gz

calculate-checksums: download-binaries ## Calcule les checksums SHA256
	@echo "Calcul des checksums SHA256..."
	@echo "DARWIN_AMD64_SHA256 = $$(shasum -a 256 $(TEMP_DIR)/darwin-amd64.tar.gz | cut -d' ' -f1)"
	@echo "DARWIN_ARM64_SHA256 = $$(shasum -a 256 $(TEMP_DIR)/darwin-arm64.tar.gz | cut -d' ' -f1)"
	@echo "LINUX_AMD64_SHA256 = $$(shasum -a 256 $(TEMP_DIR)/linux-amd64.tar.gz | cut -d' ' -f1)"
	@echo "LINUX_ARM64_SHA256 = $$(shasum -a 256 $(TEMP_DIR)/linux-arm64.tar.gz | cut -d' ' -f1)"

update-formula: download-binaries ## Met à jour la formule avec la nouvelle version et les checksums
	@echo "Mise à jour de la formule $(FORMULA_FILE) pour la version $(VERSION)..."
	@DARWIN_AMD64_SHA256=$$(shasum -a 256 $(TEMP_DIR)/darwin-amd64.tar.gz | cut -d' ' -f1); \
	DARWIN_ARM64_SHA256=$$(shasum -a 256 $(TEMP_DIR)/darwin-arm64.tar.gz | cut -d' ' -f1); \
	LINUX_AMD64_SHA256=$$(shasum -a 256 $(TEMP_DIR)/linux-amd64.tar.gz | cut -d' ' -f1); \
	LINUX_ARM64_SHA256=$$(shasum -a 256 $(TEMP_DIR)/linux-arm64.tar.gz | cut -d' ' -f1); \
	\
	echo "Mise à jour des URLs et checksums..."; \
	sed -i.bak \
		-e "s|releases/download/v[^/]*/git-fleet-v[^-]*-darwin-amd64|releases/download/$(VERSION)/git-fleet-$(VERSION)-darwin-amd64|g" \
		-e "s|releases/download/v[^/]*/git-fleet-v[^-]*-darwin-arm64|releases/download/$(VERSION)/git-fleet-$(VERSION)-darwin-arm64|g" \
		-e "s|releases/download/v[^/]*/git-fleet-v[^-]*-linux-amd64|releases/download/$(VERSION)/git-fleet-$(VERSION)-linux-amd64|g" \
		-e "s|releases/download/v[^/]*/git-fleet-v[^-]*-linux-arm64|releases/download/$(VERSION)/git-fleet-$(VERSION)-linux-arm64|g" \
		$(FORMULA_FILE); \
	\
	echo "Mise à jour des checksums SHA256..."; \
	awk -v darwin_amd64="$$DARWIN_AMD64_SHA256" \
		-v darwin_arm64="$$DARWIN_ARM64_SHA256" \
		-v linux_amd64="$$LINUX_AMD64_SHA256" \
		-v linux_arm64="$$LINUX_ARM64_SHA256" \
		'BEGIN { \
			darwin_amd64_next = 0; \
			darwin_arm64_next = 0; \
			linux_amd64_next = 0; \
			linux_arm64_next = 0; \
		} \
		/darwin-amd64\.tar\.gz/ { darwin_amd64_next = 1; print; next } \
		/darwin-arm64\.tar\.gz/ { darwin_arm64_next = 1; print; next } \
		/linux-amd64\.tar\.gz/ { linux_amd64_next = 1; print; next } \
		/linux-arm64\.tar\.gz/ { linux_arm64_next = 1; print; next } \
		darwin_amd64_next && /sha256/ { print "    sha256 \"" darwin_amd64 "\""; darwin_amd64_next = 0; next } \
		darwin_arm64_next && /sha256/ { print "    sha256 \"" darwin_arm64 "\""; darwin_arm64_next = 0; next } \
		linux_amd64_next && /sha256/ { print "    sha256 \"" linux_amd64 "\""; linux_amd64_next = 0; next } \
		linux_arm64_next && /sha256/ { print "    sha256 \"" linux_arm64 "\""; linux_arm64_next = 0; next } \
		{ print }' $(FORMULA_FILE) > $(FORMULA_FILE).tmp && mv $(FORMULA_FILE).tmp $(FORMULA_FILE)
	@echo "Formule mise à jour avec succès!"
	@echo "Sauvegarde créée: $(FORMULA_FILE).bak"

update: update-formula ## Met à jour complètement la formule (télécharge + calcule + met à jour)
	@echo "Mise à jour terminée pour la version $(VERSION)"
	@echo "Vérifiez les changements avec: git diff $(FORMULA_FILE)"

clean: ## Nettoie les fichiers temporaires
	@echo "Nettoyage des fichiers temporaires..."
	@rm -rf $(TEMP_DIR)
	@rm -f $(FORMULA_FILE).bak

test-formula: ## Test la formule localement
	@echo "Test de la formule..."
	@brew install --build-from-source ./$(FORMULA_FILE)
	@gf --version
	@brew uninstall git-fleet

# Commandes de développement
dev-info: ## Affiche les informations de développement
	@echo "Informations de développement:"
	@echo "  Repository: $(REPO)"
	@echo "  Formula: $(FORMULA_FILE)"
	@echo "  Version actuelle: $$(grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' $(FORMULA_FILE) | head -1)"
	@echo "  Dernière version disponible: $(VERSION)"

# Exemple d'utilisation avec une version spécifique
# make update VERSION=v0.4.3
