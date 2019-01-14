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
set scrolloff=4   " Show context lines when cursor goes to top/bottom of screen
set linebreak     " Do not break words but only at breakat chars

" gvim specifics
set guioptions-=m " remove menu
set guioptions-=T " remove toolbar

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
  set grepprg=rg\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m

  " fzf.vim
  command! -bang -nargs=* Rg
    \ call fzf#vim#grep(
    \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
    \   <bang>0 ? fzf#vim#with_preview('up:60%')
    \           : fzf#vim#with_preview('right:50%:hidden', '?'),
    \   <bang>0)

  " Denite: Ripgrep command on grep source
  call denite#custom#var('grep', 'command', ['rg'])
  call denite#custom#var('grep', 'default_opts',
      \ ['--vimgrep', '--no-heading'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
endif

" Denite.vim configuration
nnoremap <silent> ,g :<C-u>Denite grep:. -buffer-name=search-buffer<CR>
nnoremap <silent> ,c :<C-u>DeniteCursorWord grep -buffer-name=search-buffer<CR>
nnoremap ,b :Denite buffer<CR>
nnoremap ,f :Denite file_rec<CR>

" Color scheme
set background=dark
colorscheme solarized
"highlight NonText guibg=#060606
"highlight Folded  guibg=#0A0A0A guifg=#9090D0
" airline fonts are installed
let g:airline_powerline_fonts = 1
if has("gui_running")
  if has("gui_gtk")
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
"set wildmode=list:longest,list:full
"function! InsertTabWrapper()
    "let col = col('.') - 1
    "if !col || getline('.')[col - 1] !~ '\k'
        "return "\<tab>"
    "else
        "return "\<c-p>"
    "endif
"endfunction
"inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
"inoremap <S-Tab> <c-n>

" Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" Index ctags from any project, including those outside Rails
map <Leader>ct :!ctags -R .<CR>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" buffer shortcuts
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

" Switch to english layout if Ö is pressed, or alert
if executable('xkb-switch')
  nnoremap Ö :silent !xkb-switch -s us<CR>:
else
  nnoremap Ö :echoe "Switch to English laout!"<CR>
endif

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<space>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker buffer change
noremap <A-j> :bp<CR>
noremap <A-k> :bn<CR>
" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
" Quicker tab change
noremap <A-h> :tabp<CR>
noremap <A-l> :tabn<CR>

" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
" Checker options
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
let g:syntastic_javascript_checkers = ["eslint"]
" TypeScript
let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi']

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" xkb-switch plugin
let g:XkbSwitchNLayout = 'us'
let g:XkbSwitchILayout = 'de'

" Always use vertical diffs
set diffopt+=vertical

" airline setup
let g:airline#extensions#tabline#enabled = 1

" Automatically add empty indented line after <brace>+<CR>
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1
let delimitMate_jump_expansion = 1

""" Copy'n'Paste'n'Stuff """
" Ctrl-R for find-and-replace of currently visually selected text
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
" Ctrl-C to copy visually selected text to system clipboard
vnoremap <C-c> "+y
" Ctrl-V to paste from system clipboard in insert mode
inoremap <C-v> <C-r>+
" vim-easyclip
nnoremap gm m
nmap <leader>f <plug>EasyClipToggleFormattedPaste
"nmap M <Plug>MoveMotionEndOfLinePlug " Shadows M - go to middle of screen

" concealing configuration
set concealcursor=c
"set conceallevel=2
let g:tex_conceal = ""

" vimtex configuration
let g:vimtex_view_method = 'zathura'
let g:vimtex_fold_enabled = 1
let g:vimtex_fold_manual = 1

" YCM YouCompleteMe
nnoremap <leader>yf :YcmCompleter FixIt<CR>
nnoremap <leader>yc :YcmCompleter GetDoc<CR>
nnoremap <leader>yg :YcmCompleter GoTo<CR>
nnoremap <leader>yi :YcmCompleter GoToInclude<CR>
nnoremap <leader>yh :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>yd :YcmCompleter GoToDefinition<CR>
nnoremap <leader>yt :YcmCompleter GoToType<CR>

" YCM for tex
if !exists('g:ycm_semantic_triggers')
  let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers.tex = g:vimtex#re#youcompleteme

" Use ycm instead of jedi-vim completion
let g:jedi#completions_enabled = 0

" Termdebug
nnoremap <leader>D :packadd termdebug<CR>:Termdebug<space>

""" TAB KEY
" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" ultisnips configuration
let g:UltiSnipsSnippetDirectories=[$HOME."/.vim/UltiSnips"]

" Spell checker
autocmd BufRead,BufNewFile *.md setlocal spell
autocmd BufRead,BufNewFile README setlocal spell
autocmd FileType gitcommit setlocal spell
autocmd FileType tex setlocal spell
set complete+=kspell
nmap <silent> <leader>ss 1z=

" Thesaurus query plugin - <leader>cs already taken
let g:tq_map_keys=0
nnoremap <unique> <Leader>t :ThesaurusQueryReplaceCurrentWord<CR>
vnoremap <unique> <Leader>t "ty:ThesaurusQueryReplace <C-r>t<CR>

" Formatting
command HardWrapToggle if &fo =~ 't' | set fo-=t | else | set fo+=t | endif
nnoremap <leader>fw :HardWrapToggle<CR>

let g:tex_flavor = 'tex'

" tagbar
nmap <F8> :TagbarToggle<CR>
" nerdtree
nmap <F9> :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen = 1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" magit
let g:magit_default_fold_level=2 " Unfold all
let g:magit_show_magit_mapping=''
nmap <leader>M :MagitOnly<CR>

" macros
runtime macros/matchit.vim

" vim project rcs
set exrc
set secure
