-- shell
local powershell_options = {
  shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
  shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
  shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
  shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
  shellquote = "",
  shellxquote = "",
}

for option, value in pairs(powershell_options) do
  vim.opt[option] = value
end

local plugins = {}

-- 共通
table.insert(plugins, require("plugins.surround"))

-- Neovim用のプラグイン
if not vim.g.vscode then
  table.insert(plugins, require("plugins.hop"))
  table.insert(plugins, require("plugins.markdown-preview"))
end

return plugins
