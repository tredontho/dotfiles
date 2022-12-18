local nvim_lsp = require('lspconfig')

-- Use on_attach to only map these keys
-- after the language server attaches to the buffer
local on_attach = function(client, bufnr)
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  require('illuminate').on_attach(client)


  -- Mappings
  local opts = { noremap=true, silent=true, buffer=true}
  require('legendary').keymaps({
    { 'gD', vim.lsp.buf.declaration, description = 'LSP: Go to declaration', opts = opts },
    { 'gd', vim.lsp.buf.definition, description = 'LSP: Go to definition', opts = opts },
    { 'K', vim.lsp.buf.hover, description = 'LSP: Hover', opts = opts },
    { 'gi', vim.lsp.buf.implementation, description = 'LSP: Go to implementation', opts = opts },
    { '<C-s>', vim.lsp.buf.signature_help, description = 'LSP: Signature help', mode = { 'n', 'i' }, opts = opts },
    { '<leader>wa', vim.lsp.buf.add_workspace_folder, description = 'LSP: Add workspace folder', opts = opts },
    { '<leader>wr', vim.lsp.buf.remove_workspace_folder, description = 'LSP: Remove workspace folder', opts = opts },
    { '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, description = 'LSP: List workspaces', opts = opts },
    { '<leader>D', vim.lsp.buf.type_definition, description = 'LSP: Show type definition', opts = opts },
    { '<leader>rn', vim.lsp.buf.rename, description = 'LSP: Rename', opts = opts },
    { '<leader>ca', vim.lsp.buf.code_action, description = 'LSP: Code Action', opts = opts },
    { 'gr', vim.lsp.buf.references, description = 'LSP: Show references', opts = opts },
    { '<leader>e', function() vim.diagnostic.open_float(0, {scope="line"}) end, description = 'Diagnostics: Show window', opts = opts },
    { '[d', function() vim.diagnostic.goto_prev({ float = { border = "single" }}) end, description = 'Diagnostics: Previous', opts = opts },
    { ']d', function() vim.diagnostic.goto_next({ float = { border = "single" }}) end, description = 'Diagnostics: Next', opts = opts },
    { '<leader>q', vim.diagnostic.setloclist, description = 'Diagnostic: Show location list', opts = opts },
    { '<leader>f', vim.lsp.buf.formatting, description = 'LSP: Format file', opts = opts },
    { ']u', function() require('illuminate').next_references({ wrap = true }) end, description = 'Illuminate: Next references', opts = opts},
    { ']u', function() require('illuminate').next_references({ reverse = true, wrap = true }) end, description = 'Illuminate: Previous references', opts = opts}
  })
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local function default_lsp_setup(module)
  nvim_lsp[module].setup{
    on_attach = on_attach,
    capabilities = capabilities
  }
end

-- Haskell
default_lsp_setup('hls')

-- Lua
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
nvim_lsp.sumneko_lua.setup{
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = runtime_path,
      },
      completion = {
        callSnippet = 'Replace'
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      }
    }
  },
  on_attach = on_attach,
  capabilities = capabilities
}
