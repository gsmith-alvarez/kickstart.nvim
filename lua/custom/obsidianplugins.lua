return {
  -- 1. Obsidian integration
  {
    'epwalsh/obsidian.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      workspaces = {
        {
          name = 'Obsidian',
          path = '/home/fall-of-baghdad/Documents/Obsidian/',
        },
      },
    },
  },

  -- 2. The screenshot "Magic"
  {
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    opts = {
      default = {
        dir_path = '/home/fall-of-baghdad/Documents/Obsidian/500-Resources/Attachments/', -- Where images are saved
        prompt_for_file_name = false,
      },
    },
    keys = {
      { '<leader>p', '<cmd>PasteImage<cr>', desc = 'Paste image from clipboard' },
    },
  },
  -- 3. Latex Render
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    opts = {
      latex = {
        enabled = true,
        -- This uses a "converter" to make the math look better in the terminal
        converter = 'latex2text',
      },
      -- This ensures rendering stays on even while you are typing
      render_modes = { 'n', 'c', 'i' },
    },
  },
}
