" Vim Options {{{
let mapleader=" "
let g:netrw_banner=0
filetype indent plugin on
syntax on
set clipboard=unnamed
set belloff=all
set number relativenumber
set autoindent
set expandtab
set shiftwidth=4
set omnifunc=ale#completion#OmniFunc
set shortmess+=c
set exrc
set incsearch
set ruler
set path+=**
set display+=lastline
set autoread
" }}}

" Vim plugins {{{
call plug#begin('~/.vim/plugged')
    " Auto completion
    Plug 'dense-analysis/ale'

    " Auto pairing
    Plug 'jiangmiao/auto-pairs'

    " Change surrounding
    Plug 'tpope/vim-surround'

    " Change commentary
    Plug 'tpope/vim-commentary'

    " Handle repition with plugins
    Plug 'tpope/vim-repeat'

    " Handle Git
    Plug 'tpope/vim-fugitive'

    " Asynchronous jobs
    Plug 'skywind3000/asyncrun.vim'

    " Autoscad
    Plug 'sirtaj/vim-openscad'

    " Snippets
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'

    Plug 'blindFS/vim-taskwarrior'

call plug#end()
" }}}

" Plugin Fugitive {{{
nnoremap <leader>h :Git blame<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gm :Git mergetool<CR>
"}}}

" Colorscheme {{{
" See github https://github.com/tomasr/molokai
let g:molokai_original = 1
colorscheme molokai
" }}}

" Terminal mode {{{
tnoremap <Esc> <C-w>N
tnoremap <C-w>p <C-w>"0
"}}}

" Insert mode {{{
inoremap <C-e> <C-]>
" }}}

" Normal mode {{{
nnoremap Y y$
nnoremap gd <C-]>
nnoremap <leader>y :call system('xsel --clipboard', @0)<CR>
nnoremap S :%s//g<Left><Left>
nnoremap s :s//g<Left><Left>
augroup write_group
    autocmd BufWrite * :%s/\s*$//g
augroup END
" }}}

" Visual mode {{{
vnoremap s :s//g<Left><Left>
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

" SCREENSHOT {{{
function! ScreenSelect(name)
    execute system("rm -rf 'screenshots/" . a:name .  ".png'")
    execute system("mkdir -p screenshots")
    execute system("sleep 2; scrot 'screenshots/" . a:name .  ".png' -d 1 --select -z")
endfunction

command -nargs=* -complete=file -bar SC :execute('call ScreenSelect("' . '<args>")')
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

" PLUGIN ALE {{{
let g:ale_linters = {
      \   'python': ['flake8', 'pylint', 'pylsp'],
      \   'ruby': ['standardrb', 'rubocop'],
      \   'javascript': ['eslint'],
      \}
let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \   'python': [
          \ 'black', 'isort',
          \ 'add_blank_lines_for_python_control_statements', 'autoflake',
          \ 'autoimport', 'autopep8',
          \ 'black', 'isort',
          \ 'reorder-python-imports', 'yapf',
          \ 'remove_trailing_lines', 'trim_whitespace',
          \ ]
      \}

let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 0
let g:ale_fix_on_save = 0
" }}}

" Ctags {{{
function! RunCtags()
    if version >= 800
        execute 'AsyncRun -post=call\ EnableQuickfixOnError() ctags -R . ${CONDA_PREFIX}/lib/*/site-packages/'
    else
        silent execute ':!ctags -R . ${CONDA_PREFIX}/lib/*/site-packages/'
        silent execute ':redraw!'
    end
endfunction
nnoremap <leader>t :call RunCtags()<CR>
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
    autocmd Filetype markdown set dictionary+=~/.vim/dictionnary/ref
    autocmd BufNewFile,BufRead markdown setlocal makeprg=pandoc 
    autocmd Filetype markdown let b:recipe='-s ' . expand('%') . ' -o ' . expand('%:p:r') . '.pdf' 
    autocmd Filetype markdown let b:xprg="zathura" 
    autocmd Filetype markdown  let b:xrecipe=expand('%:p:r') . '.pdf'" "
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
    autocmd BufNewFile,BufRead *.scad set filetype=scad
    autocmd FileType scad let b:xprg='openscad' | let b:xrecipe=expand('%')
augroup END
" }}}

" FILETYPE sh {{{
augroup sh_group
    autocmd BufNewFile,BufRead *.sh setlocal makeprg=sh | let b:recipe=expand('%')
augroup END
" }}}

" FILETYPE latex {{{
augroup latex
    autocmd!
    autocmd BufNewFile,BufRead tex setlocal makeprg=pdflatex\ -interaction\=nonstopmode 
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
    autocmd Filetype tex iabbrev <buffer> xse \section{}<Esc>i
    autocmd Filetype tex iabbrev <buffer> xsu \subsection{}<Esc>i
    autocmd Filetype tex iabbrev <buffer> xsb \subsubsection{}<Esc>i
    autocmd Filetype tex iabbrev <buffer> xfi \begin{figure}[ht]<CR>    \includegraphics[width=\textwidth]{}<CR>\end{figure}<Esc>$kT=i
    autocmd Filetype tex iabbrev <buffer> xff \begin{frame}{}<CR>\end{frame}<ESC>k$i
    autocmd Filetype tex iabbrev <buffer> xfe \begin{frame}{\insertsection}<CR>\end{frame}<ESC>O
    autocmd Filetype tex iabbrev <buffer> xfu \begin{frame}{\insertsubsection}<CR>\end{frame}<ESC>O
    autocmd Filetype tex iabbrev <buffer> xcs \begin{columns}<CR>\end{columns}<ESC>O
    autocmd Filetype tex iabbrev <buffer> xcc \begin{column}{\textwidth}<CR>\end{column}<ESC>k$F\i
    autocmd Filetype tex iabbrev <buffer> xit \item
    autocmd Filetype tex iabbrev <buffer> xbe \begin{##}<cr>\end{##}<esc>kvj:s/##/
    autocmd Filetype tex iabbrev <buffer> xbp \begin{itemize}<esc>yyplciwend<esc>O\item
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
