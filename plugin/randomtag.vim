" vim: et sw=2 sts=2

" Plugin:      https://github.com/mhinz/vim-randomtag
" Description: Jump to random tags.
" Maintainer:  Marco Hinz <http://github.com/mhinz>

if exists('g:loaded_randomtag') || &compatible
  finish
endif
let g:loaded_randomtag = 1

command! -nargs=0 -bang -bar Random execute 'help' randomtag#tag(<bang>0)
