augroup MyFtDetect
  autocmd BufNewFile,BufRead *.rb
    \ let lines  = getline(1).getline(2).getline(3).getline(3).getline(4).getline(5)
    \|if lines =~? '[Ss]inatra'
    \|  setl filetype=ruby.sinatra
    \|endif
augroup END

" I'm learning more.
"
" autocmd BufReadPost *.rb
"   \ if b:current_syntax == 'ruby,sinatra'
"   \|  runtime! syntax/ruby-sinatra.vim
"   \|endif
"
" autocmd Syntax <amatch>
"   \ runtime! syntax/ruby-sinatra.vim
"

