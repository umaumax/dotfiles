#!/usr/bin/env bash
mkdir ~/.git-logs
(cd ~/.git-logs/vim-go && git log --pretty=oneline --abbrev-commit | sed 's/^[0-9a-zA-Z]* //g' | sort -f >../vim-go.log)
(cd ~/.git-logs/vim && git log --pretty=oneline --abbrev-commit | sed 's/^[0-9a-zA-Z]* //g' | sort -f >../vim.log)
