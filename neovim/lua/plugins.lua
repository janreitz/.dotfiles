-- vim.pack is the built-in plugin manager (Neovim 0.12+).
-- Missing plugins are cloned on startup; update later with :lua vim.pack.update()
if vim.pack == nil then
  vim.notify("This config needs Neovim 0.12+ (vim.pack). You are on " .. tostring(vim.version()), vim.log.levels.ERROR)
  return
end

vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim", -- telescope dependency
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/neovim/nvim-lspconfig", -- ready-made configs for vim.lsp.enable()
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
})

-- which-key ---------------------------------------------------------------
local wk = require("which-key")
wk.setup({ preset = "helix" })
wk.add({
  { "<leader>f", group = "find" },
  { "<leader>g", group = "git" },
})

-- telescope ---------------------------------------------------------------
require("telescope").setup({})
local builtin = require("telescope.builtin")
local map = vim.keymap.set
map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
map("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
map("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })

-- fugitive ----------------------------------------------------------------
map("n", "<leader>gs", "<cmd>Git<CR>", { desc = "Git status" })
map("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git blame" })
map("n", "<leader>gd", "<cmd>Gdiffsplit<CR>", { desc = "Git diff" })

-- treesitter (main branch) ------------------------------------------------
-- Grammar installs need the tree-sitter CLI and a C compiler.
-- Extend this list as needed; already-installed grammars are skipped.
require("nvim-treesitter").install({
  "bash", "cpp", "json", "markdown", "markdown_inline", "python", "rust", "toml", "yaml",
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Enable treesitter highlighting when a parser is available",
  callback = function(ev)
    pcall(vim.treesitter.start, ev.buf)
  end,
})
