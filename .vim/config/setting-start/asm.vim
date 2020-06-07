if Doctor('gawk', 'gnu awk for comment_asm')
  if Doctor('comment_asm', 'comment for asm')
    command! AsmComment :%!cd $(dirname %) && comment_asm %
  endif
endif

" count '%' or '$', or use 'file' command
" output is below
" gas.s: assembler source text, ASCII text
" nasm.s: ASCII text
function! s:is_asm_type_gas() abort
  let count=0
  let lines=getline(1, '$')
  for line in lines
    if stridx(line, '%')>=0 || stridx(line, '$')>=0
      let count+=1
    endif
  endfor
  let ratio=(0.0+count)/len(lines)
  let gas_ratio_th=0.20
  return ratio >= gas_ratio_th
endfunction

function! s:set_asm_type_auto() abort
  let &ft= s:is_asm_type_gas() ? 'gas' : 'nasm'
endfunction

autocmd BufReadPost *.s call s:set_asm_type_auto()
autocmd BufWritePre *.s call s:set_asm_type_auto()
