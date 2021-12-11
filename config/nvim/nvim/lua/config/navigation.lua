local should_reload = true
local reloader = function()
    if should_reload then
        require('plenary.reload').reload_module('plenary')
        require('plenary.reload').reload_module('popup')
        require('plenary.reload').reload_module('telescope')
    end
end

reloader()

local actions = require('telescope.actions')
local sorters = require('telescope.sorters')
local themes = require('telescope.themes')
local builtin = require('telescope.builtin')

require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ["<esc>"] = actions.close,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-x>"] = false,
                ["<C-s>"] = actions.select_horizontal,
            }
        },
        prompt_prefix = "> ",
        selection_caret = "> ",
        entry_prefix = "  ",

        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "center",
        results_title = false,

        file_sorter =  sorters.get_fuzzy_file,
        -- file_sorter =  sorters.get_fzy_sorter,
        file_ignore_patterns = {},
        generic_sorter =  sorters.get_generic_fuzzy_sorter,

        winblend = 10,
        layout_config = {
            height = 15,
            width = 100,
            preview_cutoff = 1,
            prompt_position = "top",
        },

        border = true,
        borderchars = {
            { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
            prompt = {"─", "│", " ", "│", "┌", "┐", "│", "│"},
            results = {"─", "│", "─", "│", "├", "┤", "┘", "└"},
            preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        },
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = false,
        },
    },
}
require('telescope').load_extension('fzy_native')

local M = {}
local common_opts = themes.get_dropdown {
    winblend = 10,
    previewer = false,
    borderchars = {
        { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        prompt = {"─", "│", " ", "│", "┌", "┐", "│", "│"},
        results = {"─", "│", "─", "│", "├", "┤", "┘", "└"},
        preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
    },
    layout_config = {
        height = 15,
        width = 100,
    }
}

function M.list_files()
    builtin.find_files(common_opts)
end

function M.git_files()
    local opts = common_opts
    opts['hidden'] = 'true'
    builtin.git_files(opts)
end

function M.list_buffers()
    local opts = common_opts
    opts['show_all_buffers'] = 'true'
    builtin.buffers(opts)
end

return M
