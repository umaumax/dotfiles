## Ensure that a non-login, non-interactive shell has a defined environment.
#if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
#  source "${ZDOTDIR:-$HOME}/.zprofile"
#fi

[[ $ZSH_NAME == zsh ]] && setopt all_export

cmdcheck() { type > /dev/null 2>&1 "$1"; }

alias ls='ls -G'
alias lsal='ls -alG'
alias lat='ls -altrG'
alias history='history 1'
alias h='history'
alias hgrep='h | grep'

################
#### Ubuntu ####
################
if cmdcheck xsel; then
	alias pbcopy='xsel --clipboard --input'
	alias pbpaste='xsel --clipboard --output'
fi
if [[ -n $_Ubuntu ]]; then
	alias pbcopy='xsel --clipboard --input'
	alias pbpaste='xsel --clipboard --output'
fi

if cmdcheck peco; then
	# peco copy
	alias pc='peco | c'
	alias pe='peco'
fi

if `cmdcheck pbcopy && cmdcheck pbpaste`; then
	if cmdcheck nkf ; then
		alias c='nkf -w | pbcopy'
		alias p='pbpaste | nkf -w'
		alias udec='nkf -w --url-input'
		alias uenc='nkf -WwMQ | tr = %'
		alias overwrite-utf8='nkf -w --overwrite'
	else
		alias c='pbcopy'
		alias p='pbpaste'
	fi
	# 改行コードなし
	# o: one
	alias oc="tr -d '\n' | c"
	alias op="p | tr -d '\n'"
fi

alias t='touch'

[[ $ZSH_NAME == zsh ]] && unsetopt all_export
