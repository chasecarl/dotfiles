
"##########
" Plugins #
"##########

call plug#begin('~/.vim/plugged')

Plug 'Raimondi/delimitMate'
" Plug 'challenger-deep-theme/vim', {'as': 'challenger-deep'}
Plug 'valloric/youcompleteme'
Plug 'morhetz/gruvbox'
Plug 'jaredgorski/spacecamp'
" Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-commentary'
Plug 'vim-airline/vim-airline'
" to be added later
" Plug 'lervag/vimtex'
Plug 'shime/vim-livedown'
Plug 'ryanoasis/vim-devicons'
Plug 'sevko/vim-nand2tetris-syntax'
Plug 'haya14busa/incsearch.vim'
Plug 'ying17zi/vim-live-latex-preview'
Plug 'jeetsukumaran/vim-pythonsense'

call plug#end()

" let g:NERDSpaceDelims 

let g:airline_powerline_fonts = 1
" let g:airline#extensions#keymap#enabled = 0
" let g:airline_section_z = "\ue0a1:%l/%L Col:%c"
let g:Powerline_symbols='unicode'
" let g:airline#extensions#xkblayout#enabled = 0
" let g:vimtex_quickfix_mode = 0
" let g:vimtex_view_method = 'zathura'

filetype plugin on

"########
" Theme #
"########

if has('nvim') || has('termguicolors')
	set termguicolors
endif

if &term =~ '256color'
	" set t_ut=
	set t_Co=256
	set termguicolors
endif

let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" colorscheme challenger_deep
colorscheme gruvbox
set bg=dark
hi Normal guibg=NONE ctermbg=NONE

"########################
" Environment Variables #
"########################

set number relativenumber
set nu rnu

set ts=4
set sts=4
set sw=4

set hls
set incsearch
let g:incsearch#auto_nohlsearch = 1
map n <Plug>(incsearch-nohl-n)
map N <Plug>(incsearch-nohl-N)
map * <Plug>(incsearch-nohl-*)
map # <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

"###########
" Mappings #
"###########

let mapleader = ','
" for the vim-live-latex-preview
let maplocalleader = ','

nnoremap <leader>n o<esc>
nnoremap <leader>N O<esc>
nnoremap <leader>ld :LivedownToggle<CR>

" Disabling arrow keys
cnoremap <Left> <Nop>
" cnoremap <Up> <Nop>
cnoremap <Right> <Nop>
" cnoremap <Down> <Nop>

inoremap <Left> <Nop>
inoremap <Up> <Nop>
inoremap <Right> <Nop>
inoremap <Down> <Nop>

nnoremap <Left> <Nop>
nnoremap <Up> <Nop>
nnoremap <Right> <Nop>
nnoremap <Down> <Nop>

vnoremap <Left> <Nop>
vnoremap <Up> <Nop>
vnoremap <Right> <Nop>
vnoremap <Down> <Nop>

" Indenting when beginning a scope in languages
" with curly braces
inoremap {<CR> {<CR>}<C-o>O

set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

"########
" Other #
"########

autocmd BufRead,BufNewFile *.tex set filetype=tex
