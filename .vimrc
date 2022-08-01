" Plugins (using vim-plug)
call plug#begin()
" Language-specific
Plug 'rust-lang/rust.vim'
Plug 'neovimhaskell/haskell-vim'
Plug 'itchyny/vim-haskell-indent'
Plug 'wlangstroth/vim-racket'
Plug 'dag/vim-fish'
Plug 'lervag/vimtex'
Plug 'elubow/cql-vim'
" General
Plug 'ntpeters/vim-better-whitespace'
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'vimwiki/vimwiki'
Plug 'ryanoasis/vim-devicons'
Plug 'ap/vim-css-color'
Plug 'preservim/nerdcommenter'
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

function! ToggleColors()
    if g:colors_name != "gruvbox"
        set background=light
        let g:gruvbox_contrast_light="hard"
        colorscheme gruvbox
        redraw
        echo "Using a light theme."
    else
        set background=dark
        colorscheme colorsbox-stbright
        redraw
        echo "Using a dark theme."
    endif
endfunction

" toggle the colorscheme (dark/light) using Leader + C
nnoremap <silent> <leader>c :call ToggleColors()<CR>

set encoding=UTF-8 " set the encoding for DevIcons


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

" search files using FZF with Ctrl + P
nnoremap <C-p> :Files<CR>

" do not use gitgutter by default
let g:gitgutter_enabled = 0
" toggle gitgutter easily, using F4
nnoremap <F4> :GitGutterToggle<CR>

" set Latex flavor for vimtex
let g:tex_flavor = 'latex'


" General settings
set number relativenumber " enable hybrid line numbers
set signcolumn=number " display signs in the 'number' column (not in a new one)

set cursorline " highlight the current line
set colorcolumn=80,100 " guides for line length (rulers)
set showmatch " highlight matching parenthesis/bracket
set hlsearch " highlight matches

set wildmenu " visual autocomplete for command menu
set lazyredraw " redraw only when needed

set exrc secure " allow using per-project .vimrc files

set nrformats+=alpha " allow "incrementing/decrementing" letters


" Whitespace
set tabstop=4 " number of visual spaces per TAB
set softtabstop=4 " number of spaces in TAB when editing
set shiftwidth=4 " number of spaces used when indenting with '>'
set expandtab " tabs are spaces
set nojoinspaces " don't insert extra spaces when joining lines

" make TABs visible
set list
set listchars=tab:>-,trail:#,nbsp:·

filetype indent on " load filetype-specific indent files

augroup whitespace_by_language
    autocmd!

    " insert actual TABs in Makefiles
    autocmd FileType make setlocal noexpandtab
    " the official Go coding style uses TABs
    autocmd FileType go setlocal noexpandtab

    " change indent size for some languages
    autocmd FileType html setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END


" VimWiki configuration
set nocompatible
let g:vimwiki_list = [
    \{
        \'path': '~/Documents/VimWiki',
        \'path_html': '~/Documents/VimWikiHTML',
        \'syntax': 'markdown',
        \'ext': '.md',
    \},
\]
let g:vimwiki_url_maxsave = 0
let g:vimwiki_global_ext = 0
set autoread

" TODO: Decide if this is useful.
" open Vimwiki with <leader>ww (default setting) and change current directory
" to the wiki, to allow for fuzzy file searching
nnoremap <Leader>ww :execute "normal \<Plug>VimwikiIndex"<CR>:lcd %:p:h<CR>


" NERD Commenter configuration
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1

" toggle comments with Ctrl + /
nmap <C-_> <Plug>NERDCommenterToggle
vmap <C-_> <Plug>NERDCommenterToggle<CR>


" CoC configuration
" TextEdit might fail if hidden is not set
set hidden
" some servers have issues with backup files
set nobackup
set nowritebackup
" having long updatetime leads to noticeable delays
set updatetime=300

" use Ctrl + n and Ctrl + p to navigate the completion list
inoremap <silent><expr> <C-n> coc#pum#visible() ? coc#pum#next(1) : "\<C-n>"
inoremap <silent><expr> <C-p> coc#pum#visible() ? coc#pum#prev(1) : "\<C-n>"

" trigger completion with TAB
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" confirm completion with <CR>
inoremap <expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<CR>"

function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" use F1 to rename symbols
nmap <silent> <F1> <Plug>(coc-rename)

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
