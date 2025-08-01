require("config.globals")
require("config.lazy")
require("config.options")
require("config.mappings").setup()

-- Finally load transparency to prevent overriding
vim.cmd([[
  highlight LineNr guifg=NONE guibg=NONE
  highlight SignColumn guifg=NONE guibg=NONE
  highlight EndOfBuffer guifg=NONE guibg=NONE

  highlight Normal guibg=NONE
  highlight LineNr guibg=NONE
  highlight SignColumn guibg=NONE
  highlight EndOfBuffer guibg=NONE
  highlight NormalNC guibg=NONE
  highlight VertSplit guibg=NONE
  highlight StatusLine guibg=NONE
  highlight StatusLineNC guibg=NONE
  highlight Pmenu guibg=NONE
  highlight PmenuSel guibg=NONE
  highlight CursorLine guibg=NONE
  highlight CursorLineNr guibg=NONE

  highlight NvimTreeNormal guibg=NONE
  highlight NvimTreeVertSplit guibg=NONE
  highlight NvimTreeEndOfBuffer guibg=NONE
  highlight NvimTreeCursorLine guibg=NONE
]])
