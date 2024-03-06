local lint = require "lint"

lint.linters_by_ft = {
  typescript = { "eslint_d" },
  javascript = { "eslint_d" },
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged", "TextChangedI" }, {
  callback = function()
    lint.try_lint()
  end,
})
