autocmd BufNewFile,BufRead *.txt call s:set_help_settings()

function! s:set_help_settings()
  if expand('%:p')  =~ 'doc/.*\.txt$'
    setl filetype=help
  endif
endfunction
