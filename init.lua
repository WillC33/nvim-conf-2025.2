require("config.globals")
require("config.lazy")
require("config.options")
require("config.mappings").setup()
require("config.autocmd").setup()
require("util/fns")
require("util/commands")

-- Finally load transparency to prevent overriding
-- This is now handled in the HeathGlass theme, check back in Git if needed
