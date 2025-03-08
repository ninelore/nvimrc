return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			{ "williamboman/mason-lspconfig.nvim" },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
			{ "nvim-java/nvim-java" },
			{ "ranjithshegde/ccls.nvim" },
		},
		config = function()
			-- LSP Notifications
			local progress = vim.defaulttable()
			vim.api.nvim_create_autocmd("LspProgress", {
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
					if not client or type(value) ~= "table" then
						return
					end
					local p = progress[client.id]
					for i = 1, #p + 1 do
						if i == #p + 1 or p[i].token == ev.data.params.token then
							p[i] = {
								token = ev.data.params.token,
								msg = ("[%3d%%] %s%s"):format(
									value.kind == "end" and 100 or value.percentage or 100,
									value.title or "",
									value.message and (" **%s**"):format(value.message) or ""
								),
								done = value.kind == "end",
							}
							break
						end
					end
					local msg = {} ---@type string[]
					progress[client.id] = vim.tbl_filter(function(v)
						return table.insert(msg, v.msg) or not v.done
					end, p)
					local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
					vim.notify(table.concat(msg, "\n"), vim.log.levels.INFO, {
						id = "lsp_progress",
						title = client.name,
						opts = function(notif)
							notif.icon = #progress[client.id] == 0 and " "
								or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
						end,
					})
				end,
			})
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
					end
					map("<leader>cr", vim.lsp.buf.rename, "Rename Symbol")
					map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>ch", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "Toggle Inlay [H]ints")
					end
				end,
			})

			local servers = {
				-- See `:help lspconfig-all` or https://github.com/neovim/nvim-lspconfig
				bashls = {},
				jsonls = {},
				lemminx = {},
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- Ignore Lua_LS's noisy `missing-fields` warnings
							diagnostics = { disable = { "missing-fields" } },
						},
					},
				},
				neocmake = {},
				rust_analyzer = {},
				ts_ls = {},
				yamlls = {},
			}
			require("ccls").setup({
				lsp = {
					server = {
						init_options = { cache = {
							directory = vim.fs.normalize("~/.cache/ccls/"),
						} },
						name = "ccls",
						cmd = { "ccls" },
						offset_encoding = "utf-32",
						root_dir = vim.fs.dirname(
							vim.fs.find({ "compile_commands.json", "compile_flags.txt", ".git" }, { upward = true })[1]
						),
					},
					codelens = { enable = true },
				},
			})
			require("java").setup({
				spring_boot_tools = {
					enable = false,
				},
				jdk = {
					-- install jdk using mason.nvim
					auto_install = false,
				},
				java_test = {
					enable = false,
				},
			})
			require("mason").setup({
				-- Use system binaries first if available.
				-- Fixes Stuff on NixOS
				PATH = "append",
			})
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",
				"shellcheck",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend(
							"force",
							{},
							require("blink.cmp").get_lsp_capabilities(),
							server.capabilities or {}
						)
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})

			-- Handle seperately if available
			if vim.fn.executable("nixd") == 1 then
				require("lspconfig").nixd.setup({})
			end
			if vim.fn.executable("nil") == 1 then
				require("lspconfig").nil_ls.setup({
					settings = {
						["nil"] = {
							testSetting = 42,
							formatting = {
								command = { "nixfmt" },
							},
						},
					},
				})
			end
			if vim.fn.executable("nu") == 1 then
				require("lspconfig").nushell.setup({})
			end
		end,
	},
	{ -- Autoformat
		"stevearc/conform.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"zapling/mason-conform.nvim",
		},
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		config = function()
			require("mason").setup()

			require("conform").setup({
				notify_on_error = false,
				format_on_save = function(bufnr)
					local disable_filetypes = { c = true, cpp = true }
					local lsp_format_opt
					if disable_filetypes[vim.bo[bufnr].filetype] then
						lsp_format_opt = "never"
					else
						lsp_format_opt = "fallback"
					end
					return {
						timeout_ms = 500,
						lsp_format = lsp_format_opt,
					}
				end,
				formatters_by_ft = {
					lua = { "stylua" },
					nix = { "nixfmt" },
				},
			})

			require("mason-conform").setup()
		end,
	},
}

-- vim: ts=2 sts=2 sw=2 et
