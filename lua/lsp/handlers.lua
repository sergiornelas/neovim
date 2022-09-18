local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
	return
end

local status_navic_ok, navic = pcall(require, "nvim-navic")
if not status_navic_ok then
	return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.update_capabilities(M.capabilities)

M.setup = function()
	local signs = {
		{ name = "DiagnosticSignError", text = "🔥" },
		{ name = "DiagnosticSignWarn", text = "👀" },
		{ name = "DiagnosticSignHint", text = "💡" },
		{ name = "DiagnosticSignInfo", text = "ℹ️" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		virtual_text = true, -- disable virtual text
		signs = {
			active = signs, -- show signs
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end

local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_buf_set_keymap

local function lsp_highlight_document(client)
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec(
			[[
		    augroup lsp_document_highlight
		      autocmd! * <buffer>
		      autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
		      autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
		    augroup END
		  ]],
			false
		)
	end
end

local function lsp_keymaps(bufnr)
	keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	keymap(bufnr, "n", "g<leader>", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
	keymap(bufnr, "n", "gL", "<cmd>LspInfo<cr>", opts)
	keymap(bufnr, "n", "gQ", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
	keymap(bufnr, "n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	keymap(bufnr, "n", "gW", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
	-- lspsaga handles: hover, references, show and jump diagnostics, code actions, and rename.

	-- Unused features:
	-- local bufopts = { noremap = true, silent = true, buffer = bufnr }
	-- vim.keymap.set('n', 'gz', vim.lsp.buf.remove_workspace_folder, bufopts)
	-- vim.keymap.set("n", "gz", function()
	-- 	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	-- end, bufopts)
	-- vim.keymap.set("n", "gz", vim.lsp.buf.type_definition, bufopts)
end

M.on_attach = function(client, bufnr)
	lsp_keymaps(bufnr)
	-- Prettierd and Stylua active in null_ls
	if
		client.name == "tsserver"
		or client.name == "jsonls"
		or client.name == "html"
		or client.name == "sumneko_lua"
	then
		client.resolved_capabilities.document_formatting = false
	end

	-- Classic highlight
	lsp_highlight_document(client)

	-- Inlay hints
	if client.name == "tsserver" or client.name == "sumneko_lua" then
		require("lsp-inlayhints").on_attach(client, bufnr)
	end

	-- Navic (currently not working on css and html files)
	if client.name ~= "html" and client.name ~= "cssls" then
		navic.attach(client, bufnr)
	end

	-- Format on save. All formatting clients are handled by null_ls
	-- if client.resolved_capabilities.document_formatting then
	-- 	vim.api.nvim_create_autocmd(
	-- 		"BufWritePre",
	-- 		{ pattern = "<buffer>", command = "lua vim.lsp.buf.formatting_sync()" }
	-- 	)
	-- end
end

return M
