" For writing React, turns 'word' into 'const [word, setWord] = useState();'
fun! CreateUseState()
    let varName = expand("<cword>")
    let capitalized = substitute(varName, '\v(\a)', '\u\1', "")
    let output = "const [" . varName . ", set" . capitalized . "] = useState();"
    call setline(".", substitute(getline("."), varName, output, ""))
    call cursor("0", col("$") - 2)
endf
nnoremap <buffer> <leader>cus :call CreateUseState()<CR>i
