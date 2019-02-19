augroup naming_rule_group
  autocmd!
  autocmd FileType python command! NamingRule call PipeCommandResultToNewTab('echo "モジュール(ファイル名)： module_name\nパッケージ: package_name\nクラス名: ClassName\nメソッド名: method_name\n例外: ExceptionName\n関数名: function_name\nグローバル定数：GLOBAL_CONSTANT_NAME\nグローバル変数：global_var_name\nインスタンス変数: instance_var_name\nローカル変数：local_var_name"')
  autocmd FileType cpp command! NamingRule call PipeCommandResultToNewTab('echo "ファイル名:file_name.cpp\nクラス名,構造体,型alias,template引数: ClassName\n関数名(メソッド名): FunctionName\nグローバル定数：GLOBAL_CONSTANT_NAME\nローカル変数：local_var_name\n名前空間: name_space\nprivate,protectedフィールド:field_"')
augroup END
