let mapleader = ' '
let maplocalleader = ' '

"##########
" Plugins #
"##########

call plug#begin('~/.vim/plugged')

Plug 'Raimondi/delimitMate'
" Plug 'challenger-deep-theme/vim', {'as': 'challenger-deep'}
Plug 'valloric/youcompleteme'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'morhetz/gruvbox'
" Plug 'arcticicestudio/nord-vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'lervag/vimtex'
Plug 'shime/vim-livedown'
Plug 'ryanoasis/vim-devicons'
" Plug 'sevko/vim-nand2tetris-syntax'
Plug 'haya14busa/incsearch.vim'
Plug 'jeetsukumaran/vim-pythonsense'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tommcdo/vim-exchange'
" Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'mattn/emmet-vim'
Plug 'adelarsq/vim-matchit'
Plug 'rhysd/vim-grammarous'

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
" colorscheme gruvbox
" colorscheme nord
set bg=dark
" Makes vim respect terminal's opaqueness
" hi Normal guibg=NONE ctermbg=NONE
let g:nord_bold_vertical_split_line = 1
" didn't get what it does
let g:nord_cursor_line_number_background = 1

"########################
" Environment Variables #
"########################

set colorcolumn=100

set number relativenumber
set nu rnu
set splitright

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

"##########
" Tabline #
"##########

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '│'
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
" let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#show_close_button = 0
" let g:airline#extensions#tabline#show_buffers = 2

"##########
" Buffers #
"##########

" Allows to switch to another buffer without writing the current one
set hidden

" Wrapping awkward <C-^> (<C-6> is still bad) into a function for possible map
function! ChangeBuf(count)
	execute "normal! " . a:count . "\<C-^>"
endfunction

" Jumps <count> buffers forward. If <count> is negative - jumps backwards
function! JmpBuf(count)
	" only listed and non-terminal buffers
	let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val) && buffer_name(v:val) !~ "!/bin/"')
	let l = len(buffers)
	let curBufIdx = index(buffers, bufnr())
	let jmpBufIdx = curBufIdx + a:count
	let jmpBufIdxModulo = jmpBufIdx - (jmpBufIdx / l) * l
	:execute "buf " . buffers[jmpBufIdxModulo]
endfunction

function! BufferMenuCallback(id, result)
	if a:result != -1
		call win_execute(a:id, 'let l = getline(".")')
		:execute "buffer " . l
	endif
endfunction


function! BufferMenuFilter(id, key)
	if a:key == 'b'
		let lastLine = popup_getpos(a:id)['lastline']
		call win_execute(a:id, 'let pos = getpos(".")')
		if pos[1] == lastLine
			let pos[1] = 1
		else
			let pos[1] += 1
		endif
		call win_execute(a:id, 'call setpos(".", pos)')
	elseif a:key == 'B'
		call win_execute(a:id, 'let pos = getpos(".")')
		if pos[1] == 1
			let pos[1] = popup_getpos(a:id)['lastline']
		else
			let pos[1] -= 1
		endif
		call win_execute(a:id, 'call setpos(".", pos)')
	elseif a:key == 'l'
		call popup_close(a:id)
	elseif a:key == 'h'
		call popup_close(a:id, -1)
	endif

	" blocks handling inputs not by this function (alsa adds standard j/k
	" navigation and x for quit)
	return popup_filter_menu(a:id, a:key)
endfunction

function! BufferComparator(bn1, bn2)
	let lastused1 = getbufinfo(a:bn1)[0]['lastused']
	let lastused2 = getbufinfo(a:bn2)[0]['lastused']
	if lastused1 < lastused2
		return 1
	elseif lastused1 > lastused2
		return -1
	else
		" it may seem counter-intuitive, but we don't want to return 0
		" if we quickly switch buffers, then two buffers may have the same
		" lastused value (measured in seconds). I think it's a fair assumption
		" that if we are here then we want to switch buffers, so there
		" shouldn't be a situation where the default option (the second one)
		" is the current buffer (i.e. no switch), so we need it to be the
		" first (i.e. to be sorted lower)
		if a:bn1 == bufnr()
			return -1
		else
			return 1
		endif
endfunction

function! BufferPopup()
	let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val) && buffer_name(v:val) !~ "!/bin/"')
	call sort(buffers, 'BufferComparator')
	let bufnames = map(buffers, 'bufname(v:val)')
	let winid = popup_create(bufnames, #{cursorline: 1, filter: 'BufferMenuFilter',
							\ callback: 'BufferMenuCallback'})
	" moving to the second option
	call win_execute(winid, 'call setpos(".", [0, 2, 1, 0])')
endfunction

let g:vim_screen_width = getwininfo(win_getid())[0]['width']
" window's height, 60 width (for width 159 and colorcolumn 100)
let &termwinsize = "0x" . (g:vim_screen_width - &colorcolumn)
let g:terminal_bufnr = -1
function! ToggleTerminal()
	if g:terminal_bufnr == -1
		execute "vertical botright term"
		let g:terminal_bufnr = bufnr('$')
	else
		if getbufinfo(g:terminal_bufnr)[0]['hidden'] == 0
			if bufnr() == g:terminal_bufnr
				execute "hide"
			else
				let term_windows = win_findbuf(g:terminal_bufnr)
				let term_winnr = getwininfo(term_windows[0])[0]['winnr']
				execute "" . term_winnr . "hide"
			endif
		else
			execute "vertical sbuffer " . g:terminal_bufnr
			execute "vertical " . winnr('$') . "resize " . split(&termwinsize, 'x')[1]
		endif
	endif
endfunction


" command! -nargs=1 ChangeBufCmd call ChangeBuf(<args>)
command! -nargs=1 JmpBufCmd call JmpBuf(<args>)
" nmap gb :<C-U>JmpBufCmd(v:count1)<CR>
" nmap gB :<C-U>JmpBufCmd(-v:count1)<CR>
command! BufferPopupCmd call BufferPopup()
command! ToggleTerminalCmd call ToggleTerminal()
nmap <silent> gb :<C-U>BufferPopupCmd<CR>

nmap <silent> <C-T> :<C-U>ToggleTerminalCmd<CR>

" switch buffers from terminal
tmap <C-W>b <C-W>Ngb
" toggle terminal from terminal
tmap <silent> <C-T> <C-W>N:<C-U>ToggleTerminalCmd<CR>
" the same mapping in normal mode for consistency
nmap <C-W>b gb


nmap gO <C-W>o

" Closing a buffer
nmap <leader>bq :bprevious <BAR> bdelete #<CR>

" Fuzzy search file from buffer list
nmap <leader>bf :Buffers<CR>

" Don't need these - I implemented them with count
" " Next/previous buffer
" nmap <leader>bl :bnext<CR>
" nmap <leader>bh :bprevious<CR>

" Previous opened buffer - shadows "go to sleep" mapping
nmap gs :buffer #<CR>

" " Show all buffers
" nmap <leader>bl :ls<CR>

"###########
" Mappings #
"###########

nnoremap <leader>n o<esc>
nnoremap <leader>N O<esc>
nnoremap <leader>md :LivedownToggle<CR>

" Disabling arrow keys
" cnoremap <Left> <Nop>
" cnoremap <Up> <Nop>
" cnoremap <Right> <Nop>
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

" Opening a file (fzf)
nmap <leader>O :Files<CR>

" Removes search highlighting
nmap <silent> <leader>S :nohlsearch<CR>

nmap <F5> <Plug>(grammarous-fixit)

" Indenting when beginning a scope in languages
" with curly braces
inoremap {<CR> {<CR>}<C-o>O

set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

"########
"  coc  #
"########

"" Some servers have issues with backup files, see #649.
"" set nobackup
"set nowritebackup
""
"" Give more space for displaying messages.
"set cmdheight=2
""
"" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
"" delays and poor user experience.
"set updatetime=300

"" Don't pass messages to |ins-completion-menu|.
"set shortmess+=c

"" Always show the signcolumn, otherwise it would shift the text each time
"" diagnostics appear/become resolved.
"set signcolumn=yes

"" Use tab for trigger completion with characters ahead and navigate.
"" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
"" other plugin before putting this into your config.
"inoremap <silent><expr> <TAB>
"	\ pumvisible() ? "\<C-n>" :
"	\ <SID>check_back_space() ? "\<TAB>" :
"	\ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

"function! s:check_back_space() abort
"	let col = col('.') - 1
"	return !col || getline('.')[col - 1]  =~# '\s'
"endfunction

"" Use <c-space> to trigger completion.  inoremap <silent><expr> <c-space> coc#refresh()

"" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
"" position. Coc only does snippet and additional edit on confirm.
"" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
"if exists('*complete_info')
"	inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
"else
"	inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
"endif

"" Use `[g` and `]g` to navigate diagnostics
"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)

"" GoTo code navigation.
"nmap <silent> gd <Plug>(coc-definition)
"nmap <silent> gy <Plug>(coc-type-definition)
"nmap <silent> gi <Plug>(coc-implementation)
"nmap <silent> gr <Plug>(coc-references)

"" Use K to show documentation in preview window.
"nnoremap <silent> K :call <SID>show_documentation()<CR>

"function! s:show_documentation()
"	if (index(['vim','help'], &filetype) >= 0)
"		execute 'h '.expand('<cword>')
"	else
"		call CocAction('doHover')
"	endif
"endfunction

"" Highlight the symbol and its references when holding the cursor.
"autocmd CursorHold * silent call CocActionAsync('highlight')

"" Symbol renaming.
"nmap <leader>rn <Plug>(coc-rename)

"" Formatting selected code.
"xmap <leader>f <Plug>(coc-format-selected)
"nmap <leader>f <Plug>(coc-format-selected)

"augroup mygroup
"autocmd!
"" Setup formatexpr specified filetype(s).
"autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"" Update signature help on jump placeholder.
"autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
"augroup end

"" Applying codeAction to the selected region.
"" Example: `<leader>aap` for current paragraph
"xmap <leader>a <Plug>(coc-codeaction-selected)
"nmap <leader>a <Plug>(coc-codeaction-selected)

"" Remap keys for applying codeAction to the current line.
"nmap <leader>ac <Plug>(coc-codeaction)
"" Apply AutoFix to problem on the current line.
"nmap <leader>qf <Plug>(coc-fix-current)

"" Introduce function text object
"" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
"xmap if <Plug>(coc-funcobj-i)
"xmap af <Plug>(coc-funcobj-a)
"omap if <Plug>(coc-funcobj-i)
"omap af <Plug>(coc-funcobj-a)

"" Use <TAB> for selections ranges.
"" NOTE: Requires 'textDocument/selectionRange' support from the language server.
"" coc-tsserver, coc-python are the examples of servers that support it.
"nmap <silent> <TAB> <Plug>(coc-range-select)
"xmap <silent> <TAB> <Plug>(coc-range-select)

"" Add `:Format` command to format current buffer.
"command! -nargs=0 Format :call CocAction('format')

"" Add `:Fold` command to fold current buffer.
"command! -nargs=? Fold :call CocAction('fold', <f-args>)

"" Add `:OR` command for organize imports of the current buffer.
"command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

"" Add (Neo)Vim's native statusline support.
"" NOTE: Please see `:h coc-status` for integrations with external plugins that provide custom statusline: lightline.vim, vim-airline.
"" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

"" Mappings using CoCList:
"" Show all diagnostics.
"nnoremap <silent> <space>a :<C-u>CocList diagnostics<cr>
"" Manage extensions.
"nnoremap <silent> <space>e :<C-u>CocList extensions<cr>
"" Show commands.
"nnoremap <silent> <space>c :<C-u>CocList commands<cr>
"" Find symbol of current document.
"nnoremap <silent> <space>o :<C-u>CocList outline<cr>
"" Search workspace symbols.
"nnoremap <silent> <space>s :<C-u>CocList -I symbols<cr>
"" Do default action for next item.
"nnoremap <silent> <space>j :<C-u>CocNext<CR>
"" Do default action for previous item.
"nnoremap <silent> <space>k :<C-u>CocPrev<CR>
"" Resume latest coc list.
"nnoremap <silent> <space>p :<C-u>CocListResume<CR>

"########
" Other #
"########

let g:tex_flavor = 'latex'
if !exists('g:ycm_semantic_triggers')
	let g:ycm_semantic_triggers = {}
endif
au VimEnter * let g:ycm_semantic_triggers.tex = g:vimtex#re#youcompleteme
let g:vimtex_imaps_leader = '`'

let g:UltiSnipsExpandTrigger='<c-]>'
let g:UltiSnipsJumpForwardTrigger='<c-j>'
let g:UltiSnipsJumpBackwardTrigger='<c-k>'

" autocmd BufRead,BufNewFile *.tex set filetype=tex
set clipboard^=unnamedplus
set backspace=indent,eol,start
" for mappings
set timeoutlen=400
" continuous vsplit separator
set fillchars+=vert:│

highlight ColorColumn ctermbg=darkgray

" enables signcolumn persistently for errors/warning signs from completion
" engine
augroup cfamily
	autocmd!
	" autocmd BufNewFile,BufRead *.{c, cc, cpp, h, hpp} set signcolumn=yes
	autocmd BufNewFile,BufRead *.c,*.cc,*.cpp,*.h,*.hpp set signcolumn=yes
augroup END

