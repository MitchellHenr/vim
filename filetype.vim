" A filetype detection file 
" (mostly just for org files)
if exists("did_load_filetypes")
  finish
endif
augroup filetypedetect
  au! BufRead,BufNewFile *.org	    setfiletype org
augroup END
