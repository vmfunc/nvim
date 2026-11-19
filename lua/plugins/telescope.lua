-- Telescope - Fuzzy finder (like Ctrl+P in VS Code)
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "truncate" },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<Esc>"] = actions.close,
            ["<CR>"] = actions.select_default,
          },
        },
        file_ignore_patterns = { "node_modules", ".git/" },
      },
      pickers = {
        find_files = { hidden = true },
      },
    })
    telescope.load_extension("fzf")
  end,
}
