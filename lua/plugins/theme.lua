return {
	{
		"polirritmico/monokai-nightasty.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			dark_style_background = "dark", -- default | dark | transparent | #RRGGBB
			markdown_header_marks = true,
			terminal_colors = function(colors)
				return { fg = colors.fg_dark }
			end,
			on_colors = function(colors) end,
		},
		config = function(_, opts)
			require("monokai-nightasty").load(opts)
		end,
	},
	-- {
	-- 	"sainnhe/sonokai",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		-- Optionally configure and load the colorscheme
	-- 		-- directly inside the plugin declaration.
	-- 		vim.g.sonokai_enable_italic = true
	-- 		vim.g.sonokai_style = "shusia"
	-- 		vim.cmd.colorscheme("sonokai")
	-- 	end,
	-- },
}

-- vim: ts=2 sts=2 sw=2 et
