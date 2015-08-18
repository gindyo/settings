set nocompatible              " be iMproved, required
filetype off                  " required
let mapleader="\<Space>"
 "set the runtime path to include Vundle and initialize
 set rtp+=~/.vim/bundle/Vundle.vim
 call vundle#rc()
 " alternatively, pass a path where Vundle should install plugins
 "call vundle#begin('~/some/path/here')

 " let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim' 
Plugin 'rizzatti/dash.vim'
Plugin 'vitality'
Plugin 'rails.vim'
Plugin 'unimpaired.vim'
Plugin 'rking/ag.vim'
Plugin 'LustyExplorer'
Plugin 'tslime.vim'
Plugin 'fugitive.vim'
Plugin 'benmills/vimux'
Plugin 'flazz/vim-colorschemes'
Plugin 'matchit'


" Seriously, guys. It's not like :W is bound to anything anyway.
  command! W :w
set backupdir=~/.backup,/tmp
set backspace=indent,eol,start
set history=100
set ignorecase 

set scrolloff=3 " Keep more context when scrolling off the end of a buffer
set wildmenu " Make tab completion for files/buffers act like bash
set showcmd " display incomplete commands
set hidden " keep undo history for background buffers
set autoread " autoamically read the file again when it is changed externally
set showtabline=2 " always show tab bar

" Editting configuration
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent

" set smartindent
set laststatus=2
set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

"Search Stuff
  set hlsearch " highlight previous search matches
  set incsearch " search as you type
" Make searches case-sensitive only if they contain upper-case characters
  set ignorecase
  set smartcase
"pressing enter key in command mode removes search highlighting
  nnoremap <CR> :nohlsearch <CR>

set mouse=a

cnoreabbrev td tab drop

set number
set nowrap
syntax on
if has("autocmd")
filetype plugin indent on
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
else
set autoindent
endif

"change the cursor in insert mode
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
"Set the color of folds
:hi Folded ctermbg = black
:hi Folded ctermfg = 216
set foldmethod=syntax


" Remap the tab key to do autocompletion or indentation depending on the
" context (from http://www.vim.org/tips/tip.php?tip_id=102)
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction

set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)

hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE
"Searching 
set ignorecase
no <tab> n 
no <s-tab> N
"---------------------------------------------------------------
"Open spec and code at the same time in diff tab
command! -nargs=* -complete=file E call OpenTabs(<f-args>)
function! OpenTabs(path)
  let spec_file = GetSpecFile(a:path)
  execute "tabnew " spec_file | execute 'vsplit' a:path 
endfunction

function! GetSpecFile(path)
  let beforeFile = substitute(a:path, '\w*.rb$', '','')
  let file = substitute(a:path, beforeFile, '','')
  let file_name = substitute(file, '.rb', '','')
  let spec_file = beforeFile . 'spec/' . file_name . '_spec' . '.rb'
  return spec_file
endfunction


"Vimux ---------------------------------------------------------------
function! RunTest()
  execute 'w'
  if bufname("%") !~ "spec.rb"
    execute 'A'
    call VimuxRunCommand("clear; rspec " . bufname("%"))
    execute 'A'
  else
    call VimuxRunCommand("clear; rspec " . bufname("%"))
  endif
endfunction
function! RunAllTest()
  execute 'w'
  call VimuxRunCommand("clear; rspec")
endfunction
function! RunLastTest()
  execute 'w'
  call VimuxRunLastCommand()
endfunction
map <leader>T :call RunTest()<CR> :call VimuxCloseRunner()
map <leader>Ta :call RunAllTest()<CR> :call VimuxCloseRunner()
map <Leader>Tl :call RunLastTest<CR> :call VimuxCloseRunner()
map <leader>t :call RunTest()<CR> :call VimuxCloseRunner()
map <leader>ta :call RunAllTest()<CR>
map <Leader>tl :call RunLastTest()<CR>

" Prompt for a command to run
map <Leader>tp :VimuxPromptCommand<CR>

" Inspect runner pane
map <Leader>ti :VimuxInspectRunner<CR>
" Close vim tmux runner opened by VimuxRunCommand
map <Leader>tq :VimuxCloseRunner<CR>
" Interrupt any command running in the runner pane
map <Leader>tx :VimuxInterruptRunner<CR>
let g:VimuxHeight = "100"
"=====================================================================

"Refactoring ---------------------------------------------------------
:nnoremap <leader>rap  :RAddParameter<cr>
:nnoremap <leader>rcpc :RConvertPostConditional<cr>
:nnoremap <leader>re  :RExtractLet<cr>
:vnoremap <leader>rec  :RExtractConstant<cr>
:vnoremap <leader>rv :RExtractLocalVariable<cr>
:nnoremap <leader>rit  :RInlineTemp<cr>
:vnoremap <leader>rr :RRenameLocalVariable<cr>
:vnoremap <leader>rR :RRenameInstanceVariable<cr>
:vnoremap <leader>rm  :RExtractMethod<cr>

"=====================================================================
nnoremap <leader>a :A<cr>

"navigate through tabs
noremap <a-space> :execute 'tabnext' <cr>
noremap <D-space> :execute 'tabNext' <cr>

"find definition of method
noremap <F12> :execute "noautocmd vimgrep /def .*" . expand("<cword>") . "/j **" <Bar> cw<CR> ]Q
noremap <F4> :execute "noautocmd vimgrep /" . expand("<cword>") . "/j **" <Bar> cw<CR>

"insert tob in insert mode
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

noremap <leader>[ :bprevious<CR>
noremap <leader>] :bnext<CR>
map zz zA
"save file 
no <leader>s  :w<cr>
map <leader>n <c-w><Right>
map  <leader>h <c-w><Left>
map  <leader>c <c-w><UP>
map  <leader>t <c-w><Down>
imap hh <esc>
no h <left>
no n <right>
noremap c <up>
no t <down>
no S :
no E $
no B ^

