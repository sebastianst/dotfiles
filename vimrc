" make space the leader
let mapleader = "\<Space>"
let maplocalleader = "\<Space>"

" Changes of default mappings
map Y y$

set backspace=2   " Backspace deletes like most programs in insert mode
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
set scrolloff=4   " Show context lines when cursor goes to top/bottom of screen
set linebreak     " Do not break words but only at breakat chars
set textwidth=80
set colorcolumn=+1,+21 " show where textwidth and 20 more is
set nojoinspaces  " Do not put two spaces after ., ? or !

set mouse=a

" Line Numbers
set number
set numberwidth=4
" gvim specifics
set guioptions-=m " remove menu
set guioptions-=T " remove toolbar

filetype plugin indent on
" Switch syntax highlighting on, when the terminal has colors
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

" Plugins
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

set showbreak=↪\ 
set list listchars=tab:›\ ,nbsp:␣,trail:•,extends:…,precedes:…

if !exists("autocommands_loaded")
  let autocommands_loaded = 1
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

  autocmd FileType markdown setlocal spell
  autocmd FileType tex setlocal spell
  autocmd BufRead,BufNewFile README setlocal spell

  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-

  autocmd FileType solidity setlocal tabstop=4
  autocmd FileType solidity setlocal shiftwidth=4

  autocmd FileType proto setlocal tabstop=2
  autocmd FileType proto setlocal shiftwidth=2
endif

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
endif

source ~/.vim/plugconfigs/denite.vim

" Color scheme
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set background=dark
" onedark
let g:onedark_terminal_italics = 1
augroup onedarkext
  autocmd!
  let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
  let s:grey = { "gui": "#3E4452", "cterm": "237" }
  autocmd ColorScheme * call onedark#set_highlight("MatchParen", { "fg": s:white, "bg": s:grey, "gui": "bold" })
  let s:red = {"gui": "#E06C75"}
  let s:yellow = {"gui": "#E5C07B"}
  autocmd ColorScheme * call onedark#set_highlight("SpellBad", { "sp": s:red, "gui": "undercurl" })
  autocmd ColorScheme * call onedark#set_highlight("SpellCap", { "sp": s:yellow, "gui": "undercurl" })
  autocmd ColorScheme * call onedark#set_highlight("SpellLocal", { "sp": s:yellow, "gui": "undercurl" })
  autocmd ColorScheme * call onedark#set_highlight("SpellRare", { "sp": s:yellow, "gui": "undercurl" })
augroup END
colorscheme onedark

" vim-rainbow
let g:rainbow_active = 1

let g:airline_powerline_fonts = 1
if has("gui_running")
  if has("gui_gtk")
    set guifont=Inconsolata-g\ for\ Powerline\ 12
  endif
endif

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
noremap <silent> <A-h> :tabp<CR>
noremap <silent> <A-l> :tabn<CR>

" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
" Checker options
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
let g:syntastic_javascript_checkers = ["eslint"]
" TypeScript
let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi']
" golang
let g:syntastic_go_checkers = ['golint', 'govet', 'gometalinter']
let g:syntastic_go_gometalinter_args = ['--disable-all', '--enable=errcheck']
let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

" vim-go
let g:go_list_type = "quickfix"
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_functions_parameters = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_types = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 0
let g:go_highlight_operators = 1
let g:go_rename_command = 'gopls'
autocmd FileType go let b:go_fmt_options = {
  \ 'gofmt': '-s',
  \ 'goimports': '-local ' .
    \ trim(system('{cd '. shellescape(expand('%:h')) .' && go list -m;}')),
  \ }
let g:go_imports_autosave = 1

" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" xkb-switch plugin
let g:XkbSwitchNLayout = 'us'
let g:XkbSwitchILayout = 'de'

" Always use vertical and internal diffs, with patience algo
set diffopt+=vertical,internal,algorithm:patience

" airline setup
let g:airline#extensions#tabline#enabled = 1

" Automatically add empty indented line after <brace>+<CR>
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1
let delimitMate_jump_expansion = 1

" move next symbol after/before following word - good for moving closing braces
inoremap <C-l> <C-c>l"hxe"hpi
inoremap <C-h> <C-c>l"hxb"hPi

""" Copy'n'Paste'n'Stuff """
" Ctrl-R for find-and-replace of currently visually selected text
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
" Ctrl-C to copy visually selected text to system clipboard
vnoremap <C-c> "+y
" Ctrl-V to paste from system clipboard in insert mode, literally
inoremap <C-v> <C-r><C-o>+
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
let g:vimtex_fold_enabled = 0
" for backwards search, vimtex needs a remote server
if has('nvim')
  let g:vimtex_compiler_progname = 'nvr'
endif

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

""" deoplete
let g:deoplete#enable_at_startup = 1
" go
"call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*' })
" latex
call deoplete#custom#var('omni', 'input_patterns', {
      \ 'tex': g:vimtex#re#deoplete
      \})
" LanguagleClient for language servers
let g:LanguageClient_serverCommands = {
      \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
      \ 'go': ['~/go/bin/gopls'],
      \ 'typescript': ['javascript-typescript-stdio'],
      \ 'javascript': ['javascript-typescript-stdio'],
      \ }

" Termdebug
nnoremap <leader>D :packadd termdebug<CR>:Termdebug<space>

""" TAB KEY
" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<C-j>"
let g:UltiSnipsJumpForwardTrigger = "<C-j>"
let g:UltiSnipsJumpBackwardTrigger = "<C-k>"

" ultisnips configuration
let g:UltiSnipsSnippetDirectories=[$HOME."/.vim/UltiSnips"]

" Spell checker
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

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
