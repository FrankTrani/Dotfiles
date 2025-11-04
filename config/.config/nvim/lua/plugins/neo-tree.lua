return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Neo-tree" },
    { "<leader>fe", "<cmd>Neotree reveal<cr>", desc = "Neo-tree Reveal" },
  },
  opts = {
    close_if_last_window = true, -- auto-close when it’s the last window
    enable_git_status = true,
    enable_diagnostics = true,

    window = {
      width = 36,
      mappings = {
        ["H"] = "toggle_hidden", -- keep the live toggle
        ["<bs>"] = "navigate_up",
        ["."] = "set_root",
        ["R"] = "refresh",
      },
    },

    filesystem = {
      filtered_items = {
        visible = true, -- show filtered items but dim them
        hide_dotfiles = true, -- show .files
        hide_gitignored = false, -- set to true if you prefer .gitignore to hide stuff
        hide_ignored = false,
      },

      follow_current_file = {
        enabled = true, -- keep tree focused on the file you’re editing
        leave_dirs_open = false,
      },

      group_empty_dirs = true, -- compact long chains of empty folders
      hijack_netrw_behavior = "open_default", -- “:e .” opens neo-tree
      use_libuv_file_watcher = true, -- instant updates, no manual refresh
    },

    buffers = {
      follow_current_file = { enabled = true },
      group_empty_dirs = true,
    },
  },
}
