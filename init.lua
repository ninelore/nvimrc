-- Setup mini.nvim and mini.deps
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/nvim-mini/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end
require("mini.deps").setup({ path = { package = path_package } })

-- Use 'mini.deps'. `now()` and `later()` are helpers for a safe two-stage startup
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- Basic vim config
now(function()
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "
	vim.g.have_nerd_font = true
	vim.g.loaded_netrw = 1
	vim.g.loaded_netrwPlugin = 1
	vim.o.number = true
	vim.o.mouse = "a"
	vim.o.showmode = false
	vim.o.background = "dark"
	vim.o.ts = 2
	vim.o.sw = 0
	vim.o.shm = "ltToOCFI"
	vim.o.breakindent = true
	vim.o.undofile = true
	vim.o.ignorecase = true
	vim.o.smartcase = true
	vim.o.signcolumn = "yes"
	vim.o.updatetime = 250
	vim.o.timeoutlen = 1500
	vim.o.splitright = true
	vim.o.splitbelow = true
	vim.o.list = true
	vim.o.listchars = "tab:» ,trail:·,nbsp:␣"
	vim.o.inccommand = "split"
	vim.o.cursorline = true
	vim.o.scrolloff = 5
	vim.schedule(function()
		vim.o.clipboard = "unnamedplus"
	end)
	vim.keymap.set("n", "<leader>d", function()
		vim.diagnostic.open_float()
	end, { desc = "Show Diagnostics under the cursor" })
	-- Extra actions on Esc
	vim.keymap.set("n", "<Esc>", function()
		vim.cmd.nohlsearch()
		vim.cmd.cclose()
	end)
	vim.api.nvim_create_autocmd("TextYankPost", {
		desc = "Highlight when yanking (copying) text",
		group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
		callback = function()
			vim.highlight.on_yank()
		end,
	})
	-- Language specific settings
	vim.api.nvim_create_autocmd({ "BufEnter", "BufRead" }, {
		desc = "Language specific buffer settings",
		pattern = "*.nix",
		callback = function(ev)
			vim.b[ev.buf].autoformat = true
			vim.bo[ev.buf].ts = 2
			vim.bo[ev.buf].sts = 2
			vim.bo[ev.buf].expandtab = true
		end,
	})
end)

-- mini.nvim modules
now(function()
	require("mini.notify").setup({
		content = {
			format = function(notif)
				if notif.data.source == "lsp_progress" then
					return notif.msg
				end
				return MiniNotify.default_format(notif)
			end,
		},
		lsp_progress = {
			duration_last = 3000,
		},
		window = {
			config = function()
				local has_statusline = vim.o.laststatus > 0
				local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
				return { anchor = "SE", col = vim.o.columns, row = vim.o.lines - pad }
			end,
		},
	})
	vim.notify = require("mini.notify").make_notify()
end)
now(function()
	require("mini.icons").setup()
end)
now(function()
	require("mini.statusline").setup()
end)
later(function()
	require("mini.ai").setup({
		n_lines = 200,
		mappings = {
			-- Unmap due to default LSP keymaps
			around_next = "",
			inside_next = "",
			around_last = "",
			inside_last = "",
		},
	})
end)
later(function()
	require("mini.extra").setup()
end)
later(function()
	require("mini.indentscope").setup()
end)
later(function()
	require("mini.pairs").setup()
end)
later(function()
	require("mini.pick").setup({
		window = {
			config = function()
				local height = math.floor(0.618 * vim.o.lines)
				local width = math.floor(0.618 * vim.o.columns)
				return {
					anchor = "NW",
					height = height,
					width = width,
					row = math.floor(0.5 * (vim.o.lines - height)),
					col = math.floor(0.5 * (vim.o.columns - width)),
				}
			end,
			prompt_caret = "|",
		},
	})
	vim.keymap.set("n", "<leader><Space>", ":Pick buffers<CR>")
	vim.keymap.set("n", "<leader>s", ":Pick files<CR>")
	vim.keymap.set("n", "<leader>/", ":Pick grep_live<CR>")
	vim.keymap.set("n", "<leader>H", ":Pick help<CR>")
end)
later(function()
	require("mini.surround").setup()
end)

-- Startup plugins
now(function()
	add("polirritmico/monokai-nightasty.nvim")
	require("monokai-nightasty").load({
		dark_style_background = "transparent", -- default | dark | transparent | #RRGGBB
		markdown_header_marks = true,
		terminal_colors = function(colors)
			return { fg = colors.fg_dark }
		end,
		on_colors = function() end,
	})
end)
now(function()
	add({
		source = "nvim-neo-tree/neo-tree.nvim",
		checkout = "v3.x",
		depends = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
	})
	vim.keymap.set("", "\\", ":Neotree reveal right<CR>", { desc = "Show Explorer" })
	vim.keymap.set("", "|", ":Neotree document_symbols right<CR>", { desc = "Show Explorer" })
	require("neo-tree").setup({
		sources = {
			"filesystem",
			"buffers",
			"git_status",
			"document_symbols",
		},
		source_selector = {
			winbar = true,
			statusline = true,
			sources = {
				{ source = "filesystem" },
				{ source = "git_status" },
				{ source = "document_symbols" },
			},
		},
		filesystem = {
			bind_to_cwd = true,
			hijack_netrw_behavior = "open_current",
			window = {
				mappings = {
					["\\"] = "close_window",
					["<Space>"] = "noop",
				},
			},
			filtered_items = {
				visible = true,
				hide_dotfiles = false,
				hide_gitignored = true,
				hide_by_name = {
					".DS_Store",
					".git",
					"thumbs.db",
					"node_modules",
				},
			},
		},
	})
end)
now(function()
	add("folke/which-key.nvim")
	require("which-key").setup({
		delay = 0,
		spec = {
			{ "<leader>c", group = "[C]ode / LSP", mode = { "n", "x" } },
			{ "<leader>s", group = "[S]earch" },
			{ "<leader>g", group = "[G]it" },
		},
		preset = "helix",
	})
end)
now(function()
	add({ source = "Saghen/blink.cmp", checkout = "v1.7.0", depends = { "rafamadriz/friendly-snippets" } })
	require("blink.cmp").setup({
		keymap = {
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
			["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
			["<Up>"] = { "select_prev", "fallback" },
			["<Down>"] = { "select_next", "fallback" },
			["<C-p>"] = { "select_prev", "fallback" },
			["<C-n>"] = { "select_next", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
		},
		completion = {
			keyword = {
				range = "full",
			},
			ghost_text = {
				enabled = true,
			},
			menu = {
				auto_show = true,
			},
			list = {
				selection = {
					preselect = false,
					auto_insert = false,
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
			},
		},
		cmdline = {
			keymap = {
				preset = "inherit",
				["<CR>"] = { "accept_and_enter", "fallback" },
				["<Space>"] = { "accept", "fallback" },
			},
			completion = {
				menu = {
					auto_show = true,
				},
				list = {
					selection = {
						preselect = false,
						auto_insert = false,
					},
				},
				ghost_text = {
					enabled = true,
				},
			},
		},
	})
end)
now(function()
	add("neovim/nvim-lspconfig")
	-- Server definitions
	-- See `:help lspconfig-all` or https://github.com/neovim/nvim-lspconfig
	local servers = {
		bashls = {},
		ccls = {
			init_options = {
				cache = {
					directory = vim.fs.normalize("~/.cache/ccls/"),
				},
			},
		},
		clangd = {},
		cssls = {},
		gopls = {},
		html = {},
		jsonls = {},
		lua_ls = {
			settings = {
				Lua = {
					completion = {
						callSnippet = "Replace",
					},
					diagnostics = { disable = { "missing-fields" } },
				},
			},
		},
		markdown_oxide = {},
		marksman = {},
		nixd = {},
		nushell = {},
		ruff = {},
		rust_analyzer = {},
		sqls = {},
		ts_ls = {},
		yamlls = {},
	}
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(event)
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if
				client
				and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
			then
				-- Highlight references of the word under your cursor.
				local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
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
			if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
				vim.keymap.set("n", "<leader>h", function()
					vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
				end, { desc = "Toggle LSP Inlay [H]ints" })
			end
			if client and client.server_capabilities and client.server_capabilities.codeLensProvider then
				vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "CursorHold", "BufEnter" }, {
					callback = function(event2)
						vim.lsp.codelens.refresh({ bufnr = event2.buf })
					end,
				})
			end
		end,
	})
	-- Start available servers
	for k, v in pairs(servers) do
		local client = vim.lsp.config[k]
		if vim.fn.executable(client.cmd[1]) == 1 then
			vim.lsp.config(k, v)
			vim.lsp.enable(k)
		end
	end
end)
now(function()
	add({
		source = "nvim-treesitter/nvim-treesitter",
		checkout = "main",
		hooks = {
			post_checkout = function()
				vim.cmd("TSUpdate")
			end,
		},
	})
	add("nvim-treesitter/nvim-treesitter-context")
	require("nvim-treesitter").install({ "bash", "diff", "gitcommit", "gitignore", "json", "jsonc", "lua", "markdown", "markdown_inline" })
	vim.api.nvim_create_autocmd({ "BufRead", "FileType" }, {
		callback = function(args)
			local bufnr = args.buf
			local lang = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
			if lang == "" then
				return
			end
			local parser_name = vim.treesitter.language.get_lang(lang)
			if not parser_name then
				vim.notify(vim.inspect("No treesitter parser found for filetype: " .. lang), vim.log.levels.WARN)
				return
			end
			local parser_configs = require("nvim-treesitter.parsers")
			if not parser_configs[parser_name] then
				return
			end
			if not pcall(vim.treesitter.get_parser, bufnr, parser_name) then
				if not vim.tbl_contains(require("nvim-treesitter.config").get_installed("parsers"), parser_name) then
					vim.notify("Installing parser for " .. parser_name, vim.log.levels.INFO)
					require("nvim-treesitter").install({ parser_name }):await(function()
						vim.treesitter.start(bufnr, parser_name)
						vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end)
					return
				end
			end
			vim.treesitter.start()
			vim.bo.indentexpr = 'v:lua.require"nvim-treesitter".indentexpr()'
		end,
	})
	require("treesitter-context").setup({
		max_lines = 5,
	})
end)

-- Lazy plugins
later(function()
	add("folke/todo-comments.nvim")
	require("todo-comments").setup()
end)
later(function()
	add("ferplnat/truefalse.nvim")
	vim.keymap.set("n", "<leader>x", function()
		require("truefalse").invert()
	end, { desc = "Invert boolean at cursor" })
end)
later(function()
	add("folke/lazydev.nvim")
	require("lazydev").setup({
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	})
end)
later(function()
	add("lewis6991/gitsigns.nvim")
	require("gitsigns").setup({
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")
			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end
			-- Navigation
			map("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end, { desc = "Jump to next git [c]hange" })
			map("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end, { desc = "Jump to previous git [c]hange" })
			-- Actions
			-- visual mode
			map("v", "<leader>gs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "git [s]tage hunk" })
			map("v", "<leader>gr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "git [r]eset hunk" })
			-- normal mode
			map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "git [s]tage hunk toggle" })
			map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })
			map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "git [S]tage buffer" })
			map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" })
			map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "git [p]review hunk" })
			map("n", "<leader>gb", gitsigns.blame_line, { desc = "git [b]lame line" })
			map("n", "<leader>gB", gitsigns.toggle_current_line_blame, { desc = "Toggle git show [b]lame line" })
		end,
	})
end)
later(function()
	add("stevearc/conform.nvim")
	require("conform").setup({
		notify_on_error = false,
		format_on_save = function(bufnr)
			if not (vim.g.autoformat or vim.b[bufnr].autoformat) then
				return
			end
			return {
				timeout_ms = 500,
				lsp_format = "fallback",
			}
		end,
		formatters_by_ft = {
			lua = { "stylua" },
			nix = { "nixfmt" },
			c = { "clang-format" },
			cpp = { "clang-format" },
		},
	})
	vim.api.nvim_create_user_command("FormatEnable", function(args)
		if args.bang then
			vim.b.autoformat = true
		else
			vim.g.autoformat = true
		end
	end, {
		desc = "Enable autoformat-on-save",
		bang = true,
	})
	vim.api.nvim_create_user_command("FormatDisable", function()
		vim.b.autoformat = false
		vim.g.autoformat = false
	end, {
		desc = "Disable autoformat-on-save",
	})
	vim.keymap.set("n", "<leader>f", function()
		require("conform").format({ async = true, lsp_format = "fallback" })
	end, { desc = "Format buffer" })
	vim.keymap.set("n", "grf", function()
		require("conform").format({ async = true, lsp_format = "fallback" })
	end, { desc = "Format buffer" })
end)
later(function()
	add("esensar/nvim-dev-container")
	require("devcontainer").setup({
		attach_mounts = {
			nvim_install_as_root = true,
			neovim_config = {
				enabled = true,
				options = { "readonly" },
			},
		},
	})
end)
later(function ()
	add("MeanderingProgrammer/render-markdown.nvim")
end)
