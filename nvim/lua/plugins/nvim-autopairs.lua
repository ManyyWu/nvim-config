local cmp           = require("cmp")
local autopairs     = require("nvim-autopairs")

autopairs.setup({
  --disable_filetype = { "vim" },
})

cmp.event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done({  map_char = { tex = '' } }))
