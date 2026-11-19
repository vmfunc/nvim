-- VS Code / Cursor style keymaps
local map = vim.keymap.set

-- === FILE OPERATIONS (Ctrl+) ===
map("n", "<C-s>", ":w<CR>", { desc = "Save file" })
map("i", "<C-s>", "<Esc>:w<CR>a", { desc = "Save file" })
map("n", "<C-q>", ":q<CR>", { desc = "Quit" })
map("n", "<C-n>", ":enew<CR>", { desc = "New file" })
map("n", "<C-w>", ":bdelete<CR>", { desc = "Close buffer", silent = true })

-- === NAVIGATION (Ctrl+) ===
map("n", "<C-p>", ":Telescope find_files<CR>", { desc = "Quick open file" })
map("n", "<C-S-p>", ":Telescope commands<CR>", { desc = "Command palette" })
map("n", "<C-S-f>", ":Telescope live_grep<CR>", { desc = "Search in files" })
map("n", "<C-S-e>", ":Oil<CR>", { desc = "File explorer" })
map("n", "<C-b>", ":Neotree toggle dir=.<CR>", { desc = "Toggle sidebar" })
map("n", "<C-`>", ":ToggleTerm<CR>", { desc = "Toggle terminal" })
map("t", "<C-`>", "<C-\\><C-n>:ToggleTerm<CR>", { desc = "Toggle terminal" })

-- === EDITOR (Ctrl+) ===
map("n", "<C-f>", "/", { desc = "Find in file" })
map("n", "<C-h>", ":%s/", { desc = "Find and replace" })
map("n", "<C-z>", "u", { desc = "Undo" })
map("n", "<C-S-z>", "<C-r>", { desc = "Redo" })
map("n", "<C-/>", "gcc", { desc = "Toggle comment", remap = true })
map("v", "<C-/>", "gc", { desc = "Toggle comment", remap = true })
map("n", "<C-a>", "ggVG", { desc = "Select all" })
map("n", "<C-d>", "viw", { desc = "Select word" })

-- === LINE OPERATIONS (Alt+) ===
map("n", "<A-Up>", ":m .-2<CR>==", { desc = "Move line up", silent = true })
map("n", "<A-Down>", ":m .+1<CR>==", { desc = "Move line down", silent = true })
map("i", "<A-Up>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up", silent = true })
map("i", "<A-Down>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down", silent = true })
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move lines up", silent = true })
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move lines down", silent = true })
map("n", "<A-S-Up>", "yyP", { desc = "Duplicate line up" })
map("n", "<A-S-Down>", "yyp", { desc = "Duplicate line down" })

-- === MULTI-CURSOR (kind of) ===
map("n", "<C-S-l>", "viw:s/\\%V", { desc = "Change all occurrences" })

-- === SPLITS (like VS Code) ===
map("n", "<C-\\>", ":vsplit<CR>", { desc = "Split right" })
map("n", "<C-S-\\>", ":split<CR>", { desc = "Split down" })

-- === WINDOW NAVIGATION ===
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- === TAB/BUFFER NAVIGATION ===
map("n", "<C-Tab>", ":bnext<CR>", { desc = "Next buffer", silent = true })
map("n", "<C-S-Tab>", ":bprevious<CR>", { desc = "Prev buffer", silent = true })
map("n", "<C-1>", ":BufferLineGoToBuffer 1<CR>", { silent = true })
map("n", "<C-2>", ":BufferLineGoToBuffer 2<CR>", { silent = true })
map("n", "<C-3>", ":BufferLineGoToBuffer 3<CR>", { silent = true })
map("n", "<C-4>", ":BufferLineGoToBuffer 4<CR>", { silent = true })
map("n", "<C-5>", ":BufferLineGoToBuffer 5<CR>", { silent = true })

-- === GO TO (Ctrl+G) ===
map("n", "<C-g>", ":Telescope lsp_document_symbols<CR>", { desc = "Go to symbol" })

-- === VAULT (Leader+o) ===
map("n", "<leader>ov", ":edit ~/vault/<CR>", { desc = "Open vault" })
map("n", "<leader>op", ":edit ~/vault/personal/plan.md<CR>", { desc = "Personal plan" })
map("n", "<leader>owp", ":edit ~/vault/work/plan.md<CR>", { desc = "Work plan" })

-- === KANBAN ===
map("n", "<leader>ok", ":KanbanOpen<CR>", { desc = "Open Kanban" })
map("n", "<leader>owk", ":KanbanOpen ~/vault/work/kanban.md<CR>", { desc = "Work kanban" })
map("n", "<leader>opk", ":KanbanOpen ~/vault/personal/kanban.md<CR>", { desc = "Personal kanban" })

-- === TODO STATES ===
-- Cycle: [ ] -> [@] -> [s] -> [x] -> [ ]
local todo_states = { "[ ]", "[@]", "[s]", "[x]" }
local function cycle_todo()
  local line = vim.api.nvim_get_current_line()
  for i, state in ipairs(todo_states) do
    if line:find(vim.pesc(state), 1, true) then
      local next_state = todo_states[(i % #todo_states) + 1]
      local new_line = line:gsub(vim.pesc(state), next_state, 1)
      vim.api.nvim_set_current_line(new_line)
      return
    end
  end
end
map("n", "<leader>tt", cycle_todo, { desc = "Cycle todo state" })
map("n", "<leader>td", function()
  local line = vim.api.nvim_get_current_line()
  local new_line = line:gsub("%[.%]", "[d]", 1)
  vim.api.nvim_set_current_line(new_line)
end, { desc = "Mark deferred" })
map("n", "<leader>tb", function()
  local line = vim.api.nvim_get_current_line()
  local new_line = line:gsub("%[.%]", "[b]", 1)
  vim.api.nvim_set_current_line(new_line)
end, { desc = "Mark blocked" })
map("n", "<leader>t!", function()
  local line = vim.api.nvim_get_current_line()
  local new_line = line:gsub("%[.%]", "[!]", 1)
  vim.api.nvim_set_current_line(new_line)
end, { desc = "Mark priority" })
map("n", "<leader>t?", function()
  local line = vim.api.nvim_get_current_line()
  local new_line = line:gsub("%[.%]", "[?]", 1)
  vim.api.nvim_set_current_line(new_line)
end, { desc = "Mark question" })

-- === BETTER DEFAULTS ===
map("n", "<Esc>", ":nohlsearch<CR>", { silent = true })
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })
map("n", "J", "mzJ`z", { desc = "Join lines (keep cursor)" })
map("n", "n", "nzzzv", { desc = "Next match (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev match (centered)" })

-- === TROUBLE / DIAGNOSTICS (Leader+x) ===
map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (workspace)" })
map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Diagnostics (buffer)" })
map("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>", { desc = "Todos (workspace)" })
map("n", "<leader>xT", "<cmd>Trouble todo toggle filter.buf=0<cr>", { desc = "Todos (buffer)" })
map("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols" })
map("n", "<leader>xl", "<cmd>Trouble loclist toggle<cr>", { desc = "Location list" })
map("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix list" })

-- === WHICH-KEY GROUPS ===
-- These will show up nicely in which-key
map("n", "<leader>f", "", { desc = "+find" })
map("n", "<leader>o", "", { desc = "+vault" })
map("n", "<leader>g", "", { desc = "+git" })
map("n", "<leader>t", "", { desc = "+todo" })
map("n", "<leader>x", "", { desc = "+trouble" })
map("n", "<leader>D", "", { desc = "+distant" })
