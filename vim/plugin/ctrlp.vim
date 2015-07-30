" Concatenate the directory into the ls-files command
function! GitListCommand(directory)
  return "git ls-files " . a:directory . " --cached --exclude-standard --others"
endfunction

" Command for searching folders even if they
" aren't tracked with git
function! SearchCommand()
  let l:command = ""
  if isdirectory(".git")
    let l:command = GitListCommand(".")
  endif

  if strlen(l:command) < 1
    let l:output = system("git rev-parse --show-toplevel")
    if v:shell_error == 0
      let l:output = substitute(l:output, "\\n", "", "")
      let l:command = GitListCommand(l:output)
    else
      let l:command = "find * -type f -o -type l"
    endif
  endif

  return l:command
endfunction

function! s:EscapeFilePath(path)
  return substitute(a:path, ' ', '\\ ', 'g')
endfunction

function! FuzzyFindCommand(vimCommand)
  try
    execute ':call fzf#run({"sink": "' . a:vimCommand . '", "source": "' . SearchCommand() . '"})'
  catch /Vim:Interrupt/
    " Catch the ^C so that the redraw happens
    redraw!
    return
  endtry
endfunction

nnoremap <C-p>  :call FuzzyFindCommand("edit")<cr>
nnoremap <C-p>e :call FuzzyFindCommand("edit")<cr>
nnoremap <C-p>t :call FuzzyFindCommand("tabnew")<cr>
nnoremap <C-p>v :call FuzzyFindCommand("vsplit")<cr>
nnoremap <C-p>s :call FuzzyFindCommand("split")<cr>
