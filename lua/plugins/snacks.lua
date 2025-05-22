return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			dashboard = {
				enabled = true,
				preset = {
					header = table.concat({
						"      |\\      _,,,---,,_            ",
						"ZZZzz /,`.-'`'    -.  ;-;;,_        ",
						"     |,4-  ) )-,_. ,\\ (  `'-'       ",
						"    '---''(_/--'  `-'\\_)  Felix Lee ",
					}, "\n"),
				},
			},
			explorer = {
				enabled = true,
			},
			indent = { enabled = true },
			input = { enabled = true },
			picker = {
				enabled = true,
				layout = {
					preset = function()
						return vim.o.columns >= 120 and "default" or "vertical"
					end,
				},
				sources = {
					explorer = {
						hidden = true,
						ignored = true,
					},
					files = {
						hidden = true,
						ignored = false,
						exclude = {
							".git",
						},
					},
				},
			},
			notifier = {
				enabled = true,
				top_down = false,
				margin = { bottom = 1 },
			},
			quickfile = { enabled = true },
			scope = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
		},
		keys = {
			{
				"\\",
				function()
					Snacks.explorer()
				end,
				desc = "File Explorer",
			},
			{
				"<leader>t",
				function()
					Snacks.terminal()
				end,
				desc = "[T]erminal",
			},
			-- LSP
			{
				"<leader>cd",
				function()
					Snacks.picker.lsp_definitions()
				end,
				desc = "Search Definitions",
			},
			{
				"<leader>cD",
				function()
					Snacks.picker.lsp_declarations()
				end,
				desc = "Search Declarations",
			},
			{
				"<leader>cr",
				function()
					Snacks.picker.lsp_references()
				end,
				nowait = true,
				desc = "Search References",
			},
			{
				"<leader>cI",
				function()
					Snacks.picker.lsp_implementations()
				end,
				desc = "Search Implementations",
			},
			{
				"<leader>ct",
				function()
					Snacks.picker.lsp_type_definitions()
				end,
				desc = "Search Type Definition",
			},
			{
				"<leader>cE",
				function()
					Snacks.picker.diagnostics()
				end,
				desc = "Search Workspace Diagnostics",
			},
			{
				"<leader>ce",
				function()
					Snacks.picker.diagnostics_buffer()
				end,
				desc = "Search Buffer Diagnostics",
			},
			{
				"<leader>cs",
				function()
					Snacks.picker.lsp_symbols()
				end,
				desc = "Search Buffer Symbols",
			},
			{
				"<leader>cS",
				function()
					Snacks.picker.lsp_workspace_symbols()
				end,
				desc = "Search Workspace Symbols",
			},
			-- Search Stuff
			{
				"<leader><space>",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>ss",
				function()
					Snacks.picker.smart()
				end,
				desc = "Smart Find Files",
			},
			{
				"<leader>sn",
				function()
					Snacks.picker.notifications()
				end,
				desc = "Notification History",
			},
			{
				"<leader>sv",
				function()
					Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
				end,
				desc = "Find Config File",
			},
			{
				"<leader>sf",
				function()
					Snacks.picker.files()
				end,
				desc = "Find Files",
			},
			{
				"<leader>sg",
				function()
					Snacks.picker.git_files()
				end,
				desc = "Find Git Files",
			},
			{
				"<leader>sp",
				function()
					Snacks.picker.projects()
				end,
				desc = "Projects",
			},
			{
				"<leader>sr",
				function()
					Snacks.picker.recent()
				end,
				desc = "Recent",
			},
			{
				"<leader>sb",
				function()
					Snacks.picker.lines()
				end,
				desc = "Buffer Lines",
			},
			{
				"<leader>sB",
				function()
					Snacks.picker.grep_buffers()
				end,
				desc = "Grep Open Buffers",
			},
			{
				"<leader>sg",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep",
			},
			{
				"<leader>sw",
				function()
					Snacks.picker.grep_word()
				end,
				desc = "Visual selection or word",
				mode = { "n", "x" },
			},
			{
				'<leader>s"',
				function()
					Snacks.picker.registers()
				end,
				desc = "Registers",
			},
			{
				"<leader>s/",
				function()
					Snacks.picker.search_history()
				end,
				desc = "Search History",
			},
			{
				"<leader>sa",
				function()
					Snacks.picker.autocmds()
				end,
				desc = "Autocmds",
			},
			{
				"<leader>sb",
				function()
					Snacks.picker.lines()
				end,
				desc = "Buffer Lines",
			},
			{
				"<leader>sc",
				function()
					Snacks.picker.command_history()
				end,
				desc = "Command History",
			},
			{
				"<leader>sC",
				function()
					Snacks.picker.commands()
				end,
				desc = "Commands",
			},
			{
				"<leader>sh",
				function()
					Snacks.picker.help()
				end,
				desc = "Help Pages",
			},
			{
				"<leader>sH",
				function()
					Snacks.picker.highlights()
				end,
				desc = "Highlights",
			},
			{
				"<leader>si",
				function()
					Snacks.picker.icons()
				end,
				desc = "Icons",
			},
			{
				"<leader>sj",
				function()
					Snacks.picker.jumps()
				end,
				desc = "Jumps",
			},
			{
				"<leader>sk",
				function()
					Snacks.picker.keymaps()
				end,
				desc = "Keymaps",
			},
			{
				"<leader>sl",
				function()
					Snacks.picker.loclist()
				end,
				desc = "Location List",
			},
			{
				"<leader>sm",
				function()
					Snacks.picker.marks()
				end,
				desc = "Marks",
			},
			{
				"<leader>sM",
				function()
					Snacks.picker.man()
				end,
				desc = "Man Pages",
			},
			{
				"<leader>sp",
				function()
					Snacks.picker.lazy()
				end,
				desc = "Search for Plugin Spec",
			},
			{
				"<leader>sq",
				function()
					Snacks.picker.qflist()
				end,
				desc = "Quickfix List",
			},
			{
				"<leader>sR",
				function()
					Snacks.picker.resume()
				end,
				desc = "Resume",
			},
			{
				"<leader>su",
				function()
					Snacks.picker.undo()
				end,
				desc = "Undo History",
			},
			{
				"<leader>sL",
				function()
					Snacks.picker.lsp_config()
				end,
				desc = "Undo History",
			},
			-- Git
			{
				"<leader>gb",
				function()
					Snacks.picker.git_branches()
				end,
				desc = "Git Branches",
			},
			{
				"<leader>gl",
				function()
					Snacks.picker.git_log()
				end,
				desc = "Git Log",
			},
			{
				"<leader>gL",
				function()
					Snacks.picker.git_log_line()
				end,
				desc = "Git Log Line",
			},
			{
				"<leader>gs",
				function()
					Snacks.picker.git_status()
				end,
				desc = "Git Status",
			},
			{
				"<leader>gS",
				function()
					Snacks.picker.git_stash()
				end,
				desc = "Git Stash",
			},
			{
				"<leader>gd",
				function()
					Snacks.picker.git_diff()
				end,
				desc = "Git Diff (Hunks)",
			},
			{
				"<leader>gf",
				function()
					Snacks.picker.git_log_file()
				end,
				desc = "Git Log File",
			},
		},
	},
}

-- vim: ts=2 sts=2 sw=2 et
