" make space the leader
let mapleader = "\<Space>"
let maplocalleader = "\<Space>"

" Changes of default mappings
map Y y$

set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set ignorecase    " ignore case for searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif

" Plugins
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

filetype plugin indent on

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-
augroup END

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use ripgrep
if executable('rg')
  " Use rg over Grep
  set grepprg=rg\ --vimgrep

  " fzf.vim
  " from https://medium.com/@crashybang/supercharge-vim-with-fzf-and-ripgrep-d4661fc853d2#.tj0bz9a4o
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

  " Let unite use rg
  let g:unite_source_grep_command = 'rg'
  let g:unite_source_grep_default_opts = '--vimgrep'
  let g:unite_source_grep_recursive_opt = ''
  let g:unite_source_grep_encoding = 'utf-8'
endif

" Unite.vim configuration
nnoremap <silent> ,g :<C-u>Unite grep:. -buffer-name=search-buffer<CR>

" Color scheme
set background=dark
colorscheme solarized
"highlight NonText guibg=#060606
"highlight Folded  guibg=#0A0A0A guifg=#9090D0
" airline fonts are installed
let g:airline_powerline_fonts = 1
if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata-g\ for\ Powerline\ 12
  endif
endif

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Numbers
set number
set numberwidth=5

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

" Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" Index ctags from any project, including those outside Rails
map <Leader>ct :!ctags -R .<CR>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" buffer shortcuts
nnoremap ZW :bwipeout<CR>
nnoremap ZS :write<CR>

" vimrc mappings
nnoremap <leader>vm :e $MYVIMRC<CR>
nnoremap <leader>vp :e ~/.vimrc.bundles<CR>
nnoremap <leader>vr :so $MYVIMRC<CR>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<space>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Always use vertical diffs
set diffopt+=vertical

" airline setup
let g:airline#extensions#tabline#enabled = 1

" Automatically add empty indented line after <brace>+<CR>
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1
let delimitMate_jump_expansion = 1

" Ctrl-R for find-and-replace of currently visually selected text
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
" Ctrl-C to copy visually selected text to system clipboard
vnoremap <C-c> "+y
" Ctrl-V to paste from system clipboard in insert mode
inoremap <C-v> <C-r>+

" concealing configuration
set concealcursor=c
"set conceallevel=2
let g:tex_conceal = ""

" vimtex configuration
let g:vimtex_view_method = 'zathura'

" ultisnips configuration
let g:UltiSnipsSnippetDirectories=[$HOME."/.vim/UltiSnips"]

" Spell checker
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd BufRead,BufNewFile README setlocal spell
autocmd FileType gitcommit setlocal spell
set complete+=kspell
nmap <silent> <leader>ss :set spell!<CR>
nmap <silent> <leader>sz 1z=<CR>

" tagbar
nmap <F8> :TagbarToggle<CR>

