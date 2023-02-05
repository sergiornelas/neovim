local M = {
	"nvim-neorg/neorg",
	ft = "norg",
	build = ":Neorg sync-parsers",
	-- run = ":Neorg sync-parsers", -- This is the important bit
}

function M.config()
	-- https://github.com/nvim-neorg/neorg/wiki
	local neorg_ok, neorg = pcall(require, "neorg")
	if not neorg_ok then
		return
	end

	neorg.setup({
		load = {
			["core.defaults"] = {},
			["core.keybinds"] = {
				config = {
					default_keybinds = false,
					hook = function(keybinds)
						keybinds.remap_event("norg", "", "gd", "core.norg.esupports.hop.hop-link")
					end,
				},
			},
			-- Complementary:
			["core.norg.concealer"] = {}, -- cool icons
			["core.norg.completion"] = { -- extra cmp options,
				config = {
					engine = "nvim-cmp",
				},
			},
			["core.norg.qol.toc"] = { -- Index,
				config = {
					default_toc_mode = "split",
					toc_split_placement = "right",
				},
			},
			-- ["external.context"] = {},
			-- ["core.integrations.telescope"] = {}, -- Enable telescope module
			-- ["core.norg.dirman"] = { --Managing directories full of .norg files
			--     config = {
			--       workspaces = {
			--         notes = "~/notes",
			--         -- gtd = "~/notes/gtd",
			--       },
			--     },
			--   },
			-- ["core.gtd.base"] = {,
			-- 	config = {
			-- 		workspace = "gtd",
			-- 	}
			-- },
		},
	})

	-- When error src/scanner.cc error happens:
	-- https://github.com/nvim-neorg/neorg/issues/74
	-- brew install gcc
	-- :checkhealth nvim_treesitter -> (OK: `cc` executable found)
	-- brew info gcc
	-- ln -s /usr/local/Cellar/gcc/<version>/bin/gcc-<version 11|12> /usr/local/bin/cc
end

return M
