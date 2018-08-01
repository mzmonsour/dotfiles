" Enable Neovim goodies
if has('nvim')
    runtime! python_setup.vim
endif

" Change leader, space is a redundant motion anyways
noremap <space> <nop>
let mapleader = "\<space>"
let maplocalleader = "\<space>"

set nocompatible

" Incremental Search and smart case sensitivity
set incsearch
set ignorecase
set smartcase

" Enable 256 color mode
set t_Co=256

" Use 4 space tabs
set expandtab
set softtabstop=4
set tabstop=4
set shiftwidth=4

" Show tab lines, and partially off-screen lines
set list lcs=tab:\|\ ,precedes:!,extends:!

" Disable long line wrapping
"set nowrap sidescroll=8

" Enable indent backspacing
set backspace=indent,eol,start

" Enable relative line numbering
set number
set relativenumber

" Enable search options
set hlsearch

" Enable cursorline for now
" We'll see if there are any performance problems
"set cursorline

" Enable scroll offset
set scrolloff=5

" Make :q do cool things because ctrl-p and buffers are awesome =)
set hidden

" Ignore common binary files
set wildignore+=*.class
set wildignore+=*/build/**
set wildignore+=*/target/**
set wildignore+=*.o
set wildignore+=*.ko
set wildignore+=*/CMakeFiles/**

" Remove Windows Line Feeds
command Rmfeed :%s///g

" Quick mapping to save files opened without sudo
"cmap w!! w !sudo tee > /dev/null %
cmap w!! SudoWrite

" Bind common tab styles
" Use setlocal twice so we can see the settings in the command line
nmap <leader>t :setlocal ts=4 sts=4 sw=4 et<CR>:IndentLinesReset<CR>:setlocal ts=4 sts=4 sw=4 et<CR>
nmap <leader>T :setlocal ts=8 sts=4 sw=8 et<CR>:IndentLinesReset<CR>:setlocal ts=8 sts=4 sw=8 et<CR>
nmap <leader>m :setlocal ts=2 sts=2 sw=2 et<CR>:IndentLinesReset<CR>:setlocal ts=2 sts=2 sw=2 et<CR>
nmap <leader>M :setlocal ts=8 sts=8 sw=8 noet<CR>:IndentLinesReset<CR>:setlocal ts=8 sts=8 sw=8 noet<CR>

" Bind wrap mode toggle
nmap <leader>w :setlocal wrap!<CR>:setlocal wrap?<CR>

" Bind search reset
nnoremap <leader>/ :nohlsearch<CR>

" Bind blank line insertions
nmap <leader>o o<Esc>k
nmap <leader>O O<Esc>j

" Fix weird switch case indentation
set cinoptions=l1

" Enable vundle
filetype off
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin('~/.config/nvim/bundle')
Plugin 'VundleVim/Vundle.vim'

" Load plugins here

Plugin 'kien/ctrlp.vim'
Plugin 'bkad/CamelCaseMotion'
Plugin 'rking/ag.vim'
Plugin 'Yggdroot/indentLine'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'jtratner/vim-flavored-markdown'
Plugin 'suan/vim-instant-markdown'
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'
Plugin 'bling/vim-airline'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'rust-lang/rust.vim'
Plugin 'tpope/vim-surround'
Plugin 'lervag/vimtex'
Plugin 'Valloric/YouCompleteMe'
Plugin 'rdnetto/YCM-Generator'
Plugin 'racer-rust/vim-racer'
Plugin 'tpope/vim-eunuch'
Plugin 'neomake/neomake'
Plugin 'critiqjo/lldb.nvim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'quabug/vim-gdscript'

" Colorscheme plugins
Plugin 'sickill/vim-sunburst'

call vundle#end()

" Enable syntax highlighting, and other filetype plugins
filetype plugin indent on
syntax on

set omnifunc=syntaxcomplete#Complete

" Set colorscheme

colorscheme distinguished

function SetColorscheme()
    "if has('gui_running')
    "    colorscheme Sunburst
    "else
    "    colorscheme distinguished
    "endif
endfunction

augroup col_scheme
    au!
    au VimEnter * call SetColorscheme()
augroup END

" Fix markdown plugins to recognize .md, .markdown as GitHub Markdown
"augroup markdown
"    au!
"    au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
"augroup END

" Use python plugins for distalgo
augroup distalgo
    au!
    au BufNewFile,BufRead *.da setlocal filetype=python
augroup END

" Assume MIPS assembly because I don't write x86 or any other instruction set
augroup mips
    au!
    au BufNewFile,BufRead *.asm,*.mips setlocal filetype=mips
augroup END

" Kernel C styling
" Color columns past 80 so code doesn't wrap as much
augroup kernel_c
    au!
    "au FileType c setlocal ts=8 sts=8 sw=8 noet
    au FileType c setlocal ts=4 sts=4 sw=4 et
    au FileType c let &l:cc="".join(range(81,999), ",")
augroup END

" Ruby styling
augroup ruby_style
    au!
    au FileType ruby setlocal ts=2 sts=2 sw=2 et
augroup END

" Enable text file settings
augroup text_wrap
    au!
    au FileType text setlocal tw=80 cc=81,101
augroup END

augroup help_nospell
    au!
    au FileType help setlocal nospell
augroup END

" Stop texsuite, or whatever it is, from breaking tmux-navigator bindings
function RebindNavigator()
    nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
    nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
    nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
    nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
    nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>
endfunction

augroup fix_texsuite
    au!
    au VimEnter * call RebindNavigator()
augroup END

" Stop vimtex from hiding characters
augroup fix_vimtex
    au!
    au FileType tex setlocal conceallevel=0
augroup END

" Pick a sane default for code width, this isn't the 80s
let &colorcolumn="101,".join(range(121,999), ",")
"hi ColorColumn ctermbg=Red

" Functions I guess
function ShowSpaces(...)
    let @/='\v(\s+$)|( +\ze\t)'
    let oldhlsearch=&hlsearch
    if !a:0
    let &hlsearch=!&hlsearch
    else
    let &hlsearch=a:1
    end
    return oldhlsearch
endfunction

function TrimSpaces() range
    let oldhlsearch=ShowSpaces(1)
    execute a:firstline.",".a:lastline."substitute ///gec"
    let &hlsearch=oldhlsearch
endfunction

command -bar -nargs=? ShowSpaces call ShowSpaces(<args>)
command -bar -nargs=0 -range=% TrimSpaces <line1>,<line2>call TrimSpaces()

" Set gist settings
let g:gist_post_private = 1
let g:gist_show_privates = 1
let g:gist_open_browser_after_post = 1

" Vim airline settings
set laststatus=2 " Always show airline bar
let g:airline_powerline_fonts=1 " Make me look nice (in gvim)
let g:airline#extensions#tabline#enabled = 1 " Make the tabline look nice
let g:airline#extensions#tabline#show_splits = 0 " Make the tabline less cluttered

" NERDTree settings
noremap <C-n> :NERDTreeToggle<CR>
" Close vim if NERDTree is the only open window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" indentLine settings
let g:indentLine_char = '┊'
let g:indentLine_color_term = 46

" Set CamelCaseMotion bindings
map <leader>w <Plug>CamelCaseMotion_w
map <leader>e <Plug>CamelCaseMotion_e
map <leader>b <Plug>CamelCaseMotion_b

" Fix tmux navigator in neovim, at least until <c-h> no longer sends <BS>
if has('nvim')
    nnoremap <silent> <BS> :TmuxNavigateLeft<CR>
endif

" Set eclim settings
set rtp+=~/.config/nvim/eclim/
let g:EclimCompletionMethod = 'omnifunc'

" Give YCM access to tags
let g:ycm_collect_identifiers_from_tags_files = 1

" Show rust source for ycm
let g:ycm_rust_src_path = "/usr/src/rust/src"

" Set bindings for lldb.nvim

" Toggle breakpoint
"nmap <leader>lb <Plug>LLBreakSwitch
"
"" Print hovering word, or selection
"nnoremap <leader>lp :LL print <C-R>=expand('<cword>')<CR><CR>
"vnoremap <leader>lp :LL print <C-R>=lldb#util#get_selection()<CR><CR>
"
"" Switch lldb.nvim modes
"nnoremap <leader>ll :LLmode debug<CR>
"nnoremap <leader>lL :LLmode code<CR>
"
"" Continue/interrupt execution
"nnoremap <leader>lc :LL continue<CR>
"nnoremap <leader>lx :LL process interrupt<CR>
"
"" Step into/over
"nnoremap <leader>ls :LL step<CR>
"nnoremap <leader>lS :LL next<CR>

" Make sure conceal level is set right
set conceallevel=0
let g:tex_conceal=0
