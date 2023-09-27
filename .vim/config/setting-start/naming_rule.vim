let s:name_rules={
      \ 'python': [
      \   'モジュール(ファイル名): module_name',
      \   'パッケージ:             package_name',
      \   'クラス名:               ClassName',
      \   'メソッド名:             method_name',
      \   '例外:                   ExceptionName',
      \   '関数名:                 function_name',
      \   'グローバル定数:         GLOBAL_CONSTANT_NAME',
      \   'グローバル変数:         global_var_name',
      \   'インスタンス変数:       instance_var_name',
      \   'ローカル変数:           local_var_name',
      \   'URL: [styleguide | Style guides for Google\-originated open\-source projects]( http://google.github.io/styleguide/pyguide.html )',
      \ ],
      \ 'cpp': [
      \  'ファイル名:                           file_name.cpp',
      \  'クラス名,構造体,型alias,template引数: ClassName',
      \  '関数名(メソッド名):                   FunctionName',
      \  'グローバル定数:                       GLOBAL_CONSTANT_NAME',
      \  'ローカル変数:                         local_var_name',
      \  '名前空間:                             name_space',
      \  'private,protectedフィールド:          field_',
      \  'URL: [Google C++ Style Guide]( https://google.github.io/styleguide/cppguide.html )',
      \ ],
      \ 'rust': [
      \  'ファイル名(module):                     file_name.rs',
      \  'Types,struct,Traitsalias,Enum variants: Types',
      \  '関数名(メソッド名/Modules):             function_name',
      \  'static/const vars:                      SCREAMING_SNAKE_CASE',
      \  'ローカル変数:                           local_var_name',
      \  'URL: [Naming conventions]( https://doc.rust-lang.org/1.0.0/style/style/naming/README.html )',
      \ ],
      \ 'kotlin': [
      \  'ファイル名:                 FileName.kt',
      \  'クラス名,typealias:         ClassName( テストコードのみは`ensure everything works` or ensureEverythingWorks_onAndroid)',
      \  '関数名(メソッド名):         functionName',
      \  'グローバル定数:             GLOBAL_CONSTANT_NAME',
      \  'グローバル変数:             globalValue',
      \  'グローバルシングルトン変数: GlobalValue',
      \  'ローカル変数:               localVarName',
      \  'パッケージ名:               com.example.project(-や_は使用しない やむを得ない場合には、org.example.myProject)',
      \  'バッキングプロパティ:       _field',
      \  'URL: [Coding conventions | Kotlin Documentation]( https://kotlinlang.org/docs/coding-conventions.html )',
      \ ],
      \ }
augroup naming_rule_group
  autocmd!
  autocmd FileType python command! NamingRule call PipeCommandResultToNewTab('echo "'.join(s:name_rules['python'],'\n').'"')
  autocmd FileType cpp    command! NamingRule call PipeCommandResultToNewTab('echo "'.join(s:name_rules['cpp'],'\n').'"')
  autocmd FileType rust   command! NamingRule call PipeCommandResultToNewTab('echo "'.join(s:name_rules['rust'],'\n').'"')
  autocmd FileType kotlin command! NamingRule call PipeCommandResultToNewTab('echo "'.join(s:name_rules['kotlin'],'\n').'"')
augroup END
