local nvim_navic_ok, nvim_navic = pcall(require, "nvim-navic")
local lsp_inlayhints_ok, lsp_inlayhints = pcall(require, "lsp-inlayhints")
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

if not nvim_navic_ok or not lsp_inlayhints_ok or not cmp_nvim_lsp_ok then
	return
end

local keymap = vim.keymap.set

keymap("n", "gw", '<cmd>lua vim.diagnostic.open_float(0, { scope = "cursor", border = "single" })<CR>')
keymap("n", "gl", '<cmd>lua vim.diagnostic.open_float(0, { scope = "line", border = "single" })<CR>')
keymap("n", "gB", '<cmd>lua vim.diagnostic.open_float(0, { scope = "buffer", border = "double" })<CR>')
keymap("n", "\\r", vim.diagnostic.goto_prev)
keymap("n", "\\f", vim.diagnostic.goto_next)
keymap(
	"n",
	"\\t",
	"<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR, float = { border = { '╭', '~', '╮', '│', '╯', '─', '╰', '│' } } })<CR>"
)
keymap(
	"n",
	"\\g",
	"<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR, float = { border = { '╭', '~', '╮', '│', '╯', '─', '╰', '│' } } })<CR>"
)
keymap("n", "gq", vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		local lsp = vim.lsp.buf
		local opts = { buffer = ev.buf }
		-- keymap("n", "gD", lsp.declaration, bufopts)
		keymap("n", "gd", lsp.definition, opts)
		keymap("n", "gD", "<cmd>TypescriptGoToSourceDefinition<cr>", opts)
		keymap("n", "gh", lsp.hover, opts)
		keymap("n", "gI", lsp.implementation, opts)
		keymap("n", "gs", lsp.signature_help, opts)
		keymap("n", "gA", lsp.add_workspace_folder, opts)
		keymap("n", "gF", lsp.remove_workspace_folder, opts)
		keymap("n", "gW", function()
			print(vim.inspect(lsp.list_workspace_folders()))
		end, opts)
		keymap("n", "gf", lsp.type_definition, opts)
		keymap("n", "gr", lsp.rename, opts)
		keymap({ "n", "v" }, "g<leader>", lsp.code_action, opts)
		-- keymap("n", "gR", lsp.references, bufopts)
		keymap("n", "g;", function()
			lsp.format({ async = true })
		end, opts)
	end,
	keymap("n", "gL", "<cmd>LspInfo<cr>"),
})

local M = {}

M.on_attach = function(client, bufnr)
	nvim_navic.attach(client, bufnr)
	require("nvim-navbuddy").attach(client, bufnr)
	if client.name == "tsserver" then
		lsp_inlayhints.on_attach(client, bufnr) -- Typescript 4.4+
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.documentRangeFormattingProvider = false
	end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

return M
