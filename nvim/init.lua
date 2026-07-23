-- global settings
vim.g.mapleader = " "
vim.o.background = "dark"
vim.o.backup = false
vim.o.clipboard = "unnamedplus"
vim.o.list = true
vim.o.diffopt = "vertical"
vim.o.expandtab = true
vim.o.ignorecase = true
vim.o.inccommand = "nosplit"
vim.o.incsearch = true
vim.o.iskeyword = vim.o.iskeyword .. ",@-@,$"
vim.o.mouse = "a"
vim.o.shiftwidth = 2
vim.o.shortmess = vim.o.shortmess .. "c"
vim.o.showmode = false
vim.o.smartcase = true
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.updatetime = 100
vim.o.writebackup = false
vim.wo.cursorline = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes"

-- misc autocmds
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = { "*" },
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.component.html" },
  callback = function()
    vim.bo.filetype = "angular"
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "Dockerfile.*" },
  callback = function()
    vim.bo.filetype = "dockerfile"
  end,
})

vim.api.nvim_create_autocmd("VimLeave", {
  pattern = { "*" },
  callback = function()
    vim.cmd("!pkill eslint_d &")
    vim.cmd("!pkill prettierd &")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "Avante", "AvanteInput" },
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
  end,
})

-- statusline
vim.cmd([[set statusline=%<%f\ %h%m%r%{get(b:,'gitsigns_head','')}%=%-14.(%l,%c%V%)\ %P]])

-- non-plugin keymaps
local close_on_esc = function()
  for _, ft in ipairs({ "fugitive" }) do
    if vim.bo.ft == ft then
      return vim.cmd.normal("gq")
    end
  end
  for _, ft in ipairs({ "lazy" }) do
    if vim.bo.ft == ft then
      return vim.cmd.normal("q")
    end
  end
end
vim.keymap.set("n", "<Esc>", close_on_esc)

local close_other_buffers = function()
  local cur_bufnr = vim.api.nvim_get_current_buf()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and bufnr ~= cur_bufnr then
      vim.api.nvim_buf_delete(bufnr, {})
    end
  end
end

vim.keymap.set("n", "]b", "<CMD>bn<CR>")
vim.keymap.set("n", "[b", "<CMD>bp<CR>")
vim.keymap.set("n", "<leader>bo", close_other_buffers)

-- plugin stuff below, bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- utils
vim.filetype.add({
  filename = {
    ["Tiltfile"] = "tiltfile",
    ["Justfile"] = "just",
    ["justfile"] = "just",
  },
})

vim.filetype.add({
  extension = {
    gotmpl = "gotmpl",
    just = "just",
  },
  pattern = {
    [".*/templates/.*%.tpl"] = "helm",
    [".*/templates/.*%.ya?ml"] = "helm",
    ["helmfile.*%.ya?ml"] = "helm",
    ["%.?justfile"] = "just",
  },
})

vim.cmd([[
  augroup ft_group
    autocmd!
    autocmd FileType tiltfile setlocal commentstring=#\ %s
    autocmd FileType helm setlocal commentstring=#\ %s
  augroup END
]])

-- add rounded border with highlight group
local border = function(hl)
  return {
    { "╭", hl },
    { "─", hl },
    { "╮", hl },
    { "│", hl },
    { "╯", hl },
    { "─", hl },
    { "╰", hl },
    { "│", hl },
  }
end

-- shared between lazy and mason
local ui = { border = "rounded", size = { width = 0.8, height = 0.8 } }

-- shared lsp stuff
local lsp_on_init = function(client, _)
  if client.supports_method("textDocument/semanticTokens") then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

local lsp_handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border("FloatBorder") }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border("FloatBorder") }),
}

local lsp_capabilities = function()
  -- don't call this unless until cmp is loaded
  return require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
end

local plugins = {
  "nvim-lua/plenary.nvim",

  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        -- Recommended - see "Configuring" below for more config options
        transparent = false,
        italic_comments = true,
        hide_fillchars = true,
        borderless_telescope = true,
        terminal_colors = true,
      })
      vim.cmd("colorscheme cyberdream") -- set the colorscheme
    end,
  },

  {
    "tpope/vim-commentary",
    "tpope/vim-repeat",
    "tpope/vim-sleuth",
    "tpope/vim-surround",
    lazy = false,
  },

  {
    "norcalli/nvim-colorizer.lua",
    keys = {
      { "<leader>hh", "<CMD>ColorizerToggle<CR>" },
    },
    config = function()
      require("colorizer").setup()
    end,
  },

  {
    "theskabeater/vim-kitty-navigator",
    enabled = vim.fn.has("wsl") ~= 1,
    build = "cp *.py $HOME/.config/kitty/",
    init = function()
      local function nav_and_normal(cmd)
        return function()
          vim.cmd("stopinsert")
          vim.cmd(cmd)
        end
      end

      vim.g.kitty_navigator_no_mappings = 1
      local nav_mappings = {
        ["<C-w>h"]     = "KittyNavigateLeft",
        ["<C-w><C-h>"] = "KittyNavigateLeft",
        ["<C-w>j"]     = "KittyNavigateDown",
        ["<C-w><C-j>"] = "KittyNavigateDown",
        ["<C-w>k"]     = "KittyNavigateUp",
        ["<C-w><C-k>"] = "KittyNavigateUp",
        ["<C-w>l"]     = "KittyNavigateRight",
        ["<C-w><C-l>"] = "KittyNavigateRight",
        ["<C-w>w"]     = "KittyNavigateNext",
        ["<C-w><C-w>"] = "KittyNavigateNext",
        ["<C-w>p"]     = "KittyNavigatePrevious",
        ["<C-w><C-p>"] = "KittyNavigatePrevious",
      }

      for lhs, cmd in pairs(nav_mappings) do
        vim.keymap.set({ "n", "i", "v" }, lhs, nav_and_normal(cmd))
      end
    end,
  },

  {
    "romus204/tree-sitter-manager.nvim",
    dependencies = {}, -- tree-sitter CLI must be installed system-wide
    config = function()
      require("tree-sitter-manager").setup({
        -- Default Options
        ensure_installed = {
          "angular",
          "bash",
          "css",
          "dockerfile",
          "go",
          "graphql",
          "html",
          "java",
          "javascript",
          "just",
          "json",
          "lua",
          "make",
          "markdown",
          "python",
          "query",
          "ruby",
          "rust",
          "scss",
          "starlark",
          "typescript",
          "vimdoc",
          "yaml",
        },
        -- list of parsers to install at the start of a neovim session. If set to "all", install all parsers.
        -- border = nil, -- border style for the window (e.g. "rounded", "single"), if nil, use the default border style defined by 'vim.o.winborder'. See :h 'winborder' for more info.
        -- auto_install = false, -- if enabled, install missing parsers when editing a new file
        -- highlight = true, -- treesitter highlighting is enabled by default
        -- languages = {}, -- override or add new parser sources
      })
    end
  },

  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    ft = { "typescript" },
    config = function()
      require("ts_context_commentstring").setup({
        languages = {
          angular = "<!-- %s -->",
        },
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    ft = { "angular", "lua", "javascript", "typescript", "python" },
    cmd = { "LspInfo", "LspInstall", "LspUninstall" },
    dependencies = {
      { "hrsh7th/nvim-cmp" },
      {
        "williamboman/mason.nvim",
        dependencies = { "williamboman/mason-lspconfig.nvim" },
        cmd = "Mason",
        config = function()
          require("mason").setup({ ui = ui })
          require("mason-lspconfig").setup({
            automatic_installation = true,
            ensure_installed = { "angularls", "lua_ls", "jedi_language_server", "ts_ls" },
          })
        end,
      },
    },
    config = function()
      require("lspconfig.ui.windows").default_options.border = "rounded"
      vim.diagnostic.config({ virtual_text = false })

      vim.lsp.config("angularls", {
        on_init = lsp_on_init,
        handlers = lsp_handlers,
        capabilities = lsp_capabilities(),
        filetypes = { "angular", "typescript", "html", "htmlangular" },
      })

      local jedi_project_roots =
      { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" }
      local jedi_language_server_cmd = { vim.fn.stdpath("data") .. "/mason/bin/jedi-language-server" }
      vim.lsp.config("jedi_language_server", {
        on_init = lsp_on_init,
        handlers = lsp_handlers,
        capabilities = lsp_capabilities(),
        cmd = jedi_language_server_cmd,
        root_markers = jedi_project_roots,
        filetypes = { "python" },
        on_new_config = function(new_config, _)
          new_config.cmd = jedi_language_server_cmd
        end,
      })
      local angular_ls_path = vim.fn.stdpath("data")
          .. "/mason/packages/angular-language-server/node_modules/@angular/language-service"
      vim.lsp.config("ts_ls", {
        on_init = lsp_on_init,
        handlers = lsp_handlers,
        capabilities = lsp_capabilities(),
        init_options = {
          plugins = {
            {
              name = "@angular/language-service",
              location = angular_ls_path,
              languages = { "typescript", "html", "htmlangular" },
            },
          },
          preferences = {
            importModuleSpecifierPreference = "relative",
          },
          formatOptions = {
            insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = false,
          },
        },
      })
      vim.lsp.config("gopls", {})
      vim.lsp.config("tilt_ls", {})
      vim.lsp.config("lua_ls", {
        on_init = lsp_on_init,
        handlers = lsp_handlers,
        capabilities = lsp_capabilities(),
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
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

      vim.keymap.set("n", "<C-]>", "<CMD>lua vim.lsp.buf.definition()<CR>")
      vim.keymap.set("n", "<C-k>", "<CMD>lua vim.lsp.buf.signature_help()<CR>")
      vim.keymap.set("n", "<leader>ca", "<CMD>lua vim.lsp.buf.code_action()<CR>")
      vim.keymap.set("n", "<leader>dd", "<CMD>lua vim.diagnostic.open_float()<CR>")
      vim.keymap.set("n", "<leader>rn", "<CMD>lua vim.lsp.buf.rename()<CR>")
      vim.keymap.set("n", "K", "<CMD>lua vim.lsp.buf.hover()<CR>")
      vim.keymap.set("n", "[d", "<CMD>lua vim.diagnostic.goto_prev()<CR>")
      vim.keymap.set("n", "]d", "<CMD>lua vim.diagnostic.goto_next()<CR>")
      vim.keymap.set("n", "<leader>oi", function()
        vim.lsp.buf.execute_command({
          command = "_typescript.organizeImports",
          arguments = { vim.api.nvim_buf_get_name(0) },
          title = "",
        })
      end)
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter" },
    dependencies = {
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
      {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets", "johnpapa/vscode-angular-snippets" },
        config = function()
          require("luasnip").config.set_config({
            { history = true, updateevents = "TextChanged,TextChangedI" },
          })

          -- vscode format
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_vscode").lazy_load({
            paths = vim.g
                .vscode_snippets_path or ""
          })

          -- snipmate format
          require("luasnip.loaders.from_snipmate").load()
          require("luasnip.loaders.from_snipmate").lazy_load({
            paths = vim.g
                .snipmate_snippets_path or ""
          })

          -- lua format
          require("luasnip.loaders.from_lua").load()
          require("luasnip.loaders.from_lua").lazy_load({
            paths = vim.g.lua_snippets_path or
                ""
          })

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
      },
    },
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        preselect = cmp.PreselectMode.None,
        completion = {
          completeopt = "menu,menuone,noselect",
          autocomplete = false,
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        window = {
          completion = {
            winhighlight =
            "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
            border = border("FloatBorder"),
            scrollbar = false,
          },
          documentation = {
            winhighlight = "Normal:CmpDoc",
            border = border("FloatBorder"),
            scrollbar = false,
          },
        },
        mapping = {
          ["<C-p>"] = function()
            if cmp.visible() then
              cmp.select_prev_item()
            else
              cmp.complete()
            end
          end,
          ["<C-n>"] = function()
            if cmp.visible() then
              cmp.select_next_item()
            else
              cmp.complete()
            end
          end,
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif require("luasnip").expand_or_jumpable() then
              vim.fn.feedkeys(
                vim.api.nvim_replace_termcodes(
                  "<Plug>luasnip-expand-or-jump", true, true, true),
                ""
              )
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif require("luasnip").jumpable(-1) then
              vim.fn.feedkeys(
                vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev",
                  true, true, true),
                ""
              )
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = {
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "nvim_lua" },
          { name = "path" },
        },
      })

      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })
    end,
  },

  {
    "mfussenegger/nvim-lint",
    ft = { "javascript", "typescript" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
      }

      vim.api.nvim_create_autocmd(
        { "BufEnter", "BufWritePost", "InsertLeave", "TextChanged", "TextChangedI" }, {
          callback = function()
            lint.try_lint()
          end,
        })
    end,
  },

  {
    "stevearc/conform.nvim",
    keys = {
      { "<leader>j", '<CMD>lua require("conform").format({ async = true, lsp_fallback = true})<CR>' },
    },
    config = function()
      vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. ":" .. vim.env.PATH

      require("conform").setup({
        formatters_by_ft = {
          angular = { "prettierd" },
          html = { "prettierd" },
          htmlangular = { "prettierd" },
          javascript = { "prettierd", "eslint_d" },
          json = { "prettierd" },
          lua = { "stylua" },
          python = { "ruff", "ruff_organize_imports", "ruff_fix", "ruff_format" },
          scss = { "prettierd" },
          typescript = { "prettierd", "eslint_d" },
          yaml = { "yamlfix" },
        },
      })
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    keys = {
      { "<leader>fc", "<CMD>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>" },
      { "<leader>fb", "<CMD>lua require('telescope.builtin').buffers()<CR>" },
      { "<leader>fd", "<CMD>lua require('telescope.builtin').diagnostics()<CR>" },
      { "<leader>ff", "<CMD>lua require('telescope.builtin').live_grep()<CR>" },
      { "<leader>fh", "<CMD>lua require('telescope.builtin').help_tags()<CR>" },
      { "<leader>fj", "<CMD>lua require('telescope.builtin').jumplist()<CR>" },
      { "<leader>fo", "<CMD>lua require('telescope.builtin').oldfiles()<CR>" },
      { "<leader>fp", "<CMD>lua require('telescope.builtin').find_files()<CR>" },
      { "<leader>fr", "<CMD>lua require('telescope.builtin').lsp_references()<CR>" },
      {
        "<leader>fw",
        "<CMD>lua require('telescope.builtin').grep_string({default_text = vim.fn.expand('<cword>')})<CR>",
        "n",
      },
    },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        defaults = {
          path_display = { "truncate" },
        },
        pickers = {
          current_buffer_fuzzy_find = { theme = "ivy", previewer = false },
          buffers = { theme = "ivy" },
          diagnostics = { theme = "ivy" },
          find_files = { theme = "ivy" },
          grep_string = { theme = "ivy" },
          help_tags = { theme = "ivy" },
          jumplist = { theme = "ivy" },
          live_grep = { theme = "ivy" },
          lsp_references = { theme = "ivy" },
          lsp_symboles = { theme = "ivy" },
          oldfiles = { theme = "ivy" },
          registers = { theme = "ivy", previewer = false },
        },
      })

      telescope.load_extension("fzf")
    end,
  },

  {
    "stevearc/oil.nvim",
    keys = { { "-", "<CMD>Oil<CR>" } },
    event = { "Syntax" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup({
        view_options = { show_hidden = true },
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-s>"] = "actions.select_vsplit",
          ["<C-h>"] = "actions.select_split",
          ["<C-t>"] = "actions.select_tab",
          ["<C-p>"] = "actions.preview",
          ["<C-c>"] = "actions.close",
          ["<Esc>"] = "actions.close",
          ["<C-l>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = "actions.tcd",
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g\\"] = "actions.toggle_trash",
        },
      })
    end,
  },

  {
    "tpope/vim-fugitive",
    keys = {
      { "<leader>gs", "<CMD>Git<CR>",       "n" },
      { "<leader>gb", "<CMD>Git blame<CR>", "n" },
    },
    cmd = "Git",
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufNewFile", "BufReadPre" },
    config = function()
      require("gitsigns").setup({
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
      })
    end,
  },

  {
    "moll/vim-bbye",
    keys = { { "<leader>bd", "<CMD>Bdelete<CR>", "n" } },
  },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    build = "make",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "MeanderingProgrammer/render-markdown.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope.nvim",
    },

    opts = {
      mode = "legacy",
      provider = "lmstudio",
      providers = {
        lmstudio = {
          __inherited_from = "openai",
          endpoint = "http://127.0.0.1:1234/v1",
          api_key_name = "",
          model = "broadcom/devstral-small-2505",
          timeout = 30000,
          extra_request_body = {
            temperature = 0,
            max_tokens = 8192,
          },
        },
      },
      windows = {
        width = 55,
        height = 20,
        sidebar_header = { rounded = false, align = "left" },
        selected_files = { height = 10, },
        input = { height = 10, },
        ask = { floating = true, },
      },
      behaviour = {
        confirmation_ui_style = "popup",
        use_cwd_as_project_root = true,
        auto_check_diagnostics = false,
        auto_add_current_file = false,
        auto_suggestions = false,
      },
      selection = { hint_display = "none" },
      selector = { provider = "telescope" },
      file_selector = { provider = "telescope" },
    },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      file_types = { "markdown", "Avante" },
    },
    ft = { "markdown", "Avante" },
  },

}

require("lazy").setup(plugins, {
  ui = ui,
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "tohtml",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "netrw",
        "netrwPlugin",
        "netrwSettings",
        "netrwFileHandlers",
        "matchit",
        "tar",
        "tarPlugin",
        "rrhelper",
        "spellfile_plugin",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
        "tutor",
        "rplugin",
        "syntax",
        "synmenu",
        "optwin",
        "compiler",
        "bugreport",
      },
    },
  },
})
