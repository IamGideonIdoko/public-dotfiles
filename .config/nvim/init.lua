--[[
Set <space> as the leader key (see `:help mapleader`)
NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
--]]
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you want to files with set configured languages to be formatted on save
vim.g.autoformat = false

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Global table to keep track of buffer usage
vim.g.buffer_usage = {}

-- Setting options
require("options")

-- Terminal
require("terminal")

-- Autocommands
require("autocmds")

-- Set up the `lazy.nvim` plugin manager
require("lazy-bootstrap")

-- Configure and install plugins
require("lazy-plugins")

-- Keymaps
require("keymaps")

-- Modeline (see `:modeline`)
-- vim: ts=2 sts=2 sw=2 et
