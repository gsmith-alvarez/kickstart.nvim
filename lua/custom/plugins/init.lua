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
      vim.list_extend(opts.ensure_installed, { 'markdown', 'markdown_inline', 'latex' })
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
      ui = { enable = true },
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
        converter = 'latex2text',
      },
      -- Hides the $ signs and marks when you aren't editing them
      anti_conceal = { enabled = true },
      render_modes = { 'n', 'c', 'i' },
    },
  },
}
