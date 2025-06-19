# Makefile for git-fleet Homebrew formula
# Usage: make update VERSION=v0.4.3
# For authenticated requests: make update GITHUB_TOKEN=your_token

FORMULA_FILE = git-fleet.rb
REPO = qskkk/git-fleet

# GitHub token for authenticated requests (optional)
ifdef GITHUB_TOKEN
    GITHUB_AUTH_HEADER = -H "Authorization: token $(GITHUB_TOKEN)"
    GITHUB_API_CMD = curl -s $(GITHUB_AUTH_HEADER) https://api.github.com/repos/$(REPO)/releases/latest
else
    GITHUB_API_CMD = curl -s https://api.github.com/repos/$(REPO)/releases/latest
endif

# Default version (can be overridden with make update VERSION=vX.X.X)
# If API call fails, you must specify VERSION manually
VERSION ?= $(shell $(GITHUB_API_CMD) | jq -r '.tag_name // "FAILED"')

# Check if VERSION is valid
ifeq ($(VERSION),FAILED)
    $(error GitHub API call failed. Please specify VERSION manually: make update VERSION=v1.0.1)
endif

# Binary URLs
DARWIN_AMD64_URL = https://github.com/$(REPO)/releases/download/$(VERSION)/git-fleet-$(VERSION)-darwin-amd64.tar.gz
DARWIN_ARM64_URL = https://github.com/$(REPO)/releases/download/$(VERSION)/git-fleet-$(VERSION)-darwin-arm64.tar.gz
LINUX_AMD64_URL = https://github.com/$(REPO)/releases/download/$(VERSION)/git-fleet-$(VERSION)-linux-amd64.tar.gz
LINUX_ARM64_URL = https://github.com/$(REPO)/releases/download/$(VERSION)/git-fleet-$(VERSION)-linux-arm64.tar.gz

# Temporary directory for downloads
TEMP_DIR = /tmp/git-fleet-checksums

.PHONY: help update clean check-deps download-binaries calculate-checksums update-formula latest-version test-api

help: ## Display this help
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Usage examples:"
	@echo "  make update                           # Update to latest version (requires API access)"
	@echo "  make update VERSION=v1.0.1          # Update to specific version"
	@echo "  make update GITHUB_TOKEN=ghp_xxx    # Update with GitHub token (higher rate limit)"
	@echo "  make calculate-checksums VERSION=v1.0.1  # Just calculate checksums"
	@echo ""
	@echo "GitHub API rate limit solution:"
	@echo "  1. Create a GitHub token: https://github.com/settings/tokens"
	@echo "  2. Use: make update GITHUB_TOKEN=your_token"
	@echo "  3. Or specify version manually: make update VERSION=v1.0.1"

check-deps: ## Check that dependencies are installed
	@command -v curl >/dev/null 2>&1 || { echo "curl is required but not installed. Aborting." >&2; exit 1; }
	@command -v jq >/dev/null 2>&1 || { echo "jq is required but not installed. Install with: brew install jq" >&2; exit 1; }
	@command -v shasum >/dev/null 2>&1 || { echo "shasum is required but not installed. Aborting." >&2; exit 1; }

latest-version: check-deps ## Display the latest available version
	@echo "Checking latest version..."
	@RESULT=$$($(GITHUB_API_CMD)); \
	if echo "$$RESULT" | jq -e '.message' >/dev/null 2>&1; then \
		echo "GitHub API Error: $$(echo "$$RESULT" | jq -r '.message')"; \
		echo "Solution: Use GITHUB_TOKEN or specify VERSION manually"; \
		exit 1; \
	else \
		echo "Latest available version: $$(echo "$$RESULT" | jq -r '.tag_name')"; \
	fi

test-api: check-deps ## Test GitHub API connectivity
	@echo "Testing GitHub API connectivity..."
	@RESULT=$$($(GITHUB_API_CMD)); \
	if echo "$$RESULT" | jq -e '.message' >/dev/null 2>&1; then \
		echo "❌ API Error: $$(echo "$$RESULT" | jq -r '.message')"; \
		echo "Rate limit info:"; \
		echo "  Reset time: $$(date -r $$(echo "$$RESULT" | jq -r '.documentation_url // "0"' | grep -o '[0-9]*' || echo "0") 2>/dev/null || echo "Unknown")"; \
		echo "Solutions:"; \
		echo "  1. Wait for rate limit reset"; \
		echo "  2. Use GitHub token: make update GITHUB_TOKEN=your_token"; \
		echo "  3. Specify version manually: make update VERSION=v1.0.1"; \
	else \
		echo "✅ API is working"; \
		echo "Latest version: $$(echo "$$RESULT" | jq -r '.tag_name')"; \
		echo "Rate limit remaining: $$(curl -s $(GITHUB_AUTH_HEADER) https://api.github.com/rate_limit | jq -r '.resources.core.remaining // "Unknown"')"; \
	fi

download-binaries: check-deps ## Download all binaries
	@echo "Downloading binaries for version $(VERSION)..."
	@mkdir -p $(TEMP_DIR)
	@echo "  - darwin-amd64..."
	@curl -sL $(DARWIN_AMD64_URL) -o $(TEMP_DIR)/darwin-amd64.tar.gz
	@echo "  - darwin-arm64..."
	@curl -sL $(DARWIN_ARM64_URL) -o $(TEMP_DIR)/darwin-arm64.tar.gz
	@echo "  - linux-amd64..."
	@curl -sL $(LINUX_AMD64_URL) -o $(TEMP_DIR)/linux-amd64.tar.gz
	@echo "  - linux-arm64..."
	@curl -sL $(LINUX_ARM64_URL) -o $(TEMP_DIR)/linux-arm64.tar.gz

calculate-checksums: download-binaries ## Calculate SHA256 checksums
	@echo "Calculating SHA256 checksums..."
	@echo "DARWIN_AMD64_SHA256 = $$(shasum -a 256 $(TEMP_DIR)/darwin-amd64.tar.gz | cut -d' ' -f1)"
	@echo "DARWIN_ARM64_SHA256 = $$(shasum -a 256 $(TEMP_DIR)/darwin-arm64.tar.gz | cut -d' ' -f1)"
	@echo "LINUX_AMD64_SHA256 = $$(shasum -a 256 $(TEMP_DIR)/linux-amd64.tar.gz | cut -d' ' -f1)"
	@echo "LINUX_ARM64_SHA256 = $$(shasum -a 256 $(TEMP_DIR)/linux-arm64.tar.gz | cut -d' ' -f1)"

update-formula: download-binaries ## Update the formula with new version and checksums
	@echo "Updating formula $(FORMULA_FILE) for version $(VERSION)..."
	@DARWIN_AMD64_SHA256=$$(shasum -a 256 $(TEMP_DIR)/darwin-amd64.tar.gz | cut -d' ' -f1); \
	DARWIN_ARM64_SHA256=$$(shasum -a 256 $(TEMP_DIR)/darwin-arm64.tar.gz | cut -d' ' -f1); \
	LINUX_AMD64_SHA256=$$(shasum -a 256 $(TEMP_DIR)/linux-amd64.tar.gz | cut -d' ' -f1); \
	LINUX_ARM64_SHA256=$$(shasum -a 256 $(TEMP_DIR)/linux-arm64.tar.gz | cut -d' ' -f1); \
	VERSION_NUM=$$(echo $(VERSION) | sed 's/^v//'); \
	\
	echo "Updating version and URLs..."; \
	sed -i.bak \
		-e "s|version \"[^\"]*\"|version \"$$VERSION_NUM\"|g" \
		-e "s|releases/download/v[^/]*/git-fleet-v[^-]*-darwin-amd64|releases/download/$(VERSION)/git-fleet-$(VERSION)-darwin-amd64|g" \
		-e "s|releases/download/v[^/]*/git-fleet-v[^-]*-darwin-arm64|releases/download/$(VERSION)/git-fleet-$(VERSION)-darwin-arm64|g" \
		-e "s|releases/download/v[^/]*/git-fleet-v[^-]*-linux-amd64|releases/download/$(VERSION)/git-fleet-$(VERSION)-linux-amd64|g" \
		-e "s|releases/download/v[^/]*/git-fleet-v[^-]*-linux-arm64|releases/download/$(VERSION)/git-fleet-$(VERSION)-linux-arm64|g" \
		$(FORMULA_FILE); \
	\
	echo "Updating SHA256 checksums..."; \
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
	@echo "Formula updated successfully!"
	@echo "Backup created: $(FORMULA_FILE).bak"

update: update-formula ## Completely update the formula (download + calculate + update)
	@echo "Update completed for version $(VERSION)"
	@echo "Check changes with: git diff $(FORMULA_FILE)"

clean: ## Clean temporary files
	@echo "Cleaning temporary files..."
	@rm -rf $(TEMP_DIR)
	@rm -f $(FORMULA_FILE).bak

test-formula: ## Test the formula locally
	@echo "Testing formula..."
	@brew install --build-from-source ./$(FORMULA_FILE)
	@gf --version
	@brew uninstall git-fleet

# Development commands
dev-info: ## Display development information
	@echo "Development information:"
	@echo "  Repository: $(REPO)"
	@echo "  Formula: $(FORMULA_FILE)"
	@echo "  Version in formula: $$(grep 'version ' $(FORMULA_FILE) | sed 's/.*version "\([^"]*\)".*/\1/')"
	@echo "  Version in URLs: $$(grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' $(FORMULA_FILE) | head -1)"
	@echo "  Latest available version: $(VERSION)"

# Example usage with specific version
# make update VERSION=v0.4.3
