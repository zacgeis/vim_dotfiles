set nocompatible
syntax on

if &shell == "/usr/bin/sudosh"
  set shell=/bin/bash
endif

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim', {'commit': '990834ab6cb86961e61c55a8e012eb542ceff10e'}
Plug 'chriskempson/base16-vim'
Plug 'flazz/vim-colorschemes'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
call plug#end()

compiler ruby

set hlsearch
set number
set showmatch
set incsearch
set background=dark
set hidden
set backspace=indent,eol,start
set ruler
set wrap
set dir=/tmp//
set scrolloff=5
set nofoldenable
colorscheme Tomorrow-Night

set textwidth=0 nosmartindent tabstop=2 shiftwidth=2 softtabstop=2 expandtab

set ignorecase
set smartcase

set wildignore+=*.pyc,*.o,*.class

let g:ctrlp_working_path_mode = 'rw'
" let g:ctrlp_custom_ignore = 'node_modules\\|_build\\|deps\\|elm-stuff'

let html_use_css=1
let html_number_lines=0
let html_no_pre=1

let g:rubycomplete_buffer_loading = 1

let g:no_html_toolbar = 'yes'

let coffee_no_trailing_space_error = 1

let go_highlight_trailing_whitespace_error = 0

" let g:ctrlp_match_window = "top,order:ttb"
"
" let g:ctrlp_prompt_mappings = {
"   \\ 'PrtSelectMove("j")':   ['<c-n>', '<down>'],
"   \\ 'PrtSelectMove("k")':   ['<c-p>','<c-k>', '<up>'],
"   \\ 'PrtHistory(-1)':       ['<c-j>'],
"   \\ 'PrtHistory(1)':        ['<c-k>'],
" \\ }

autocmd FileType php setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType tex setlocal textwidth=80
autocmd Filetype go setlocal noexpandtab
autocmd Filetype scheme setlocal expandtab
autocmd FileType rust setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd BufNewFile,BufRead *.txt setlocal textwidth=80
autocmd BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown textwidth=80

imap <C-L> <SPACE>=><SPACE>
map <silent> <LocalLeader>rt :!ctags -R --exclude=".git" --exclude="log" --exclude="tmp" --exclude="db" --exclude="pkg" --exclude="deps" --exclude="_build" --extra=+f .<CR>
" map <silent> <C-p> :Files<CR>
map <C-p> :e **/*
map <silent> <leader>ff :Files<CR>
map <silent> <leader>fb :Buffers<CR>
map <silent> <LocalLeader>nh :nohls<CR>
map <silent> <LocalLeader>bd :bufdo :bd<CR>
map <silent> <LocalLeader>cc :TComment<CR>

map <silent> <LocalLeader>rl :wa<CR> :VimuxRunLastCommand<CR>
map <silent> <LocalLeader>vp :wa<CR> :VimuxPromptCommand<CR>

nnoremap <silent> k gk
nnoremap <silent> j gj
nnoremap <silent> Y y$

if version >= 700
  map <silent> <LocalLeader>sc :setlocal spell! spelllang=en_us<CR>
endif

" Highlight trailing whitespace
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd BufRead,InsertLeave * match ExtraWhitespace /\s\+$/

" Remove trailing whitespace
autocmd FileType * autocmd BufWritePre <buffer> :%s/\s\+$//e

" Set up highlight group & retain through colorscheme changes
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
map <silent> <LocalLeader>ws :highlight clear ExtraWhitespace<CR>

set laststatus=2
set statusline=
set statusline+=%<\                       " cut at start
set statusline+=%2*[%n%H%M%R%W]%*\        " buffer number, and flags
set statusline+=%-40f\                    " relative path
set statusline+=%=                        " seperate between right- and left-aligned
set statusline+=%1*%y%*%*\                " file type
set statusline+=%10(L(%l/%L)%)\           " line
set statusline+=%2(C(%v/125)%)\           " column
set statusline+=%P                        " percentage of file

if version >= 703
  set undodir=~/.vim/undodir
  set undofile
  set undoreload=10000 "maximum number lines to save for undo on a buffer reload
endif
set undolevels=1000 "maximum number of changes that can be undone

" for :e **/* autocomplete display
set wildmenu

" Shortcut for new tabs
nmap gn :tabnew<cr>

" Prevent automatic comment insertion on newlines
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Remove trailing whitespace
autocmd FileType * autocmd BufWritePre <buffer> :%s/\s\+$//e

" Quickfix grep maps
nnoremap gw :grep! -rI <cword> .<CR><CR>:cw<CR>
nnoremap ge :ccl<CR>

" Quick cycle through buffers
nnoremap <Tab> :bnext <CR>
nnoremap <S-Tab> :bprevious<CR>

" NerdTree
map <silent> <LocalLeader>nt :NERDTreeToggle<CR>
map <silent> <LocalLeader>nf :NERDTreeFind<CR>

" Disable escape
inoremap <Esc> <Nop>
vnoremap <Esc> <Nop>

" Fix Ctrl-C block insert mode
inoremap <C-c> <Esc>
vnoremap <C-c> <Esc>

" Chicken Scheme

nmap <silent> <leader>sf :call Scheme_eval_defun()<cr>
nmap <silent> <leader>sb :call Scheme_send_sexp("(load \"" . expand("%:p") . "\")\n")<cr>
nmap <silent> <leader>se :call Scheme_new()<cr>
nmap <silent> <leader>sq :call Scheme_quit()<cr>

function! Scheme_eval_defun()
    let pos = getpos('.')
    silent! exec "normal! 99[(yab"
    call Scheme_send_sexp(@")
    call setpos('.', pos)
endfun

function! Scheme_send_sexp(sexp)
    let ss = escape(a:sexp, '\"')
    call system("tmux send-keys -t 1 \"" . ss . "\n\"")
endfun

function! Scheme_new()
  call system("tmux send-keys -t 1 C-c C-l csi C-m")
endfun

function! Scheme_quit()
  call system("tmux send-keys -t 1 C-c C-d C-l")
endfun
