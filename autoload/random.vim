" vim: et sw=2 sts=2

" Plugin:      https://github.com/mhinz/vim-random
" Description: Jump to random tags.
" Maintainer:  Marco Hinz <http://github.com/mhinz>

if exists('g:autoloaded_random') || &compatible
  finish
endif
let g:autoloaded_random = 1

function! random#tag(bang) abort
  if a:bang
    let paths = s:external_tagfiles()
    let path  = empty(paths) ? s:default_tagfile() : paths[s:randnum(len(paths))]
  else
    let path  = s:default_tagfile()
  endif

  let lines = readfile(path)
  let line  = lines[s:randnum(len(lines))]

  return substitute(line, '^\(.\{-}\)\t.*', '\=submatch(1)', '')
endfunction

function! s:randnum(max) abort
  return str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) % a:max
endfunction

function! s:default_tagfile() abort
  let path = $VIMRUNTIME .'/doc/tags'
  let dir  = fnamemodify(path, ':h')

  if !filereadable(path) && filewritable(dir) == 2
    execute 'helptags' dir
  endif

  return path
endfunction

function! s:external_tagfiles() abort
  return filter(map(split(&runtimepath, ','), 'v:val . "doc/tags"'), 'filereadable(v:val)')
endfunction
