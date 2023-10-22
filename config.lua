-- install plugins
lvim.plugins = {
  "ChristianChiarulli/swenv.nvim",
  "stevearc/dressing.nvim",
  "mfussenegger/nvim-dap-python",
  "nvim-neotest/neotest",
  "nvim-neotest/neotest-python",
  {
    "unblevable/quick-scope"
    -- QuickScopeToggle
  },
  {
  "phaazon/hop.nvim",
  event = "BufRead",
  config = function()
    require("hop").setup()
    -- vim.api.nvim_set_keymap("n", "s", ":HopChar2<cr>", { silent = true })
    -- vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
    vim.api.nvim_set_keymap('n', 'jw', "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.BEGIN })<cr>", {})
    vim.api.nvim_set_keymap('v', 'jw', "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.BEGIN })<cr>", {})
    vim.api.nvim_set_keymap('o', 'jw', "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.BEGIN, inclusive_jump = true })<cr>", {})
    vim.api.nvim_set_keymap('n', 'jr', "<cmd> lua require'hop'.hint_lines({ hint_position = require'hop.hint'.HintPosition.BEGIN })<cr>", {})
    vim.api.nvim_set_keymap('v', 'jr', "<cmd> lua require'hop'.hint_lines({ hint_position = require'hop.hint'.HintPosition.BEGIN })<cr>", {})
    vim.api.nvim_set_keymap('o', 'jr', "<cmd> lua require'hop'.hint_lines({ hint_position = require'hop.hint'.HintPosition.BEGIN, inclusive_jump = true })<cr>", {})
    vim.api.nvim_set_keymap('n', 'jf', "<cmd> lua require'hop'.hint_patterns({ hint_position = require'hop.hint'.HintPosition.BEGIN })<cr>", {})
    vim.api.nvim_set_keymap('v', 'jf', "<cmd> lua require'hop'.hint_patterns({ hint_position = require'hop.hint'.HintPosition.BEGIN })<cr>", {})
    vim.api.nvim_set_keymap('o', 'jf', "<cmd> lua require'hop'.hint_patterns({ hint_position = require'hop.hint'.HintPosition.BEGIN, inclusive_jump = true })<cr>", {})
  end,
  },
  {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  -- opts.label.after = {0, 2},
  -- opts = {}
  opts = {
      label = {
        after = {0, 2},
      },
    },
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
},
  -- {
  -- "ggandor/leap.nvim",
  -- name = "leap",
  -- config = function()
  --   require("leap").add_default_mappings()
  -- end,
  -- },
  {
  "nacro90/numb.nvim",
  event = "BufRead",
  config = function()
  require("numb").setup {
    show_numbers = true, -- Enable 'number' for the window while peeking
    show_cursorline = true, -- Enable 'cursorline' for the window while peeking
  }
  end,
  },
  {
  "tpope/vim-fugitive",
  cmd = {
    "G",
    "Git",
    "Gdiffsplit",
    "Gread",
    "Gwrite",
    "Ggrep",
    "GMove",
    "GDelete",
    "GBrowse",
    "GRemove",
    "GRename",
    "Glgrep",
    "Gedit"
  },
  ft = {"fugitive"}
  },
}

-- automatically install python syntax highlighting
lvim.builtin.treesitter.ensure_installed = {
  "python",
}

-- set up markdown lsp server
require("lvim.lsp.manager").setup("marksman")

-- setup formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup { { name = "black" }, }
lvim.format_on_save.enabled = true
lvim.format_on_save.pattern = { "*.py" }

-- setup linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup { { command = "ruff", filetypes = { "python" } } }

-- setup debug adapter
lvim.builtin.dap.active = true
local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
pcall(function()
  require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
end)

-- setup testing
require("neotest").setup({
  adapters = {
    require("neotest-python")({
      -- Extra arguments for nvim-dap configuration
      -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
      dap = {
        justMyCode = false,
        console = "integratedTerminal",
      },
      args = { "--log-level", "DEBUG", "--quiet" },
      runner = "pytest",
    })
  }
})

lvim.builtin.which_key.mappings["dm"] = { "<cmd>lua require('neotest').run.run()<cr>",
  "Test Method" }
lvim.builtin.which_key.mappings["dM"] = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
  "Test Method DAP" }
lvim.builtin.which_key.mappings["df"] = {
  "<cmd>lua require('neotest').run.run({vim.fn.expand('%')})<cr>", "Test Class" }
lvim.builtin.which_key.mappings["dF"] = {
  "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", "Test Class DAP" }
lvim.builtin.which_key.mappings["dS"] = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Test Summary" }


-- binding for switching
lvim.builtin.which_key.mappings["C"] = {
  name = "Python",
  c = { "<cmd>lua require('swenv.api').pick_venv()<cr>", "Choose Env" },
}

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  -- vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
