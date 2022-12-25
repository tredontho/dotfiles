local api = vim.api
local map = vim.keymap.set

-- Scala
local metals_config = require("metals").bare_config()
metals_config.settings = {
  showImplicitArguments = true,
  excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
}
metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

metals_config.on_attach = function(client, buffer)
        -- LSP mappings
        map("n", "gD", function()
          vim.lsp.buf.definition()
        end)

        map("n", "K", function()
          vim.lsp.buf.hover()
        end)

        map("n", "gi", function()
          vim.lsp.buf.implementation()
        end)

        map("n", "gr", function()
          vim.lsp.buf.references()
        end)

        map("n", "gds", function()
          vim.lsp.buf.document_symbol()
        end)

        map("n", "gws", function()
          vim.lsp.buf.workspace_symbol()
        end)

        map("n", "<leader>cl", function()
          vim.lsp.codelens.run()
        end)

        map("n", "<leader>sh", function()
          vim.lsp.buf.signature_help()
        end)

        map("n", "<leader>rn", function()
          vim.lsp.buf.rename()
        end)

        map("n", "<leader>f", function()
          vim.lsp.buf.format { async = true }
        end)

        map("n", "<leader>ca", function()
          vim.lsp.buf.code_action()
        end)

        map("n", "<leader>ws", function()
          require("metals").hover_worksheet()
        end)

        -- all workspace diagnostics
        map("n", "<leader>aa", function()
          vim.diagnostic.setqflist()
        end)

        -- all workspace errors
        map("n", "<leader>ae", function()
          vim.diagnostic.setqflist({ severity = "E" })
        end)

        -- all workspace warnings
        map("n", "<leader>aw", function()
          vim.diagnostic.setqflist({ severity = "W" })
        end)

        -- buffer diagnostics only
        map("n", "<leader>d", function()
          vim.diagnostic.setloclist()
        end)

        map("n", "[c", function()
          vim.diagnostic.goto_prev({ wrap = false })
        end)

        map("n", "]c", function()
          vim.diagnostic.goto_next({ wrap = false })
        end)
end


-- Autocmd that will actually be in charging of starting the whole thing
local nvim_metals_group = api.nvim_create_augroup("nvim-metals", { clear = true })
api.nvim_create_autocmd("FileType", {
  -- NOTE: You may or may not want java included here. You will need it if you
  -- want basic Java support but it may also conflict if you are using
  -- something like nvim-jdtls which also works on a java filetype autocmd.
  pattern = { "scala", "sbt", "java" },
  callback = function()
    require("metals").initialize_or_attach(metals_config)
  end,
  group = nvim_metals_group,
})

