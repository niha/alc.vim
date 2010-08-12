fun! s:SearchAlc(words)
  let comm = "ruby1.8 /home/m/.vim/plugin/alc.rb " . a:words
  echo system(comm)
endf

fun! s:SearchAlcCursor()
  let word = expand("<cword>")
  call s:SearchAlc(word)
endf

command! -nargs=* SearchAlc call s:SearchAlc(<q-args>)
command! -nargs=0 SearchAlcCursor call s:SearchAlcCursor()
