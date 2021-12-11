" NOTE: this treesitter setting must be called after plug#end()
if !&rtp =~ 'nvim-treesitter'
  finish
endif

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

-- lukas-reineke/indent-blankline.nvim
vim.opt.list = true
vim.opt.listchars:append("space: ")
vim.opt.listchars:append("eol:↲")

vim.opt.termguicolors = true
vim.cmd [[highlight IndentBlanklineIndent1 guifg=#703C35 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guifg=#75603B gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent3 guifg=#486339 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent4 guifg=#265662 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent5 guifg=#315F7F gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent6 guifg=#66386D gui=nocombine]]

vim.cmd [[highlight IndentBlanklineContextIndent1 guifg=#E06C75 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineContextIndent2 guifg=#E5C07B gui=nocombine]]
vim.cmd [[highlight IndentBlanklineContextIndent3 guifg=#98C379 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineContextIndent4 guifg=#56B6C2 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineContextIndent5 guifg=#61AFEF gui=nocombine]]
vim.cmd [[highlight IndentBlanklineContextIndent6 guifg=#C678DD gui=nocombine]]

require("indent_blankline").setup {
  char = "|",
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = true,
  char_highlight_list = {
    "IndentBlanklineIndent1",
    "IndentBlanklineIndent2",
    "IndentBlanklineIndent3",
    "IndentBlanklineIndent4",
    "IndentBlanklineIndent5",
    "IndentBlanklineIndent6",
  },
  context_patterns={
    "class",
    "function",
    "method",
    "if",
    "for",
    "loop",
    "let",
    "while",
  },
  context_highlight_list={
    "IndentBlanklineContextIndent1",
    "IndentBlanklineContextIndent2",
    "IndentBlanklineContextIndent3",
    "IndentBlanklineContextIndent4",
    "IndentBlanklineContextIndent5",
    "IndentBlanklineContextIndent6",
  },
}

EOF

function! ShowPopup(title, lines)
  let b:title=a:title
  " You have to use g: because of creating new window buffer
  let g:lines=a:lines

  lua <<EOF
  local Popup = require("nui.popup")
  local event = require("nui.utils.autocmd").event

  local popup = Popup({
enter = true,
focusable = true,
border = {
  text = {
    top = vim.b.title,
    top_align = "center",
    },
  style = { "#", "-", "#", "|", "#", "-", "#", "|" },
  highlight = 'FloatBorder',
  },
position = "50%",
size = {
  width = "90%",
  height = "30%",
  },
buf_options = {
  modifiable = true,
  readonly = false,
  },
})

-- mount/open the component
popup:mount()

-- unmount component when cursor leaves buffer
popup:on(event.BufLeave, function()
popup:unmount()
end)

-- set content
vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, vim.g.lines)
vim.cmd('set readonly')
vim.cmd('if exists("*markology#MarkologyDisable") | call markology#MarkologyDisable() | endif')
EOF
endfunction
