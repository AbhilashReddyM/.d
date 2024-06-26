
"Always show status line
set laststatus=2

"Markdown conceal level. 0-3. 2 shows markup when a line is highlighted
set cole=2

" set hybrid line numbering. This is done by turning on both line numbering and relative line numbering
set nu rnu

" toggle line numbering
noremap <F3> :set nu! rnu!<CR>

set visualbell

"apply highlighting to scons files
autocmd BufRead,BufNewFile Sconstruct,SConscript set filetype=python

"Apply markdown highlighting
autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
let g:markdown_fenced_languages = ['sh=bash','f=fortran', 'py=python', 'css', 'erb=eruby', 'javascript', 'js=javascript', 'json=javascript', 'xml', 'html']

" change leader key to space
nnoremap <SPACE> <Nop>
let mapleader = "\<SPACE>"

" timeout length in ms for leader
set timeoutlen=1500

" buffer navigation
map <leader>n :bn<CR>
map <leader>p :bp<CR>
map <leader>d :bd<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>f :Files<CR>

"Plugins using vim-plug 
call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-sensible'
Plug 'vim-airline/vim-airline'
Plug 'chrisbra/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'mhinz/vim-startify'
Plug 'bling/vim-bufferline'
Plug 'easymotion/vim-easymotion'
call plug#end()

"some help for syntax hightlighting for fortran
nmap <S-F> :set syntax=fortran<CR>:let b:fortran_fixed_source=!b:fortran_fixed_source<CR>:set syntax=text<CR>:set syntax=fortran<CR>
nmap <C-F> :filetype detect<CR>
let fortran_free_source=1
let fortran_have_tabs=1
let fortran_more_precise=1
let fortran_do_enddo=1
let fortran_fold=1
let fortran_fold_conditionals=1
let fortran_fols_multilinecomments=1
filetype plugin indent off
syntax on

" I want
"  - autoindent to use spaces
"  - tabs to be 4 spaces wide and
"  - Tab character when i press the tab key on my keyboard
set tabstop     =4
set softtabstop =4
set shiftwidth  =4
set expandtab
inoremap <tab> <c-v><tab>

" fold using syntax
set foldmethod=syntax

" open files without any closed folds
au BufWinEnter * normal zR

" gets rid of old search highlighting
nnoremap <CR> :noh<CR><CR>


"Python syntax customization
autocmd BufRead,BufNewFile *.py setlocal foldmethod=indent

"  open files without any closed folds
au BufWinEnter * normal zR


" get a nice tab line
set tabline=%!MyTabLine()
function MyTabLine()
  let s = '' " complete tabline goes here
  " loop through each tab page
  for t in range(tabpagenr('$'))
    " select the highlighting for the buffer names
    if t + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif
    " empty space
    let s .= ' '
    " set the tab page number (for mouse clicks)
    let s .= '%' . (t + 1) . 'T'
    " set page number string
    let s .= t + 1 . ' '
    " get buffer names and statuses
    let n = ''  "temp string for buffer names while we loop and check buftype
    let m = 0 " &modified counter
    let bc = len(tabpagebuflist(t + 1))  "counter to avoid last ' '
    " loop through each buffer in a tab
    for b in tabpagebuflist(t + 1)
      " buffer types: quickfix gets a [Q], help gets [H]{base fname}
      " others get 1dir/2dir/3dir/fname shortened to 1/2/3/fname
      if getbufvar( b, "&buftype" ) == 'help'
        let n .= '[H]' . fnamemodify( bufname(b), ':t:s/.txt$//' )
      elseif getbufvar( b, "&buftype" ) == 'quickfix'
        let n .= '[Q]'
      else
        let n .= pathshorten(bufname(b))
        "let n .= bufname(b)
      endif
      " check and ++ tab's &modified count
      if getbufvar( b, "&modified" )
        let m += 1
      endif
      " no final ' ' added...formatting looks better done later
      if bc > 1
        let n .= ' '
      endif
      let bc -= 1
    endfor
    " add modified label [n+] where n pages in tab are modified
    if m > 0
      "let s .= '[' . m . '+]'
      let s.= '+ '
    endif
    " add buffer names
    if n == ''
      let s .= '[No Name]'
    else
      let s .= n
    endif
    " switch to no underlining and add final space to buffer list
    "let s .= '%#TabLineSel#' . ' '
    let s .= ' '
  endfor
  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'
  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999XX'
  endif
  return s
endfunction
