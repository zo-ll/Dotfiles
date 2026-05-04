-- Neovim 0.12 minimal config (built-in vim.pack)

vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"

vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  { src = "https://github.com/shaunsingh/nord.nvim" },
}, { load = true, confirm = false })

vim.cmd.colorscheme("tokyonight")

require("telescope").setup({
  defaults = {
    preview = {
      treesitter = false,
    },
  },
})
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

require("nvim-treesitter").setup({
  ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "javascript", "typescript", "tsx", "php" },
  highlight = { enable = true },
  indent = { enable = true },
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local b = args.buf
    local map = function(lhs, rhs) vim.keymap.set("n", lhs, rhs, { buffer = b }) end
    map("gd", vim.lsp.buf.definition)
    map("gr", vim.lsp.buf.references)
    map("K", vim.lsp.buf.hover)
    map("<leader>rn", vim.lsp.buf.rename)
    map("<leader>ca", vim.lsp.buf.code_action)
    map("<leader>f", function() vim.lsp.buf.format({ async = true }) end)
    map("[d", vim.diagnostic.goto_prev)
    map("]d", vim.diagnostic.goto_next)
  end,
})

vim.lsp.enable("intelephense")
vim.lsp.enable("ts_ls")
vim.lsp.enable("clangd")

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    vim.lsp.buf.format({ bufnr = args.buf, async = false, timeout_ms = 2000 })
  end,
})
