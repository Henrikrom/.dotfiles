require("hbr")
require("config.lazy")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "aftershave" then
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
  end,
})

function _G.LspFormatProviders(bufnr)
  bufnr = bufnr or 0
  print("LSP formatting providers:")
  for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    local fmt = c.server_capabilities.documentFormattingProvider
    print(string.format(
      "  %-12s %s",
      c.name,
      fmt == vim.empty_dict() and "true" or tostring(fmt)
    ))
  end
end

