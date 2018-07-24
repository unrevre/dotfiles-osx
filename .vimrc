execute pathogen#infect()

" vim-commentary
" vim-easyalign
" vim-peekaboo
" vim-pencil
" vim-surround
" vim-tradewinds
" vimagit

" general settings {
filetype plugin indent on
syntax on

colorscheme colours

set background=light
set encoding=utf-8

set tabstop=8
set shiftwidth=4
set smarttab
set expandtab
set autoindent

set ttimeout
set ttimeoutlen=10

set backspace=indent,eol,start
set formatoptions+=j
set nojoinspaces

set incsearch
set hlsearch
set noshowmode
set laststatus=2
set display+=lastline
set scrolloff=1
set fillchars=vert:\ ,fold:-

set hidden
set sessionoptions-=options
set history=512
set tabpagemax=16

set wildmenu

runtime macros/matchit.vim

let mapleader = ' '
let maplocalleader = ' '

let g:tex_flavor = "latex"
" }

" key bindings {
nnoremap <silent> <C-g> :let _s=@/ <Bar> :%s/\s\+$//e <Bar>
        \ :let @/=_s <Bar> :nohl <Bar> :unlet _s<CR>
nnoremap <silent> <C-l> :nohlsearch<C-r>=has('diff')?' <Bar>
        \ diffupdate':''<CR><CR><C-l>
nnoremap <silent> @R :set operatorfunc=util#repeat<CR>g@

nnoremap ]b :bnext<CR>
nnoremap [b :bprev<CR>
nnoremap ]l :lnext<CR>
nnoremap [l :lprev<CR>
nnoremap ]t :tabn<CR>
nnoremap [t :tabp<CR>

nnoremap <silent> gb :<C-u>call util#break()<CR>
nnoremap <silent> gk :<C-u>call util#next_indent(v:count1, -1)<CR>
nnoremap <silent> gj :<C-u>call util#next_indent(v:count1, 1)<CR>
nnoremap Q @q
nnoremap Y y$

nnoremap <leader>q :quit<CR>
nnoremap <leader>u :update<CR>
nnoremap <leader>w <C-w>
nnoremap <leader>. :let @/=@"<cr>/<cr>cgn<c-r>.<esc>
nnoremap <leader>/ :execute 'vimgrep /'.@/.'/g %'<CR>:copen<CR>

inoremap <C-u> <C-g>u<C-u>

xnoremap . :normal .<CR>
xnoremap @ :<C-u>call util#repeat()<CR>

cnoremap <C-a> <Home>

set pastetoggle=<C-_>
" }

" commands {
command! -nargs=1 Count execute printf('%%s/%s//gn', escape(<q-args>, '/'))
        \ | normal! ``
command! -bang -nargs=* -complete=file Make
        \ call make#make(<bang>0,<q-args>)
command! -nargs=? -complete=customlist,make#completion MakeStop
        \ call make#stop(<f-args>)
" }

" autocommands {
augroup guess
    autocmd!
    autocmd StdinReadPost,FilterReadPost,FileReadPost,BufReadPost
            \ * call start#guess()
augroup END

augroup lint
    autocmd!
    autocmd FileType asm
            \ setlocal makeprg=gcc\ -x\ assembler\ -fsyntax-only
    autocmd FileType c
            \ setlocal makeprg=gcc\ -S\ -x\ c\ -fsyntax-only\ -Wall
    autocmd FileType cpp
            \ setlocal makeprg=g++\ -S\ -x\ c++\ -fsyntax-only\ -Wall
    autocmd BufWritePost *.S,*.c,*.cpp silent :Make! <afile> | silent redraw!
    autocmd QuickFixCmdPost [^l]* cwindow
augroup END

augroup quickfix
    autocmd!
    autocmd BufWinEnter quickfix nnoremap <silent> <buffer>
            \ q :cclose<CR>:lclose<CR>
    autocmd BufEnter * if (winnr('$') == 1 && &buftype ==# 'quickfix') |
            \ bd | q | endif
augroup END

augroup git
    autocmd!
    autocmd BufNewFile,BufReadPost * call git#detect(expand('<amatch>:p:h'))
    autocmd BufEnter * call git#detect(expand('%:p:h'))
augroup END

augroup status
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * call status#refresh()
augroup END
" }

" highlight groups {
highlight! User1 ctermfg=7 ctermbg=6 cterm=bold
highlight! User2 ctermfg=7 ctermbg=3 cterm=bold
highlight! User3 ctermfg=7 ctermbg=1 cterm=bold
highlight! User4 ctermfg=7 ctermbg=2 cterm=bold
highlight! User5 ctermfg=7 ctermbg=5 cterm=bold
highlight! User6 ctermfg=7 ctermbg=8
highlight! User7 ctermfg=7 ctermbg=9
" }

" plugin settings {
" easyalign {{
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
" }}

" magit {{
let g:magit_show_magit_mapping = '<leader>m'
let g:magit_stage_hunk_mapping = 's'
let g:magit_commit_mapping = 'cm'
let g:magit_commit_amend_mapping = 'ca'
let g:magit_commit_fixup_mapping = 'cf'
let g:magit_close_commit_mapping = 'cq'
let g:magit_ignore_mapping = "<Nop>"
let g:magit_jump_next_hunk = 'n'
let g:magit_jump_prev_hunk = 'N'

let g:magit_git_cmd = 'git'
" }}

" peekaboo {{
let g:peekaboo_window = 'vert bo 40new'
" }}

" pencil {{
let g:pencil#autoformat = 1
let g:pencil#textwidth = 79
let g:pencil#joinspaces = 0
let g:pencil#cursorwrap = 0
let g:pencil#conceallevel = 0

augroup pencil
    autocmd!
    autocmd FileType tex call pencil#init() | set formatoptions-=n
augroup END

nnoremap <silent> <C-h> :<C-u>PFormatToggle<CR>
inoremap <silent> <C-h> <C-o>:PFormatToggle<CR>
" }}
" }
