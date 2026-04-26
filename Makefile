.PHONY: all lint boot check-dap check-lsp dev-bootstrap

all: lint boot check-dap

lint:
	@command -v selene >/dev/null 2>&1 || { echo "selene not found — run: make dev-bootstrap"; exit 1; }
	@command -v markdownlint >/dev/null 2>&1 || { echo "markdownlint not found — run: npm install -g markdownlint-cli"; exit 1; }
	@selene --config selene.toml lua/
	@markdownlint README.md updates.md CHANGELOG.md
	@echo "PASS: lint clean"

boot:
	@echo "Running neovim headless boot test..."
	@OUTPUT=$$(nvim --headless -c "qa" 2>&1 || true); \
	FILTERED=$$(echo "$$OUTPUT" | grep -v \
	    -e "vim.tbl_flatten is deprecated" \
	    -e 'Run ":checkhealth vim.deprecated"' \
	    -e "nvim-lspconfig support for Nvim" \
	    -e "Feature will be removed in nvim-lspconfig" \
	    -e "^\[" \
	    -e "^[[:space:]]*$$" \
	    || true); \
	if [ -n "$$FILTERED" ]; then \
	    echo "FAIL: Unexpected output during boot:"; \
	    echo "$$FILTERED"; \
	    exit 1; \
	fi; \
	echo "PASS: neovim booted cleanly"

check-dap:
	@scripts/check-dap.sh

check-lsp:
	@scripts/check-lsp.sh

dev-bootstrap:
	@OS=$$(uname -s); \
	if command -v selene >/dev/null 2>&1; then \
	    echo "selene already installed ($$(selene --version))"; \
	elif [ "$$OS" = "Linux" ]; then \
	    mkdir -p "$$HOME/.local/bin"; \
	    URL=$$(curl -fsSL https://api.github.com/repos/Kampfkarren/selene/releases/latest \
	        | python3 -c "import json,sys; print(next(a['browser_download_url'] for a in json.load(sys.stdin)['assets'] if 'linux' in a['name'] and 'light' not in a['name']))"); \
	    curl -fsSL "$$URL" -o /tmp/selene.zip; \
	    unzip -o /tmp/selene.zip selene -d "$$HOME/.local/bin"; \
	    chmod +x "$$HOME/.local/bin/selene"; \
	    echo "==> selene installed"; \
	elif [ "$$OS" = "Darwin" ]; then \
	    brew install selene; \
	else \
	    echo "Unsupported OS. Install selene manually: https://github.com/Kampfkarren/selene"; \
	    exit 1; \
	fi
