.PHONY: all lint boot check-dap check-lsp dev-bootstrap

# Run everything CI runs
all: lint boot check-dap

# Fast lua lint via selene
lint:
	@scripts/lint.sh

# Headless neovim boot — validates config loads cleanly
boot:
	@scripts/boot-test.sh

# Validate debug adapter binaries exist and respond
check-dap:
	@scripts/check-dap.sh

# Validate mason-installed LSP/formatter binaries (local only, requires first nvim boot)
check-lsp:
	@scripts/check-lsp.sh

# Install local dev tools (selene)
dev-bootstrap:
	@scripts/bootstrap-dev.sh
