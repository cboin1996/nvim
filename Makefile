.PHONY: all lint boot check-dap check-lsp dev-bootstrap

all: lint boot check-dap

lint:
	@command -v selene >/dev/null 2>&1 || { echo "selene not found — run: make dev-bootstrap"; exit 1; }
	@selene --config selene.toml lua/
	@echo "PASS: lint clean"

boot:
	@echo "Running neovim headless boot test..."
	@OUTPUT=$$(nvim --headless -c "qa" 2>&1 || true); \
	FILTERED=$$(echo "$$OUTPUT" | grep -v \
	    -e "vim.tbl_flatten is deprecated" \
	    -e 'Run ":checkhealth vim.deprecated"' \
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
	    curl -fsSL "https://github.com/Kampfkarren/selene/releases/latest/download/selene-linux.zip" \
	        -o /tmp/selene.zip; \
	    unzip -o /tmp/selene.zip selene -d "$$HOME/.local/bin"; \
	    chmod +x "$$HOME/.local/bin/selene"; \
	    echo "==> selene installed"; \
	elif [ "$$OS" = "Darwin" ]; then \
	    brew install selene; \
	else \
	    echo "Unsupported OS. Install selene manually: https://github.com/Kampfkarren/selene"; \
	    exit 1; \
	fi
