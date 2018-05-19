" JSON
" http://koturn.hatenablog.com/entry/2015/07/27/042519
" ウィンドウ操作
" http://cohama.hateblo.jp/entry/2013/09/28/220808
" http://d.hatena.ne.jp/kasei_san/20130714/p1
" http://d.hatena.ne.jp/yk5656/20131215/1387098750

" 自動保存前にで整形コマンド実行
" フォーカスが編集中のファイルに強制的に戻るので、
" エラー出力ウィンドウがどんどん増えてしまうので、
" 既にエラーウィンドウが存在する場合には消去する仕様に変更した
if executable('jq')
	function! s:jq(has_bang, ...) abort range
	execute 'silent' a:firstline ',' a:lastline '!jq' string(a:0 == 0 ? '.' : a:1)
	" ADD THIS
	let w = bufwinnr(bufnr('jq_error_window'))
	if w != -1
		execute w . 'wincmd w'
		q
	endif
	if !v:shell_error || a:has_bang
		return
	endif
	let error_lines = filter(getline('1', '$'), 'v:val =~# "^parse error: "')
	" 範囲指定している場合のために，行番号を置き換える
	let error_lines = map(error_lines, 'substitute(v:val, "line \\zs\\(\\d\\+\\)\\ze,", "\\=(submatch(1) + a:firstline - 1)", "")')
	let winheight = len(error_lines) > 10 ? 10 : len(error_lines)
	" カレントバッファがエラーメッセージになっているので，元に戻す
	undo
	" カレントバッファの下に新たにウィンドウを作り，エラーメッセージを表示するバッファを作成する
	" ADD THIS
	execute 'botright' winheight 'new jq_error_window'
	setlocal nobuflisted bufhidden=unload buftype=nofile
	call setline(1, error_lines)
	" エラーメッセージ用バッファのundo履歴を削除(エラーメッセージをundoで消去しないため)
	let save_undolevels = &l:undolevels
	setlocal undolevels=-1
	execute "normal! a \<BS>\<Esc>"
	setlocal nomodified
	let &l:undolevels = save_undolevels
	" エラーメッセージ用バッファは読み取り専用にしておく
	setlocal readonly
	endfunction
	command! -bar -bang -range=% -nargs=? Jq  <line1>,<line2>call s:jq(<bang>0, <f-args>)
endif
