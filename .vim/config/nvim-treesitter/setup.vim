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

local fn = require('fine-cmdline').fn
require('fine-cmdline').setup({
cmdline = {
enable_keymaps = true
},
  popup = {
    position = {
      row = '10%',
      col = '50%',
      },
    size = {
      width = '60%',
      height = 1
      },
    border = {
      text = {
        top = "Popup Command Line",
        top_align = "center",
        },
      -- style = 'none',
      style = { "#", "-", "#", "|", "#", "-", "#", "|" },
      highlight = 'FloatBorder',
      },
    win_options = {
      winhighlight = 'Normal:Normal',
      },
    },
  hooks = {
    before_mount = function(input)
    input.input_props.prompt = ':'
  end,
  after_mount = function(input)
end,
set_keymaps = function(imap, feedkeys)
imap('<Up>', fn.complete_or_next_item)
    end
    }
  })
EOF
