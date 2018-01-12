set nocompatible

" Plugin management ----------------------------- {{{
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vundle itself
Plugin 'VundleVim/Vundle.vim'

" Others ----------------------------------------- {{{
Plugin 'chrisbra/csv.vim' " --------------------------------------------------- CSV filetype
Plugin 'dhruvasagar/vim-dotoo' " ---------------------------------------------- Todo manager
Plugin 'KeitaNakamura/neodark.vim' " ------------------------------------------ Color scheme
Plugin 'airblade/vim-gitgutter' " --------------------------------------------- Git
Plugin 'darfink/vim-plist' " -------------------------------------------------- Editing plists
Plugin 'easymotion/vim-easymotion' " ------------------------------------------ Easier movement
Plugin 'fholgado/minibufexpl.vim' " ------------------------------------------- Minibuffer
Plugin 'godlygeek/tabular' " -------------------------------------------------- Easy tabularization
Plugin 'indentpython.vim' " --------------------------------------------------- Python indentation
Plugin 'jaxbot/semantic-highlight.vim' " -------------------------------------- Semantic highlighting
Plugin 'jiangmiao/auto-pairs' " ----------------------------------------------- Pair delimiters
Plugin 'junegunn/limelight.vim' " --------------------------------------------- Paragraph highlighting
Plugin 'scrooloose/nerdtree' " ------------------------------------------------ File management
Plugin 'scrooloose/syntastic' " ----------------------------------------------- Syntax checking
Plugin 'sjl/gundo.vim' " ------------------------------------------------------ Undo
Plugin 'skalnik/vim-vroom' " -------------------------------------------------- Ruby testing
Plugin 'tpope/vim-commentary' " ----------------------------------------------- Easy commenting
Plugin 'tpope/vim-endwise' " -------------------------------------------------- Automatically close Ruby blocks
Plugin 'tpope/vim-fugitive' " ------------------------------------------------- Git
Plugin 'tpope/vim-surround' " ------------------------------------------------- Adding delimiters easily
Plugin 'vim-latex/vim-latex' " ------------------------------------------------ LaTeX support
" }}}

call vundle#end()
filetype plugin indent on
" }}}

" Settings ---------------------------------------------------------- {{{
let $PATH="/usr/local/bin/:".$PATH
colorscheme neodark
set autoindent " -------------------------------------------------------------- Copy indent from current line when starting a new line
set backspace=indent,eol,start " ---------------------------------------------- Allow backspace to work normally
set backupdir=$HOME/.vim/files/backup/ " -------------------------------------- Where vim creates backup files to
set backupext=-vimbackup " ---------------------------------------------------- File extension for backups
set backupskip= " ------------------------------------------------------------- List of file patterns to skip backups for
set cursorline " -------------------------------------------------------------- Highlight the line with the cursor on it
set directory=$HOME/.vim/files/swap/ " ---------------------------------------- Location(s) for the swap files
set expandtab " --------------------------------------------------------------- Turn tabs into spaces
set hidden " ------------------------------------------------------------------ Easier buffer switching
set hlsearch " ---------------------------------------------------------------- Highlight search resuts
set incsearch " --------------------------------------------------------------- Do incremental search
set laststatus=2 " ------------------------------------------------------------ When to show the statusline (always)
set lazyredraw " -------------------------------------------------------------- Don't redraw while executing non-typed commands
set number " ------------------------------------------------------------------ Shows line number
set path+=.,** " -------------------------------------------------------------- Allow :find to go recursively down the directory tree
set relativenumber " ---------------------------------------------------------- Relative line numbers
set report=0 " ---------------------------------------------------------------- Threshold for reporting number of liens changed
set scrolloff=3 " ------------------------------------------------------------- Leave 3 lines between cursor and edge of window
set shiftwidth=4 " ------------------------------------------------------------ Indent size
set showcmd " ----------------------------------------------------------------- Show the things I'm typing in normal mode
set showmode " ---------------------------------------------------------------- Show the mode I'm in
set splitbelow " -------------------------------------------------------------- Automatically open new splits below the current one
set splitright " -------------------------------------------------------------- Automatically open new splits to the right of the current one
set statusline=\ %t\ %m\ %{fugitive#statusline()}%=col:\ %c\ (%l/%L)\  " ------ Set my statusline
set synmaxcol=3000 " ---------------------------------------------------------- Maximum column to do syntax highlighting
set tabstop=4 " --------------------------------------------------------------- Number of spaces a tab gets converted to
set ttyfast " ----------------------------------------------------------------- Redraws quickly
set undodir=$HOME/.vim/files/undo/ " ------------------------------------------ Sets the directory for undo files
set updatecount=100 " --------------------------------------------------------- Write a swapfile after this many characters are written
set updatetime=250 " ---------------------------------------------------------- How many milliseconds to wait after typing to write the swapfile
set viminfo='100,n$HOME/.vim/files/info/viminfo " ----------------------------- How many marks to store, name of the viminfo file
set visualbell " -------------------------------------------------------------- Use only a visual bell (to turn it off)
set t_vb= " ------------------------------------------------------------------- No bell
set wildmenu " ---------------------------------------------------------------- Show matches in command line
set wildmode=list:longest " --------------------------------------------------- Show list of matches, complete till longest common string
set wrapscan " ---------------------------------------------------------------- Searches wrap around they end of a file
set writebackup " ------------------------------------------------------------- Make a temporary backup before writing a file
syntax on
" }}}

" Functions ------------------------------------------------- {{{
" To remove trailing whitespace
function! StripTrailingWhitespace()
    " Save cursor position
    let l:save = winsaveview()
    " Remove trailing whitespace
    %s/\s\+$//e
    " Move cursor to original position
    call winrestview(l:save)
endfunction
" }}}

" Syntax checking ---------------------------- {{{
let g:syntastic_python_checkers=["flake8"]
let g:syntastic_tex_checkers=["lacheck"]
" }}}

" Git things ------------------------------------- {{{
let g:gitgutter_realtime=1
let g:gitgutter_eager=1
" }}}

" LaTeX things ----------------- {{{
if !has("gui_running")
    let g:vimtex_compiler_latexmk = {'callback' : 0}
endif
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_TreatMacViewerAsUNIX=1
let g:Tex_ViewRule_pdf='open'
let g:tex_flavor='latex'
" }}}

" Keybindings and custom commands ----------------------------- {{{
" Easier un-highlighting
nnoremap <leader><space> :nohlsearch<enter>
" Make moving between panes easier
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" More reasonable yanking
nnoremap Y y$

" Because you keep holding shift down for too long
if exists(":W")==0
    command W w
endif
" }}}

" File-specific autocommands ---------------------------------{{{
"
" Things to do on opening Python files -----------------------{{{
augroup py_group
    autocmd!
    " Creates header
    autocmd BufNewFile *.py :execute ":normal! :source ~/.vim/snippets/python/setup.vim\r"
    " Indentation things
    autocmd BufNewFile,BufRead *.py :setlocal foldmethod=indent
                \ tabstop=4
    " Delete trailing whitespace
    autocmd BufWritePre *.py call StripTrailingWhitespace()
augroup END
" }}}
"
" Things to do on opening TeX files ------------------------- {{{
augroup tex_group
    autocmd!
    " Corrects indentation on all lines,
    " returns cursor to original position
    autocmd BufWritePre *.tex execute "normal! mqHmtgg=G'tzt`q"
    " Strips trailing whitespace
    autocmd BufWritePre *.tex call StripTrailingWhitespace()
    " Makes folding work
    autocmd Filetype tex :set foldmethod=expr
    autocmd BufWritePre,BufRead *.tex execute "normal! :mkview<cr><leader>rf:loadview"
    " autocmd Filetype tex :set foldexpr=
    " Spell check on
    autocmd Filetype tex :setlocal spell spelllang=en_us shiftwidth=2
    " Allow for special mappings
    autocmd Filetype tex :let b:AutoPairs={"{": "}", "(": ")", "$": "$"}
    " Set special characters
    autocmd BufNewFile,BufRead *.tex setlocal iskeyword+=:,_,.
augroup END
" }}}
"
" Things to do on opening vim files --------------------------------- {{{
augroup vim_group
    autocmd!
    autocmd BufNewFile,BufRead vimrc,*.vim :set foldmethod=marker
augroup END
" }}}

" Things to do on opening Ruby files ---------------------------{{{
augroup rb_group
    autocmd!
    " Add header
    autocmd BufNewFile *.rb :execute ":normal! :source ~/.vim/snippets/ruby/setup.vim\r"
    " Get folding set up
    autocmd BufNewFile,Bufread *.rb :setlocal foldmethod=syntax
    " Correct indentation
    autocmd BufWritePre *.rb :execute "normal! mqHmtgg=G'tzt`q"
augroup END
" }}}
" }}}

" Org things ------------------------- {{{
let g:dotoo#agenda#files=['/Users/hmmitche/Todo/school/*']
" }}}

" Cron things ----------------------------- {{{
if $VIM_CRONTAB == "true"
    set nobackup
    set nowritebackup
endif
" }}}
