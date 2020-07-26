" Plugins (using vim-plug)
call plug#begin()
" Language-specific
Plug 'rust-lang/rust.vim'
Plug 'neovimhaskell/haskell-vim'
Plug 'itchyny/vim-haskell-indent'
Plug 'wlangstroth/vim-racket'
Plug 'dag/vim-fish'
" General
Plug 'ntpeters/vim-better-whitespace'
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Colorschemes
Plug 'godlygeek/csapprox'
Plug 'mkarmona/colorsbox'
Plug 'morhetz/gruvbox'
Plug 'cormacrelf/vim-colors-github'
call plug#end()


" Theme and syntax
syntax enable " enable syntax processing
set termguicolors
set background=dark
colorscheme colorsbox-stbright


" Custom mappings
" open a terminal pane using comma (,)
nnoremap , :vert term<CR><C-w>L<C-w>11<
" save (update) the file using Space
nnoremap <Space> :up<CR>

" move between panes with Ctrl + Direction (hjkl)
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" open NERDTree with Ctrl + n
map <C-n> :NERDTreeToggle<CR>

" open Ctrl-P with Ctrl + p
let g:ctrl_map = '<c-p>'

" do not use gitgutter by default
let g:gitgutter_enabled = 0
" toggle gitgutter easily, using F4
nnoremap <F4> :GitGutterToggle<CR>


" General settings
set number relativenumber " enable hybrid line numbers
set signcolumn=number " display signs in the 'number' column (not in a new one)

set cursorline " highlight the current line
set colorcolumn=79,99 " guides for line length (rulers)
set showmatch " highlight matching parenthesis/bracket
set hlsearch " highlight matches

set wildmenu " visual autocomplete for command menu
set lazyredraw " redraw only when needed


" Whitespace
set tabstop=4 " number of visual spaces per TAB
set softtabstop=4 " number of spaces in TAB when editing
set shiftwidth=4 " number of spaces used when indenting with '>'
set expandtab " tabs are spaces

" make TABs visible
set list
set listchars=tab:>-

filetype indent on " load filetype-specific indent files

augroup whitespace_by_language
    autocmd!

    " insert actual TABs in Makefiles
    autocmd FileType make setlocal noexpandtab

    " change indentation level for some languages
    autocmd FileType java setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd FileType python setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END


" CoC configuration
" TextEdit might fail if hidden is not set
set hidden
" some servers have issues with backup files
set nobackup
set nowritebackup
" having long updatetime leads to noticeable delays
set updatetime=300

" trigger completion with TAB
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" use F2 to format the code
nnoremap <silent> <F2> :call CocAction('format')<CR>

" use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction
