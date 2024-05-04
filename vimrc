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
Plug 'wesQ3/vim-windowswap'       "Window swap without move the layout
Plug 'skywind3000/vim-quickui'    "Menus
Plug 'preservim/nerdtree'         "NerdTree for files

" Color schemes
Plug 'NLKNguyen/papercolor-theme' "PaperColor
Plug 'sainnhe/everforest'         "everforest
Plug 'Rigellute/rigel'            "rigel
Plug 'yuttie/hydrangea-vim'       "hydrangea
Plug 'raphamorim/lucario'         "lucario 
Plug 'nordtheme/vim'              "nord
Plug 'nanotech/jellybeans.vim'    "jellybeans
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

" Always display the status line, even if only one window is displayed
set laststatus=2

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
    colorscheme PaperColor
  catch
    colorscheme industry
  endtry  
endif
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git etc. anyway...
" set nobackup
" set nowb
" set noswapfile


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

" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c


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
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
map <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

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
" => NERDTree key maps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <leader>n :NERDTree<CR>
noremap <leader>nh :help NERDTree<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Drawbox key maps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <leader>be :set virtualedit+=all<cr>
noremap <leader>bd :set virtualedit=<cr>
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


" clear all the menus
call quickui#menu#reset()

" install a 'File' menu, use [text, command] to represent an item.
call quickui#menu#install('&File', [
            \ [ "&New File\tCtrl+n", 'tabe `=tempname()`', 'Edit a new file' ],
            \ [ "&Open File\t(F3)", 'NERDTree', 'Open a file' ],
            \ [ "&Close", 'close' ],
            \ [ "--", '' ],
            \ [ "&Save\tCtrl+s", 'w'],
            \ [ "Save &As", 'call feedky(":saveas ")' ],
            \ [ "Save All", 'wa' ],
            \ [ "--", '' ],
            \ [ "Save All and Exit", 'xa' ],
            \ [ "E&xit\tAlt+x", 'q' ],
            \ ])

" items containing tips, tips will display in the cmdline
call quickui#menu#install('&Edit', [
            \ [ 'Start select', 'v' ],
            \ [ '&Copy', 'y', 'help 1' ],
            \ [ '&Paste', 'p', 'help 2' ],
            \ ])

" script inside %{...} will be evaluated and expanded in the string
call quickui#menu#install("&Option", [
			\ ['Set &Spell %{&spell? "Off":"On"}', 'set spell!'],
			\ ['Set &Cursor Line %{&cursorline? "Off":"On"}', 'set cursorline!'],
			\ ['Set &Paste %{&paste? "Off":"On"}', 'set paste!'],
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

" hit space twice to open menu
noremap <leader><space> :call quickui#menu#open()<cr>

