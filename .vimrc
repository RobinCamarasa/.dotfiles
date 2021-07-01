""""""""""""
" SETTINGS "
""""""""""""
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
set omnifunc=syntaxcomplete
set shortmess+=c
set exrc
set incsearch
set ruler
set path+=**
set display+=lastline
set autoread

""""""""""""
" PLUGGINS "
""""""""""""

call plug#begin('~/.vim/plugged')
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

call plug#end()

"""""""""""""""""""""
" PLUGGINS SETTINGS "
"""""""""""""""""""""

" tpope/vim-fugitive
nnoremap <leader>h :Git blame<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gm :Git mergetool<CR>

" Color scheme
" See github https://github.com/tomasr/molokai
let g:molokai_original = 1
colorscheme molokai

"""""""""""
" GENERAL "
"""""""""""

" Terminal mode
tnoremap <leader><Esc> <C-\><C-n>:q!<CR>

" Insert mode
inoremap <C-e> <C-]>

" Normal mode
nnoremap Y y$
nnoremap gd <C-]>
nnoremap <leader>y :call system('xsel --clipboard', @0)<CR>
nnoremap S :%s//g<Left><Left>
nnoremap s :s//g<Left><Left>
nnoremap <leader>f :ls<CR>:b 

" Visual mode
vnoremap s :s//g<Left><Left>

""""""""""""""""""
" SYNTAX CHECKER "
""""""""""""""""""

" Based on this tutorial https://www.youtube.com/watch?v=lwD8G1P52Sk&t=18s 
function! FixSpellingError()
    normal! mm[s1z=`m
endfunction
nnoremap <leader>lc :call FixSpellingError()<CR>

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

"""""""""""""""
" COMPILATION "
"""""""""""""""

" Default compilation protocol
function! Compile()
    if version >= 800
        execute 'AsyncRun -program=make -C ' . expand('%:p:h')
    else
        execute 'make -C ' . expand('%:p:h')
    end
endfunction

nnoremap <leader>c :call Compile()<CR>


"""""""""
" VIMRC "
"""""""""

" vimrc shortcuts
nnoremap <leader>v :e ~/.vimrc<CR>
nnoremap <leader>V :w<CR>:source %<CR>

"""""""""
" LATEX "
"""""""""

" Set file types
autocmd BufNewFile,BufRead *.cls set filetype=tex
autocmd BufNewFile,BufRead *.tikz set filetype=tex
autocmd BufNewFile,BufRead *.pdf_tex set filetype=tex

" Set dictionary
au Filetype tex set dictionary+=~/.vim/dictionnary/ref

" Latex commands (consider snippets)
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

" Compilation
let g:latex_compile="build"
let g:latex_bib="bib"

function! VisualizePdf()
    silent execute ':!zathura %:p:h/*.pdf &'
    execute ':redraw!'
endfunction

function! CompileLatex()
    set errorformat=%f:%l:\ %m
    if version >= 800
        execute 'AsyncRun -program=make -post=call\ EnableQuickfixOnError() ' . g:latex_compile
    else
        silent execute ':make ' . g:latex_compile
    end
endfunction

function! CompileLatexBib()
    set errorformat=%f:%l:\ %m
    if version >= 800
        execute 'AsyncRun -program=make -post=call\ EnableQuickfixOnError() ' . g:latex_bib
    else
        silent execute ':make ' . g:latex_bib
    end
endfunction

autocmd Filetype tex nnoremap <leader>p :call VisualizePdf()<CR>
autocmd Filetype tex nnoremap <leader>c :call CompileLatex()<CR>
autocmd Filetype tex nnoremap <leader>b :call CompileLatexBib()<CR>

""""""""""""
" MARKDOWN "
""""""""""""

" Compile
let g:md_make=0
let g:md_compile='build'
let g:md_location='/tmp/file'

function! CompileMarkdown()
    if filereadable('Makefile')
        set makeprg=make
        if version >= 800
            execute 'AsyncRun -program=make -post=call\ EnableQuickfixOnError() ' . g:md_compile
        else
            silent execute ':make ' . g:md_compile
        end
    else
        set makeprg=pandoc
        silent execute ':!rm -f ' . g:md_location . '.md'
        silent execute ':!ln -s %:p ' . g:md_location . '.md'
        execute ':redraw!'
        if version >= 800
            execute 'AsyncRun -program=make -post=call\ EnableQuickfixOnError() -s ' . g:md_location . '.md --listings -o ' . g:md_location . '.pdf'
        else
            silent execute ':make -s ' . g:md_location . '.md --listings -o ' . g:md_location . '.pdf'
        end
    end
endfunction

" Visualize
function! VisualizeMarkdown()
    if filereadable('Makefile')
        silent execute '!zathura *.pdf &'
        execute ':redraw!'
    else
        silent execute '!zathura ' . g:md_location . '.pdf &'
        execute ':redraw!'
    end
endfunction

autocmd Filetype markdown nnoremap <leader>c :call CompileMarkdown()<CR>
autocmd Filetype markdown nnoremap <leader>p :call VisualizeMarkdown()<CR>

""""""""""
" PYTHON "
""""""""""

" General
autocmd Filetype tex,markdown set dictionary+=~/.vim/dictionnary/ref
autocmd Filetype python set keywordprg=$CONDA_PREFIX/bin/pydoc

" Python commands (consider snippets)
" autocmd Filetype python iabbrev <buffer> 
autocmd Filetype python nnoremap <leader><leader> Oimport ipdb; ipdb.set_trace() ###!!!BREAKPOINT!!!<Esc>j
autocmd Filetype python inoremap ,hh """<CR>**Author** : Robin Camarasa<CR><CR>**Institution** : Erasmus Medical Center<CR><CR>**Position** : PhD student<CR><CR>**Contact** : r.camarasa@erasmusmc.nl<CR><CR>**Date** : <Esc>:pu=strftime('%Y-%m-%d')<CR>kJ$o<CR>**Project** : <CR><CR>****<CR><CR>"""<Esc>v4k<$

" Compilation
function! SetPythonMake()
    normal! mm
    ?^def
    normal 2e"fyiw
    let g:pytest=1
    if match(@f, "^test") != -1
        set makeprg=$CONDA_PREFIX/bin/pytest
        let g:command=$CONDA_PREFIX . '/bin/python -m pytest -s ' . expand('%:p') . '::' . @f
        let @c= expand('%:p') . '::' . @f
        set errorformat=
          \%-G=%#\ ERRORS\ =%#,
          \%-G=%#\ FAILURES\ =%#,
          \%-G%\\s%\\*%\\d%\\+\ tests\ deselected%.%#,
          \ERROR:\ %m,
          \%E_%\\+\ %m\ _%\\+,
          \%Cfile\ %f\\,\ line\ %l,
          \%CE\ %#%m,
          \%EE\ \ \ \ \ File\ \"%f\"\\,\ line\ %l,
          \%ZE\ \ \ %[%^\ ]%\\@=%m,
          \%Z%f:%l:\ %m,
          \%Z%f:%l,
          \%C%.%#,
          \%-G%.%#\ seconds,
          \%-G%.%#,
    else
        set makeprg=$CONDA_PREFIX/bin/python
        let g:pytest=0
        let g:command=$CONDA_PREFIX .'/bin/python ' . expand('%:p')
        let @c=expand('%:p')
        set errorformat=
          \%*\\sFile\ \"%f\"\\,\ line\ %l\\,\ %m,
          \%*\\sFile\ \"%f\"\\,\ line\ %l,
    end
    call system('xsel --clipboard', g:command)
    normal! `m
endfunction

function! EnableQuickfixOnError()
    if g:asyncrun_status == 'failure'
        copen
    else
        echo g:asyncrun_status
    end
endfunction

function! SleepAndClose()
    sleep 200m
    execute 'quit'
endfunction

function! CompilePython()
    if version >= 800
        execute 'AsyncRun -program=make -post=call\ EnableQuickfixOnError() ' . @c
    else
        silent execute ':make ' . @c
        execute ':redraw!'
        copen
    end
endfunction

function! DebugPython()
    if g:pytest == 0
        if version >= 800
            execute 'AsyncRun -program=make -mode=terminal -post=call\ SleepAndClose() ' . @c
        else
            silent execute ':!' . g:command
            execute ':redraw!'
        end
    else
        if version >= 800
            execute 'AsyncRun -mode=terminal -post=call\ SleepAndClose() ' . g:command
        else
            silent execute ':!' . g:command
            execute ':redraw!'
        end
    end
endfunction

autocmd Filetype python nnoremap <leader>m :call SetPythonMake()<CR>
autocmd Filetype python nnoremap <leader>c :call CompilePython()<CR>
autocmd Filetype python nnoremap <leader>d :call DebugPython()<CR>

"""""""""
" Shell "
"""""""""

" Compilation
function! SetShellMake()
    set makeprg=shellcheck\ -e\ SC1090\ -f\ gcc\ --\ %:S
    set errorformat=%f:%l:%c:\ %m\ [SC%n]
    let g:command='sh ' . expand('%:p')
    call system('xsel --clipboard', g:command)
    let @c=expand('%:p')
endfunction


function! LinterShell()
    set makeprg=shellcheck\ -e\ SC1090\ -f\ gcc\ --\ %:S
    if version >= 800
        execute 'AsyncRun -program=make -post=call\ EnableQuickfixOnError() "' . @c . '"'
    else
        silent execute ':make "' . @c . '"'
        execute ':redraw!'
        copen
    end
endfunction


function! CompileShell()
    if version >= 800
        execute 'AsyncRun -mode=terminal sh ' . @c
    else
        execute ':!sh ' . @c
        execute ':redraw!'
        copen
    end
endfunction

autocmd Filetype sh nnoremap <leader>m :call SetShellMake()<CR>
autocmd Filetype sh nnoremap <leader>c :call CompileShell()<CR>
autocmd Filetype sh nnoremap <leader>l :call LinterShell()<CR>

"""""
" C "
"""""

" Compilation
let g:c_make_compile='build'
let g:c_make_run='run'
let g:c_make_debug_compile='debug_build'
let g:c_make_debug_run='debug_run'
let g:c_compile='build'
let g:c_run='run'
let g:c_debug=0
let g:c_make=1

function! SetCMake()
    if filereadable('Makefile')
        let g:c_make=1
        set makeprg=make
        let g:command='make ' . g:c_compile
    else
        let g:c_make=0
        echo "No Makefile"
        let g:c_entrypoint=expand('%:p')
        if g:c_debug == 0
            let g:command='gcc ' . g:c_entrypoint . ' -o out'
            let g:cc_compile=g:command
            let g:cc_run='bash -c "./out"'
        else
            set makeprg=gdb
            let g:command='gcc -g ' . g:c_entrypoint . ' -o out'
            let g:cc_compile=g:command
            let g:cc_run='out'
        end
    end
    call system('xsel --clipboard', g:command)
endfunction

function! SetDebugMode()
    if g:c_debug == 0
        let g:c_debug=1
        let g:c_compile=g:c_make_debug_compile
        let g:c_run=g:c_make_debug_run
        echo 'Debug mode'
    else
        let g:c_debug=0
        let g:c_compile=g:c_make_compile
        let g:c_run=g:c_make_run
        echo 'Build mode'
    end
    silent call SetCMake()
endfunction

function! CompileC()
    if g:c_make == 1
        if version >= 800
            execute 'AsyncRun -program=make -post=call\ EnableQuickfixOnError() ' . g:c_compile
        else 
            silent execute ':make ' . g:c_compile
            execute ':redraw!'
            copen
        end
    else
        if version >= 800
            execute 'AsyncRun -post=call\ EnableQuickfixOnError() ' . g:cc_compile
        else
            silent execute ':!' . g:cc_compile
            execute ':redraw!'
            copen
        end
    end
endfunction

function! RunC()
    if g:c_make == 1
        if g:c_debug == 1
            if version >= 800
                execute 'AsyncRun -program=make -mode=terminal -post=call\ SleepAndClose() ' . g:c_run
            else
                silent execute ':!make ' . g:c_run
                execute ':redraw!'
            end
        else
            if version >= 800
                execute 'AsyncRun -program=make -mode=terminal ' . g:c_run
            else
                execute ':!make ' . g:c_run
                execute ':redraw!'
            end
        end
    else
        if g:c_debug == 1
            if version >= 800
                execute 'AsyncRun -program=make -mode=terminal -post=call\ SleepAndClose() ' . g:cc_run
            else
                silent execute ':!gdb out'
                execute ':redraw!'
            end
        else
            if version >= 800
                execute 'AsyncRun -mode=terminal ' . g:cc_run
            else
                execute ':!' . g:cc_run
                execute ':redraw!'
            end
        end
    end
endfunction

autocmd Filetype c nnoremap <leader>m :call SetCMake()<CR>
autocmd Filetype c nnoremap <leader>c :call CompileC()<CR>
autocmd Filetype c nnoremap <leader>r :call RunC()<CR>
autocmd Filetype c nnoremap <leader>d :call SetDebugMode()<CR>

""""""""
" HTML "
""""""""

" Set file type
autocmd BufNewFile,BufRead *.vue set filetype=html

""""""""
" Tags "
""""""""

function! RunCtags() 
    if version >= 800
        execute 'AsyncRun -post=call\ EnableQuickfixOnError() ctags -R . ${CONDA_PREFIX}/lib/*/site-packages/'
    else
        silent execute ':!ctags -R . ${CONDA_PREFIX}/lib/*/site-packages/'
        silent execute ':redraw!'
    end
endfunction

nnoremap <leader>t :call RunCtags()<CR>

"""""""""""
" English "
"""""""""""

iabbrev therefor therefore
iabbrev Therefor Therefore

