# vim autocmd

```
augroup include_guard
	autocmd!
	autocmd BufWinEnter *.h   command! -nargs=0 IncGuard call IncludeGuardC()
	autocmd BufWinEnter *.hpp command! -nargs=0 IncGuard call IncludeGuardC()
	autocmd BufWinEnter *.vim command! -nargs=0 IncGuard call IncludeGuardVim()
augroup END
```

[autocmd \- Vim日本語ドキュメント]( http://vim-jp.org/vimdoc-ja/autocmd.html#VimEnter )
```
読み込み
BufNewFile            存在しないファイルの編集を始めたとき
BufReadPre            新しいバッファの編集を始めたとき。ファイルを読み込む前
BufRead               新しいバッファの編集を始めたとき。
ファイルを読み込んだ後
BufReadPost           新しいバッファの編集を始めたとき。
ファイルを読み込んだ後
BufReadCmd            新しいバッファの編集を始める前 Cmd-event

FileReadPre           ":read"でファイルを読み込む前
FileReadPost          ":read"でファイルを読み込んだ後
FileReadCmd           ":read"でファイルを読み込む前 Cmd-event

FilterReadPre         フィルタコマンドでファイルを読み込む前
FilterReadPost        フィルタコマンドでファイルを読み込んだ後

StdinReadPre          標準入力からバッファに読み込む前
StdinReadPost         標準入力からバッファに読み込んだ後

書き込み
BufWrite              バッファ全体をファイルに書き込むとき
BufWritePre           バッファ全体をファイルに書き込むとき
BufWritePost          バッファ全体をファイルに書き込んだ後
BufWriteCmd           バッファ全体をファイルに書き込む前 Cmd-event

FileWritePre          バッファの一部をファイルに書き込むとき
FileWritePost         バッファの一部をファイルに書き込んだ後
FileWriteCmd          バッファの一部をファイルに書き込む前 Cmd-event

FileAppendPre         ファイルに追加するとき
FileAppendPost        ファイルに追加した後
FileAppendCmd         ファイルに追加する前 Cmd-event

FilterWritePre        フィルタコマンドやdiff用にファイルを書き込むとき
FilterWritePost       フィルタコマンドやdiff用にファイルを書き込んだ後

バッファ
BufAdd                バッファリストにバッファを追加した直後
BufCreate             バッファリストにバッファを追加した直後
BufDelete             バッファリストからバッファを削除する前
BufWipeout            完全にバッファを削除する前

BufFilePre            カレントバッファの名前を変える前
BufFilePost           カレントバッファの名前を変えた後

BufEnter              バッファに入った後
BufLeave              別のバッファへ移る前
BufWinEnter           バッファがウィンドウに表示された後
BufWinLeave           バッファがウィンドウから削除される前

BufUnload             バッファをアンロードする前
BufHidden             バッファが隠れバッファになった直後
BufNew                新規バッファを作成した直後

SwapExists            既存のスワップファイルを検出したとき

オプション
FileType              オプション'filetype'がセットされたとき
Syntax                オプション'syntax'がセットされたとき
EncodingChanged       オプション'encoding'が変更された後
TermChanged           オプション'term'が変更された後
OptionSet             オプションが設定された後

起動と終了
VimEnter              全ての起動処理が終わった後
GUIEnter              GUIの起動が成功した後
GUIFailed             GUIの起動が失敗した後
TermResponse          t_RVに対する端末の反応を受け取った後

QuitPre               :quit を使ったとき、本当に閉じるか決定する前
VimLeavePre           Vimを終了する前、viminfoファイルを書き出す前
VimLeave              Vimを終了する前、viminfoファイルを書き出した後

その他
FileChangedShell      編集を始めた後にファイルが変更されたことを検出したとき
FileChangedShellPost  編集を始めた後にファイルが変更されたことに対処した後
FileChangedRO         読み込み専用ファイルに対して最初に変更を加える前

ShellCmdPost          シェルコマンドを実行した後
ShellFilterPost       シェルコマンドでフィルタをかけた後

CmdUndefined          呼び出そうとしたユーザー定義コマンドが定義されていな
かったとき
FuncUndefined         呼び出そうとしたユーザー定義関数が定義されていなかった
とき
SpellFileMissing      スペリングファイルを使おうとしたが見つからなかったとき
SourcePre             Vim script を読み込む前
SourceCmd             Vim script を読み込む前 Cmd-event

VimResized            Vimのウィンドウサイズが変わったとき
FocusGained           Vimが入力フォーカスを得たとき
FocusLost             Vimが入力フォーカスを失ったとき
CursorHold            ユーザーが一定時間キーを押さなかったとき
CursorHoldI           挿入モードでユーザーが一定時間キーを押さなかったとき
CursorMoved           ノーマルモードでカーソルが移動したとき
CursorMovedI          挿入モードでカーソルが移動したとき

WinNew                新しいウィンドウを作成した後
TabNew                新しいタブページを作成した後
TabClosed             タブページを閉じた後
WinEnter              別のウィンドウに入った後
WinLeave              ウィンドウから離れる前
TabEnter              別のタブページに入った後
TabLeave              タブページから離れる前
CmdwinEnter           コマンドラインウィンドウに入った後
CmdwinLeave           コマンドラインウィンドウから離れる前

InsertEnter           挿入モードを開始したとき
InsertChange          挿入や置換モードで<Insert>をタイプしたとき
InsertLeave           挿入モードを抜けるとき
InsertCharPre         挿入モードで文字が入力されたとき、その文字が挿入される
前

TextChanged           ノーマルモードでテキストが変更された後
TextChangedI          挿入モードでテキストが変更された後

ColorScheme           カラースキームを読み込んだ後

RemoteReply           Vimサーバーからの返答を受け取ったとき

QuickFixCmdPre        QuickFixコマンドを実行する前
QuickFixCmdPost       QuickFixコマンドを実行した後

SessionLoadPost       セッションファイルを読み込んだ後

MenuPopup             ポップアップメニューを表示する直前
CompleteDone          挿入モード補完が完了したとき

User                  ":doautocmd"との組合せで使われる
```
