local M = {
	"rmagatti/auto-session",
	lazy = false,
}

function M.config()
	local auto_session_ok, auto_session = pcall(require, "auto-session")
	if not auto_session_ok then
		return
	end

	auto_session.setup({
		log_level = "error",
		auto_session_create_enabled = false,
		auto_session_use_git_branch = false,
		save_extra_cmds = {
			-- load last colorscheme by session
			function()
				return "colorscheme " .. vim.g.colors_name
			end,
		},
		-- post_save_cmds
		-- pre_restore_cmds
		-- pre_delete_cmds
		-- post_delete_cmds
	})

	vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,globals"
end

return M
