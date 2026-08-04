"
" My vimrc by bsdero@gmail.com. 
" I took most of the file from https://github.com/amix/vimrc
" and then applied my own customizations
"
" Sections:
"    -> Help commands -nothing is configured here
"    -> General
"    -> VIM user interface
"    -> Colors and Fonts
"    -> Files and backups
"    -> Text, tab and indent related
"    -> Visual mode related
"    -> Moving around, tabs and buffers
"    -> Status line
"    -> Editing mappings
"    -> vimgrep searching and cope displaying
"    -> Spell checking
"    -> Misc
"    -> Helper functions
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Help commands
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MOVE CURSOR: Go to Normal mode with esc key and: 
" gg                 -Move cursor to beginning of file
" G                  -Move cursor to EOF
" [lineNO]G          -Move cursor to lineNo
"
"
" RUN COMMAND
" :! command         -Run command
" 
"
" SELECT, COPY, CUT, PASTE OPERATION.
" Go to normal mode with Esc key, then:
" v                  -Start selection, start visual char mode
" V                  -Start selection, start visual line mode
" ggVG               -Select all the file
" y                  -copy selection
" d                  -Cut selection
" move cursor and p  -Paste selection
"
"
" MULTIPLE WINDOW COMMANDS
" :split code.c      -split screen in two windows, one on top the other
" :vsplit code.c     -split screen in two windows, one on the side the other
" :<C-w> H           -Move window to the left
" :<C-w> J           -Move window to the bottom
" :<C-w> K           -Move window to the bottom
" :<C-w> L           -Move window to the right
" :<C-w> arrows      -Move cursor to other window
" :<C-w> R           -Rotate windows up/left
" :<C-w> r           -Rotate windows down/right
" :res 60            -Resize windows heigth to 60 lines
" :res +5            -Increase in 5 lines
" :res -5            -Decrease in 5 lines
" :<C-w> +           -Increate by 1
" :<C-w> -           -Decrease by 1
" :ls                -List all opened windows
" :b [0..N]          -Go to window with buffer N
" :sbN               -Split from buffer N
" :vertical sbN      -Vertical split from buffer N
"
"
" TABS
" :tabe code.c       -Open a new tab with a file code.c
" :tabc              -Close current tab
" :tabo              -Close all tabs except current
" :tabs              -List all tabs
" :tabn              -Go Next tab
" :tabp              -Go prev tab
"
"
" SAVE AND EXIT COMMANDS
" :wa                -Save all, no exit
" :xa                -Save all, exit
" :wqa               -Same than :xa
" :qa                -Exit if no updates
" :qa!               -Exit, no matter what
"
"
" RECTANGULAR SELECTIONS
" :set virtualedit+=all    -Enable virtual edition
" <C-V>                    -Set rectangular selection
" o                        -Switch corners
" gv                       -Restore selection
"
" 
" COMMANDS FROM CLI
" wincmd j         -Down
" wincmd k         -Up
" wincmd h         -left
" wincmd l         -right
"
"
" LAYOUTS
" ,---.
" |1|2|
" `---'
" vim -O f1 f2                           
" vim f1 -c 'vsplit f2' -c 'wincmd r'
"
"
" ,-.
" |1|
" |-|
" |2|
" `-'
" vim -o f1 f2                           
" vim f1 -c 'split f2' -c 'wincmd r'
"
"
" ,-----.
" |1|2|3|
" `-----'
" vim -O f1 f2 f3                          
"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Sets how many lines of history VIM has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","

" Fast saving
nmap <leader>w :w!<cr>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vimplug configurations
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'gyim/vim-boxdraw' "box draw plugin 
Plug 'itchyny/lightline.vim'     "text bar at bottom plugin
" Plug 'vim-airline/vim-airline'         " Alternative status bar to lightline.vim above (see the "=> Status line" section for the switch config)
" Plug 'vim-airline/vim-airline-themes'  " Status bar themes for vim-airline
Plug 'wesQ3/vim-windowswap'       "Window swap without move the layout
Plug 'skywind3000/vim-quickui'    "Menus
Plug 'preservim/nerdtree'         "NerdTree for files
" Plug 'leafOfTree/vim-project'  "disabled: installed but never configured (no g:vim_project_* settings exist anywhere). Re-enable once configured.

Plug 'xolox/vim-misc'                  " Required dependency for vim-session below
Plug 'xolox/vim-session'               " Session save/restore (:SaveSession, :OpenSession)
Plug 'tpope/vim-commentary'            " Comment toggling (gcc toggles a line, gc in visual mode)
Plug 'dense-analysis/ale'              " Async Lint Engine - syntax/lint hinting
Plug 'tpope/vim-fugitive'              " Git commands from inside Vim (:Git, :Git blame, :Gdiffsplit, ...)
Plug 'Xuyuanp/nerdtree-git-plugin'     " Git status flags inside the NERDTree sidebar
Plug 'tpope/vim-surround'              " Surround/change/delete quote & bracket text objects (cs"', ds", ysiw))
Plug 'jiangmiao/auto-pairs'            " Auto-close brackets/quotes/parens as you type
Plug 'Yggdroot/indentLine'             " Visual indent-guide characters (configured in Step 8)
Plug 'sheerun/vim-polyglot'            " Syntax/indent packs for many languages (notably improves Perl highlighting)
Plug 'neoclide/coc.nvim', {'branch': 'release'}  " Autocompletion + LSP client (hover, signature help, go-to-definition) - see => Coc.nvim configuration

" Color schemes
Plug 'NLKNguyen/papercolor-theme' "PaperColor
Plug 'sainnhe/everforest'         "everforest
Plug 'Rigellute/rigel'            "rigel
Plug 'yuttie/hydrangea-vim'       "hydrangea
Plug 'raphamorim/lucario'         "lucario 
Plug 'nordtheme/vim'              "nord
Plug 'nanotech/jellybeans.vim'    "jellybeans
Plug 'rafi/awesome-vim-colorschemes' "many color schemes:
Plug 'morhetz/gruvbox'                 " gruvbox
Plug 'tomasr/molokai'                  " molokai
Plug 'dracula/vim', { 'as': 'dracula' } " dracula (aliased: 'dracula/vim' otherwise installs into the same plugged/vim/ directory as nordtheme/vim above)
Plug 'arcticicestudio/nord-vim'        " nord-vim (a different plugin from nordtheme/vim above - see caution note in the plan)
Plug 'joshdick/onedark.vim'            " onedark

if has('nvim')
    " catppuccin
    " colorscheme catppuccin " catppuccin-latte, catppuccin-frappe, 
    " catppuccin-macchiato, catppuccin-mocha
    Plug 'catppuccin/nvim', { 'as': 'catppuccin' } 
    
    " colorscheme tokyonight
    " There are also colorschemes for the different styles.
    " colorscheme tokyonight-night
    " colorscheme tokyonight-storm
    " colorscheme tokyonight-day
    " colorscheme tokyonight-moon
    Plug 'folke/tokyonight.nvim'     

    " vim.cmd("colorscheme rose-pine")
    " vim.cmd("colorscheme rose-pine-main")
    " vim.cmd("colorscheme rose-pine-moon")
    " vim.cmd("colorscheme rose-pine-dawn")
    Plug 'rose-pine/neovim'
endif

call plug#end()
" Use the command 'PlugInstall' to setup those plugins


" In order to use the plugin vim-boxdraw, we need this configuration. It 
" allows to go beyond the end of line. Useful for box drawing, arrows, lines 
" and stuff. 
" https://github.com/gyim/vim-boxdraw
" set virtualedit+=all


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Show line numbers
set nu

" Put a vertical bar in the column #80
set cc=80

" Height of the command bar
set cmdheight=2

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch

" How many tenths of a second to blink when matching brackets
set mat=2

" Add a bit extra margin to the left
"set foldcolumn=1

" Enable mouse. Just in case.
set mouse=a
"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlight
syntax on

" Prefer a dark bckground
set background=dark

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

if has('nvim')
  try
    colorscheme tokyonight-night
  catch
    colorscheme industry
  endtry  
endif

if !has('nvim')
  try
    " colorscheme PaperColor
    colorscheme nord
  catch
    colorscheme industry
  endtry  
endif
"

" Custom Pmenu/PmenuSel colors for the completion popup menu (and the
" vim-quickui dropdown menus), so they stay legible no matter which
" colorscheme above is active. Must be reapplied on every ColorScheme
" event (not just set once) since `:colorscheme` clears all highlights
" before loading a new scheme - see the Why note in the plan.
function! ApplyPmenuColors()
  highlight Pmenu ctermfg=159 ctermbg=18 guifg=#CCECEC guibg=#1A2941
  highlight PmenuSel ctermfg=17 ctermbg=214 guifg=#121B2B guibg=#FFB300
endfunction
autocmd ColorScheme * call ApplyPmenuColors()
call ApplyPmenuColors()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Backup/swap/undo are left at Vim's built-in defaults; nothing is
" explicitly configured in this section.


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines

" Per-filetype indent width overrides (settings above are the global
" fallback; these take precedence for their specific filetypes)
augroup language_specific
    autocmd!
    autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
    autocmd FileType javascript,html,css setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd FileType go setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
    autocmd FileType vim setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd FileType make setlocal tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
augroup END


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
map <space> /
map <C-space> ?

" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext<cr>

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()


" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
map <leader>te :tabedit <C-r>=escape(expand("%:p:h"), " ")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


""""""""""""""""""""""""""""""
" => Status line
""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Configure lightline.vim's active statusline components
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ }
      \ }

" --- Alternative: vim-airline instead of lightline.vim ---
" lightline.vim (above) is the active status bar. To switch to vim-airline:
"   1. Comment out the 'Plug itchyny/lightline.vim' line and the g:lightline
"      block above.
"   2. Uncomment the two 'Plug vim-airline/...' lines in the Vimplug
"      configurations section (call plug#begin() block).
"   3. Uncomment the airline config lines directly below this comment.
"   4. Run :PlugClean then :PlugInstall, then restart Vim.
"
" let g:airline_powerline_fonts = 1
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
" let g:airline_theme = 'tomorrow'
" if !exists('g:airline_symbols')
"   let g:airline_symbols = {}
" endif
" let g:airline_symbols.linenr = '¶'
" let g:airline_symbols.paste = 'ρ'
" let g:airline_symbols.whitespace = 'Ξ'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remap VIM 0 to first non-blank character
map 0 ^

" Move a line of text using ALT+[jk] or Command+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => ALE configuration (syntax/lint hinting)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_linters = {
\   'python': ['flake8', 'pylint'],
\   'javascript': ['eslint'],
\   'typescript': ['tslint'],
\   'go': ['gofmt', 'golint'],
\   'c': ['clang'],
\   'cpp': ['clang'],
\}

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['autopep8', 'black'],
\   'javascript': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'tslint'],
\   'css': ['prettier'],
\   'html': ['prettier'],
\   'go': ['gofmt', 'goimports'],
\}
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚠'
let g:ale_lint_on_text_changed = 'never'  " Only lint when saving
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 0   " Off by default - flip to 1 once you've reviewed the fixers above and want auto-formatting on every save


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Coc.nvim configuration (autocompletion / LSP: hover, signature
" help, go-to-definition/references, rename)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ALE (above) stays the linter/fixer; coc's own diagnostics are turned
" off below so the two don't both draw signs in the gutter - coc is
" used here purely for completion/hover/goto, ALE stays the sole
" linting source.
let g:coc_global_extensions = [
      \ 'coc-pyright',
      \ 'coc-clangd',
      \ 'coc-json',
      \ 'coc-sh',
      \ 'coc-rust-analyzer',
      \ ]

" Perl has no official coc marketplace extension, so it's wired up here
" as a generic LSP entry instead, pointing at Perl::LanguageServer
" (install separately: `cpanm Perl::LanguageServer`; requires a
" system Perl with cpanm available). Untested in this repo - installing
" CPAN modules isn't possible in this sandbox, so verify interactively
" that it actually starts (:CocInfo after opening a .pl file) before
" relying on it.
let g:coc_user_config = {
      \ 'diagnostic.enable': v:false,
      \ 'languageserver': {
      \   'perl': {
      \     'command': 'perl',
      \     'args': ['-MPerl::LanguageServer', '-e', 'Perl::LanguageServer::run'],
      \     'filetypes': ['perl'],
      \   },
      \ },
      \ }

" <Tab>/<S-Tab> cycle the completion popup, <CR> confirms the selected
" entry - coc.nvim's own recommended config. Caution: this <CR> mapping
" is a blanket insert-mode override, so if auto-pairs' own <CR> handling
" (expanding a bracket pair onto its own line) stops working, this is
" why - the two haven't been tested together interactively here.
function! CocCheckBackspace() abort
  let l:col = col('.') - 1
  return !l:col || getline('.')[l:col - 1] =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CocCheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" Hover docs, go-to-definition/type/implementation/references
nnoremap <silent> K :call CocActionAsync('doHover')<CR>
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Session configuration (vim-session)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:session_autosave = 'yes'
let g:session_autoload = 'no'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => IndentLine configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:indentLine_char = '┊'
let g:indentLine_enabled = 1
let g:indentLine_concealcursor = ''
let g:indentLine_setColors = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERDTree key maps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <leader>n :NERDTree<CR>
noremap <leader>n0 :NERDTreeClose<CR>
noremap <leader>n1 :NERDTreeFocus<CR>
noremap <leader>nh :help NERDTree<CR>

" Open NERDTree automatically when vim starts up if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Close vim if the only window left open is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" Show hidden files by default
let NERDTreeShowHidden=1
" Ignore specific files
let NERDTreeIgnore = ['\.pyc$', '__pycache__', '\.git$', '\.DS_Store']


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Drawbox key maps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <leader>be :set virtualedit+=all<cr>
noremap <leader>bv :set virtualedit=<cr>
" For box or line drawing first enable the virtualedit mode, and select a 
" rectangular area with Ctrl-V. Then issue the next commands:
" +o: draw rectangle
" +O: draw rectangle with caption
" o: switch corners in selection
" +- : draw lines
" +> : draw arrows
" ++>: draw arrows in both ends
"
"


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Session key maps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Capital S so these don't collide with the lowercase <leader>s* spell
" mappings above.
noremap <leader>So :OpenSession<cr>
noremap <leader>Ss :SaveSession<cr>
noremap <leader>Sc :CloseSession<cr>
noremap <leader>Sd :DeleteSession<cr>

" Show the currently active session (there's no dedicated vim-session
" command for this - it's the plug-in's own function).
nnoremap <leader>Sl :echo empty(xolox#session#find_current_session()) ? "No session open" : "Current session: " . xolox#session#find_current_session()<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Custom mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" All mappings added while extending this vimrc live here, together,
" instead of scattered across the topical sections above. Each one is
" commented individually below.

" Remove the Windows ^M - when the encodings gets messed up
" (moved here from => Misc; renamed from <Leader>m to <leader>rc so it
" doesn't collide with the <leader>m0 / <leader>m1 mouse toggles below)
noremap <leader>rc mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Disable mouse
nnoremap <leader>m0 :set mouse=<CR>

" Enable mouse
nnoremap <leader>m1 :set mouse=a<CR>

" Remove trailing whitespace from every line in the file
nnoremap <leader>rs :%s/\s\+$//e<CR>

" Toggle line wrap
nnoremap <leader>rw :setlocal wrap!<CR>

" Rename the symbol under the cursor (coc.nvim, requires the matching
" language extension - see => Coc.nvim configuration)
nnoremap <leader>rn <Plug>(coc-rename)

" Quick colorscheme cycling: <leader>cn (next) / <leader>cp (previous).
" Only includes schemes with a single, unambiguous `:colorscheme` name -
" deliberately excludes 'rafi/awesome-vim-colorschemes' (a multi-scheme
" bundle) and 'arcticicestudio/nord-vim' (name collides with
" 'nordtheme/vim', declared in => Vimplug configurations - see the
" caution note there) to avoid ambiguity. Neovim-only schemes
" (catppuccin, tokyonight, rose-pine) are excluded too, since they are
" only installed `if has('nvim')`.
let g:my_colorschemes = [
      \ 'PaperColor', 'everforest', 'rigel', 'hydrangea', 'lucario',
      \ 'nord', 'jellybeans', 'gruvbox', 'molokai', 'dracula', 'onedark'
      \ ]
let g:my_colorscheme_idx = index(g:my_colorschemes, 'nord')

function! CycleColorscheme(step)
  let g:my_colorscheme_idx = (g:my_colorscheme_idx + a:step + len(g:my_colorschemes)) % len(g:my_colorschemes)
  let l:name = g:my_colorschemes[g:my_colorscheme_idx]
  try
    execute 'colorscheme ' . l:name
    echo 'colorscheme: ' . l:name
  catch
    echo 'colorscheme not installed yet (run :PlugInstall): ' . l:name
  endtry
endfunction

nnoremap <leader>cn :call CycleColorscheme(1)<CR>
nnoremap <leader>cp :call CycleColorscheme(-1)<CR>

" Quickly edit this vimrc/init.vim
nnoremap <leader>ev :e $MYVIMRC<CR>


" clear all the menus
call quickui#menu#reset()

" install a 'File' menu, use [text, command] to represent an item.
call quickui#menu#install('&File', [
            \ [ "&New File\tCtrl+n", 'tabe `=tempname()`', 'Edit a new file' ],
            \ [ "&Open File\t(F3)", 'NERDTree', 'Open a file' ],
            \ [ "&Close", 'close', 'q' ],
            \ [ "--", '' ],
            \ [ "&Save\tCtrl+s", 'w'],
            \ [ "Save &As", 'call feedkeys(":saveas ")' ],
            \ [ "Save All", 'wa' ],
            \ [ "--", '' ],
            \ [ "Save All and Exit", 'xa' ],
            \ [ "E&xit\tAlt+x", 'qa' ],
            \ ])

" items containing tips, tips will display in the cmdline
call quickui#menu#install('&Edit', [
            \ [ 'Start select', 'v' ],
            \ [ '&Copy', 'y', 'help 1' ],
            \ [ '&Paste', 'p', 'help 2' ],
            \ ])

" buffer, tab and window management (mirrors the <leader>b*/t* mappings)
call quickui#menu#install('&Buffer', [
            \ [ '&Next Buffer', 'bnext', 'Same as <leader>l' ],
            \ [ '&Previous Buffer', 'bprevious', 'Same as <leader>h' ],
            \ [ '&Close Buffer', 'Bclose | tabclose | normal! gT', 'Same as <leader>bd' ],
            \ [ 'Close &All Buffers', 'bufdo bd', 'Same as <leader>ba' ],
            \ [ '--', '' ],
            \ [ '&New Tab', 'tabnew', 'Same as <leader>tn' ],
            \ [ 'C&lose Tab', 'tabclose', 'Same as <leader>tc' ],
            \ [ '&Next Tab', 'tabnext', 'Same as <leader>t<leader>' ],
            \ [ '&Toggle Last Tab', 'exe "tabn ".g:lasttab', 'Same as <leader>tl' ],
            \ ])

" script inside %{...} will be evaluated and expanded in the string
call quickui#menu#install("&Option", [
			\ ['Set &Spell %{&spell? "Off":"On"}', 'set spell!'],
			\ ['Set &Cursor Line %{&cursorline? "Off":"On"}', 'set cursorline!'],
			\ ['Set &Paste %{&paste? "Off":"On"}', 'set paste!'],
            \ ['Edit Configurations', 'tabe $MYVIMRC', 'Edit configuration' ],
            \ ['Set Mouse %{&mouse? "Off":"On"}', 'set mouse!'],
            \ ['Set &Wrap %{&wrap? "Off":"On"}', 'setlocal wrap!', 'Same as <leader>rw'],
            \ ['Toggle &NERDTree', 'NERDTreeToggle', 'Same as <leader>n'],
            \ ['Remove &Trailing Whitespace', '%s/\s\+$//e', 'Same as <leader>rs'],
            \ ['Toggle &ALE Linting', 'ALEToggle', 'Toggle async lint engine'],
            \ ['Rename &Symbol (coc)', 'call CocActionAsync("rename")', 'Same as <leader>rn'],
			\ ])

" colorscheme cycling (mirrors the <leader>cn/<leader>cp mappings)
call quickui#menu#install('&Colors', [
            \ [ '&Next Colorscheme', 'call CycleColorscheme(1)', 'Same as <leader>cn' ],
            \ [ '&Previous Colorscheme', 'call CycleColorscheme(-1)', 'Same as <leader>cp' ],
            \ [ '--', '' ],
            \ [ 'Toggle &Background %{&background == "dark" ? "Light" : "Dark"}', 'let &background = (&background == "dark" ? "light" : "dark")', '' ],
            \ ])

" session save/restore via vim-session (mirrors the <leader>S* mappings below)
call quickui#menu#install('&Session', [
            \ [ '&Open Session', 'OpenSession', 'Same as <leader>So' ],
            \ [ '&Save Session', 'SaveSession', 'Same as <leader>Ss' ],
            \ [ '&Close Session', 'CloseSession', 'Same as <leader>Sc' ],
            \ [ '&Delete Session', 'DeleteSession', 'Same as <leader>Sd' ],
            \ [ '--', '' ],
            \ [ '&List Sessions', 'echo join(xolox#session#get_names(0), "\n")', 'Show all saved session names' ],
            \ [ 'C&urrent Session', 'echo empty(xolox#session#find_current_session()) ? "No session open" : xolox#session#find_current_session()', 'Same as <leader>Sl' ],
            \ ])

" register HELP menu with weight 10000
call quickui#menu#install('H&elp', [
			\ ["&Cheatsheet", 'help index', ''],
			\ ['T&ips', 'help tips', ''],
			\ ['--',''],
			\ ["&Tutorial", 'help tutor', ''],
			\ ['&Quick Reference', 'help quickref', ''],
			\ ['&Summary', 'help summary', ''],
			\ ], 10000)

" enable to display tips in the cmdline
let g:quickui_show_tip = 1

" open the quickui menu
noremap <leader>mm :call quickui#menu#open()<cr>

