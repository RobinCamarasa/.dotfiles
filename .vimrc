" Vim Options {{{
let mapleader=" "
let g:netrw_banner=0
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

" TODO
let g:netrw_browsex_viewer="xdg-open"
let b:recipe=" "
let b:makeprg="/usr/bin/make"
let b:xprg="/usr/bin/zathura"
let b:xrecipe=" "

let $BASH_ENV = "~/.bash_aliases"
set grepprg=grep\ --color=never\ -n\ $*\ /dev/null
" }}}

" Vim plugins {{{

" Personal plugin {{{
packadd! cto.vim " My Custom Text Objects (cto) (depends on matchit) (path ~/.vim/pack/personal/opt/cto.vim/)
packadd! openscad.vim " Add support for openscad (path ~/.vim/pack/personal/opt/openscad.vim/)
"}}}

" Tpope plugin {{{
packadd! vim-sensible " Add sensible default to vim (path ~/.vim/pack/tpope/opt/vim-sensible/)
packadd! vim-commentary " Deal with comments with the operator gc (path ~/.vim/pack/tpope/opt/vim-commentary/)
packadd! vim-fugitive " Deal with git (path ~/.vim/pack/tpope/opt/vim-fugitive/)
packadd! vim-repeat " Deal with repetition (path ~/.vim/pack/tpope/opt/vim-repeat/)
packadd! vim-surround " Add surrounding options with the operator cs (path ~/.vim/pack/tpope/opt/vim-surround/)
"}}}

" Utils plugins {{{
packadd! auto-pairs " Add automatically the closing parenthesis (path ~/.vim/pack/utils/opt/auto-pairs/)
packadd! asyncrun.vim " TODO: remove -- Add latex matching of operations (path ~/.vim/pack/utils/opt/asyncrun.vim/)
"}}}

" }}}

" Colorscheme {{{
colorscheme slate
" }}}

" Terminal mode {{{
" tnoremap <Esc> <C-w>N
tnoremap <C-w>p <C-w>"0
"}}}

" Insert mode {{{
inoremap <C-e> <C-]>
" }}}

" Normal mode {{{
nnoremap gd <C-]>
nnoremap <leader>y :let @+=@0<CR>:let @*=@0<CR>
nnoremap S :%s//g<Left><Left>
nnoremap s :s//g<Left><Left>
nnoremap <leader>u :UndotreeToggle<cr>
nnoremap <leader>y :set operatorfunc=CopyOperator<cr>g@

function! CopyOperator(type)
    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif
    let @+=@@
endfunction
" }}}

" Visual mode {{{
vnoremap s :s//g<Left><Left>
vnoremap <leader>y :<c-u>call CopyOperator(visualmode())<cr>
" }}}

" GRAMMAR Auto-correction {{{
" Based on this tutorial https://www.youtube.com/watch?v=lwD8G1P52Sk&t=18s
function! FixSpellingError()
    normal! mm[s1z=`m
endfunction

function! MultiChoiceFixSpellingError()
    execute 'normal! mm[sz='
    let choice=input('Choice: ')
    silent execute 'normal! ' . choice . 'z=`m'
endfunction

function! ModifyWord()
    execute 'normal! z='
    let choice=input('Choice: ')
    silent execute 'normal! ' . choice . 'z='
endfunction

nnoremap <leader>lc :call FixSpellingError()<CR>
nnoremap <leader>lC :call MultiChoiceFixSpellingError()<CR>
nnoremap <leader>lm :call ModifyWord()<CR>

function! SetSpellang(lang)
    if &spelllang != a:lang || &spell == 0
        execute 'set spell spelllang=' . a:lang
        echo 'Set lang : ' . a:lang
        set complete+=kspell
    else
        echo 'Deactivate : ' . &spelllang
        set nospell
    end
endfunction

nnoremap <leader>le :call SetSpellang("en")<CR>
nnoremap <leader>ls :call SetSpellang("es")<CR>
nnoremap <leader>lf :call SetSpellang("fr")<CR>
nnoremap <leader>ln :call SetSpellang("nl")<CR>
" }}}

" GRAMMAR Current typos {{{
iabbrev therefor therefore
iabbrev Therefor Therefore
" }}}

" General mapping {{{
augroup general_mappings
    autocmd!
    nnoremap <leader>v :e ~/.vimrc<CR>
augroup END
" }}}

" rk {{{
    command -nargs=* -complete=file -bar RK :call system('rk ' . '<args> &')
" }}}

" Compiler {{{
function! EnableQuickfixOnError()
    if g:asyncrun_status == 'failure'
        copen
    else
        echo g:asyncrun_status
    end
endfunction

function! SetLMake()
    let &l:makeprg=input("Make: ", &l:makeprg)
    let b:recipe=input("Recipe: ", b:recipe)
endfunction

function! SetMake()
    let &g:makeprg=input("Make: ", &g:makeprg)
    let g:recipe=input("Recipe: ", g:recipe)
endfunction

function! LockMake()
    let &g:makeprg=&l:makeprg
    let g:recipe=b:recipe
endfunction

function! SetXprg()
    let b:xprg=input("Xprg: ", b:xprg)
    let b:xrecipe=input("Xrecipe: ", b:xrecipe)
endfunction

let xprg="/usr/bin/zathura"
let xrecipe=" "
let makeprg="/usr/bin/make"
let recipe=" "

command -nargs=* -complete=file -bar LMake :execute('AsyncRun -silent -save=2 -mode=async -post=call\ EnableQuickfixOnError() ' . expand(&l:makeprg) . ' <args>')
command -nargs=* -complete=file -bar Make :execute('AsyncRun -silent -save=2 -mode=async -post=call\ EnableQuickfixOnError() ' . expand(&g:makeprg) . ' <args>')
command -nargs=* -complete=file -bar LDebug :execute('AsyncRun -silent -save=2 -mode=terminal -pos=tab ' . expand(&l:makeprg) . ' <args>')
command -nargs=* -complete=file -bar Debug :execute('AsyncRun -silent -save=2 -mode=terminal -pos=tab ' . expand(&g:makeprg) . ' <args>')
command -nargs=* -complete=file -bar Xprg :silent execute('!' . b:xprg . ' ' . '<args>' . ' &')

nnoremap <leader>c :execute('LMake '. b:recipe)<CR>
nnoremap <leader>d :execute('LDebug '. b:recipe)<CR>

nnoremap <leader>C :execute('Make '. g:recipe)<CR>
nnoremap <leader>D :execute('Debug '. g:recipe)<CR>

nnoremap <leader>m :call SetLMake()<CR>
nnoremap <leader>M :call SetMake()<CR>

nnoremap <leader>L :call LockMake()<CR>

nnoremap <leader>x :call SetXprg()<CR>
nnoremap <leader>p :execute("Xprg " . b:xrecipe)<CR>:redraw!<CR>
" }}}

" FILETYPE Markdown {{{
augroup markdown_group
    autocmd!
    autocmd Filetype markdown setlocal makeprg=pandoc 
    autocmd Filetype markdown let b:recipe='-s ' . expand('%') . ' -o ' . expand('%:p:r') . '.pdf' 
    autocmd Filetype markdown let b:xprg="zathura" 
    autocmd Filetype markdown let b:xrecipe=expand('%:p:r') . '.pdf'" "
    autocmd Filetype markdown setlocal keywordprg=clear\ \&\ trans\ :fr
augroup END
" }}}

" FILETYPE python {{{
augroup python_group
    autocmd!
    autocmd Filetype python set keywordprg=$CONDA_PREFIX/bin/pydoc
    autocmd Filetype python setlocal cc=80
    autocmd Filetype python nnoremap <leader><leader> Oimport ipdb; ipdb.set_trace() ###!!!BREAKPOINT!!!<Esc>j
    autocmd Filetype python setlocal makeprg=python | let b:recipe=expand('%')
augroup END
" }}}

" FILETYPE Vim {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType vim nnoremap <leader>V :w<CR>:source %<CR>
augroup END
" }}}

" (FILETYPE) Pytest {{{
augroup pytest_group
    autocmd BufNewFile,BufRead test*.py setlocal makeprg=python\ -m\ pytest\ -s
    autocmd BufNewFile,BufRead test*.py let b:recipe=expand('%')
    autocmd BufNewFile,BufRead test*.py setlocal efm+=
          \%EE\ \ \ \ \ File\ \"%f\"\\,\ line\ %l,
          \%CE\ \ \ %p^,
          \%ZE\ \ \ %[%^\ ]%\\@=%m,
          \%Afile\ %f\\,\ line\ %l,
          \%+ZE\ %mnot\ found,
          \%CE\ %.%#,
          \%-G_%\\+\ ERROR%.%#\ _%\\+,
          \%A_%\\+\ %o\ _%\\+,
          \%C%f:%l:\ in\ %o,
          \%ZE\ %\\{3}%m,
          \%EImportError%.%#\'%f\'\.,
          \%C%.%#,
          \%+G%[=]%\\+\ %*\\d\ passed%.%#,
          \%-G%[%^E]%.%#,
          \%-G
augroup END
" }}}

" FILETYPE HTML {{{
augroup html_group
    autocmd BufNewFile,BufRead *.vue set filetype=html
augroup END
" }}}

" FILETYPE scad {{{
augroup scad_group
    autocmd!
    autocmd FileType openscad let b:xprg='openscad' | let b:xrecipe=expand('%')
augroup END
" }}}

" FILETYPE sh {{{
augroup sh_group
    autocmd!
    autocmd BufNewFile,BufRead *.sh setlocal makeprg=sh | let b:recipe=expand('%')
    setlocal fdm=marker
augroup END
" }}}

" FILETYPE latex {{{
augroup latex
    autocmd!
    autocmd Filetype tex setlocal makeprg=pdflatex\ -interaction\=nonstopmode 
    autocmd Filetype tex let b:recipe=expand('%') 
    autocmd Filetype tex let b:xprg='zathura'
    autocmd Filetype tex let b:xrecipe=expand('%:r') . '.pdf' 
    " Extend filetype
    autocmd BufNewFile,BufRead *.cls set filetype=tex
    autocmd BufNewFile,BufRead *.tikz set filetype=tex
    autocmd BufNewFile,BufRead *.pdf_tex set filetype=tex
    " Set dictionnary
    autocmd Filetype tex set dictionary+=~/.vim/dictionnary/ref
    " Define snippets
    autocmd Filetype tex setlocal efm+=
            \%E!\ LaTeX\ %trror:\ %m,
            \%E!\ %m,
            \%+WLaTeX\ %.%#Warning:\ %.%#line\ %l%.%#,
            \%+W%.%#\ at\ lines\ %l--%*\\d,
            \%WLaTeX\ %.%#Warning:\ %m,
            \%Cl.%l\ %m,
            \%+C\ \ %m.,
            \%+C%.%#-%.%#,
            \%+C%.%#[]%.%#,
            \%+C[]%.%#,
            \%+C%.%#%[{}\\]%.%#,
            \%+C<%.%#>%.%#,
            \%C\ \ %m,
            \%-GSee\ the\ LaTeX%m,
            \%-GType\ \ H\ <return>%m,
            \%-G\ ...%.%#,
            \%-G%.%#\ (C)\ %.%#,
            \%-G(see\ the\ transcript%.%#),
            \%-G\\s%#,
            \%+O(%f)%r,
            \%+P(%f%r,
            \%+P\ %\\=(%f%r,
            \%+P%*[^()](%f%r,
            \%+P[%\\d%[^()]%#(%f%r,
            \%+Q)%r,
            \%+Q%*[^()])%r,
            \%+Q[%\\d%*[^()])%r,
augroup end
" }}}
