--  _       _
-- | |_ ___| | ___  ___  ___ ___  _ __   ___
-- | __/ _ \ |/ _ \/ __|/ __/ _ \| '_ \ / _ \
-- | ||  __/ |  __/\__ \ (_| (_) | |_) |  __/
--  \__\___|_|\___||___/\___\___/| .__/ \___|
--                               |_|
-- https://github.com/nvim-telescope/telescope.nvim

return {
    "nvim-telescope/telescope.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = "Telescope",
    branch = "0.1.x",
    dependencies = {
        {
            "nvim-tree/nvim-web-devicons",
            lazy = true,
        },
        "nvim-lua/plenary.nvim",
        { "nvim-tree/nvim-web-devicons", lazy = true },
        "nvim-telescope/telescope-github.nvim",
        "ThePrimeagen/harpoon",
        {
            "piersolenski/telescope-import.nvim",
            ft = { "python", "javascript", "lua" },
        },
    },

    config = function()
        local telescope = require("telescope")
        local telescope_builtin = require("telescope.builtin")
        local open_with_trouble = require("trouble.sources.telescope").open
        -- TODO: look up how to utilize this command
        -- Use this to add more results without clearing the trouble list
        local add_to_trouble = require("trouble.sources.telescope").add

        local custom_helpers = require("eb.utils.custom_helpers")
        local hostname = custom_helpers.get_hostname()
        local utils = require("eb.utils.telescope-helpers")
        local multi_select = utils.multi_select
        local buffer_searcher = utils.buffer_searcher

        local file_ignore_patterns = {
            "^.git/",
            "node_modules\\",
            "__pycache__\\",
            ".git\\",
            "%.zip",
            "%.tar",
            "%.gz",
            "%.7zip",
            "%.exe",
            "%.pyc",
            "yarn%.lock",
            "package%-lock%.json",
        }

        -- SETUP
        telescope.setup({
            defaults = {
                prompt_prefix = " ",
                selection_caret = " ",
                path_display = { "truncate" },
                sorting_strategy = "ascending",
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.50,
                        results_width = 0.50,
                    },
                    center = {
                        width = 1.0,
                        height = 1.0,
                    },
                },
                winblend = 0,
                scroll_strategy = "cycle",
                border = {},
                borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
                file_ignore_patterns = file_ignore_patterns,
                file_previewer = require("telescope.previewers").vim_buffer_cat.new,
                grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
                qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
                buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
                mappings = {
                    i = {
                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous",
                        ["<C-n>"] = "preview_scrolling_down",
                        ["<C-p>"] = "preview_scrolling_up",
                        ["<C-t>"] = open_with_trouble,
                        ["<C-a>"] = add_to_trouble,
                        ["<C-s>"] = multi_select,
                    },
                    n = {
                        ["<C-t>"] = open_with_trouble,
                        ["<C-a>"] = add_to_trouble,
                        ["<C-s>"] = multi_select,
                    },
                },
            },
            pickers = {
                find_files = {
                    hidden = true,
                    -- TODO: create a toggle to show/hide gitignored files
                    no_ignore = false,
                    theme = "ivy",
                    find_command = { "rg", "--files", "--sortr=modified" },
                },
                keymaps = {
                    theme = "ivy",
                },
                help_tags = {
                    theme = "ivy",
                },
                man_pages = {
                    theme = "ivy",
                },
                marks = {
                    theme = "ivy",
                },
                git_files = {
                    theme = "ivy",
                },
                grep_string = {
                    theme = "ivy",
                },
                quickfix = {
                    theme = "ivy",
                },
                lsp_references = {
                    theme = "ivy",
                },
                lsp_definitions = {
                    theme = "ivy",
                },
                lsp_type_definitions = {
                    theme = "ivy",
                },
                lsp_document_symbols = {
                    theme = "ivy",
                },
                buffers = {
                    theme = "ivy",
                },
                current_buffer_fuzzy_find = {
                    theme = "ivy",
                },
            },
            extensions = {
                tmuxinator = {
                    select_action = "switch",
                    stop_action = "stop",
                    disable_icons = false,
                },
                fzy_native = {
                    override_generic_sorter = false,
                    override_file_sorter = true,
                },
                import = {
                    -- Add imports to the top of the file keeping the cursor in place
                    insert_at_top = true,
                },
            },

            telescope.load_extension("notify"),
            telescope.load_extension("harpoon"),
            telescope.load_extension("import"),
            telescope.load_extension("luasnip"),
            -- telescope.load_extension("refactoring"),
        })

        -- KEYMAPS
        local keymap = function(keys, func, desc)
            if desc then
                desc = "TELESCOPE: " .. desc
            end

            vim.keymap.set("n", keys, func, { desc = desc })
        end

        local custom_theme = require("telescope.themes").get_dropdown({
            previewer = false,
        })

        -- keybinds
        keymap("<leader>ff", telescope_builtin.find_files, "Find Files in local folder only recursively")
        -- keymap(
        --     "<leader>ff",
        --     "<CMD>Telescope find_files workspace=CWD theme=ivy<CR>",
        --     "Find Files in local folder only recursively"
        -- )
        keymap("<leader>fo", telescope_builtin.oldfiles, "Find recently Opened files")
        keymap("<leader>fk", telescope_builtin.keymaps, "Find Keymaps")
        keymap("<leader>fh", telescope_builtin.help_tags, "Find in Help tags")
        keymap("<leader>fp", telescope_builtin.man_pages, "Find in man Pages")
        keymap("<leader>fm", telescope_builtin.marks, "Find in vim marks")
        keymap("<leader>fg", telescope_builtin.git_files, "Find files in Git repository")
        keymap("gr", telescope_builtin.lsp_references, "Find references [LSP]")
        keymap("gd", telescope_builtin.lsp_definitions, "Find definitions [LSP]")
        keymap("gD", telescope_builtin.lsp_type_definitions, "Find type definitions [LSP]")
        keymap("<leader>ds", telescope_builtin.lsp_document_symbols, "Find document symbols [LSP]")
        keymap("<leader>co", telescope_builtin.quickfix, "View all items in the quickfix list")
        -- BUG: this does not reload modules but does show the notification
        -- keymap(
        --     "<leader>fr",
        --     "<cmd>:lua require('eb.utils.telescope_reload').reload()<CR>",
        --     "Reload nvim plugin using telescope"
        -- )

        if hostname == "JIGA" then
            keymap(
                "<leader>os",
                ":Telescope find_files search_dirs=/mnt/d/the_vault/<CR>",
                "Search notes in Obsidian vault"
            )

            keymap("<leader>oz", function()
                telescope_builtin.grep_string({
                    search = vim.fn.input("Grep in Obisidian > "),
                    search_dirs = { "/mnt/d/the_vault/" },
                })
            end, "Grep string in Obsidian vault")
        elseif hostname == "eb-t490" then
            keymap(
                "<leader>os",
                ":Telescope find_files search_dirs=~/Documents/the_vault<CR>",
                "Search notes in Obsidian vault"
            )

            keymap("<leader>oz", function()
                telescope_builtin.grep_string({
                    search = vim.fn.input("Grep in Obisidian > "),
                    search_dirs = { "~/Documents/the_vault" },
                })
            end, "Grep string in Obsidian vault")
        end

        keymap("<leader>fss", function()
            telescope_builtin.grep_string({
                search = vim.fn.input("Grep for > "),
            })
        end, "Find using Grep")

        keymap("<leader>fsb", function()
            telescope_builtin.grep_string({
                search = vim.fn.input("Grep in open buffers > "),
                grep_open_files = true,
            })
        end, "Find using Grep in current open buffers")

        keymap("<leader>fsB", function()
            -- local current_buffer = vim.api.nvim_get_current_buf()
            -- local lines = vim.api.nvim_buf_get_lines(current_buffer, 0, -1, false)
            local search_term = vim.fn.input("Grep in current buffer > ")

            telescope_builtin.grep_string({
                search = search_term,
                search_dirs = { vim.fn.expand("%:p") }, -- Limit to the current buffer's directory
                only_sort_text = true, -- Focus on the search term itself
                default_text = search_term,
            })
        end, "Find using Grep in current buffer")

        keymap("<leader>fn", function()
            telescope_builtin.find_files({
                prompt_title = "[ VIMRC ]",
                file_ignore_patterns = file_ignore_patterns,
                cwd = "~/.config/nvim/",
            })
        end, "Find in Nvim configs")

        keymap("<leader>fF", function()
            telescope_builtin.find_files({
                prompt_title = "[ Search HOME ]",
                file_ignore_patterns = file_ignore_patterns,
                cwd = "~/",
            })
        end, "Find Files in home directory")

        keymap("<leader>fsw", function()
            telescope_builtin.grep_string({
                search = vim.fn.expand("<cword>"),
                grep_open_files = true,
            })
        end, "Find Word under cursor")

        -- keymap("<leader>fb", function()
        --     -- telescope_builtin.buffers(custom_theme)
        --     telescope_builtin.buffers()
        -- end, "Find in existing Buffers")

        keymap("<leader>fb", buffer_searcher, "Find in existing Buffers")

        keymap("<leader>fsh", function()
            telescope_builtin.search_history(custom_theme)
        end, "Find Search History")

        keymap("<leader>fcb", function()
            telescope_builtin.current_buffer_fuzzy_find(custom_theme)
        end, "Find Current Buffer")

        keymap("<leader>fch", function()
            telescope_builtin.command_history(custom_theme)
        end, "Find Command History")

        keymap("<leader>fS", function()
            telescope_builtin.spell_suggest(custom_theme)
        end, "Spell Suggesions")

        keymap("<leader>fe", ":Easypick<CR>", "Find in Dotbare")

        keymap("<leader>fu", ":Telescope luasnip theme=ivy<CR>", "Find in luansip snippets")

        -- vim.keymap.set({ "n", "x" }, "<leader>re", function()
        --     require("telescope").extensions.refactoring.refactors()
        -- end)

        -- TEST:
        -- print("Hello from lazy telescope")
    end,
}
