vnoremap <buffer> im <ESC>:call SelectInMath(0)<CR>
vnoremap <buffer> am <ESC>:call SelectInMath(1)<CR>
omap <buffer> im :normal vim<CR>
omap <buffer> am :normal vam<CR>

" Operate on LaTeX quotes
vmap <buffer> iq <ESC>?``<CR>llv/''<CR>h
omap <buffer> iq :normal viq<CR>
vmap <buffer> aq <ESC>?``<CR>v/''<CR>l
omap <buffer> aq :normal vaq<CR>

map <buffer> % :call MatchedBlock()<CR>
vmap <buffer> % :call VisualMatchedBlock()<CR>

" Mathematica mappings
imap <buffer> <C-6> ^{}
imap <buffer> <C-^> ^{}
imap <buffer> <C--> _{}
imap <buffer> <C-_> _{}
