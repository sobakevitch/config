" vimrc by me

" reloading vimrc when saved
" augroup
"   autocmd!
"   autocmd bufwritepost $MYVIMRC nested source $MYVIMRC
" augroup END

" Plugin manager: Vundle
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
" Requirements: git curl
" ----------------------

" Auto install Vundle
if has('nvim')
  let s:editor_root=expand("~/.config/nvim")
  if empty(glob("~/.config/nvim/bundle/Vundle.vim"))
    execute '! git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim'
  endif
else
  let s:editor_root=expand("~/.vim")
  if empty(glob("~/.vim/bundle/Vundle.vim"))
    execute '! git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim'
  endif
endif

set nocompatible
set shell=/bin/bash
filetype off

if has('nvim')
  set rtp+=~/.config/nvim/bundle/Vundle.vim
else
  set rtp+=~/.vim/bundle/Vundle.vim
endif

call vundle#rc(s:editor_root . '/bundle')
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

" Plugins
Plugin 'vim-scripts/indentpython.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'nvie/vim-flake8'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tmhedberg/SimpylFold'
Plugin 'supertab'
Plugin 'davidhalter/jedi-vim'           " Requires external package vim-jedi
Plugin 'vim-php/tagbar-phpctags.vim'
Plugin 'dikiaap/minimalist'
Plugin 'godlygeek/tabular'
Plugin 'w0rp/ale'
Plugin 'nsf/gocode', {'rtp': 'vim/'}
Plugin 'sobakevitch/vim-code-dark'
"Plugin 'scrooloose/syntastic'
"Plugin 'nanotech/jellybeans.vim'
"Plugin 'itchyny/lightline.vim'
"Plugin 'josuegaleas/jay'
"Plugin 'plasticboy/vim-markdown'
Plugin 'integralist/vim-mypy'

Bundle 'https://github.com/majutsushi/tagbar.git'
Bundle 'https://github.com/tpope/vim-git'
Bundle 'https://github.com/tpope/vim-fugitive.git'
Bundle 'https://github.com/sjl/gundo.vim.git'
Bundle 'https://github.com/Shougo/neomru.vim'
Bundle 'https://github.com/Shougo/unite.vim.git'
Bundle 'https://github.com/Shougo/vimproc.vim.git'
Bundle 'https://github.com/dag/vim-fish'
Bundle 'https://github.com/msanders/cocoa.vim'
Bundle 'https://github.com/tpope/vim-markdown.git'
Bundle 'https://github.com/fatih/vim-go.git'
Bundle 'https://github.com/PProvost/vim-ps1.git'
Bundle 'https://github.com/Shougo/deoplete.nvim.git'
Bundle 'https://github.com/python-mode/python-mode.git'
"Bundle 'https://github.com/zchee/nvim-go.git'
"Bundle 'https://github.com/encody/nvim.git'
"Bundle 'https://github.com/w0ng/vim-hybrid.git'
"Bundle 'https://github.com/joshdick/onedark.vim.git'
Bundle 'https://github.com/pangloss/vim-javascript.git'
Bundle 'https://github.com/briancollins/vim-jst.git'

call vundle#end()


" Misc configuration
" -------------------
filetype plugin indent on
set nocompatible
set secure
set backspace=indent,eol,start
"set nobackup                     " disable backup file (ending with ~)
set backup
set backupdir=$HOME/.local/share/nvim/backup/,.
set history=50                   " keep 50 lines of command line history
set ruler                        " show the cursor position all the time
set showcmd                      " display incomplete commands
set showmode                     " show current mode
set encoding=utf-8
set number                       " display line number
set wildmenu                     " enhance line completion
set scrolloff=5
set title
set showmatch                    " show associated braces, parens...
set smartcase
set hlsearch                   " disable highlighting searched strings
set incsearch                    " move cursor to the matched string
set completeopt=menu,longest
set visualbell                   " disable visual bell
set t_vb=
set wrap
set mouse=a
set list

" Display settings
" ----------------
syntax on
set t_Co=256
set background=dark
set laststatus=2
set cursorline

" let g:load_doxygen_syntax=1
colorscheme codedark

let g:airline_powerline_fonts = 1
let g:airline_theme = 'codedark'

"let g:lightline = {
"      \ 'colorscheme': 'jay',
"    \ 'active': {
"    \   'left': [ ['mode', 'paste', 'readonly'], ['fugitive', 'filename', 'syntastic'], ['ctrlpmark'] ],
"    \   'right': [ ['lineinfo'], ['percent'], ['fileformat', 'fileencoding', 'filetype'] ]
"    \ },
"    \ 'component_function': {
"    \  'fugitive': 'LightLineFugitive',
"    \  },
"    \ 'component_expand': {
"    \  'syntastic': 'SyntasticStatuslineFlag',
"    \  },
"    \ 'component_error': {
"    \  'syntastic': 'error',
"    \  },
"    \ }

" hi Normal ctermbg=none
function! LightLineFugitive()
  return exists('*fugitive#head') ? fugitive#head() : ''
endfunction

" augroup AutoSyntastic
"   autocmd!
"   autocmd BufWritePost *.c,*.cpp,*.py call s:syntastic()
" augroup END
function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction


" Persistent undo
" ---------------
let vimConfigDir = '$HOME/.config/nvim'
let vimLocalDir = '$HOME/.local/share/nvim'
let &runtimepath.=','.vimConfigDir
if has('persistent_undo')
  let myUndoDir = expand(vimConfigDir . '/undodir')
  " Create dirs
  :silent call system('mkdir -p ' . myUndoDir)
  let &undodir = myUndoDir
  set undofile
endif


" Remind old position settings
" ----------------------------
if has('nvim')
  set viminfo='10,\"100,:20,%,n~/.config/nvim/viminfo
else
  set viminfo='10,\"100,:20,%,n~/.viminfo
endif
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END


" Language specific settings
" --------------------------
" au BufRead,BufNewFile .*rc,*.conf,*.rb,*.py,*.pyw,*.c,*.h :
"             \ set colorcolumn=80 |
"             \ hi colorcolumn guibg=gray14 ctermbg=darkgray |

"set expandtab
"set tabstop=4
"set shiftwidth=4

au BufNewFile,BufRead *.py :
      \ set tabstop=4 |
      \ set shiftwidth=4 |
      \ set noexpandtab |
      \ set autoindent |
      \ set fileformat=unix |
"\ set foldlevel=0 |
"\ set textwidth=79 |

au BufNewFile,BufRead *.rst :
      \ set tabstop=4 |
      \ set shiftwidth=4 |
      \ set noexpandtab |
      \ set autoindent |
      \ set fileformat=unix

au BufNewFile,BufRead *.hs :
      \ set tabstop=4 |
      \ set shiftwidth=4

au BufNewFile,BufRead *.go :
      \ set tabstop=4 |
      \ set shiftwidth=4 |
      \ set noexpandtab |
      \ set autoindent |
      \ set fileformat=unix |

au BufNewFile,BufRead *.c,*.cpp,*.fish :
      \ set tabstop=4 |
      \ set shiftwidth=4 |
      \ set noexpandtab |
      \ set autoindent |
      \ set fileformat=unix |

au BufNewFile,BufRead *.html,*.css :
      \ set tabstop=2 |
      \ set softtabstop=2 |
      \ set shiftwidth=2 |

au BufNewFile,BufRead *.ts set filetype=javascript

au BufNewFile,BufRead *.jspx set filetype=jsp

au BufNewFile,BufRead *.sh :
      \ set foldmethod=marker |
      \ set fmr={{,}} |

" Ctags for tagbar
" ---------------

" Add support for markdown files in tagbar.
let g:tagbar_type_markdown = {
      \ 'ctagstype': 'markdown',
      \ 'ctagsbin' : '~/.bin/markdown2ctags.py',
      \ 'ctagsargs' : '-f - --sort=yes',
      \ 'kinds' : [
      \ 's:sections',
      \ 'i:images'
      \ ],
      \ 'sro' : '|',
      \ 'kind2scope' : {
      \ 's' : 'section',
      \ },
      \ 'sort': 0,
      \ }


" Folding
" -----------
set foldenable
set foldmethod=indent
set foldlevel=99
let g:SimpylFold_docstring_preview=1


" Indentation
" -----------
set shiftwidth=2    " shift length using < or >
"set tabstop=4       " length of a tab
set autoindent


" Key mapping
" -----------
:let mapleader = " "

nnoremap <Leader>s :vsp<CR>

" Tagbar
nmap <Leader>l :TagbarToggle<CR>
nmap <F8> :TagbarToggle<CR>

" Gundo
nnoremap <F5> :GundoToggle<CR>
nnoremap <Leader>h :GundoToggle<CR>

nnoremap <F9> :TagbarToggle<CR>:NERDTreeToggle<CR><C-W><C-L>

nnoremap <F6> :set paste<CR>i
nnoremap <F10> :set number!<CR>

" copy paste to outside vim
vnoremap <C-c> "+y

" Unite
nnoremap <Leader>f :Unite -no-split -buffer-name=files -start-insert file_rec/async<CR>
nnoremap <Leader>e :Unite -no-split -buffer-name=files -start-insert file<CR>
nnoremap <Leader>t :Unite -no-split -buffer-name=mru -start-insert file_mru<CR>
nnoremap <Leader>b :Unite -buffer-name=buffer -start-insert buffer<CR>

" NERDTree
nnoremap <Leader>v :NERDTreeToggle<CR>

" clear hlsearch
nnoremap <Leader>a :noh<CR>

" save and quit
nnoremap <Leader>q :q<CR>
nnoremap <Leader>w :w<CR>

" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" next/previous file (buffer)
nnoremap <C-P> :bp<CR>
nnoremap <C-N> :bn<CR>

" Deleting leading and traing whitespaces
nnoremap <C-M><C-M> :% s/\s\s*$//g<CR>

" ALE, toggle ALE
nnoremap <Leader>m :ALEToggle<CR>


" Plugins settings
" ----------------

" Markdown
" --------
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'java', 'xml', 'cpp', 'c', 'javascript', 'json', 'objc', 'cs']

" Jedi-vim
"let g:jedi#squelch_py_warning = 1
let g:jedi#show_call_signatures = "2"

" obsolete by 'set list'
"# highlight BadWhitespace ctermbg=red guibg=darkred
"# au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" ALE
" ---
let g:ale_linters = {
      \   "python": ["pycodestyle"],
      \   "go": [],
      \}
let g:ale_python_pycodestyle_options="--ignore=W191,E501,E402,E731"
let g:ale_python_flake8_options="--ignore=W191,E501,E402,E731"


" NERDTree
" --------
" ignore files in NERDTree
let NERDTreeIgnore=['\.pyc$', '\~$']
" close vim when NERDTree is the last buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


" Unite
" -----
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  " Play nice with supertab
  let b:SuperTabDisabled=1
  " Enable navigation with control-j and control-k in insert mode
  imap <buffer> <C-j> <Plug>(unite_select_next_line)
  imap <buffer> <C-k> <Plug>(unite_select_previous_line)
endfunction


" vim-go
" ------
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1

" python-mode
" -----------
let g:pymode_options_colorcolumn = 1
let g:pymode_options_max_line_length = 0
let g:pymode_trim_whitespaces = 0
let g:pymode_warnings = 0
let g:pymode_indent = 0
let g:pymode_folding = 0
let g:pymode_motion = 0
let g:pymode_doc = 0
let g:pymode_virtualenv = 0
let g:pymode_run = 0
let g:pymode_breakpoint = 0
let g:pymode_lint = 0
let g:pymode_rope = 0
let g:pymode_rope_completion = 0
