" In normal & insert mode, meta-shift-right should take us to the current
" word’s end (e), while meta-shift-left takes us to its start (b).
"
nnoremap <M-S-Right> ve
nnoremap <M-S-Left> vb
inoremap <M-S-Right> <Esc> ve
inoremap <M-S-Left> <Esc> vb

" ----------------------------------------------------------------------

function! _byte_offset(my_expr)
    return line2byte(line(a:my_expr)) + col(a:my_expr)
endfunction

function! _cur_word_startidx()
    let curword = expand("<cword>")
    " echom "curword: [" . curword . "]"
    let word_length = strlen(curword)
    let curline = getline(".")
    let curcolidx = col(".")
    let line_offset = line2byte(line("."))

    let chars_left = word_length
    while chars_left > 0
        let curcolidx = curcolidx - 1
        let chars_left = chars_left - 1
        let curstr = strpart(curline, curcolidx, word_length)
        " echo "curstr: [" . curstr . "]"
        if curstr == curword
            return curcolidx + line_offset
        endif
    endwhile

    return col(".") + line_offset
endfunction

function! _cur_word_endidx()
    let startidx = _cur_word_startidx()
    return startidx + strlen(expand("<cword>")) - 1
endfunction

function! VisualWordShiftRight()
    let cursor_offset = _byte_offset(".")
    let selection_start_offset = _byte_offset("v")

    if cursor_offset >= selection_start_offset
        " echom "later: "
        let extn = "e"
    elseif _cur_word_endidx() > selection_start_offset
        " echom "later, cross start"
        let extn = "e"
    else
        " echom "not later: "
        let extn = "w"
    endif

    echom "returning: " . extn

    return extn
endfunction

function! VisualWordShiftLeft()
    let cursor_offset = _byte_offset(".")
    let selection_start_offset = _byte_offset("v")
    " echom "left; cursor=" . cursor_offset . "; selstart=" . selection_start_offset

    if cursor_offset <= selection_start_offset
        " echom "left in leftward selection"
        let extn = "b"
    elseif _cur_word_startidx() < selection_start_offset
        " echom "left in rightward selection, crossing start"
        " echom "word=" . expand('<cword>') . "; start=" . _cur_word_startidx()
        let extn = "b"
    else
        " echom "left in rightward selection, NOT crossing cursor"
        let extn = "ge"
    endif

    return extn
endfunction

" ----------------------------------------------------------------------

" In visual mode:
"   If cursor >= selection start, then M-S-R should take us to the current
"       word’s end (e), while MSL takes us to the prior word’s end (ge),
"       as long as that doesn’t move the cursor to earlier than the selection
"       start, in which case we should go to the current word’s start.
"   If cursor < selection start, then M-S-L goes to the prior word’s start (b).
"       M-S-R goes to the next word’s start (w), as long as that doesn’t cross
"       the cursor, in which case we should go the current word’s end (e).
"
vnoremap <expr> <M-S-Right> VisualWordShiftRight()
vnoremap <expr> <M-S-Left> VisualWordShiftLeft()
