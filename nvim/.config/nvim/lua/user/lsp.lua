local lsp_cmds = {
    LspDef = vim.lsp.buf.definition,
    LspRefs = vim.lsp.buf.references,
    LspDocSymbols = vim.lsp.buf.document_symbol,
    LspCodeAction = vim.lsp.buf.code_action,
    LspRename = vim.lsp.buf.rename,

    LineDiagnostics = vim.diagnostic.open_float,
    LspGotoPrev = vim.diagnostic.goto_prev,
    LspGotoNext = vim.diagnostic.goto_next,
}

for name, cmd in pairs(lsp_cmds) do
    vim.api.nvim_create_user_command(name, cmd, {})
end

vim.diagnostic.config {
    -- virtual_text = false,
    signs = true,
    float = { focus = false },
}

local function on_attach(client, bufnr)
    vim.opt.omnifunc = 'v:lua.vim.lsp.omnifunc'
    pat = { '*.rs', '*.c', '*.h', '<buffer>' }
    augroup('Lsp', {
        BufWritePre = { pattern = pat, callback = vim.lsp.buf.formatting_sync, desc = 'format' },
        CursorHold = { pattern = pat, callback = vim.diagnostic.open_float, desc = 'diagnostic floating window' },
    })
end

local lspconfig = require 'lspconfig'
local servers = { 'clangd', 'rust_analyzer' }
for _, ls in ipairs(servers) do
    lspconfig[ls].setup {
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
        on_attach = on_attach,
        flags = { debounce_text_changes = 150 },
    }
end