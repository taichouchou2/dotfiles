" Vim Syntax File
" Language:     Gemspec for Bundler, Ruby
" Creator:      Tatsuhiro Ujihisa <ujihisa at gmail com>
" Maintainer:   Iain Hecker <iain at iain nl>
" Last Change:  2010 Sep 05
" Filenames:    berksfile

" It's basically just Ruby
runtime syntax/ruby.vim

syntax case match

" Normal oneliners
syntax keyword berksfileKeywords cookbook
highlight link berksfileKeywords Function

" Things that accept a block (because that will create a clearer color
" distinction)
syntax keyword berksfileBlockKeywords site
highlight link berksfileBlockKeywords Keyword

" Old berksfile Syntax
" syntax keyword berksfileDeprecated only except disable_rubygems disable_system_gems clear_sources bundle_path bin_path
" highlight link berksfileDeprecated Error

" Make commenting plugin work
if exists("*TCommentDefineType")
  call TCommentDefineType('berksfile', '# %s')
endif
