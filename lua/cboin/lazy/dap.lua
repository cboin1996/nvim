return {
	-- plain dap
	{
		"mfussenegger/nvim-dap",
		config = function()
			-- javascript firefox: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#javascript-firefox
			local dap = require("dap")
			dap.adapters.firefox = {
				type = "executable",
				command = "node",
				args = { os.getenv("HOME") .. "/debug-adapters/vscode-firefox-debug/dist/adapter.bundle.js" },
			}
			-- javascript node: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#vscode-js-debug
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "node",
					-- 💀 Make sure to update this path to point to your installation
					args = { os.getenv("HOME") .. "/debug-adapters/js-debug/src/dapDebugServer.js", "${port}" },
				},
			}
			dap.configurations.javascript = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = vim.fn.getcwd(),
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "attach",
					processId = function()
						require("dap.utils").pick_process({ filter = "node" })
					end,
					cwd = vim.fn.getcwd(),
				},
			}
		end,
	},
	-- python dap
	{
		"mfussenegger/nvim-dap-python",
		dependencies = {
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dpy = require("dap-python")
			dpy.setup("~/.virtualenvs/debugpy/bin/python")
		end,
	},
	-- go dap
	{
		"leoluz/nvim-dap-go",
		config = function()
			require("dap-go").setup()
		end,
	},
	-- dap and dap ui
	{
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			require("dapui").setup({
				icons = { expanded = "▾", collapsed = "▸" },
				mappings = {
					open = "o",
					remove = "d",
					edit = "e",
					repl = "r",
					toggle = "t",
				},
				expand_lines = vim.fn.has("nvim-0.7"),
				layouts = {
					{
						elements = {
							{
								id = "watches",
								size = 0.10,
							},
							{
								id = "stacks",
								size = 0.10,
							},
							{
								id = "breakpoints",
								size = 0.10,
							},
							{
								id = "scopes",
								size = 0.70,
							},
						},
						position = "left",
						size = 40,
					},
					{
						elements = {
							{
								id = "console",
								size = 0.2,
							},
							{
								id = "repl",
								size = 0.8,
							},
						},
						position = "bottom",
						size = 10,
					},
				},
				floating = {
					max_height = nil,
					max_width = nil,
					border = "single",
					mappings = {
						close = { "q", "<Esc>" },
					},
				},
				windows = { indent = 1 },
				render = {
					max_type_length = nil,
				},
			})

			local dap = require("dap")
			local dapui = require("dapui")

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			vim.fn.sign_define("DapBreakpoint", { text = "🐞" })

			-- set keybinds
			-- Set breakpoints, get variable values, step into/out of functions, etc.
			vim.keymap.set("n", "<Leader>dl", require("dap.ui.widgets").hover, { desc = "hover" })
			vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "continue" })
			vim.keymap.set("n", "<Leader>de", dap.terminate, { desc = "exit debug session" })
			vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "toggle breakpoint" })
			vim.keymap.set("n", "<Leader>dn", dap.step_over, { desc = "step over" })
			vim.keymap.set("n", "<Leader>di", dap.step_into, { desc = "step into" })
			vim.keymap.set("n", "<Leader>do", dap.step_out, { desc = "step out" })
			vim.keymap.set("n", "<Leader>dr", dap.restart, { desc = "restart debug session" })
			vim.keymap.set("n", "<Leader>dC", function()
				dap.clear_breakpoints()
			end, { desc = "clear breakpoints" })
		end,
	},
}
