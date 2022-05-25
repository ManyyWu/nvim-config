local which_key = require("which-key")
local global = require("global")
local config_path = global.config_path

which_key.setup({

})

which_key.register(require("keymaps").leader_keybinding, { prefix = "<leader>" })
which_key.register(require("keymaps").leader2_keybinding, { prefix = ";" })
