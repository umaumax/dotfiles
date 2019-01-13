if Doctor('gawk', 'gnu awk for comment_asm')
  if Doctor('comment_asm', 'comment for asm')
    command! AsmComment :%!cd $(dirname %) && comment_asm %
  endif
endif
