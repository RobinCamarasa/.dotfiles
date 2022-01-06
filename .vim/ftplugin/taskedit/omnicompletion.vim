function! CompletionFunction(findstart, base)
    if a:findstart
        normal! mmB
        let start = col('.') - 1
        normal! `m
        return start
    else
        echom a:base
        " Define complete project
        let projects=sort(split(system('task _projects')))
        for project in projects
            if (project =~ '^' . a:base)
                call complete_add(project)
            elseif ('project:' . project =~ '^' . a:base)
                call complete_add('project:' . project)
            endif
        endfor

        " Define complete tags
        let tags=sort(split(system('task _tags')))
        for tag in tags
            if tag =~ '^' . a:base
                call complete_add(tag)
            endif
        endfor

        " Define complete dates
        if a:base =~ '^\v[0-9]{4}$' ||  a:base =~ '^\v[0-9]{4}-[0-9]{2}$'
            call complete_add(a:base . '-')
        endif
        if a:base =~ '\v[0-9]{4}-$'
            echom "match"
            for i in range(1, 12)
                if i < 10
                    call complete_add(a:base . '0' . i . '-')
                else
                    call complete_add(a:base . i . '-')
                endif
            endfor
        endif
        if a:base =~ '\v[0-9]{4}-[0-9]{2}-$'
            for i in range(1, 31)
                if i < 10
                    call complete_add(a:base . '0' . i)
                else
                    call complete_add(a:base . i)
                endif
            endfor
        endif
        if a:base =~ '\v[0-9]{4}-[0-9]{2}-[0-9]{2}$'
            call complete_add(a:base . 'T00:00:00')
            for i in range(0, 23)
                if i < 10
                    call complete_add(a:base . 'T0' . i . ':')
                else
                    call complete_add(a:base . 'T' . i . ':')
                endif
            endfor
        endif
        if a:base =~ '\v[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:$'
            for i in range(0, 60, 5)
                if i < 10
                    call complete_add(a:base . '0' . i . ':00')
                else
                    call complete_add(a:base . i . ':00')
                endif
            endfor
        endif
    endif
endfunction

set completefunc=CompletionFunction
set omnifunc=CompletionFunction
