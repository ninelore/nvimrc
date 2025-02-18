return {
	{ -- Useful plugin to show you pending keybinds.
		"folke/which-key.nvim",
		event = "VimEnter",
		opts = {
			delay = 0,
			icons = {
				mappings = vim.g.have_nerd_font,
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},
			-- Document existing key chains
			spec = {
				{ "<leader>c", group = "[C]ode / LSP", mode = { "n", "x" } },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>g", group = "[G]it" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			},
			preset = "helix",
		},
	},
	{ -- neovim lua help
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true },
	{ -- Highlight todo, notes, etc in comments
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{ -- Add indentation guides even on blank lines
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
}

-- vim: ts=2 sts=2 sw=2 et
