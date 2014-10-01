" vim: et sw=2 sts=2

" Plugin:      https://github.com/mhinz/vim-randomtag
" Description: Jump to random tags.
" Maintainer:  Marco Hinz <http://github.com/mhinz>

if exists('g:autoloaded_randomtag') || &compatible
  finish
endif

" Function: randomtag#tag {{{1
function! randomtag#tag(bang) abort
  let path = a:bang ? s:paths[s:randnum(s:npaths)] : s:default

  if !get(s:cache, path)
    let s:cache.path       = {}
    let s:cache.path.lines = readfile(path)
    let s:cache.path.len   = len(s:cache.path.lines)
  endif

  let line = s:cache.path.lines[s:randnum(s:cache.path.len)]
  let tag  = substitute(line, '^\(.\{-}\)\t.*', '\=submatch(1)', '')

  return tag
endfunction

" Function: s:randnum {{{1
function! s:randnum(max) abort
  return str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) % a:max
endfunction

" Function: s:default_tagfile {{{1
function! s:default_tagfile() abort
  let path = $VIMRUNTIME .'/doc/tags'
  let dir  = fnamemodify(path, ':h')

  if !filereadable(path)
    if filewritable(dir) == 2
      execute 'helptags' dir
    else
      echohl ErrorMsg
      echomsg 'Cannot write: '. path
      echohl NONE
      return
    endif
  endif

  return path
endfunction

" Values {{{1
let s:cache   = {}
let s:default = s:default_tagfile()
let s:paths   = filter(map(split(&runtimepath, ','), 'v:val . "doc/tags"'), 'filereadable(v:val)')
if empty(s:paths)
  let s:paths = [ s:default ]
endif
let s:npaths  = len(s:paths)

let g:autoloaded_randomtag = 1
