return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      -- Function to show LSP clients in brackets
      local function lsp_client_names()
        local clients = vim.lsp.get_active_clients()
        if next(clients) == nil then
          return 'No LSP'
        end
        local client_names = {}
        for _, client in ipairs(clients) do
          table.insert(client_names, client.name)
        end
        return '' .. table.concat(client_names, ', ') .. ''
      end

      -- Function to show the active Python virtual environment name
      local function venv_name()
        local venv = vim.env.VIRTUAL_ENV
        if venv then
          return '[' .. vim.fn.fnamemodify(venv, ':t') .. ']' -- Get only the env name (folder name)
        else
          return ''                                           -- Return empty if no venv is active
        end
      end

      -- Function to show active linters for the current filetype using nvim-lint
      local function linter_names()
        local ft = vim.bo.filetype
        local linters = require('lint').linters_by_ft[ft] or {}
        if #linters > 0 then
          return '' .. table.concat(linters, ', ') .. '' -- Show linters in square brackets
        else
          return 'No Linters'
        end
      end

      -- Function to show active formatter for the current filetype using formatter.nvim
      local function formatter_name()
        local ft = vim.bo.filetype
        local formatter_config = require("formatter.config").values.filetype[ft]

        if formatter_config and #formatter_config > 0 then
          -- Extract the executable name of the first active formatter
          local active_formatter = formatter_config[1]()
          if active_formatter.exe then
            return '' .. active_formatter.exe .. '' -- Show the formatter executable in square brackets
          end
        end
        return 'No Formatter'
      end

      local function status_info()
        local lsp_info = lsp_client_names()
        local linter_info = linter_names()
        local formatter_info = formatter_name()

        return '[' .. lsp_info .. ', ' .. linter_info .. ', ' .. formatter_info .. ']'
      end

      require("lualine").setup({
        options = {
          theme = "auto", -- Adjust to match your setup
          icons_enabled = true,
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          globalstatus = true,                -- Ensure lualine fills the entire width
          disabled_filetypes = { "NvimTree" } -- Disable NeoTree from appearing in lualine
        },
        sections = {
          lualine_a = { 'mode' }, -- Show 'NORMAL' or other modes in the bottom left
          lualine_b = { 'branch', { 'diff', colored = true, symbols = { added = ' ', modified = '~', removed = ' ' } }, venv_name }, -- Custom diff symbols
          lualine_c = {}, -- Empty to avoid showing filename here
          lualine_x = { 'diagnostics', status_info, 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {},
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
      })
    end,
  }
}
