set nocompatible
syntax on

if &shell == "/usr/bin/sudosh"
  set shell=/bin/bash
endif

call plug#begin('~/.vim/plugged')
Plug 'sheerun/vim-polyglot'
Plug 'w0rp/ale'
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'jlanzarotta/bufexplorer'
Plug 'flazz/vim-colorschemes'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
call plug#end()

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

let g:ale_set_highlights = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_linters_explicit = 1
let g:ale_list_window_size = 3
let g:ale_linters = {
      \   'rust': ['rustc', 'cargo'],
      \   'go': ['go build', 'goimports'],
      \   'ruby': ['ruby'],
      \   'c': ['gcc'],
      \   'cpp': ['gcc'],
      \}

let html_use_css=1
let html_number_lines=0
let html_no_pre=1

let g:rubycomplete_buffer_loading = 1

let g:no_html_toolbar = 'yes'

let coffee_no_trailing_space_error = 1

let go_highlight_trailing_whitespace_error = 0

autocmd FileType php setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType tex setlocal textwidth=80
autocmd Filetype go setlocal noexpandtab
autocmd Filetype scheme setlocal expandtab
autocmd FileType rust setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd BufNewFile,BufRead *.txt setlocal textwidth=80
autocmd BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown textwidth=80

imap <C-p> ->
map <silent> <C-p> :Files<CR>
map <silent> <LocalLeader>rt :!echo "Generating ctags" && ctags -R --exclude=".git" --exclude="log" --exclude="tmp" --exclude="db" --exclude="pkg" --exclude="deps" --exclude="_build" --extra=+f --fields=+l --langmap=c:.c.h --langmap=c++:.c++.c.cc.cpp.h .<CR>
map <silent> <LocalLeader>ff :Files<CR>
map <silent> <LocalLeader>fb :Buffers<CR>
map <silent> <LocalLeader>ft :Tags<CR>
map <silent> <LocalLeader>nh :nohls<CR>
map <silent> <LocalLeader>bd :bufdo :bd<CR>
map <silent> <LocalLeader>cc :TComment<CR>
map <silent> <LocalLeader>sc :setlocal spell! spelllang=en_us<CR>
" set compiler and makeprg with make
map <LocalLeader>m :make<CR>

function! GrepPattern(pattern)
  cgetexpr system("grep -nIr --exclude-dir=.* --exclude-dir=*build* --exclude=tags --exclude=.* '" . a:pattern . "'")
  cwin
endfunction
function! GrepWord()
  call GrepPattern(expand("<cword>"))
endfunction
function! GrepPrompt()
  let l:pattern = input("Pattern: ")
  call GrepPattern(l:pattern)
endfunction
command! -nargs=0 GrepWord :call GrepWord()
map <silent> <LocalLeader>gw :GrepWord<CR>
command! -nargs=0 GrepPrompt :call GrepPrompt()
map <silent> <LocalLeader>gp :GrepPrompt<CR>

" function! TagDefinition()
"   let ind = 0
"   let tags = taglist(expand("<cword>"))
"   let signatures = []
"   for entry in tags
"     let cmd = entry["cmd"]
"     let file = entry["filename"]
"     let cmdClean = substitute(strpart(cmd, 2, strlen(cmd) - 4), '^\s*\(.\{-}\)\s*$', '\1', '')
"     let kind = entry["kind"]
"     let signature = ""
"     if kind == "f"
"       let signature = ind . ": signature: " . cmdClean . ", file: " . file
"     endif
"     if kind == "m"
"       let signature = ind . ": class: " . entry["class"] . ", signature: " . cmdClean . ", file: " . file
"     endif
"     silent echo signature
"     let signatures += [signature]
"     let ind += 1
"   endfor
"   let choice = input("signature: ")
"   silent echo ""
"   silent echo signatures[choice]
" endfunction
" command! -nargs=0 TagDefinition :call TagDefinition()
map <silent> <LocalLeader>td :ts expand("<cword>")<CR>

nnoremap <silent> k gk
nnoremap <silent> j gj
nnoremap <silent> Y y$

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

" Quick cycle through buffers
" nnoremap <Tab> :bnext <CR>
" nnoremap <S-Tab> :bprevious<CR>

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

nmap <silent> <leader>sf :call SchemeEvalDefun()<cr>
nmap <silent> <leader>sb :call SchemeSendSexp("(load \"" . expand("%:p") . "\")\n")<cr>
nmap <silent> <leader>se :call SchemeNew()<cr>
nmap <silent> <leader>sq :call SchemeQuit()<cr>

function! SchemeEvalDefun()
    let pos = getpos('.')
    silent! exec "normal! 99[(yab"
    call SchemeSendSexp(@")
    call setpos('.', pos)
endfun

function! SchemeSendSexp(sexp)
    let ss = escape(a:sexp, '\"')
    call system("tmux send-keys -t 1 \"" . ss . "\n\"")
endfun

function! SchemeNew()
  call system("tmux send-keys -t 1 C-c C-l csi C-m")
endfun

function! SchemeQuit()
  call system("tmux send-keys -t 1 C-c C-d C-l")
endfun

" Game

nmap <silent> <leader>rg :call Run_game()<cr>
function! Run_game()
  call system("tmux send-keys -t 1 C-c C-l 'ninja && ./build/game' C-m")
endfun

" function! Terminal_new()
"   execute "terminal"
"   let g:terminal_buffer = bufnr("%")
"   let g:terminal_window = win_getid()
"   execute "wincmd J"
"   execute "resize 20"
"   execute "NERDTreeToggle"
"   execute "NERDTreeToggle"
"   win_gotoid(g:terminal_window)
" endfun

" function! Terminal_run_command()
"   call term_sendkeys(g:terminal_buffer, g:terminal_command)
"   call term_sendkeys(g:terminal_buffer, "\<C-l>\<CR>")
"   win_gotoid(g:terminal_window)
" endfun

" Can be automatically set in a local project vimrc
" function! RunnerSetCommand()
"   let g:terminal_command = input("Enter command: ")
" endfun
"
" function! RunnerRunCommand()
"   exec "new"
"   exec "read !" . g:terminal_command
"   exec "cexpr []"
"   exec "caddbuffer"
"   exec "q!"
"   exec "cw"
" endfun
" map <silent> <LocalLeader>rs :call RunnerSetCommand()<CR>
" map <silent> <LocalLeader>rr :call RunnerRunCommand()<CR>

augroup Binary
  au!
  au BufReadPre  *.bmp let &bin=1
  au BufReadPost *.bmp if &bin | %!xxd
  au BufReadPost *.bmp set ft=xxd | endif
  au BufWritePre *.bmp if &bin | %!xxd -r
  au BufWritePre *.bmp endif
  au BufWritePost *.bmp if &bin | %!xxd
  au BufWritePost *.bmp set nomod | endif
augroup END

" For project specific .vimrc files
set exrc
set secure
