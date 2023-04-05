local M = {
	"nvim-neorg/neorg",
	ft = "norg",
	cmd = "Neorg",
	dependencies = { "nvim-neorg/neorg-telescope" },
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
					neorg_leader = ",",
					hook = function(keybinds)
						keybinds.remap_event("norg", "n", "\\e", "core.integrations.treesitter.previous.heading")
						keybinds.remap_event("norg", "n", "\\f", "core.integrations.treesitter.next.heading")
						keybinds.remap_event("norg", "n", "gc", "core.looking-glass.magnify-code-block")
						keybinds.remap_event("norg", "n", "\\v", "core.itero.next-iteration")
						keybinds.remap_event("norg", "n", ",e", "core.integrations.telescope.find_linkable") -- go to other header from current workspace
						keybinds.remap_event("norg", "n", ",l", "core.integrations.telescope.insert_file_link") -- insert file link from current workspace
						keybinds.remap_event("norg", "n", ",f", "core.integrations.telescope.search_headings") -- current file headers
						keybinds.remap_event("norg", "n", ",nf", "core.integrations.telescope.find_norg_files") -- find files in current workspace, not useful
						keybinds.remap_event("norg", "n", ",s", "core.integrations.telescope.switch_workspace") -- not useful
						keybinds.remap_event("norg", "n", ",L", "core.integrations.telescope.insert_link") -- not working
					end,
					-- default_keybinds = false,
				},
			},
			["core.norg.dirman"] = {
				config = {
					workspaces = {
						wiki = "~/notes/wiki",
						todo = "~/notes/todo",
						data = "~/notes/data",
					},
					default_workspace = "wiki",
					index = "index.norg",
					open_last_workspace = false,
				},
			},
			["core.norg.concealer"] = {
				config = {
					dim_code_blocks = {
						conceal = false,
					},
					icon_preset = "varied",
					icons = {
						todo = {
							cancelled = {
								icon = "❌",
							},
							done = {
								icon = "✅",
							},
							on_hold = {
								icon = "⏸️",
							},
							pending = {
								icon = "🕒",
							},
							recurring = {
								icon = "🔄",
							},
							uncertain = {
								icon = "❔",
							},
							urgent = {
								icon = "⚠️",
							},
						},
					},
				},
			},
			["core.norg.completion"] = {
				config = {
					engine = "nvim-cmp",
				},
			},
			["core.norg.qol.toc"] = {
				config = {
					default_toc_mode = "split",
					toc_split_placement = "right",
				},
			},
			["core.integrations.telescope"] = {},
			["external.context"] = {},
		},
	})

	-- When error src/scanner.cc error happens:
	-- https://github.com/nvim-neorg/neorg/issues/74
	-- brew install gcc
	-- :checkhealth nvim_treesitter -> (OK: `cc` executable found)
	-- brew info gcc
	-- ln -s /usr/local/Cellar/gcc/<version>/bin/gcc-<version 11|12> /usr/local/bin/cc
	-- real: ln -s /usr/local/Cellar/gcc/12.2.0/bin/gcc-12 /usr/local/bin/cc
end

return M
