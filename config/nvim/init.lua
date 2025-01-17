--------------------------------------------------------------------------------
-- Globals
--------------------------------------------------------------------------------

vim.g.mapleader = " "
vim.cmd("colorscheme default")

--------------------------------------------------------------------------------
-- Pluign installer
--------------------------------------------------------------------------------

local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
---@diagnostic disable-next-line: undefined-field
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/echasnovski/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end
require("mini.deps").setup({ path = { package = path_package } })
---@diagnostic disable-next-line: undefined-global
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

--------------------------------------------------------------------------------
-- options
--------------------------------------------------------------------------------

-- UI
vim.opt.laststatus = 3 -- global statusline
vim.opt.number = true -- Print line number
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.scrolloff = 4 -- Lines of context
vim.opt.sidescrolloff = 8 -- Columns of context
vim.opt.termguicolors = true -- True color support

-- Search
vim.opt.ignorecase = true -- Ignore case
vim.opt.smartcase = true -- Don't ignore case with capitals

-- Indent
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 2 -- Size of an indent
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.smartindent = true -- Insert indents automatically

-- Splits
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current

-- Completions
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.completeopt = "menu,menuone,noselect"

-- Others
vim.opt.smoothscroll = true
vim.opt.undofile = true
vim.opt.spelllang = { "en", "it" }

--------------------------------------------------------------------------------
-- Plugins
--------------------------------------------------------------------------------

-- Treesitter
now(function()
	add({
		source = "nvim-treesitter/nvim-treesitter",
		hooks = {
			post_checkout = function()
				vim.cmd("TSUpdate")
			end,
		},
	})
	---@diagnostic disable-next-line: missing-fields
	require("nvim-treesitter.configs").setup({
		ensure_installed = {
			"c",
			"lua",
			"vim",
			"vimdoc",
			"query",
			"markdown",
			"markdown_inline",
			"python",
			"ninja",
			"rst",
		},
		highlight = { enable = true },
	})
end)

-- Statusline
now(function()
	require("mini.ai").setup()
end)

-- Statusline
now(function()
	require("mini.statusline").setup()
end)

-- Icons
now(function()
	require("mini.icons").setup()
end)

-- Buffers as tabs
later(function()
	require("mini.tabline").setup()
end)

-- Completions
later(function()
	require("mini.completion").setup({})
end)

-- File Explorer
later(function()
	require("mini.files").setup()
end)

-- Picker
later(function()
	require("mini.pick").setup()
	vim.ui.select = require("mini.pick").ui_select
end)

-- Extra pickers
later(function()
	require("mini.extra").setup()
end)

--------------------------------------------------------------------------------
-- Autocmds
--------------------------------------------------------------------------------

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("config_highlight_on_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ timeout = 100 })
	end,
})

--------------------------------------------------------------------------------
-- Keymaps
--------------------------------------------------------------------------------

local map = vim.keymap.set

-- windows
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right" })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })
map({ "n", "v" }, "<leader>by", 'mqgg"+yG`q<cmd>delm q<cr>', { desc = "Yank buffer (+)" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>")

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Improved yank/paste/delete
map("x", "<leader>p", '"_dP', { desc = "Paste without overwriting the default register" })
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without overwriting the default register" })
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })

-- File Explorer
map("n", "<leader>e", function()
	require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
end, { desc = "File explorer (buf)" })
map("n", "<leader>E", function()
	---@diagnostic disable-next-line: undefined-field
	require("mini.files").open(vim.uv.cwd(), true)
end, { desc = "File explorer (cwd)" })

-- Picker: Find files & buffers
map("n", "<leader><leader>", function()
	require("mini.pick").builtin.files({ tool = "rg" })
end, { desc = "Find Files" })
map("n", "<leader>,", function()
	require("mini.pick").builtin.buffers()
end, { desc = "Find Buffer" })
map("n", "<leader>fg", function()
	require("mini.pick").builtin.files({ tool = "git" })
end, { desc = "Find Files (git)" })
map("n", "<leader>fc", function()
	require("mini.pick").builtin.files({}, { source = { cwd = "~/.config" } })
end, { desc = "Find Config" })
map("n", "<leader>fr", function()
	require("mini.extra").pickers.oldfiles()
end, { desc = "Find Recent" })

-- Picker: Search
map("n", "<leader>sg", function()
	require("mini.pick").builtin.grep_live()
end, { desc = "Search Grep" })
map("n", "<leader>sh", function()
	require("mini.pick").builtin.help()
end, { desc = "Search Help" })
map("n", "<leader>sk", function()
	require("mini.extra").pickers.keymaps()
end, { desc = "Search Keymaps" })
