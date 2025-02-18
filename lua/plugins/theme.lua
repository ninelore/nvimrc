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
		},
		config = function(_, opts)
			require("monokai-nightasty").load(opts)
		end,
	},
}

-- vim: ts=2 sts=2 sw=2 et
