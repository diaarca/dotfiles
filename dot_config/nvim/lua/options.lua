require("nvchad.options")

local o = vim.o
local opt = vim.opt
local wo = vim.wo

-- Aesthetic
opt.list = true
opt.colorcolumn = "80"

-- Tab
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
o.tabstop = 4
o.shiftwidth = 4

-- Relative Numbers
wo.relativenumber = true

-- No Fold in Config File
opt.foldenable = false

if vim.env.HOME then
  o.shell = vim.env.HOME .. "/.nix-profile/bin/fish"
else
  vim.notify("HOME environment variable is not set", vim.log.levels.ERROR)
end
