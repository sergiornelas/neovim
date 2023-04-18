local M = {
	"kyazdani42/nvim-tree.lua",
	dependencies = {
		"kyazdani42/nvim-web-devicons",
	},
	keys = {
		{ "<leader>w", "<cmd>NvimTreeToggle<cr>", desc = "NvimTree" },
	},
}

function M.config()
	local nvim_tree_ok, nvim_tree = pcall(require, "nvim-tree")
	if not nvim_tree_ok then
		return
	end

	nvim_tree.setup({
		disable_netrw = true,
		hijack_cursor = true,
		update_focused_file = {
			enable = true, --cursor goes to the file
			update_root = true, --Update the root directory of the tree if the file is not under current root directory.
			-- disabled because updates to current folder instead root .git
		},
		-- root_dirs = { ".git" }, -- Preferred root directories. Only relevant when `update_focused_file.update_root` is `true`
		prefer_startup_root = false, --Prefer startup root directory when updating root directory of the tree. Only relevant when `update_focused_file.update_root` is `true`
		sync_root_with_cwd = false, --Changes the tree root directory on `DirChanged` and refreshes the tree.
		reload_on_bufenter = false, --Automatically reloads the tree on `BufEnter` nvim-tree.
		respect_buf_cwd = true, --Will change cwd of nvim-tree to that of new buffer's when opening nvim-tree.
		renderer = {
			highlight_opened_files = "icon",
			icons = {
				glyphs = {
					git = {
						unstaged = "🐻",
					},
					folder = {
						arrow_closed = "",
						arrow_open = "",
					},
				},
			},
			indent_markers = {
				enable = false,
			},
		},
		actions = {
			open_file = {
				quit_on_open = true,
			},
		},
		view = {
			adaptive_size = true,
			centralize_selection = true,
			hide_root_folder = false,
			side = "left",
			signcolumn = "yes",
			float = {
				enable = false,
				open_win_config = {
					relative = "cursor",
					border = "shadow",
					height = 33,
					col = 4,
				},
			},
			mappings = {
				custom_only = true,
				list = {
					{ key = { "l", "<cr>", "o" }, action = "edit" },
					{ key = "q", action = "copy_path" },
					{ key = "gk", action = "prev_git_item" },
					{ key = "gj", action = "next_git_item" },
					{ key = "O", action = "edit_no_picker" },
					{ key = { "<c-]>", "<2-RightMouse>" }, action = "cd" },
					{ key = "<c-s>", action = "split" },
					{ key = "<c-v>", action = "vsplit" },
					{ key = "<c-t>", action = "tabnew" },
					{ key = "<", action = "prev_sibling" },
					{ key = ">", action = "next_sibling" },
					{ key = "P", action = "parent_node" },
					{ key = "<esc>", action = "close" },
					{ key = "<BS>", action = "close_node" },
					{ key = "<c-i>", action = "preview" },
					{ key = "K", action = "first_sibling" },
					{ key = "J", action = "last_sibling" },
					{ key = "I", action = "toggle_git_ignored" },
					{ key = "H", action = "toggle_dotfiles" },
					{ key = "U", action = "toggle_custom" },
					{ key = "R", action = "refresh" },
					{ key = "a", action = "create" },
					{ key = "d", action = "remove" },
					{ key = "D", action = "trash" },
					{ key = "r", action = "rename" },
					{ key = "x", action = "cut" },
					{ key = "c", action = "copy" },
					{ key = "p", action = "paste" },
					{ key = "y", action = "copy_name" },
					{ key = "gy", action = "copy_absolute_path" },
					{ key = "-", action = "dir_up" },
					{ key = "s", action = "system_open" },
					{ key = "f", action = "live_filter" },
					{ key = "F", action = "clear_live_filter" },
					{ key = "W", action = "collapse_all" },
					{ key = "E", action = "expand_all" },
					{ key = "S", action = "search_node" },
					{ key = ".", action = "run_file_command" },
					{ key = "g?", action = "toggle_help" },
					-- { key = "<c-k>", actionk= "toggle_file_info" },
					-- { key = "<c-a>", action = "full_rename" },
					-- { key = "<c-e>", action = "edit_in_place" },
				},
			},
		},
	})
end

return M
