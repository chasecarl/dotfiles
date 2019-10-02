
"##########
" Plugins #
"##########

call plug#begin('~/.vim/plugged')

Plug 'Raimondi/delimitMate'
Plug 'challenger-deep-theme/vim', {'as': 'challenger-deep'}
Plug 'valloric/youcompleteme'
Plug 'scrooloose/nerdcommenter'
Plug 'vim-airline/vim-airline'
" to be added later
" Plug 'lervag/vimtex'
Plug 'shime/vim-livedown'
Plug 'ryanoasis/vim-devicons'


call plug#end()

let g:NERDSpaceDelims = 2

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

colorscheme challenger_deep

"########################
" Environment Variables #
"########################

set number
set ts=4
set sts=4
set sw=4

"###########
" Mappings #
"###########

let mapleader = ','

nnoremap <leader>n o<esc>
nnoremap <leader>N O<esc>
nnoremap <leader>ld :LivedownToggle<CR>

"########
" Other #
"########

