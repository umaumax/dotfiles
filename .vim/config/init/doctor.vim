" NOTE: doctor mode
" VIM_DOCTOR='on' vim

" NOTE: temporarily comment out
" \'yapf':'pip install yapf',
let s:doctor_map={
      \'ag':           'brew install ag || sudo apt install silversearcher-ag',
      \'algin':        'npm install -g align-yaml',
      \'autopep8':     'pip install autopep8',
      \'bash-language-server': 'npm i -g bash-language-server',
      \'clang':        'sudo apt-get install clang',
      \'clangd':       'brew install llvm || sudo apt-get install clang-tools',
      \'code':         'brew cask install visual-studio-code || [Running Visual Studio Code on Linux]( https://code.visualstudio.com/docs/setup/linux )',
      \'cmake-format': 'pip install https://github.com/umaumax/cmake_format/archive/master.tar.gz (pip install cmake_format)',
      \'cmakelint':    'pip install cmakelint',
      \'cmigemo':      'brew install cmigemo || sudo apt-get install cmigemo',
      \'clang-format': 'brew install clang-format || sudo apt0get install clang-format',
      \'cpplint':      'pip install cpplint',
      \'docker-langserver' : 'npm install -g dockerfile-language-server-nodejs',
      \'files':        'go get -u github.com/mattn/files',
      \'flake8':       'pip install flake8',
      \'git':          'brew install git || sudo apt-get install git',
      \'go':           'brew install go || sudo apt-get install go',
      \'gofmt':        'brew install go || sudo apt-get install go',
      \'golfix':       'go get -u github.com/umaumax/golfix',
      \'gopls':        'go get -u golang.org/x/tools/cmd/gopls',
      \'googler':      'brew install googler || sudo apt-get install googler',
      \'jsonlint':     'npm install -g jsonlint',
      \'jq':           'brew install jq || sudo apt -y install jq',
      \'look':         'maybe default command',
      \'npm':          'install node',
      \'pylint':       'pip install pylint',
      \'pyls':         'pip install python-language-server',
      \'racer':        'cargo +nightly install racer',
      \'rls':          'rustup component add rls rust-analysis rust-src',
      \'s':            'brew install s-search',
      \'tig':          'brew install tig || build tig your self ( https://github.com/jonas/tig/releases )',
      \'trans':        'brew install translate-shell || sudo apt-get install translate-shell',
      \'textlint':     'npm install -g textlint',
      \'shellcheck':   'sudo apt-get install shellcheck || brew install shellcheck',
      \'shfmt':        'go get -u mvdan.cc/sh/cmd/shfmt',
      \'vint':         'pip install vim-vint',
      \}
let s:doctor_logs=[]
let s:no_cmd_map={}
function! Doctor(cmd, description)
  if !has_key(s:doctor_map, a:cmd)
    let s:doctor_logs+=['Add ['.a:cmd.'] description for install']
  endif
  if executable(a:cmd)
    return 1
  endif
  if $VIM_DOCTOR != ''
    echohl ErrorMsg
    echomsg 'Require:[' . a:cmd . '] for [' . a:description . ']'
    echomsg '    ' . get(s:doctor_map, a:cmd, '[no description]')
    echohl None
  endif
  if !has_key(s:no_cmd_map,a:cmd)
    let s:no_cmd_map[a:cmd]=a:description
  else
    let s:no_cmd_map[a:cmd].=', '.a:description
  endif
  return 0
endfunction
function! s:print_doctor_result()
  if len(s:no_cmd_map)==0&&len(s:doctor_logs)==0
    echo '🍺You are healthy!'
    return
  endif
  for s:key in keys(s:no_cmd_map)
    let s:val = s:no_cmd_map[s:key]
    echohl ErrorMsg
    echomsg 'Require:[' . s:key . '] for [' . s:val . ']'
    echomsg '  [Install] '.get(s:doctor_map, s:key, '[no description]')
    echohl None
  endfor
  echohl ErrorMsg
  for log in s:doctor_logs
    echomsg log
  endfor
  echohl None
endfunction
command! Doctor call s:print_doctor_result()
