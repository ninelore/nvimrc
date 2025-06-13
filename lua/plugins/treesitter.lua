return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		branch = "main",
		config = function()
			require("nvim-treesitter").install({ "bash", "diff", "gitcommit", "gitignore", "lua", "nu", "nix" })
			vim.api.nvim_create_autocmd({ "BufRead", "FileType" }, {
				callback = function(args)
					local bufnr = args.buf
					local lang = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
					if lang == "" then
						return
					end
					local parser_name = vim.treesitter.language.get_lang(lang)
					if not parser_name then
						vim.notify(
							vim.inspect("No treesitter parser found for filetype: " .. lang),
							vim.log.levels.WARN
						)
						return
					end
					local parser_configs = require("nvim-treesitter.parsers")
					if not parser_configs[parser_name] then
						return
					end
					if not pcall(vim.treesitter.get_parser, bufnr, parser_name) then
						if
							not vim.tbl_contains(
								require("nvim-treesitter.config").get_installed("parsers"),
								parser_name
							)
						then
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
		end,
	},
}

-- vim: ts=2 sts=2 sw=2 et
