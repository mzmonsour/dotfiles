" Enable Neovim goodies
if has('nvim')
    runtime! python_setup.vim
endif

" Change leader, space is a redundant motion anyways
noremap <space> <nop>
let mapleader = "\<space>"

set nocompatible

" Incremental Search and smart case sensitivity
set incsearch
set ignorecase
set smartcase

" Enable 256 color mode
set t_Co=256

" Set colorscheme
colorscheme distinguished

" Use 4 space tabs
set expandtab
set softtabstop=4
set tabstop=4
set shiftwidth=4

" Show tab lines
set list lcs=tab:\|\ 

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

" Remove Windows Line Feeds
command Rmfeed :%s///g

" Quick mapping to save files opened without sudo
cmap w!! w !sudo tee > /dev/null %

" Bind common tab styles
" Use setlocal twice so we can see the settings in the command line
nmap <leader>t :setlocal ts=4 sts=4 sw=4 et<CR>:IndentLinesReset<CR>:setlocal ts=4 sts=4 sw=4 et<CR>
nmap <leader>T :setlocal ts=8 sts=4 sw=8 et<CR>:IndentLinesReset<CR>:setlocal ts=8 sts=4 sw=8 et<CR>
nmap <leader>m :setlocal ts=2 sts=2 sw=2 et<CR>:IndentLinesReset<CR>:setlocal ts=2 sts=2 sw=2 et<CR>
nmap <leader>M :setlocal ts=8 sts=8 sw=8 noet<CR>:IndentLinesReset<CR>:setlocal ts=8 sts=8 sw=8 noet<CR>

" Bind wrap mode toggle
nmap <leader>w :setlocal wrap!<CR>:setlocal wrap?<CR>

" Bind search reset
nnoremap <leader>/ :let @/=""<CR>

" Bind blank line insertions
nmap <leader>o o<Esc>k
nmap <leader>O O<Esc>j

" Enable vundle
filetype off
set rtp+=~/.nvim/bundle/vundle
call vundle#begin('~/.nvim/bundle')
Plugin 'gmarik/vundle'

" Load plugins here

Plugin 'bruno-/vim-man'
Plugin 'benekastah/neomake'
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

call vundle#end()

" Enable syntax highlighting, and other filetype plugins
filetype plugin indent on
syntax on

set omnifunc=syntaxcomplete#Complete

" Fix markdown plugins to recognize .md, .markdown as GitHub Markdown
"augroup markdown
"    au!
"    au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
"augroup END

" Assume MIPS assembly because I don't write x86 or any other instruction set
augroup mips
    au!
    au BufNewFile,BufRead *.asm,*.mips setlocal filetype=mips
augroup END

" Kernel C styling
" Color columns past 80 so code doesn't wrap as much
augroup kernel_c
    au!
    au FileType c setlocal ts=8 sts=8 sw=8 noet
    au FileType c let &l:cc="".join(range(81,999), ",")
augroup END

" Ruby styling
augroup ruby_style
    au!
    au FileType ruby setlocal ts=2 sts=2 sw=2 et
augroup END

augroup text_wrap
    au!
    au BufNewFile,BufRead *.txt set wrap linebreak
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

" NERDTree settings
noremap <C-n> :NERDTreeToggle<CR>
" Close vim if NERDTree is the only open window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" indentLine settings
let g:indentLine_char = '┊'
let g:indentLine_color_term = 46

" CamelCaseMotion replaces w,e,b bindings
" Set standard w,e,b to <leader>w,e,b
map <silent> w <Plug>CamelCaseMotion_w
map <silent> e <Plug>CamelCaseMotion_e
map <silent> b <Plug>CamelCaseMotion_b
noremap <leader>w w
noremap <leader>e e
noremap <leader>b b
sunmap w
sunmap e
sunmap b
