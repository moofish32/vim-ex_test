let s:plugin_path = expand("<sfile>:p:h:h")
let s:default_command = "mix test {test}"
let s:force_gui = 0

if !exists("g:ex_test_runner")
  let g:ex_test_runner = "os_x_terminal"
endif

function! RunAllTests()
  let s:last_test = "test"
  call s:RunTests(s:last_test)
endfunction

function! RunCurrentTestFile()
  if s:InTestFile()
    let s:last_test_file = s:CurrentFilePath()
    let s:last_test = s:last_test_file
    call s:RunTests(s:last_test_file)
  elseif exists("s:last_test_file")
    call s:RunTests(s:last_test_file)
  endif
endfunction

function! RunNearestTest()
  if s:InTestFile()
    let s:last_test_file = s:CurrentFilePath()
    let s:last_test_file_with_line = s:last_test_file . ":" . line(".")
    let s:last_test = s:last_test_file_with_line
    call s:RunTests(s:last_test_file_with_line)
  elseif exists("s:last_test_file_with_line")
    call s:RunTests(s:last_test_file_with_line)
  endif
endfunction

function! RunLastTest()
  if exists("s:last_test")
    call s:RunTests(s:last_test)
  endif
endfunction

" === local functions ===

function! s:RunTests(test_location)
  let s:ex_test_command = substitute(s:ExTestCommand(), "{test}", a:test_location, "g")

  execute s:ex_test_command
endfunction

function! s:InTestFile()
  return match(expand("%"), "_test.exs$") != -1
endfunction

function! s:ExTestCommand()
  if s:ExTestCommandProvided() && s:IsMacGui()
    let l:command = s:GuiCommand(g:ex_test_command)
  elseif s:ExTestCommandProvided()
    let l:command = g:ex_test_command
  elseif s:IsMacGui()
    let l:command = s:GuiCommand(s:default_command)
  else
    let l:command = s:DefaultTerminalCommand()
  endif

  return l:command
endfunction

function! s:ExTestCommandProvided()
  return exists("g:ex_test_command")
endfunction

function! s:DefaultTerminalCommand()
  return "!" . s:ClearCommand() . " && echo " . s:default_command . " && " . s:default_command
endfunction

function! s:CurrentFilePath()
  return @%
endfunction

function! s:GuiCommand(command)
  return "silent ! '" . s:plugin_path . "/bin/" . g:ex_test_runner . "' '" . a:command . "'"
endfunction

function! s:ClearCommand()
  if s:IsWindows()
    return "cls"
  else
    return "clear"
  endif
endfunction

function! s:IsMacGui()
  return s:force_gui || (has("gui_running") && has("gui_macvim"))
endfunction

function! s:IsWindows()
  return has("win32") && fnamemodify(&shell, ':t') ==? "cmd.exe"
endfunction

" begin vspec config
function! ex_test#scope()
  return s:
endfunction

function! ex_test#sid()
    return maparg('<SID>', 'n')
endfunction
nnoremap <SID> <SID>
" end vspec config
