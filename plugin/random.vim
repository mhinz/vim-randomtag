" vim: et sw=2 sts=2

" Plugin:      https://github.com/mhinz/vim-random
" Description: Jump to random tags.
" Maintainer:  Marco Hinz <http://github.com/mhinz>

if exists('g:loaded_random') || &compatible
  finish
endif
let g:loaded_random = 1

command! -nargs=0 -bang -bar Random execute 'help' random#tag(<bang>0)
