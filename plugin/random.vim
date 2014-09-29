" vim: et sw=2 sts=2

" Plugin:      https://github.com/mhinz/vim-random
" Description: Jump to random tags.
" Maintainer:  Marco Hinz <http://github.com/mhinz>

if exists('g:loaded_random') || &compatible
  finish
endif
let g:loaded_random = 1

function! s:get_random_number(max) abort
  return str2nr(matchstr(reltimestr(reltime()), '\v\.@<=\d+')[1:]) % a:max
endfunction

function! s:get_internal_tags_file() abort
  let tags_file_path = $VIMRUNTIME .'/doc/tags'
  if !filereadable(tags_file_path)
    execute 'helptags' fnamemodify(tags_file_path, ':h')
  endif
  return tags_file_path
endfunction

function! s:get_external_tags_files() abort
  return filter(map(split(&runtimepath, ','), 'v:val . "doc/tags"'), 'filereadable(v:val)')
endfunction

function! s:get_random_tag(bang) abort
  if a:bang
    let tags_paths = s:get_external_tags_files()
    " Have at least one valid tags file.
    if empty(tags_paths)
      let tags_file_path = s:get_internal_tags_file()
    else
      let tags_file_path = tags_paths[s:get_random_number(len(tags_paths))]
    endif
  else
    let tags_file_path = s:get_internal_tags_file()
  endif

  let tags_file = readfile(tags_file_path)
  let tags_line = tags_file[s:get_random_number(len(tags_file))]
  let tag       = substitute(tags_line, '^\(.\{-}\)\t.*', '\=submatch(1)', '')

  return tag
endfunction

command! -nargs=0 -bang -bar Random execute 'help' s:get_random_tag(<bang>0)
