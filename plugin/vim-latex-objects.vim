if !exists("g:latex_select_math_lines")
    let g:latex_select_math_lines = 0
end

function! <sid>NextEnd()
    let curline = line(".") + 1
    let begins = getline(".") !~ '.*\\end.*$'
    while begins > 0
        if getline(curline) =~ '.*\\begin.*$'
            let begins += 1
        endif
        if getline(curline) =~ '.*\\end.*$'
            let begins -= 1
        endif

        let curline += 1
    endwhile

    return curline - 1
endfunction

function! <sid>PrevBegin()
    let curline = line(".") - (getline(".") =~ '.*\\end.*$')
    let ends = 1
    while ends > 0
        if getline(curline) =~ '.*\\begin.*$'
            let ends -= 1
        endif
        if getline(curline) =~ '.*\\end.*$'
            let ends += 1
        endif

        let curline -= 1
    endwhile

    return curline + 1
endfunction

function! <sid>SelectInEnvironment(surround)
    let start = <sid>PrevBegin()
    let end = <sid>NextEnd()

    keepjumps call cursor(start, 0)
    if !a:surround
        normal! j
    end
    normal! V
    keepjumps call cursor(end, 0)
    if !a:surround
        normal! k
    end
endfunction

" Operate on environments (that have begin and ends on separate lines)
xnoremap <silent> ie <ESC>:call <sid>SelectInEnvironment(0)<CR>
xnoremap <silent> ae <ESC>:call <sid>SelectInEnvironment(1)<CR>

nnoremap  <SID>(V) V
onoremap <silent> ie :execute "keepjumps normal \<SID>(V)ie"<CR>
onoremap <silent> ae :execute "keepjumps normal \<SID>(V)ae"<CR>

" Operate on math
function! SelectInMath(surround)
    let next = search('\$\|\(\\]\)\|\(\\)\)', 'ncpW')
    let [nextLine, nextCol] = searchpos('\$\|\(\\]\)\|\(\\)\)', 'ncW')
    if next == 1
        let prev = search('\$', 'ncpWb')
        let [prevLine, prevCol] = searchpos('\$', 'ncWb')
    elseif next == 2
        let prev = search('\\[', 'ncpWb')
        let [prevLine, prevCol] = searchpos('\\[', 'ncWb')
    elseif next == 3
        let prev = search('\\(', 'ncpbW')
        let [prevLine, prevCol] = searchpos('\\(', 'ncbW')
    end

    if next == 1
        let delimLen = 1
    else
        let delimLen = 2
    end

    if !a:surround 
        if len(getline(prevLine)) <= prevCol + delimLen
            let prevLine = prevLine + 1
            let prevCol = -delimLen + 1
        end

        if nextCol <= 1
            let nextLine = nextLine - 1
            let nextCol = len(getline(nextLine)) + 1
        end
    end

    if a:surround
        call cursor(prevLine, prevCol)
    else
        call cursor(prevLine, prevCol + delimLen)
    end

    if g:latex_select_math_lines && next == 2
        normal! V
    else
        normal! v
    end
    if a:surround
        call cursor(nextLine, nextCol + delimLen - 1)
    else
        call cursor(nextLine, nextCol - 1)
    end
endfunction

" Use % to jump between begin/end
function! MatchedBlock()
    if getline(line(".")) =~ '.*\\begin.*$'
        normal! j
        call cursor(NextEnd(), 0)
    elseif getline(line(".")) =~ '.*\\end.*$'
        normal! k
        call cursor(PrevBegin(), 0)
    else
        normal! %
    end
endfunction

function! VisualMatchedBlock()
    let start = line(".")
    call MatchedBlock()
    let end = line(".")

    call cursor(start, 0)
    exec "normal!" . visualmode()
    call cursor(end, 0)
endfunction
