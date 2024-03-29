LazyPlug 'dense-analysis/ale'

let g:ale_disable_lsp = 1

let g:ale_sign_error = 'x'
let g:ale_sign_warning = '*'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_sign_column_always = 1

let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0
let g:ale_open_list = 0
let g:ale_keep_list_window_open = 0

let g:ale_linters =
      \ {
      \   'awk': ['gawk'],
      \   'python': ['pylint', 'autopep8', 'flake8'],
      \   'json': ['jsonlint'],
      \   'cmakelint': ['cmakelint'],
      \   'sh': ['shellcheck'],
      \   'vim': ['vint'],
      \   'cpp': ['cpplint','clang'],
      \   'rust': ['rls','cargo','analyzer'],
      \   'markdown': ['alex','vale'],
      \   'txt': ['textlint'],
      \   'make': ['checkmake'],
      \   'docker': ['hadolint'],
      \   'yaml': [],
      \ }
" NOTE: doesn't fit for me
" 'yaml': ['yamllint'],
" NOTE: maybe cause little spped down
" 'cpp': ['clangcheck', 'clangtidy'],
" NOTE: rustc make all lines with underline (I don't know the reason)
" 'rust': ['rustc']
" NOTE: check linter commands existence
for [key, linters] in items(g:ale_linters)
  for linter in linters
    if linter ==# 'analyzer'
      continue
    endif
    if !Doctor(linter, 'for '.key.' linter')
      call remove(g:ale_linters[key], linter)
    endif
  endfor
endfor
let g:ale_cpp_cpplint_options = '--linelength=160 --filter=-readability/todo,-legal/copyright,-whitespace/line_length,-build/header_guard'
let g:ale_cmake_cmakelint_options = '--filter=-linelength'
let g:ale_python_pylint_options = '--disable=C0111,C0301' " C0111:missing-docstring C0301:max-line-length
let g:ale_python_autopep8_options = '--ignore=E501' " E501:line too long
let g:ale_python_flake8_options = '--ignore=E501' " E501:line too long

let g:ale_rust_rls_toolchain = 'nightly'
let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')

let g:ale_set_highlights = 1

augroup ale_init_group
  autocmd!
  autocmd VimEnter,SourcePost * :highlight! ALEError    guifg=#C30500 guibg=#151515
  autocmd VimEnter,SourcePost * :highlight! ALEWarning  guifg=#ffd300 guibg=#333333
augroup END

nmap [ale] <Nop>
map <C-k> [ale]

nmap <silent> [ale]<C-P> <Plug>(ale_previous)
nmap <silent> [ale]<C-N> <Plug>(ale_next)

command! ALECursorMessage call ale#cursor#ShowCursorDetail()

" you can get message under cursor by below codes
" let buffer=bufnr('')
" let [info, loc] = ale#util#FindItemAtCursor(buffer)
" let format = ale#Var(buffer, 'echo_msg_format')
" let msg = ale#GetLocItemMessage(loc, ;format)
