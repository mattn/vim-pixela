function! s:debug(ch, msg)
  echomsg a:msg
endfunction

function! s:start()
  let user = get(g:, 'pixela_username', '')
  let token = get(g:, 'pixela_token', '')
  let debug = get(g:, 'pixela_debug', 0)
  if empty(user) || empty(token)
    return
  endif
  let opts = {}
  if debug
    let opts['out_cb'] = function('s:debug')
    let opts['err_cb'] = function('s:debug')
  endif
  let s:job = job_start([
  \  'curl', '-v', '-X', 'PUT',
  \  printf('https://pixe.la/v1/users/%s/graphs/vim-pixela/increment', user),
  \  '-H', printf('X-USER-TOKEN:%s', token),
  \  '-H', 'Content-Length:0'], opts)
endfunction

function! s:browser()
  let user = get(g:, 'pixela_username', '')
  if empty(user)
    return
  endif
  call openbrowser#open(printf('https://pixe.la/v1/users/%s/graphs/vim-pixela', user))
endfunction

if !v:vim_did_enter
  au VimEnter * call s:start()
endif

command! VimPixela call s:browser()
