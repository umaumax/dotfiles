let s:name_rules={
      \ 'python': [
      \   'モジュール(ファイル名)： module_name',
      \   'パッケージ: package_name',
      \   'クラス名: ClassName',
      \   'メソッド名: method_name',
      \   '例外: ExceptionName',
      \   '関数名: function_name',
      \   'グローバル定数：GLOBAL_CONSTANT_NAME',
      \   'グローバル変数：global_var_name',
      \   'インスタンス変数: instance_var_name',
      \   'ローカル変数：local_var_name',
      \ ],
      \ 'cpp': [
      \  'ファイル名:file_name.cpp',
      \  'クラス名,構造体,型alias,template引数: ClassName',
      \  '関数名(メソッド名): FunctionName',
      \  'グローバル定数：GLOBAL_CONSTANT_NAME',
      \  'ローカル変数：local_var_name',
      \  '名前空間: name_space',
      \  'private,protectedフィールド:field_',
      \ ],
      \ }
augroup naming_rule_group
  autocmd!
  autocmd FileType python command! NamingRule call PipeCommandResultToNewTab('echo "'.join(s:name_rules['python'],'\n').'"')
  autocmd FileType cpp    command! NamingRule call PipeCommandResultToNewTab('echo "'.join(s:name_rules['cpp'],'\n').'"')
augroup END
