--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
The goal is that you can read every line of code, top-to-bottom, understand
what your configuration is doing, and modify it to suit your needs.

Once you've done that, you should start exploring, configuring and tinkering to
explore Neovim!

If you don't know anything about Lua, I recommend taking some time to read through
a guide. One possible example:
- https://learnxinyminutes.com/docs/lua/


And then you can explore or search through `:help lua-guide`
- https://neovim.io/doc/user/lua-guide.html


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
--]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath
    }
end
vim.opt.rtp:prepend(lazypath)

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require("lazy").setup(
    {
        -- NOTE: First, some plugins that don't require any configuration
        -- {
        -- 'alexghergh/nvim-tmux-navigation',
        -- config = function()
        -- require("nvim-tmux-navigation").setup {
        --             -- disable_when_zoomed = true, -- defaults to false
        --             keybindings = {
        --                 left = "<C-h>",
        --                 down = "<C-j>",
        --                 up = "<C-k>",
        --                 right = "<C-l>",
        --                 last_active = "<C-\\>",
        --                 next = "<C-Space>",
        --             }
        --       }
        -- end
        -- },
        --
        --
        {
            "christoomey/vim-tmux-navigator",
            lazy = false,
            enabled = true
        },
        "itchyny/vim-cursorword",
        "eandrju/cellular-automaton.nvim",
        "onsails/lspkind.nvim",
        "romainl/vim-cool",
        -- {
        --     "zbirenbaum/copilot.lua",
        --     cmd = "Copilot",
        --     event = "InsertEnter",
        -- },
        -- {
        --     "zbirenbaum/copilot-cmp",
        --     config = function()
        --         require("copilot_cmp").setup()
        --     end,
        -- },
        {
            "nvim-tree/nvim-tree.lua",
            keys = {
                { "<C-t>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle tree" }
            },
            -- sync_root_with_cwd = true,
            -- disable_netrw = true,
            --   update_focused_file = {
            --     enable = true,
            --     update_root = true,
            --     ignore_list = {},
            --   },
            version = "*",
            lazy = false,
            dependencies = {
                "nvim-tree/nvim-web-devicons"
            },
            config = function()
                require("nvim-tree").setup {}
            end
        },
        {
            "folke/trouble.nvim",
            dependencies = { "nvim-tree/nvim-web-devicons" },
            opts = {}
        },
        {
            "f-person/git-blame.nvim",
            config = function()
                require("gitblame").setup {
                    --Note how the `gitblame_` prefix is omitted in `setup`
                    enabled = false
                }
            end
        },
        -- My libraries
        -- puts lines
        "Yggdroot/indentLine",
        -- Bar
        "romgrk/barbar.nvim",
        -- Choose Windows
        "t9md/vim-choosewin",
        "szw/vim-maximizer",
        --TODO fix keys
        {
            "Wansmer/treesj",
            keys = { "<space>m", "<space>j", "<space>s" },
            dependencies = { "nvim-treesitter/nvim-treesitter" },
            config = function()
                require("treesj").setup {}
            end
        },
        {
            "kana/vim-textobj-user", -- Dependency for custom text objects
            lazy = false,
        },
        {
            "nelstrom/vim-textobj-rubyblock",
            dependencies = { "kana/vim-textobj-user" },
            config = function()
                -- No additional config needed, just loads the plugin.
            end,
            lazy = false,
        },
        --move
        -- {
        --     "/ggandor/leap.nvim"
        -- },
        --TODO check keys and also use ruby text objects
        "terryma/vim-expand-region",
        "wellle/targets.vim",
        -- TODO check and make them work
        -- 'kana/vim-textobj-user',
        -- 'kana/vim-textobj-entire',
        -- 'lucapette/vim-textobj-underscore',
        -- 'rhysd/vim-textobj-ruby',
        -- 'kana/vim-textobj-indent',
        -- 'thinca/vim-textobj-function-javascript',
        -- 'inside/vim-textobj-jsxattr',
        -- 'whatyouhide/vim-textobj-erb',
        -- TODO check later to see whow it works
        {
            "windwp/nvim-autopairs",
            event = "InsertEnter",
            opts = {} -- this is equalent to setup({}) function
        },
        --TODO maybe I would not need this but had this before luochen1990/rainbow parantez icin
        --
        -- multi line
        "mg979/vim-visual-multi",
        -- highlight yanking
        "machakann/vim-highlightedyank",
        -- vim rooter
        "airblade/vim-rooter",
        -- TODO check it lateer
        "NvChad/nvim-colorizer.lua",
        -- Git related plugins
        "tpope/vim-fugitive",
        "tpope/vim-rhubarb",
        -- Detect tabstop and shiftwidth automatically
        "tpope/vim-sleuth",
        "https://github.com/tpope/vim-abolish",
        -- NOTE: This is where your plugins related to LSP can be installed.
        --  The configuration is done below. Search for lspconfig to find it below.
        {
            -- LSP Configuration & Plugins
            "neovim/nvim-lspconfig",
            dependencies = {
                -- Automatically install LSPs to stdpath for neovim
                "williamboman/mason.nvim",
                "williamboman/mason-lspconfig.nvim",
                -- Useful status updates for LSP
                -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
                { "j-hui/fidget.nvim", tag = "legacy", opts = {} },
                -- Additional lua configuration, makes nvim stuff amazing!
                "folke/neodev.nvim"
            }
        },
        {
            -- Autocompletion
            "hrsh7th/nvim-cmp",
            dependencies = {
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-cmdline",
                "andersevenrud/cmp-tmux",
                "f3fora/cmp-spell",
                -- Snippet Engine & its associated nvim-cmp source
                "L3MON4D3/LuaSnip",
                "saadparwaiz1/cmp_luasnip",
                -- Adds LSP completion capabilities
                "hrsh7th/cmp-nvim-lsp",
                -- Adds a number of user-friendly snippets
                "rafamadriz/friendly-snippets"
            }
        },
        {
            "nvimdev/lspsaga.nvim",
            dependencies = {
                "nvim-treesitter/nvim-treesitter", -- optional
                "nvim-tree/nvim-web-devicons"      -- optional
            },
            config = function()
                require("lspsaga").setup({})
            end
        },
        {
            "Exafunction/codeium.nvim",
            dependencies = {
                "nvim-lua/plenary.nvim",
                "hrsh7th/nvim-cmp",
            },
            config = function()
                require("codeium").setup({
                })
            end
        },
        -- Useful plugin to show you pending keybinds.
        -- { "folke/which-key.nvim",  opts = {} },
        {
            -- Adds git related signs to the gutter, as well as utilities for managing changes
            "lewis6991/gitsigns.nvim",
            opts = {
                -- See `:help gitsigns.txt`
                signs = {
                    add = { text = "+" },
                    change = { text = "~" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" }
                },
                on_attach = function(bufnr)
                    vim.keymap.set(
                        "n",
                        "<leader>hp",
                        require("gitsigns").preview_hunk,
                        { buffer = bufnr, desc = "Preview git hunk" }
                    )

                    -- don't override the built-in and fugitive keymaps
                    local gs = package.loaded.gitsigns
                    vim.keymap.set(
                        { "n", "v" },
                        "]c",
                        function()
                            if vim.wo.diff then
                                return "]c"
                            end
                            vim.schedule(
                                function()
                                    gs.next_hunk()
                                end
                            )
                            return "<Ignore>"
                        end,
                        { expr = true, buffer = bufnr, desc = "Jump to next hunk" }
                    )
                    vim.keymap.set(
                        { "n", "v" },
                        "[c",
                        function()
                            if vim.wo.diff then
                                return "[c"
                            end
                            vim.schedule(
                                function()
                                    gs.prev_hunk()
                                end
                            )
                            return "<Ignore>"
                        end,
                        { expr = true, buffer = bufnr, desc = "Jump to previous hunk" }
                    )
                end
            }
        },
        {
            -- Theme inspired by Atom
            "rakr/vim-one",
            priority = 1000,
            config = function()
                vim.cmd.colorscheme "one"
            end
        },
        {
            -- Set lualine as statusline
            "nvim-lualine/lualine.nvim"
            -- See `:help lualine.txt`
        },
        {
            -- Add indentation guides even on blank lines
            "lukas-reineke/indent-blankline.nvim",
            -- Enable `lukas-reineke/indent-blankline.nvim`
            -- See `:help indent_blankline.txt`
            main = "ibl",
            opts = {}
        },
        -- "gc" to comment visual regions/lines
        { "numToStr/Comment.nvim", opts = {} },
        -- Fuzzy Finder (files, lsp, etc)
        {
            "nvim-telescope/telescope.nvim",
            branch = "0.1.x",
            defaults = {
                layout_config = {
                    prompt_position = "top",
                    vertical = { width = 0.5 }
                }
            },
            dependencies = {
                "nvim-lua/plenary.nvim",
                -- Fuzzy Finder Algorithm which requires local dependencies to be built.
                -- Only load if `make` is available. Make sure you have the system
                -- requirements installed.
                {
                    "nvim-telescope/telescope-fzf-native.nvim",
                    -- NOTE: If you are having trouble with this installation,
                    --       refer to the README for telescope-fzf-native for more instructions.
                    build = "make",
                    cond = function()
                        return vim.fn.executable "make" == 1
                    end
                }
            }
        },
        {
            -- Highlight, edit, and navigate code
            "nvim-treesitter/nvim-treesitter",
            dependencies = {
                "nvim-treesitter/nvim-treesitter-textobjects"
            },
            build = ":TSUpdate"
        },
        {
            "kylechui/nvim-surround",
            version = "*", -- Use for stability; omit to use `main` branch for the latest features
            event = "VeryLazy",
            config = function()
                require("nvim-surround").setup({})
            end
        }

        -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
        --       These are some example plugins that I've included in the kickstart repository.
        --       Uncomment any of the lines below to enable them.
        -- require 'kickstart.plugins.autoformat',
        -- require 'kickstart.plugins.debug',

        -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
        --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
        --    up-to-date with whatever is in the kickstart repo.
        --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
        --
        --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
        -- { import = 'custom.plugins' },
    }
)

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = "unnamedplus"

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd(
    "TextYankPost",
    {
        callback = function()
            vim.highlight.on_yank()
        end,
        group = highlight_group,
        pattern = "*"
    }
)

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").setup {
    defaults = {
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false
            }
        }
    }
}
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local telescope_builtin = require('telescope.builtin')

require("telescope").setup {
    -- defaults = {
    --   layout_config = {
    --     cursor = { width = 0.5 }
    --     -- other layout configuration here
    --   },
    --   },
    -- pickers = {
    --   find_files = {
    --     theme = "cursor",
    --   }
    -- },
    --
    vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--files",
        "--smart-case"
    },
    defaults = {
        sorting_strategy = "ascending", -- display results top->bottom
        layout_config = {
            prompt_position = "top"
            -- vertical = { width = 0.5 }
        },
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false,
                ["<CR>"] = require("telescope.actions").select_default,
                ["<C-v>"] = require("telescope.actions").select_horizontal,
                ["<C-s>"] = require("telescope.actions").select_vertical,
                ["<C-t>"] = require("telescope.actions").select_tab,
            },
        }
    },
    pickers = {
        buffers = { -- Only apply the custom mapping in the `buffers` picker
            mappings = {
                i = {
                    ["<C-x>"] = function(prompt_bufnr)
                        local entry = action_state.get_selected_entry()
                        vim.api.nvim_buf_delete(entry.bufnr, { force = true }) -- Delete buffer
                        actions.close(prompt_bufnr)                            -- Close Telescope
                        telescope_builtin.buffers()                            -- Reopen buffers picker
                    end,
                },
                n = {
                    ["<C-x>"] = function(prompt_bufnr)
                        local entry = action_state.get_selected_entry()
                        vim.api.nvim_buf_delete(entry.bufnr, { force = true }) -- Delete buffer
                        actions.close(prompt_bufnr)                            -- Close Telescope
                        telescope_builtin.buffers()                            -- Reopen buffers picker
                    end,
                },
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case"        -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
            -- here
        }
    }
}

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")

-- See `:help telescope.builtin`
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<C-b>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set(
    "n",
    "<leader>/",
    function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require("telescope.builtin").current_buffer_fuzzy_find(
            require("telescope.themes").get_dropdown {
                winblend = 10,
                previewer = false
            }
        )
    end,
    { desc = "[/] Fuzzily search in current buffer" }
)

vim.keymap.set("n", "<leader>gf", require("telescope.builtin").git_files, { desc = "Search [G]it [F]iles" })
vim.keymap.set("n", "<C-f>", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<C-g>", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", require("telescope.builtin").resume, { desc = "[S]earch [R]esume" })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(
    function()
        require("nvim-treesitter.configs").setup {
            -- Add languages to be installed here that you want installed for treesitter
            ensure_installed = {
                "c",
                "cpp",
                "go",
                "lua",
                "python",
                "rust",
                "tsx",
                "javascript",
                "typescript",
                "vimdoc",
                "vim",
                "ruby"
            },
            -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
            auto_install = false,
            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<c-space>",
                    node_incremental = "<c-space>",
                    scope_incremental = "<c-s>",
                    node_decremental = "<M-space>"
                }
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["aa"] = "@parameter.outer",
                        ["ia"] = "@parameter.inner",
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner"
                    }
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        ["]m"] = "@function.outer",
                        ["]]"] = "@class.outer"
                    },
                    goto_next_end = {
                        ["]M"] = "@function.outer",
                        ["]["] = "@class.outer"
                    },
                    goto_previous_start = {
                        ["[m"] = "@function.outer",
                        ["[["] = "@class.outer"
                    },
                    goto_previous_end = {
                        ["[M"] = "@function.outer",
                        ["[]"] = "@class.outer"
                    }
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["<leader>a"] = "@parameter.inner"
                    },
                    swap_previous = {
                        ["<leader>A"] = "@parameter.inner"
                    }
                }
            }
        }
    end,
    0
)

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    -- NOTE: Remember that lua is a real programming language, and as such it is possible
    -- to define small helper and utility functions so you don't have to repeat yourself
    -- many times.
    --
    -- In this case, we create a function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    nmap("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
    nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, "[W]orkspace [R]emove Folder")
    nmap(
        "<leader>wl",
        function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end,
        "[W]orkspace [L]ist Folders"
    )

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(
        bufnr,
        "Format",
        function(_)
            vim.lsp.buf.format()
        end,
        { desc = "Format current buffer with LSP" }
    )
end

-- document existing key chains
-- require("which-key").register {
--     ["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
--     ["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
--     ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
--     ["<leader>h"] = { name = "More git", _ = "which_key_ignore" },
--     ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
--     ["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
--     ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" }
-- }

-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require("mason").setup()
require("mason-lspconfig").setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    gopls = {
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                },
                staticcheck = true,
                gofumpt = true,
            },
        },
    },
    terraformls = {},
    -- html = { filetypes = { 'html', 'twig', 'hbs'} },
    solargraph = {
        cmd = { os.getenv("HOME") .. "/.rbenv/shims/solargraph", "stdio" },
        -- root_dir = root_pattern("Gemfile", ".git", "."),
        settings = {
            solargraph = {
                autoformat = false,
                formatting = true,
                completion = true,
                diagnostic = true,
                folding = true,
                references = true,
                rename = true,
                symbols = true
            }
        }
    },
    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false }
        }
    }
}

-- Setup neovim lua configuration
require("neodev").setup()
-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require "mason-lspconfig"

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers)
}

mason_lspconfig.setup_handlers {
    function(server_name)
        require("lspconfig")[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = servers[server_name],
            filetypes = (servers[server_name] or {}).filetypes
        }
    end
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require "cmp"
local luasnip = require "luasnip"
require("luasnip.loaders.from_vscode").lazy_load()
luasnip.config.setup {}

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    mapping = cmp.mapping.preset.insert {
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete {},
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true
        },
        ["<Tab>"] = cmp.mapping(
            function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_locally_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end,
            { "i", "s" }
        ),
        ["<S-Tab>"] = cmp.mapping(
            function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end,
            { "i", "s" }
        )
    },
    -- formatting = {
    --   format = require('lspkind').cmp_format({
    --     mode = "symbol",
    --     max_width = 50,
    --     symbol_map = { Copilot = "",
    --     Text = "󰉿",
    --     Method = "󰆧",
    --     Function = "󰊕",
    --     Constructor = "",
    --     Field = "󰜢",
    --     Variable = "󰀫",
    --     Class = "󰠱",
    --     Interface = "",
    --     Module = "",
    --     Property = "󰜢",
    --     Unit = "󰑭",
    --     Value = "󰎠",
    --     Enum = "",
    --     Keyword = "󰌋",
    --     Snippet = "",
    --     Color = "󰏘",
    --     File = "󰈙",
    --     Reference = "󰈇",
    --     Folder = "󰉋",
    --     EnumMember = "",
    --     Constant = "󰏿",
    --     Struct = "󰙅",
    --     Event = "",
    --     Operator = "󰆕",
    --     TypeParameter = "",
    --       }
    --   })
    -- },
    sources = {
        -- { name = "copilot", group_index = 2 },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "tmux" },
        { name = "buffer" },
        { name = "path" },
        {
            name = "spell",
            option = {
                keep_all_entries = false,
                enable_in_context = function()
                    return true
                end
            }
        }
    }
}

-- require("leap").add_default_mappings()

-- require("copilot").setup({
--   suggestion = { enabled = false },
--   panel = { enabled = false },
-- })

-- Additional keybindings
vim.keymap.set("n", "j", "h", { noremap = true, desc = "Description here" })
vim.keymap.set("n", "k", "gj", { noremap = true, desc = "Description here" })
vim.keymap.set("n", "l", "gk", { noremap = true, desc = "Description here" })
vim.keymap.set("n", ";", "l", { noremap = true, desc = "Description here" })
vim.keymap.set("v", "j", "h", { noremap = true, desc = "Description here" })
vim.keymap.set("v", "k", "j", { noremap = true, desc = "Description here" })
vim.keymap.set("v", "l", "k", { noremap = true, desc = "Description here" })
vim.keymap.set("v", ";", "l", { noremap = true, desc = "Description here" })

-- Vim keybindings
vim.keymap.set("n", "n", "nzzzv", { noremap = true })
vim.keymap.set("n", "N", "Nzzzv", { noremap = true })
vim.keymap.set("n", "<TAB>", ":bnext<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-TAB>", ":bprevious<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>x", ":BufferClose<CR>", { noremap = true, silent = true })

-- WINDOW SPLIT NAVIGATION
vim.keymap.set("n", "<Leader>v", ":<C-u>split<CR>", { noremap = true })
vim.keymap.set("n", "<Leader>s", ":<C-u>vsplit<CR>", { noremap = true })

-- Better window navigation
-- local dirs = {h = 'h', j = 'j', k = 'k', l = 'l'}
-- for i, dir in pairs(dirs) do
--   vim.keymap.set('n', '<C-'..i..'>', '<C-w>'..dir, { noremap = true })
--   vim.keymap.set('i', '<C-'..i..'>', '<C-w>'..dir, { noremap = true })
-- end

-- Substitute all occurrences
vim.keymap.set("n", "<leader>saw", ":%s/\\<<C-r><C-w>\\>//g<Left><Left>", { noremap = true })

-- Overwrite word
vim.keymap.set("n", "<leader>o", "<esc>viwp", { noremap = true })
vim.keymap.set("n", "<leader>O", "<esc>viWp", { noremap = true })
vim.keymap.set("v", "<leader>o", "<esc>viwp", { noremap = true })
vim.keymap.set("v", "<leader>O", "<esc>viWp", { noremap = true })

-- Delete without yank
vim.keymap.set("n", "<leader>d", '"_d', { noremap = true, silent = true })

-- Resize
vim.keymap.set("n", "<Up>", ":resize +2<CR>", { noremap = true })
vim.keymap.set("n", "<Down>", ":resize -2<CR>", { noremap = true })
vim.keymap.set("n", "<Left>", ":vertical resize +10<CR>", { noremap = true })
vim.keymap.set("n", "<Right>", ":vertical resize -10<CR>", { noremap = true })

-- Copy full path and filename
vim.keymap.set("n", "<leader>cp", ':let @+=expand("%")<CR>', { noremap = true })
vim.keymap.set("n", "<leader>cpf", ':let @+=expand("%:p")<CR>', { noremap = true })
vim.keymap.set("n", "<leader>cpp", ':let @+=expand("%:t")<CR>', { noremap = true })

-- Delete buffer
vim.keymap.set("n", "<leader>a", ":Bdelete menu<CR>", { noremap = true })

-- Move vertically by visual line
vim.keymap.set("n", "j", "h", { noremap = true })
vim.keymap.set("n", "k", "gj", { noremap = true })
vim.keymap.set("n", "l", "gk", { noremap = true })
vim.keymap.set("n", ";", "l", { noremap = true })

vim.keymap.set("v", "j", "h", { noremap = true })
vim.keymap.set("v", "k", "j", { noremap = true })
vim.keymap.set("v", "l", "k", { noremap = true })
vim.keymap.set("v", ";", "l", { noremap = true })

-- Alternate ways to save, quit, and other actions
vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-z>", ":wq!<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-x>", ":q!<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-c>", "<Esc>", { noremap = true, silent = true })

-- MOVE AND EDIT

-- Reselect last pasted text to allow subsequent indenting, etc.
vim.keymap.set("n", "<leader>l", "V`]", { noremap = true })

-- Make `p` in Visual mode replace the selected text with the yank register
vim.keymap.set("v", "p", '<cmd>let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>', { noremap = true })

-- Copy and paste in visual mode using standard ctrl-c ctrl-v keys
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true })
vim.keymap.set("v", "<C-x>", '"+c', { noremap = true })
vim.keymap.set("v", "<C-v>", 'c<ESC>"+p', { noremap = true })
vim.keymap.set("i", "<C-v>", "<C-r><C-o>+", { noremap = true })

-- Quick yanking to the end of the line
vim.keymap.set("n", "Y", "y$", { noremap = true })

-- Paste previous yank
vim.keymap.set("n", "<leader>p", '"0p', { noremap = true })

-- Better indenting
vim.keymap.set("v", "<", "<gv", { noremap = true })
vim.keymap.set("v", ">", ">gv", { noremap = true })

-- Copy and paste in visual mode using standard ctrl-c ctrl-v keys
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true })
vim.keymap.set("v", "<C-x>", '"+c', { noremap = true })
vim.keymap.set("v", "<C-v>", 'c<ESC>"+p', { noremap = true })
vim.keymap.set("i", "<C-v>", "<C-r><C-o>+", { noremap = true })

-- Quick yanking to the end of the line
vim.keymap.set("n", "Y", "y$", { noremap = true })

-- Paste previous yank
vim.keymap.set("n", "<leader>p", '"0p', { noremap = true })

-- Better indenting
vim.keymap.set("v", "<", "<gv", { noremap = true })
vim.keymap.set("v", ">", ">gv", { noremap = true })
require("evi_line")

vim.keymap.set("n", "-", "<Plug>(choosewin)", { noremap = false, silent = true })

vim.keymap.set("n", "<leader>z", ":MaximizerToggle!<CR>", { noremap = true })

vim.keymap.set("n", "<leader>I", ":set list!<cr>", { noremap = true })
vim.keymap.set("n", "<leader>gs", ":Git<cr>", { noremap = true })

vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { noremap = true })
vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { noremap = true })
vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { noremap = true })
vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { noremap = true })

-- sample to  change background color
vim.cmd [[
silent! colorscheme snow
hi Normal guibg=#181a1f
]]

vim.g.rooter_patterns = { ".git" }
vim.g.rooter_manual_only = 1

-- use relative numbers with number
-- vim.wo.relativenumber = true
vim.wo.number = true
-- use clipboard
vim.o.clipboard = "unnamedplus"
-- get rid of vim compatibility
vim.o.compatible = false
-- vim primagen settings
vim.o.errorbells = false
vim.o.smartindent = true
vim.o.swapfile = false
vim.o.scrolloff = 8

-- Give more space for displaying messages.
vim.o.cmdheight = 1
-- Set syntax highlighting on
vim.cmd("syntax on")
-- Specify the shell
vim.o.shell = "/bin/zsh"
-- Always show current mode
vim.o.showmode = true
-- Configure backspace behavior
vim.o.backspace = "indent,eol,start"
vim.o.autoindent = true
vim.o.copyindent = true
vim.o.autoread = true
vim.o.updatetime = 300
vim.o.ttyfast = true
vim.o.timeout = true
vim.o.timeoutlen = 1000
vim.o.ttimeoutlen = 50
vim.wo.list = true
vim.o.listchars = "tab:▸\\ ,eol:¬"

-- Settings for wrapping
vim.wo.wrap = true
vim.o.textwidth = 79
vim.o.formatoptions = "qrn1"

-- Auto save on focus lost
vim.cmd("autocmd FocusLost * :wa")

-- Various other settings
vim.o.expandtab = true
vim.o.gdefault = true
vim.o.undofile = true
vim.o.undodir = "/home/ysf/.config/nvim/undodir"
vim.o.mouse = "a"
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.diffopt = vim.o.diffopt .. ",vertical"
vim.o.hidden = true
vim.o.backup = false
vim.o.writebackup = false
vim.wo.signcolumn = "yes"

vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

vim.o.spell = true
vim.o.spelllang = "en_us"

-- dont forget to use nvim surroundings
-- S and delimeter in visual mode
-- dst for tags
-- function does not work for ruby
-- :TSInstall language for tree sitter
-- treesj leader m toggle leader s split leader j join
--https://github.com/kevinhwang91/nvim-bqf needs to check later
--s two letter for search leap

--   Default Values:
--     cmd = { "solargraph", "stdio" }
--     filetypes = { "ruby" }
--     root_dir = root_pattern("Gemfile", ".git")
--
-- local nvim_lsp = require('nvim_lsp')
-- -- nvim_lsp.gopls.setup{
-- --   root_dir = nvim_lsp.util.root_pattern('.git');
-- -- }
-- local lspconfig = require("lspconfig")
--
-- require("lspconfig").solargraph.setup {
--     cmd = {os.getenv("HOME") .. "/.rbenv/shims/solargraph", "stdio"},
--     root_dir = lspconfig.util.root_pattern("Gemfile", ".git", "."),
--     settings = {
--         solargraph = {
--             autoformat = false,
--             formatting = true,
--             completion = true,
--             diagnostic = true,
--             folding = true,
--             references = true,
--             rename = true,
--             symbols = true
--         }
--     }
-- }
--
vim.keymap.set("n", "<leader>fo", "<cmd>lua vim.lsp.buf.format()<CR>", { noremap = true })


require("nvim-tree").setup({
    disable_netrw = true,
    hijack_netrw = true,
    sync_root_with_cwd = true,
    update_focused_file = {
        enable = true,
        update_root = true,
    },
    view = {
        width = 30,
        side = "left",
    },
    on_attach = function(bufnr)
        local api = require('nvim-tree.api')

        local function opts(desc)
            return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- Default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- Custom mappings
        vim.keymap.set('n', '<C-s>', api.node.open.vertical, opts('Open: Vertical Split'))
        vim.keymap.set('n', '<C-v>', api.node.open.horizontal, opts('Open: Horizontal Split'))
        -- Uncomment the next line if you want to disable the <C-t> mapping
        vim.keymap.del('n', '<C-t>', { buffer = bufnr })
    end,
})

-- Iosevka Nerd Font Mono
--
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.keymap.set("n", "<leader>gt", ":GoTest<CR>", { buffer = true })
        vim.keymap.set("n", "<leader>gi", ":GoImports<CR>", { buffer = true })
        vim.keymap.set("n", "<leader>gfs", ":GoFillStruct<CR>", { buffer = true })
    end,
})

-- Set Go file-specific options
vim.api.nvim_create_autocmd("FileType", {
    pattern = "go",
    callback = function()
        vim.bo.expandtab = false
        vim.bo.tabstop = 4
        vim.bo.shiftwidth = 4
    end,
})

-- ~/.config/nvim/init.lua or relevant config file
vim.opt.guifont = "JetBrainsMono Nerd Font:h12"




-- One Dark color overrides
local colors = {
    mono_1 = '#CDD5E4',
    mono_2 = '#A7AFC1',
    mono_3 = '#778091',
    mono_4 = '#69738A',
    
    hue_1 = '#48CDDE',  -- cyan
    hue_2 = '#54AFFA',  -- blue
    hue_3 = '#D86AF9',  -- purple
    hue_4 = '#9CD871',  -- green
    
    hue_5 = '#F45E69',    -- red 1
    hue_5_2 = '#D34C3E',  -- red 2
    
    hue_6 = '#E99F58',    -- orange 1
    hue_6_2 = '#F7C76F',  -- orange 2
    
    syntax_bg = '#181a1f',
    syntax_gutter = '#636d83',
    syntax_cursor = '#2c323c',
    syntax_accent = '#527AFF'
}

-- Apply the colors after colorscheme is loaded
vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = 'one',
    callback = function()
        vim.api.nvim_command('hi Normal guifg=' .. colors.mono_1 .. ' guibg=' .. colors.syntax_bg)
        vim.api.nvim_command('hi Comment guifg=' .. colors.mono_3)
        vim.api.nvim_command('hi String guifg=' .. colors.hue_4)
        vim.api.nvim_command('hi Number guifg=' .. colors.hue_6)
        vim.api.nvim_command('hi Function guifg=' .. colors.hue_2)
        vim.api.nvim_command('hi Keyword guifg=' .. colors.hue_3)
        vim.api.nvim_command('hi Operator guifg=' .. colors.hue_1)
        vim.api.nvim_command('hi Type guifg=' .. colors.hue_6_2)
        vim.api.nvim_command('hi Special guifg=' .. colors.hue_2)
        vim.api.nvim_command('hi Error guifg=' .. colors.hue_5)
        vim.api.nvim_command('hi LineNr guifg=' .. colors.syntax_gutter)
        vim.api.nvim_command('hi CursorLine guibg=' .. colors.syntax_cursor)
        vim.api.nvim_command('hi Search guibg=' .. colors.syntax_accent .. ' guifg=' .. colors.mono_1)
    end
})
