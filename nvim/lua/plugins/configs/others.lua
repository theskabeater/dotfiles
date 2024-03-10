return {

	gitsigns = {
		on_attach = function(bufnr)
			local gs = package.loaded.gitsigns
			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end
			map("n", "]c", function()
				if vim.wo.diff then
					return "]c"
				end
				vim.schedule(function()
					gs.next_hunk()
				end)
				return "<Ignore>"
			end, { expr = true })

			map("n", "[c", function()
				if vim.wo.diff then
					return "[c"
				end
				vim.schedule(function()
					gs.prev_hunk()
				end)
				return "<Ignore>"
			end, { expr = true })
			map("n", "<leader>gr", gs.reset_hunk)
			map("v", "<leader>gr", function()
				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end)
			map("n", "<leader>gp", gs.preview_hunk)
		end,
	},

	luasnip = function(opts)
		require("luasnip").config.set_config(opts)

		-- vscode format
		require("luasnip.loaders.from_vscode").lazy_load()
		require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.g.vscode_snippets_path or "" })

		-- snipmate format
		require("luasnip.loaders.from_snipmate").load()
		require("luasnip.loaders.from_snipmate").lazy_load({ paths = vim.g.snipmate_snippets_path or "" })

		-- lua format
		require("luasnip.loaders.from_lua").load()
		require("luasnip.loaders.from_lua").lazy_load({ paths = vim.g.lua_snippets_path or "" })

		vim.api.nvim_create_autocmd("InsertLeave", {
			callback = function()
				if
					require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
					and not require("luasnip").session.jump_active
				then
					require("luasnip").unlink_current()
				end
			end,
		})
	end,

	ts_context_commentstring = {
		languages = {
			angular = "<!-- %s -->",
		},
	},
}
