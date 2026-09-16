-- Bootstrap lazy.nvim; it clones itself on first launch.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 24-bit color, so themes render as designed rather than snapping to 256 colors.
vim.o.termguicolors = true

-- q: opens the command-line window, which is nearly always a mistyped :q.
vim.keymap.set("n", "q:", "<Nop>")

-- Treesitter compiles each parser on install, so skip them when there is no
-- C compiler. Get one with: sudo apt install build-essential
local has_compiler = vim.fn.executable("cc") == 1
	or vim.fn.executable("gcc") == 1
	or vim.fn.executable("clang") == 1

require("lazy").setup({
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000, -- load first, so no other plugin paints in the default theme
		config = function()
			require("catppuccin").setup({ flavour = "mocha" }) -- matches the kitty theme
			vim.cmd.colorscheme("catppuccin")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = has_compiler and {
					"gdscript",
					"gdshader",
					"godot_resource",
					"bash",
					"json",
					"lua",
					"markdown",
					"query",
					"toml",
					"vim",
					"vimdoc",
					"yaml",
				} or {},
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
})
