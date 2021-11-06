lua <<EOF
require'nvim-treesitter.configs'.setup {
ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
ignore_install = {"php", "tlaplus"}, -- List of parsers to ignore installing
highlight = {
enable = true,              -- false will disable the whole extension
disable = {},  -- list of language that will be disabled
-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
-- Using this option may slow down your editor, and you may see some duplicate highlights.
-- Instead of true it can also be a list of languages
additional_vim_regex_highlighting = false,
},
rainbow = {
enable = true,
extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
max_file_lines = nil, -- Do not enable for files with more than n lines, int
-- colors = {}, -- table of hex strings
-- termcolors = {} -- table of colour name strings
},
indent = {
enable = true,
}
}

require('spellsitter').setup {
  -- Whether enabled, can be a list of filetypes, e.g. {'python', 'lua'}
enable = true,

-- Highlight to use for bad spellings
hl = 'SpellBad',

-- Spellchecker to use. values:
-- * vimfn: built-in spell checker using vim.fn.spellbadword()
-- * ffi: built-in spell checker using the FFI to access the
--   internal spell_check() function
spellchecker = 'vimfn',
}
EOF
