" vim: et sw=2 sts=2

" Plugin:      https://github.com/mhinz/vim-random
" Description: Jump to random tags.
" Maintainer:  Marco Hinz <http://github.com/mhinz>

if exists('g:loaded_random') || &compatible
  finish
endif
let g:loaded_random = 1

function! s:get_random_tag() abort
  let tagssave = &tags
  let &tags    = $VIMRUNTIME .'/doc/tags'

  if !filereadable(&tags)
    execute 'helptags' fnamemodify(&tags, ':h')
  endif

  let tagfile  = readfile(&tags)
  let nlines   = len(tagfile)
  let line     = str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) % nlines
  let tagline  = tagfile[line]
  let tag      = substitute(tagline, '^\(.\{-}\)\t.*', '\=submatch(1)', '')
  let &tags    = tagssave

  return tag
endfunction

function! s:jump_to_random_tag() abort
  execute 'help' s:get_random_tag()
endfunction

command! -nargs=0 -bar Random call s:jump_to_random_tag()
