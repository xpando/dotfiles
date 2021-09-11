if !exists('g:loaded_nvim_treesitter')
  echom "Not loaded treesitter"
  finish
endif

lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = {},
  },
  ensure_installed = {
    "bash",
    "c",
    "c_sharp",
    "clojure",
    "cmake",
    "cpp",
    "css",
    "dockerfile",
    "elixir",
    "erlang",
    "fish",
    "go",
    "graphql",
    "haskell",
    "html",
    "java",
    "javascript",
    "jsdoc",
    "json",
    "kotlin",
    "lua",
    "nix",
    "python",
    "regex",
    "rust",
    "scala",
    "scss",
    "swift",
    "toml",
    "typescript",
    "vim",
    "yaml"
  },
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.used_by = { "javascript", "typescript.tsx" }
EOF
