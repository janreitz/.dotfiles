-- Native LSP setup. Server definitions (cmd/filetypes/root markers) come
-- from nvim-lspconfig; Neovim's built-in client does the rest.
vim.lsp.enable({
  "clangd",        -- C/C++  (apt: clangd)
  "rust_analyzer", -- Rust   (~/.cargo/bin)
  "basedpyright",  -- Python (pipx)
})

-- Built-in autocompletion (0.12+): trigger as you type in any LSP buffer.
vim.o.completeopt = "menuone,noselect,fuzzy"
vim.api.nvim_create_autocmd("LspAttach", {
  desc = "Enable native LSP autocompletion",
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

-- Show diagnostics inline (off by default since 0.11)
vim.diagnostic.config({ virtual_text = true })

-- Readable which-key hints for the built-in LSP/diagnostic keymaps
require("which-key").add({
  { "gr", group = "lsp" },
  { "grn", desc = "Rename symbol" },
  { "gra", desc = "Code action", mode = { "n", "x" } },
  { "grr", desc = "References" },
  { "gri", desc = "Goto implementation" },
  { "grt", desc = "Goto type definition" },
  { "gO", desc = "Document symbols" },
  { "K", desc = "Hover docs" },
  { "[d", desc = "Prev diagnostic" },
  { "]d", desc = "Next diagnostic" },
  { "<C-w>d", desc = "Diagnostic float" },
})
