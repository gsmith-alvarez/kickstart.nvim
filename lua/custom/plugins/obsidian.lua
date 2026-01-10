-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      -- Ensure ensure_installed is a table to avoid nil errors during merge
      if type(opts.ensure_installed) ~= 'table' then
        opts.ensure_installed = {}
      end
      -- Append your Obsidian-specific parsers to the existing list
      vim.list_extend(opts.ensure_installed, { 'markdown', 'markdown_inline', 'latex', 'html' })
    end,
    config = function(_, opts)
      require('nvim-treesitter.config').setup(opts)
      vim.api.nvim_create_autocmd({ 'FileType' }, {
        pattern = 'markdown',
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
  { -- 2. Obsidian: The "Brain"
    'epwalsh/obsidian.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      workspaces = {
        {
          name = 'Obsidian',
          path = '/home/fall-of-baghdad/Documents/Obsidian/',
        },
      },
      -- This ensures links look like [[this]] instead of [this](this.md)
      ui = { enable = false },
    },
  },

  { -- 3. Image Paste: The "Scanner"
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    opts = {
      default = {
        -- Relative to the current file, just like Obsidian likes it
        dir_path = '500-Resources/Attachments',
        use_absolute_path = false,
        prompt_for_file_name = false,
        -- This template makes the image work in BOTH Neovim and Obsidian
        template = '![[$FILE_NAME]]',
      },
    },
    keys = {
      { '<leader>p', '<cmd>PasteImage<cr>', desc = 'Paste image from clipboard' },
    },
  },

  { -- 4. Render Markdown: The "Display"
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    opts = {
      latex = {
        enabled = true,
        render_modes = false,
        converter = { 'utftex', 'latex2text' },
        highlight = 'RenderMarkdownMath',
        style = 'expr',
        position = 'center',
        top_pad = 0,
        bottom_pad = 0,
      },
      -- Hides the $ signs and marks when you aren't editing them
      anti_conceal = { enabled = true },
    },

    -- 5. Markdown Linting: The "Auditor" (NEW)
    {
      'mfussenegger/nvim-lint',
      event = { 'BufReadPre', 'BufNewFile' },
      config = function()
        local lint = require 'lint'
        -- Setup the linter
        lint.linters_by_ft = lint.linters_by_ft or {}
        lint.linters_by_ft['markdown'] = { 'markdownlint' }

        -- Configure markdownlint to find your .markdownlint.json
        local markdownlint = lint.linters.markdownlint
        markdownlint.args = {
          '--config',
          function()
            -- Searches upward for your config in the Obsidian Vault
            local config = vim.fs.find({ '.markdownlint.json' }, { upward = true, path = vim.fn.expand '%:p:h' })[1]
            return config or '.markdownlint.json'
          end,
          '--',
        }

        -- Create autocommand for markdown linting
        local lint_augroup = vim.api.nvim_create_augroup('markdown_lint', { clear = true })
        vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
          group = lint_augroup,
          callback = function()
            if vim.bo.filetype == 'markdown' and vim.bo.modifiable then
              lint.try_lint()
            end
          end,
        })
      end,
    },
  },
}
