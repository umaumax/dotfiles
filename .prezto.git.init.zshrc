#!/usr/bin/env zsh

# FYI: [prezto/git\-branch\-current at master · sorin\-ionescu/prezto]( https://github.com/sorin-ionescu/prezto/blob/master/modules/git/functions/git-branch-current )
# NOTE: below commands ared defined by prezto
# git-branch-current
# git-commit-lost
# git-dir
# git-hub-browse
# git-hub-shorten-url
# git-info
# git-root
# git-stash-clear-interactive
# git-stash-dropped
# git-stash-recover
# git-submodule-move
# git-submodule-remove

# NOTE: unalias default prezto git aliases
local _git_aliases=(gCa gCe gCl gCo gCt gFb gFbc gFbd gFbf gFbl gFbm gFbp gFbr gFbs gFbt gFbx gFf gFfc gFfd gFff gFfl gFfm gFfp gFfr gFfs gFft gFfx gFh gFhc gFhd gFhf gFhl gFhm gFhp gFhr gFhs gFht gFhx gFi gFl gFlc gFld gFlf gFll gFlm gFlp gFlr gFls gFlt gFlx gFs gFsc gFsd gFsf gFsl gFsm gFsp gFsr gFss gFst gFsx gR gRa gRb gRl gRm gRp gRs gRu gRx gS gSI gSa gSf gSi gSl gSm gSs gSu gSx gb gbD gbL gbM gbR gbS gbV gbX gba gbc gbd gbl gbm gbr gbs gbv gbx gc gcF gcO gcP gcR gcS gcSF gcSa gcSf gcSm gca gcam gcd gcf gcl gcm gco gcp gcr gcs gd gdc gdi gdk gdm gdu gdx gf gfa gfc gfcr gfm gfr gg ggL ggi ggl ggv ggw giA giD giI giR giX gia gid gii gir giu gix gl glb glc gld glg glo gm gmC gmF gma gmt gp gpA gpF gpa gpc gpf gpp gpt gr gra grc gri grs gs gsL gsS gsX gsa gsd gsl gsp gsr gss gsw gsx gwC gwD gwR gwS gwX gwc gwd gwr gws gwx)
for e in ${_git_aliases[@]}; do
	alias $e >/dev/null 2>&1 && unalias $e
done
