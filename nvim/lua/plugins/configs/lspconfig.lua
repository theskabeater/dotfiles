local utils = require("core.utils")
local lspconfig = require("lspconfig")

require("lspconfig.ui.windows").default_options.border = "rounded"

lspconfig.lua_ls.setup({
	on_init = utils.on_init,
	handlers = utils.handlers,
	capabilities = utils.capabilities(),
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					[vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
				},
				maxPreload = 100000,
				preloadFileSize = 10000,
			},
		},
	},
})

local angular_project_roots = { "angular.json", "project.json" }
local angular_project_root = vim.fs.dirname(vim.fs.find(angular_project_roots, { upward = true })[1])
if angular_project_root then
	local angularls_cmd = {
		"ngserver",
		"--stdio",
		"--tsProbeLocations",
		vim.fn.stdpath("data") .. "/mason/packages/typescript-language-server/node_modules",
		"--ngProbeLocations",
		angular_project_root,
	}
	lspconfig.angularls.setup({
		on_init = utils.on_init,
		handlers = utils.handlers,
		capabilities = utils.capabilities(),
		cmd = angularls_cmd,
		root_dir = lspconfig.util.root_pattern(angular_project_roots),
		on_new_config = function(new_config, _)
			new_config.cmd = angularls_cmd
		end,
	})
end

vim.keymap.set("n", "<C-]>", "<CMD>lua vim.lsp.buf.definition()<CR>")
vim.keymap.set("n", "<C-k>", "<CMD>lua vim.lsp.buf.signature_help()<CR>")
vim.keymap.set("n", "<leader>ca", "<CMD>lua vim.lsp.buf.code_action()<CR>")
vim.keymap.set("n", "<leader>dd", "<CMD>lua vim.diagnostic.open_float()<CR>")
vim.keymap.set("n", "<leader>rn", "<CMD>lua vim.lsp.buf.rename()<CR>")
vim.keymap.set("n", "K", "<CMD>lua vim.lsp.buf.hover()<CR>")
vim.keymap.set("n", "[d", "<CMD>lua vim.diagnostic.goto_prev()<CR>")
vim.keymap.set("n", "]d", "<CMD>lua vim.diagnostic.goto_next()<CR>")

vim.diagnostic.config({ virtual_text = false })
