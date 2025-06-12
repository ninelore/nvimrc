return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		branch = "main",
		opts = {
			highlight = {
				enable = true,
			},
		},
		config = function()
			require("nvim-treesitter").install({ "bash", "diff", "gitcommit", "gitignore", "lua", "nu" })
			vim.bo.indentexpr = 'v:lua.require"nvim-treesitter".indentexpr()'
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "<filetype>" },
				callback = function(args)
					local buf = args.buf
					local ft = vim.bo[buf].filetype
					local lang = vim.treesitter.language.get_lang(ft) or ft
					if vim.list_contains(require("nvim-treesitter").get_available(), lang) then
						require("nvim-treesitter").install(lang)
					end
					vim.treesitter.start()
				end,
			})
		end,
	},
}

-- vim: ts=2 sts=2 sw=2 et
