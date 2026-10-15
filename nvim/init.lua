--------------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------------

vim.g.mapleader = " "

-- ui
vim.o.background = "dark"
vim.o.cursorline = true
vim.o.list = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.winborder = "rounded"
vim.o.statusline = "%<%f %h%m%r%{get(b:,'gitsigns_head','')}%=%-14.(%l,%c%V%) %P"

-- indentation (vim-sleuth adjusts per file)
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.tabstop = 2

-- search
vim.o.ignorecase = true
vim.o.inccommand = "nosplit"
vim.o.incsearch = true
vim.o.smartcase = true

-- editing
vim.o.backup = false
vim.o.clipboard = "unnamedplus"
vim.o.diffopt = "vertical"
vim.o.mouse = "a"
vim.o.updatetime = 100
vim.o.writebackup = false
vim.opt.iskeyword:append({ "@-@", "$" })
vim.opt.shortmess:append("c")

--------------------------------------------------------------------------------
-- Filetypes
--------------------------------------------------------------------------------

vim.filetype.add({
  extension = {
    gotmpl = "gotmpl",
    just = "just",
  },
  filename = {
    ["Justfile"] = "just",
    ["justfile"] = "just",
    ["Tiltfile"] = "tiltfile",
  },
  pattern = {
    [".*/templates/.*%.tpl"] = "helm",
    [".*/templates/.*%.ya?ml"] = "helm",
    ["helmfile.*%.ya?ml"] = "helm",
    ["%.?justfile"] = "just",
    -- angularls and the angular treesitter parser both key off htmlangular
    [".*%.component%.html"] = "htmlangular",
  },
})

--------------------------------------------------------------------------------
-- Autocmds
--------------------------------------------------------------------------------

local augroup = vim.api.nvim_create_augroup("config", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 300 })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "helm", "tiltfile" },
  callback = function()
    vim.bo.commentstring = "# %s"
  end,
})

-- the daemons outlive nvim otherwise
vim.api.nvim_create_autocmd("VimLeave", {
  group = augroup,
  callback = function()
    vim.fn.system({ "pkill", "-f", "eslint_d" })
    vim.fn.system({ "pkill", "-f", "prettierd" })
  end,
})

--------------------------------------------------------------------------------
-- Keymaps (plugin keymaps live with their plugin spec)
--------------------------------------------------------------------------------

-- close special buffers with <Esc>, using whatever key the plugin binds to close
local close_keys = { fugitive = "gq", lazy = "q" }
vim.keymap.set("n", "<Esc>", function()
  local key = close_keys[vim.bo.filetype]
  if key then
    vim.cmd.normal(key)
  end
end)

-- buffers
vim.keymap.set("n", "]b", "<CMD>bn<CR>")
vim.keymap.set("n", "[b", "<CMD>bp<CR>")
vim.keymap.set("n", "<leader>bo", function()
  local cur_bufnr = vim.api.nvim_get_current_buf()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and bufnr ~= cur_bufnr then
      vim.api.nvim_buf_delete(bufnr, {})
    end
  end
end)

-- emacs-style movement in insert mode
vim.keymap.set("i", "<C-a>", "<C-o>^")
vim.keymap.set("i", "<C-e>", "<C-o>$")
vim.keymap.set("i", "<C-f>", "<Right>")
vim.keymap.set("i", "<C-b>", "<Left>")
vim.keymap.set("i", "<C-d>", "<Del>")
vim.keymap.set("i", "<C-k>", "<C-o>d$")
vim.keymap.set("i", "<C-n>", "<Down>")
vim.keymap.set("i", "<C-p>", "<Up>")

--------------------------------------------------------------------------------
-- LSP helpers (used by the lspconfig and telescope specs below)
--------------------------------------------------------------------------------

local lsp_on_init = function(client)
  if client:supports_method("textDocument/semanticTokens") then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

-- requires cmp_nvim_lsp, only call once nvim-cmp is loaded
local lsp_capabilities = function()
  return require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
end

-- ts_ls and angularls both answer for .ts files, drop the duplicate locations
local lsp_on_list = function(use_telescope)
  return function(opts)
    local seen, items = {}, {}
    for _, item in ipairs(opts.items) do
      local key = item.filename .. ":" .. item.lnum .. ":" .. item.col
      if not seen[key] then
        seen[key] = true
        table.insert(items, item)
      end
    end

    if #items == 1 then
      local bufnr = vim.fn.bufadd(items[1].filename)
      vim.bo[bufnr].buflisted = true
      vim.cmd("normal! m'")
      vim.api.nvim_win_set_buf(0, bufnr)
      vim.api.nvim_win_set_cursor(0, { items[1].lnum, items[1].col - 1 })
      return
    end

    vim.fn.setqflist({}, " ", { title = opts.title, items = items })
    if use_telescope then
      require("telescope.builtin").quickfix()
    else
      vim.cmd("botright copen")
    end
  end
end

-- lsp floats (hover, signature help, ...): size relative to the current window, pad 1 col
-- on each side (foldcolumn on the left, extra width on the right)
local open_floating_preview = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
vim.lsp.util.open_floating_preview = function(contents, syntax, opts)
  opts = opts or {}
  local cur_win = vim.api.nvim_get_current_win()
  local max_width = opts.max_width or math.max(40, math.floor(vim.api.nvim_win_get_width(cur_win) * 0.6))
  local max_height = opts.max_height or math.max(8, math.floor(vim.api.nvim_win_get_height(cur_win) * 0.4))
  opts.max_width = max_width - 2
  opts.max_height = max_height

  local bufnr, winid = open_floating_preview(contents, syntax, opts)
  -- an already open float gets focused instead of recreated, don't pad it twice
  if vim.wo[winid].foldcolumn == "1" then
    return bufnr, winid
  end

  vim.wo[winid].foldcolumn = "1"
  vim.wo[winid].winhighlight = "FoldColumn:NormalFloat"
  vim.api.nvim_win_set_width(winid, vim.api.nvim_win_get_width(winid) + 2)

  -- fit the height to the wrapped text, markdown hovers end with a ``` fence that's
  -- concealed but can still take a row, so stop counting before it
  local line_count = vim.api.nvim_buf_line_count(bufnr)
  local last = vim.api.nvim_buf_get_lines(bufnr, -2, -1, false)[1] or ""
  local text_opts = {}
  if syntax == "markdown" and line_count > 1 and last:match("^%s*```%s*$") then
    text_opts.end_row = line_count - 2
  end
  local rows = vim.api.nvim_win_text_height(winid, text_opts).all
  vim.api.nvim_win_set_height(winid, math.max(1, math.min(rows, max_height)))
  return bufnr, winid
end

--------------------------------------------------------------------------------
-- Plugins
--------------------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

-- shared between lazy and mason
local ui = { border = "rounded", size = { width = 0.8, height = 0.8 } }

local plugins = {
  "nvim-lua/plenary.nvim",

  ------------------------------------------------------------------------------
  -- Theme
  ------------------------------------------------------------------------------

  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        transparent = false,
        italic_comments = true,
        hide_fillchars = true,
        terminal_colors = true,
        -- the default border is ~bg_highlight, so floats blend into the buffer
        overrides = function(c)
          return {
            FloatBorder = { fg = c.grey, bg = c.bg },
          }
        end,
      })
      vim.cmd.colorscheme("cyberdream")
    end,
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

  ------------------------------------------------------------------------------
  -- Editing
  ------------------------------------------------------------------------------

  {
    "tpope/vim-commentary",
    "tpope/vim-repeat",
    "tpope/vim-sleuth",
    "tpope/vim-surround",
    lazy = false,
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
    -- the tree-sitter CLI must be installed system-wide
    "romus204/tree-sitter-manager.nvim",
    config = function()
      require("tree-sitter-manager").setup({
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
          "json",
          "just",
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
      })
    end,
  },

  ------------------------------------------------------------------------------
  -- Navigation
  ------------------------------------------------------------------------------

  {
    "theskabeater/vim-kitty-navigator",
    enabled = vim.fn.has("wsl") ~= 1,
    build = "cp *.py $HOME/.config/kitty/",
    init = function()
      vim.g.kitty_navigator_no_mappings = 1

      local nav_mappings = {
        ["<C-w>h"] = "KittyNavigateLeft",
        ["<C-w><C-h>"] = "KittyNavigateLeft",
        ["<C-w>j"] = "KittyNavigateDown",
        ["<C-w><C-j>"] = "KittyNavigateDown",
        ["<C-w>k"] = "KittyNavigateUp",
        ["<C-w><C-k>"] = "KittyNavigateUp",
        ["<C-w>l"] = "KittyNavigateRight",
        ["<C-w><C-l>"] = "KittyNavigateRight",
        ["<C-w>w"] = "KittyNavigateNext",
        ["<C-w><C-w>"] = "KittyNavigateNext",
        ["<C-w>p"] = "KittyNavigatePrevious",
        ["<C-w><C-p>"] = "KittyNavigatePrevious",
      }

      for lhs, cmd in pairs(nav_mappings) do
        vim.keymap.set({ "n", "i", "v" }, lhs, function()
          vim.cmd("stopinsert")
          vim.cmd(cmd)
        end)
      end
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    keys = {
      { "<leader>fb", function() require("telescope.builtin").buffers() end },
      { "<leader>fc", function() require("telescope.builtin").current_buffer_fuzzy_find() end },
      { "<leader>fd", function() require("telescope.builtin").diagnostics() end },
      { "<leader>ff", function() require("telescope.builtin").live_grep() end },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end },
      { "<leader>fj", function() require("telescope.builtin").jumplist() end },
      { "<leader>fo", function() require("telescope.builtin").oldfiles() end },
      { "<leader>fp", function() require("telescope.builtin").find_files() end },
      { "<leader>fr", function() vim.lsp.buf.references(nil, { on_list = lsp_on_list(true) }) end },
      { "<leader>fw", function() require("telescope.builtin").grep_string({ default_text = vim.fn.expand("<cword>") }) end },
      { "<leader>fy", function() require("telescope.builtin").registers() end },
    },
    config = function()
      local telescope = require("telescope")

      telescope.setup({
        defaults = require("telescope.themes").get_ivy({
          path_display = { "truncate" },
        }),
        pickers = {
          current_buffer_fuzzy_find = { previewer = false },
          registers = { previewer = false },
        },
      })

      telescope.load_extension("fzf")
    end,
  },

  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = { "Syntax" },
    keys = {
      { "-", "<CMD>Oil<CR>" },
    },
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
          ["yp"] = {
            desc = "Copy filepath to system clipboard",
            callback = function()
              require("oil.actions").copy_entry_path.callback()
              local path = vim.fn.getreg(vim.v.register)
              vim.fn.setreg("+", path)
              vim.notify("Copied '" .. path .. "' to the system clipboard", vim.log.levels.INFO)
            end,
          },
        },
      })
    end,
  },

  {
    "moll/vim-bbye",
    keys = {
      { "<leader>bd", "<CMD>Bdelete<CR>" },
    },
  },

  ------------------------------------------------------------------------------
  -- Git
  ------------------------------------------------------------------------------

  {
    "tpope/vim-fugitive",
    cmd = "Git",
    keys = {
      { "<leader>gs", "<CMD>Git<CR>" },
      { "<leader>gb", "<CMD>Git blame<CR>" },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufNewFile", "BufReadPre" },
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = require("gitsigns")
          local map = function(mode, lhs, rhs)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr })
          end

          -- fall back to the builtin ]c/[c in diff mode
          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gs.nav_hunk("next")
            end
          end)
          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gs.nav_hunk("prev")
            end
          end)
          map("n", "<leader>gp", gs.preview_hunk)
          map("n", "<leader>gr", gs.reset_hunk)
          map("v", "<leader>gr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end)
        end,
      })
    end,
  },

  ------------------------------------------------------------------------------
  -- LSP
  ------------------------------------------------------------------------------

  {
    "neovim/nvim-lspconfig",
    ft = { "html", "htmlangular", "javascript", "lua", "python", "typescript" },
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
            ensure_installed = { "angularls", "jedi_language_server", "lua_ls", "ts_ls" },
            -- enabled manually after vim.lsp.config, otherwise clients start with default configs
            automatic_enable = false,
          })
        end,
      },
    },
    config = function()
      require("lspconfig.ui.windows").default_options.border = "rounded"
      vim.diagnostic.config({ virtual_text = false })

      -- Angular: prefer the project's language-service, fall back to mason's.
      -- forceStrictTemplates because template hover/goto returns nothing when tsconfig
      -- has strictTemplates: false (editor only, doesn't change the build)
      local ng_mason = vim.fn.stdpath("data") .. "/mason/packages/angular-language-server/node_modules"
      vim.lsp.config("angularls", {
        on_init = lsp_on_init,
        capabilities = lsp_capabilities(),
        cmd = function(dispatchers, config)
          local node_modules = vim.fs.joinpath(config.root_dir or vim.fn.getcwd(), "node_modules")
          return vim.lsp.rpc.start({
            "ngserver",
            "--stdio",
            "--tsProbeLocations", node_modules .. "," .. ng_mason,
            "--ngProbeLocations", node_modules .. "," .. ng_mason .. "/@angular/language-server/node_modules",
            "--forceStrictTemplates",
          }, dispatchers)
        end,
      })

      -- Lua
      vim.lsp.config("lua_ls", {
        on_init = function(client)
          lsp_on_init(client)

          -- projects with their own .luarc.json configure themselves. the nvim config is
          -- symlinked into the dotfiles repo, which is the workspace root, so match on that
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            local config_path = vim.uv.fs_realpath(vim.fn.stdpath("config")) or vim.fn.stdpath("config")
            if
                not vim.startswith(config_path, path)
                and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
            then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              version = "LuaJIT",
              path = { "lua/?.lua", "lua/?/init.lua" },
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
              },
            },
          })
        end,
        capabilities = lsp_capabilities(),
        settings = {
          Lua = {},
        },
      })

      -- Python
      vim.lsp.config("jedi_language_server", {
        on_init = lsp_on_init,
        capabilities = lsp_capabilities(),
        cmd = { vim.fn.stdpath("data") .. "/mason/bin/jedi-language-server" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git" },
      })

      -- TypeScript: plain ts_ls, angularls owns templates (inline + external)
      local ts_format = { insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = false }
      vim.lsp.config("ts_ls", {
        on_init = lsp_on_init,
        capabilities = lsp_capabilities(),
        init_options = {
          hostInfo = "neovim",
          preferences = { importModuleSpecifierPreference = "relative" },
        },
        -- format options are only read from settings, not init_options
        settings = {
          javascript = { format = ts_format },
          typescript = { format = ts_format },
        },
      })

      -- configured but not enabled, install the server and add it to vim.lsp.enable to use
      vim.lsp.config("gopls", {})
      vim.lsp.config("tilt_ls", {})

      vim.lsp.enable({ "angularls", "jedi_language_server", "lua_ls", "ts_ls" })

      -- keymaps
      vim.keymap.set("n", "<C-]>", function() vim.lsp.buf.definition({ on_list = lsp_on_list(false) }) end)
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help)
      vim.keymap.set("n", "K", vim.lsp.buf.hover)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
      vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float)
      vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end)
      vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end)
      vim.keymap.set("n", "<leader>oi", function()
        local client = vim.lsp.get_clients({ bufnr = 0, name = "ts_ls" })[1]
        if client then
          client:exec_cmd({
            title = "Organize imports",
            command = "_typescript.organizeImports",
            arguments = { vim.api.nvim_buf_get_name(0) },
          }, { bufnr = 0 })
        end
      end)
    end,
  },

  ------------------------------------------------------------------------------
  -- Completion & snippets
  ------------------------------------------------------------------------------

  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter" },
    dependencies = {
      {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-path",
        "saadparwaiz1/cmp_luasnip",
      },
      {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets", "johnpapa/vscode-angular-snippets" },
        config = function()
          local luasnip = require("luasnip")
          luasnip.setup({ history = true, update_events = "TextChanged,TextChangedI" })

          -- snippets from plugins (vscode format) and the config's snippets/ dirs
          require("luasnip.loaders.from_vscode").lazy_load()
          require("luasnip.loaders.from_snipmate").load()
          require("luasnip.loaders.from_lua").load()

          -- leaving insert mode ends the snippet so <Tab> doesn't jump back into it
          vim.api.nvim_create_autocmd("InsertLeave", {
            group = augroup,
            callback = function()
              if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] and not luasnip.session.jump_active then
                luasnip.unlink_current()
              end
            end,
          })
        end,
      },
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local window = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        scrollbar = false,
      }

      -- open the menu when it's closed, otherwise move through it
      local select_or_complete = function(select)
        return function()
          if cmp.visible() then
            select()
          else
            cmp.complete()
          end
        end
      end

      cmp.setup({
        preselect = cmp.PreselectMode.None,
        completion = {
          completeopt = "menu,menuone,noselect",
          autocomplete = false,
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = vim.tbl_extend("force", window, {
            winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
            side_padding = 0,
          }),
          documentation = vim.tbl_extend("force", window, {
            winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder",
          }),
        },
        mapping = {
          ["<C-n>"] = select_or_complete(cmp.select_next_item),
          ["<C-p>"] = select_or_complete(cmp.select_prev_item),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
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

  ------------------------------------------------------------------------------
  -- Linting & formatting
  ------------------------------------------------------------------------------

  {
    "mfussenegger/nvim-lint",
    ft = { "javascript", "typescript" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
      }

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged", "TextChangedI" }, {
        group = augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    keys = {
      { "<leader>j", function() require("conform").format({ async = true, lsp_format = "fallback" }) end },
    },
    config = function()
      -- conform can load before mason has put its bin dir on PATH
      vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. ":" .. vim.env.PATH

      require("conform").setup({
        formatters_by_ft = {
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
}

require("lazy").setup(plugins, {
  ui = ui,
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin",
        "bugreport",
        "compiler",
        "getscript",
        "getscriptPlugin",
        "gzip",
        "logipat",
        "matchit",
        "netrw",
        "netrwFileHandlers",
        "netrwPlugin",
        "netrwSettings",
        "optwin",
        "rplugin",
        "rrhelper",
        "spellfile_plugin",
        "synmenu",
        "syntax",
        "tar",
        "tarPlugin",
        "tohtml",
        "tutor",
        "vimball",
        "vimballPlugin",
        "zip",
        "zipPlugin",
      },
    },
  },
})
