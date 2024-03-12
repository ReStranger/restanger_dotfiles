local opt = vim.opt
local g = vim.g

opt.relativenumber = true
g.dap_virtual_text = true

if g.vscode then
    -- VSCode extension
else
    -- ordinary Neovim
end
