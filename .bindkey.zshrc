alias bindkey_events_list='bindkey -L'
alias bindkey_default_events_list='zsh -c "bindkey"'
function bindkey_default_all_events_list() {
	# NOTE: show only default events
	zsh -c 'zle -all'
	echo 1>&2 ''
	echo 1>&2 'If you want to know more, please access below page!'
	echo 1>&2 '[18 Zsh Line Editor \(zsh\)]( http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Standard-Widgets )'
}

#--------------------------------

function _insert_strs() {
	local n=${2:-$#1}
	local BUFFER_="${LBUFFER}$1${RBUFFER}"
	local CURSOR_=$CURSOR
	# NOTE: to avoid show unnecessary completion
	zle kill-buffer
	BUFFER="$BUFFER_"
	# NOTE: don't use below command because this cause mono color
	# 	CURSOR=$((CURSOR_ + 1))
	CURSOR=$((CURSOR_))
	for i in $(seq $n); do
		zle forward-char
	done
	zle -R -c # refresh
}
bindkey '"' _double_quotes && zle -N _double_quotes && function _double_quotes() { _insert_strs '""' 1; }
bindkey "'" _single_quotes && zle -N _single_quotes && function _single_quotes() { _insert_strs "''" 1; }
bindkey "\`" _exec_quotes && zle -N _exec_quotes && function _exec_quotes() { _insert_strs '``' 1; }
bindkey "^O" _exec2_quotes && zle -N _exec2_quotes && function _exec2_quotes() { _insert_strs '$()' 2; }
bindkey "(" _paren && zle -N _paren && function _paren() { _insert_strs '()' 1; }
bindkey "{" _brace && zle -N _brace && function _brace() { _insert_strs '{}' 1; }
bindkey "[" _bracket && zle -N _bracket && function _bracket() { _insert_strs '[]' 1; }

bindkey "^F" backward-delete-char
bindkey "^D" delete-char

bindkey "^H" backward-char
bindkey "^K" up-line-or-history
bindkey "^J" down-line-or-history
bindkey "^L" forward-char

# NOTE: Shift + arrow
bindkey '^[[1;2D' emacs-backward-word
bindkey '^[[1;2C' emacs-forward-word

bindkey '^X^A' backward-kill-line
bindkey '^X^E' kill-line

# F:fix
bindkey '^X^F' edit-command-line

function _set_only_LBUFFER() {
	if [[ -z "$BUFFER" ]]; then
		LBUFFER="$1"
	fi
}
function _insert_sudo() { _set_only_LBUFFER 'sudo '; }
zle -N _insert_sudo
bindkey "^S" _insert_sudo

function _insert_git() { _set_only_LBUFFER 'git '; }
zle -N _insert_git
bindkey "^G" _insert_git

function _insert_cd_home() { _set_only_LBUFFER 'cd ~/'; }
zle -N _insert_cd_home
bindkey "^X^H" _insert_cd_home

function _insert_run_secret_dotfile() { _set_only_LBUFFER './.'; }
zle -N _insert_run_secret_dotfile
bindkey "^X." _insert_run_secret_dotfile

function _insert_exec() { _set_only_LBUFFER './'; }
zle -N _insert_exec
bindkey "^X^E" _insert_exec

function _no_history_rm() { _set_only_LBUFFER ' rm '; }
zle -N _no_history_rm
bindkey "^X^R" _no_history_rm

function _copy_command() {
	echo "$BUFFER" | tr -d '\n' | c
	zle kill-whole-line
	zle -R -c # refresh
}
zle -N _copy_command
bindkey '^X^P' _copy_command
bindkey '^Y' _copy_command

function _paste_command() { _insert_strs "$(p)"; }
zle -N _paste_command
bindkey '^V' _paste_command

function _goto_middle_of_line() {
	CURSOR=$#BUFFER
	CURSOR=$((CURSOR / 2))
	zle -R -c # refresh
}
zle -N _goto_middle_of_line
bindkey '^X^M' _goto_middle_of_line

function _goto_line_n() {
	local n=${1:-1}
	CURSOR=$#BUFFER
	CURSOR=$((CURSOR / 11 * n))
	zle -R -c # refresh
}
zle -N _goto_line_1 && bindkey '^X1' _goto_line_1 && function _goto_line_1() { _goto_line_n 1; }
zle -N _goto_line_2 && bindkey '^X2' _goto_line_2 && function _goto_line_2() { _goto_line_n 2; }
zle -N _goto_line_3 && bindkey '^X3' _goto_line_3 && function _goto_line_3() { _goto_line_n 3; }
zle -N _goto_line_4 && bindkey '^X4' _goto_line_4 && function _goto_line_4() { _goto_line_n 4; }
zle -N _goto_line_5 && bindkey '^X5' _goto_line_5 && function _goto_line_5() { _goto_line_n 5; }
zle -N _goto_line_6 && bindkey '^X6' _goto_line_6 && function _goto_line_6() { _goto_line_n 6; }
zle -N _goto_line_7 && bindkey '^X7' _goto_line_7 && function _goto_line_7() { _goto_line_n 7; }
zle -N _goto_line_8 && bindkey '^X8' _goto_line_8 && function _goto_line_8() { _goto_line_n 8; }
zle -N _goto_line_9 && bindkey '^X9' _goto_line_9 && function _goto_line_9() { _goto_line_n 9; }
zle -N _goto_line_0 && bindkey '^X0' _goto_line_0 && function _goto_line_0() { _goto_line_n 10; }

# [最近のzshrcとその解説 \- mollifier delta blog]( http://mollifier.hatenablog.com/entry/20090502/p1 )
# quote previous word in single or double quote
autoload -U modify-current-argument
_quote-previous-word-in-single() {
	modify-current-argument '${(qq)${(Q)ARG}}'
	zle vi-forward-blank-word
}
zle -N _quote-previous-word-in-single
bindkey '^Xs' _quote-previous-word-in-single
bindkey '^X^S' _quote-previous-word-in-single

_quote-previous-word-in-double() {
	modify-current-argument '${(qqq)${(Q)ARG}}'
	zle vi-forward-blank-word
}
zle -N _quote-previous-word-in-double
bindkey '^Xd' _quote-previous-word-in-double
bindkey '^X^D' _quote-previous-word-in-double

function my-backward-delete-word() {
	local WORDCHARS=${WORDCHARS/\//}
	zle backward-delete-word
}
zle -N my-backward-delete-word
# shift+tab
bindkey '^[[Z' my-backward-delete-word

function _peco-select-history() {
	BUFFER="$(builtin history -nr 1 | command peco | tr -d '\n')"
	CURSOR=$#BUFFER
	zle -R -c # refresh
}
zle -N _peco-select-history
bindkey '^X^P' _peco-select-history

function peco-select-history() {
	local tac
	if which tac >/dev/null; then
		tac="tac"
	else
		tac="tail -r"
	fi
	local query="$LBUFFER"
	local opts=("--query" "$LBUFFER")
	[[ -z $query ]] && local opts=()
	BUFFER=$(builtin history -nr 1 |
		eval $tac |
		command peco "${opts[@]}")
	CURSOR=$#BUFFER
	zle clear-screen
}
zle -N peco-select-history
bindkey '^X^O' peco-select-history

# [Vimの生産性を高める12の方法 \| POSTD]( https://postd.cc/how-to-boost-your-vim-productivity/ )
# Ctrl-Zを使ってVimにスイッチバックする
# vim -> C-z -> zsh -> Ctrl-z or fg
function fancy-ctrl-z() {
	if [[ $#BUFFER -eq 0 ]]; then
		BUFFER="fg"
		zle accept-line
	else
		zle push-input
		zle clear-screen
	fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z
