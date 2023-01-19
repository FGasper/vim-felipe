set list

function! _setFGTabs()
    set listchars=trail:_,lead:*,leadmultispace:*...
endfunction

function! _setFGSpaces()
    set expandtab
    set shiftround

    set listchars=trail:_,tab:>-
endfunction

if &filetype == "go"
    call _setFGTabs()
else
    call _setFGSpaces()
endif
