return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		branch = "main",
		opts = {
			highlight = {
				enable = true,
			},
		},
		config = function()
			vim.bo.indentexpr = 'v:lua.require"nvim-treesitter".indentexpr()'
		end,
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local buf = args.buf
					local ft = vim.bo[buf].filetype
					local lang = vim.treesitter.language.get_lang(ft) or ft
					if vim.list_contains(require("nvim-treesitter").get_installed(), lang) then
						pcall(vim.treesitter.start, buf, lang)
					end
				end,
			})
		end,
		dependencies = {
			{
				"lewis6991/ts-install.nvim",
				config = function()
					require("ts-install").setup({
						auto_install = true,
					})
				end,
			},
		},
	},
}

-- vim: ts=2 sts=2 sw=2 et
