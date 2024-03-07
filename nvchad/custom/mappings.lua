---@type MappingsTable
local M = {}

M.disabled = {
  n = {
    ["<Esc>"] = "",
    ["<Tab>"] = "",
    ["<A-h>"] = "",
    ["<A-i>"] = "",
    ["<A-v>"] = "",
    ["<C-c>"] = "",
    ["<C-n>"] = "",
    ["<C-h>"] = "",
    ["<C-j>"] = "",
    ["<C-k>"] = "",
    ["<C-l>"] = "",
    ["<C-]>"] = "",
    ["<S-Tab>"] = "",
    ["<leader>e"] = "",
    ["<leader>h"] = "",
    ["<leader>v"] = "",
    ["<leader>x"] = "",
    ["<leader>fa"] = "",
    ["<leader>fb"] = "",
    ["<leader>ff"] = "",
    ["<leader>fm"] = "",
    ["<leader>fw"] = "",
    ["<leader>fz"] = "",
    ["<leader>ph"] = "",
    ["<leader>ra"] = "",
    ["<leader>rh"] = "",
    ["<leader>rn"] = "",
  },
  t = {
    ["<A-h>"] = "",
    ["<A-i>"] = "",
    ["<A-v>"] = "",
  },
}

M.general = {
  n = {
    ["<leader>j"] = {
      function()
        require("conform").format()
      end,
      "Format with conform",
    },

    ["<C-l>"] = {
      function()
        vim.cmd "noh"
      end,
      "Stop the highlighting for the 'hlsearch' option",
    },
  },
}

M.tabufline = {
  n = {
    ["]b"] = {
      function()
        require("nvchad.tabufline").tabuflineNext()
      end,
      "Goto next buffer",
    },
    ["[b"] = {
      function()
        require("nvchad.tabufline").tabuflinePrev()
      end,
      "Goto previous buffer",
    },
    ["<leader>bd"] = {
      function()
        require("nvchad.tabufline").close_buffer()
      end,
      "Close buffer",
    },
    ["<leader>bo"] = {
      function()
        require("nvchad.tabufline").closeOtherBufs()
      end,
      "Close other buffers",
    },
  },
}

M.telescope = {
  n = {
    ["<leader>fb"] = {
      function()
        require("telescope.builtin").buffers()
      end,
      "Buffers",
    },
    ["<leader>fc"] = {
      function()
        require("telescope.builtin").command_history()
      end,
      "Command history",
    },
    ["<leader>fd"] = {
      function()
        require("telescope.builtin").diagnostics()
      end,
      "Diagnostics",
    },
    ["<leader>ff"] = {
      function()
        require("telescope.builtin").live_grep()
      end,
      "Live grep",
    },
    ["<leader>fp"] = {
      function()
        require("telescope.builtin").find_files()
      end,
      "Find project files",
    },
    ["<leader>fr"] = {
      function()
        require("telescope.builtin").lsp_references()
      end,
      "LSP references",
    },
    ["<leader>fs"] = {
      function()
        require("telescope.builtin").lsp_document_symbols()
      end,
      "LSP document symbols",
    },
    ["<leader>f/"] = {
      function()
        require("telescope.builtin").current_buffer_fuzzy_find()
      end,
      "Registers",
    },
  },
}

M.lspconfig = {
  n = {
    ["<C-]>"] = {
      function()
        require("vim.lsp.buf").definition()
      end,
      "LSP definition",
    },
    ["<C-k>"] = {
      function()
        require("vim.lsp.buf").signature_help()
      end,
      "LSP signature help",
    },
    ["<leader>dd"] = {
      function()
        require("vim.diagnostic").open_float()
      end,
      "LSP diagnostic",
    },
    ["<leader>rn"] = {
      function()
        require("vim.lsp.buf").rename()
      end,
      "LSP rename",
    },
  },
}

M.gitsigns = {
  n = {
    ["<leader>gp"] = {
      function()
        require("gitsigns").preview_hunk()
      end,
      "Preview hunk",
    },
    ["<leader>gr"] = {
      function()
        require("gitsigns").reset_hunk()
      end,
      "Reset hunk",
    },
  },
}

M.nvimtree = {
  n = {
    ["-"] = {
      function()
        local api = require "nvim-tree.api"
        if not api.tree.is_visible() then
          api.tree.open { find_file = true, focus = true }
        else
          api.tree.focus()
        end
      end,
      "Open nvimtree if closed, focus nvimtree if open",
    },
    ["<C-c>"] = {
      function()
        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname then
          if string.find(bufname, "NvimTree") then
            local api = require "nvim-tree.api"
            api.tree.close()
          elseif string.find(bufname, "fugitive") then
            vim.cmd("normal gq")
          end
        end
      end,
      "Close nvimtree and vim-fugitive when focused",
    },
    ["<Esc>"] = {
      function()
        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname then
          if string.find(bufname, "NvimTree") then
            local api = require "nvim-tree.api"
            api.tree.close()
          elseif string.find(bufname, "fugitive") then
            vim.cmd("normal gq")
          end
        end
      end,
      "Close nvimtree and vim-fugitive when focused",
    },
  },
}

M.nvterm = {
  n = {
    ["<leader>ft"] = {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "Toggle float terminal",
    },
  },
  t = {
    ["<leader>ft"] = {
      function()
        require("nvterm.terminal").toggle "float"
      end,
      "Toggle float terminal",
    },
  },
}

M.ngnvim = {
  n = {
    ["<leader>ac"] = {
      function()
        require("ng").goto_component_with_template_file()
      end,
      "Goto template for component under cursor"
    },
    ["<leader>at"] = {
      function()
        require("ng").goto_template_for_component()
      end,
      "Go to component(s) for template"
    },
    ["<leader>aT"] = {
      function()
        require("ng").get_template_tcb()
      end,
      "Display template typecheck block"
    }
  }
}

M.fugitive = {
  n = {
    ["<leader>gs"] = {
      function ()
        vim.cmd("Git")
      end,
      "Git status"
    },
    ["<leader>gb"] = {
      function ()
        vim.cmd("Git blame")
      end,
      "Git blame"
    }
  }
}

-- more keybinds!

return M
