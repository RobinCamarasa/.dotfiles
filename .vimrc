" General {{{

" Leaders {{{
let mapleader=" "
let maplocalleader=","
"}}}

" Options {{{
set clipboard=unnamed
set belloff=all
set number relativenumber
set autoindent
set expandtab
set shiftwidth=4
set shortmess+=c
set exrc
set incsearch
set foldmethod=manual
set grepprg=grep\ --color=never\ -n\ $*\ /dev/null
"}}}

" Variables {{{
let g:netrw_banner=0
let g:netrw_browsex_viewer="xdg-open"
"}}}

" Colorscheme {{{
colorscheme slate
" }}}

" }}}

" Plugins {{{

" Board of directors (personal) {{{
packadd! cco.vim " My Custom Completion Organizer (cco) (path ~/.vim/pack/personal/opt/cco.vim/)
packadd! ceo.vim " My Compilation and Execution Organizer (ceo) (path ~/.vim/pack/personal/opt/ceo.vim/)
packadd! cfo.vim " My Contextual and Folding Organizer (cfo) (path ~/.vim/pack/personal/opt/cfo.vim/)
packadd! coo.vim " My Custom Operators Organizer (coo) (path ~/.vim/pack/personal/opt/coo.vim/)
packadd! cto.vim " My Custom Text Objects (cto) (path ~/.vim/pack/personal/opt/cto.vim/)
packadd! cxo.vim " My Custom Xdg-Open (cxo) (path ~/.vim/pack/personal/opt/cxo.vim/)
"}}}

" Personal {{{
packadd! openscad.vim " Add support for openscad (path ~/.vim/pack/personal/opt/openscad.vim/)
"}}}

" Tpope {{{
packadd! vim-sensible " Add sensible default to vim (path ~/.vim/pack/tpope/opt/vim-sensible/)
packadd! vim-commentary " Deal with comments with the operator gc (path ~/.vim/pack/tpope/opt/vim-commentary/)
packadd! vim-fugitive " Deal with git (path ~/.vim/pack/tpope/opt/vim-fugitive/)
packadd! vim-repeat " Deal with repetition (path ~/.vim/pack/tpope/opt/vim-repeat/)
packadd! vim-surround " Add surrounding options with the operator cs (path ~/.vim/pack/tpope/opt/vim-surround/)
packadd! vim-vinegar " Enhance netrw (path ~/.vim/pack/tpope/opt/vim-vinegar/)
"}}}

" Utils {{{
packadd! auto-pairs " Add automatically the closing parenthesis (path ~/.vim/pack/utils/opt/auto-pairs/)
"}}}

" }}}

" Mappings {{{

" Insert mode {{{
inoremap <C-e> <C-]>
" }}}

" Normal mode {{{
nnoremap Q <nop> 
" Who need Execution mode?
nnoremap gd <C-]>
nnoremap S :%s//g<Left><Left>
nnoremap s :s//g<Left><Left>
nnoremap <leader>v :tabnew<CR><C-w>v:E ~/.vim<CR><C-W>l:e ~/.vimrc<CR>

augroup general_mappings
    autocmd!
    autocmd FileType vim nnoremap <localleader>V :w<CR>:source %<CR>
augroup END
" }}}

" Visual mode {{{
vnoremap s :s//g<Left><Left>
" }}}

" Terminal mode {{{
tnoremap <Esc>p <C-w>"0
"}}}

"}}}

" Experiments {{{
"}}}
