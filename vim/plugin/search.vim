" Custom grepprg for happy greping
if filereadable(".git") || isdirectory(".git")
  set grepprg=git\ rgrep
else
  set grepprg=grep\ -RIn\ --exclude-dir=build\ --exclude-dir=.git\ $*\ *
endif

command -nargs=+ -complete=file -bar -bang Grep execute 'silent grep<bang> <args>' | copen

" Custom search motions
" From http://www.vimbits.com/bits/153
nnoremap <silent> s :set operatorfunc=<SID>GrepMotion<CR>g@

function! s:GrepMotion(type) abort
  let save = @@
  execute "Grep! '" . shellescape(@@) . "'"
  let @@ = save
endfunction
