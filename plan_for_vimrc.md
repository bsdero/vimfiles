# vimrc feature-addition plan

Status legend: `[ ]` not done · `[x]` done · `[-]` skipped (see note)

## How to execute this plan (read first)

You are adding new features to `vimrc` in this repo. Follow these rules exactly:

1. Only do the steps in the **"Confirmed — implement these"** section below, in order, one at a time.
2. Do **not** implement anything in the **"Pending / undecided"** section — currently empty, kept as a placeholder for future rounds.
3. Each confirmed step has one or more **Find**/**Replace** pairs (some steps have two, labeled Part A / Part B — do both parts of a step before checking it off).
4. Locate each edit by **matching its Find text exactly**, character for character, including indentation, blank lines, and trailing spaces. **Do not use line numbers** — they drift after each edit. Search for the Find text itself.
5. Steps are ordered so each step's Find text is the file's state **after all earlier steps are applied**. Do them in order.
6. If a Find block doesn't match (not even close), **stop and ask** — don't improvise.
7. Change only what a step says. Don't reformat, reindent, or "improve" unrelated code.
8. Check off each step's box (`[ ]` → `[x]`) after finishing it.
9. Run the verification section at the bottom after all steps are done.

If unsure about anything, stop and ask the user — do not guess.

---

## Confirmed — implement these

### Step 1 — Declare `vim-airline` as a commented-out alternative to `lightline.vim`

**Why:** Switchable status bar. `lightline.vim` stays active; airline's `Plug` lines are added but commented out (see Step 7 for its config).

- [x] In `vimrc`, in the `call plug#begin()` block, find:

```
Plug 'itchyny/lightline.vim'     "text bar at bottom plugin
```

  Replace with:

```
Plug 'itchyny/lightline.vim'     "text bar at bottom plugin
" Plug 'vim-airline/vim-airline'         " Alternative status bar to lightline.vim above (see the "=> Status line" section for the switch config)
" Plug 'vim-airline/vim-airline-themes'  " Status bar themes for vim-airline
```

---

### Step 2 — Add `vim-session`, `vim-commentary`, and `ale` plugins

**Why:** `vim-session` (+ `vim-misc` dependency) adds `:SaveSession`/`:OpenSession`. `vim-commentary` adds `gcc`/`gc` comment toggling. `ale` is the syntax/lint hinter (config in Step 8).

- [x] In `vimrc`, in the `call plug#begin()` block, find:

```
Plug 'preservim/nerdtree'         "NerdTree for files
" Plug 'leafOfTree/vim-project'  "disabled: installed but never configured (no g:vim_project_* settings exist anywhere). Re-enable once configured.
```

  Replace with:

```
Plug 'preservim/nerdtree'         "NerdTree for files
" Plug 'leafOfTree/vim-project'  "disabled: installed but never configured (no g:vim_project_* settings exist anywhere). Re-enable once configured.

Plug 'xolox/vim-misc'                  " Required dependency for vim-session below
Plug 'xolox/vim-session'               " Session save/restore (:SaveSession, :OpenSession)
Plug 'tpope/vim-commentary'            " Comment toggling (gcc toggles a line, gc in visual mode)
Plug 'dense-analysis/ale'              " Async Lint Engine - syntax/lint hinting
```

---

### Step 3 — Add the git plugins: `vim-fugitive` and `nerdtree-git-plugin`

**Why:** `vim-fugitive` is a command-driven git wrapper (`:Git`, `:Git blame`, `:Gdiffsplit`) — no config or mapping needed. `nerdtree-git-plugin` overlays git status letters in the NERDTree sidebar — also zero-config. `vim-gitgutter` was considered and explicitly skipped (see "Explicitly skipped" below); neither plugin here depends on it.

- [x] In `vimrc`, in the `call plug#begin()` block, find:

```
Plug 'dense-analysis/ale'              " Async Lint Engine - syntax/lint hinting
```

  Replace with:

```
Plug 'dense-analysis/ale'              " Async Lint Engine - syntax/lint hinting
Plug 'tpope/vim-fugitive'              " Git commands from inside Vim (:Git, :Git blame, :Gdiffsplit, ...)
Plug 'Xuyuanp/nerdtree-git-plugin'     " Git status flags inside the NERDTree sidebar
```

---

### Step 4 — Add the editing/visual plugins: `vim-surround`, `auto-pairs`, `indentLine`, `vim-polyglot`

**Why:** `vim-surround` (`cs"'`, `ds"`, `ysiw)`) and `auto-pairs` (auto-close brackets/quotes) are zero-config. `indentLine` is configured in Step 8. `vim-polyglot` was chosen for this user's language list (shell/bash, Vim, C, C++, Python, Perl) mainly for its **Perl** support — Vim's stock `perl.vim` is old and slow on complex files; the other languages already have solid built-in Vim support so the gain there is smaller. No config needed now.

- [x] In `vimrc`, in the `call plug#begin()` block, find:

```
Plug 'Xuyuanp/nerdtree-git-plugin'     " Git status flags inside the NERDTree sidebar
```

  Replace with:

```
Plug 'Xuyuanp/nerdtree-git-plugin'     " Git status flags inside the NERDTree sidebar
Plug 'tpope/vim-surround'              " Surround/change/delete quote & bracket text objects (cs"', ds", ysiw))
Plug 'jiangmiao/auto-pairs'            " Auto-close brackets/quotes/parens as you type
Plug 'Yggdroot/indentLine'             " Visual indent-guide characters (configured in Step 8)
Plug 'sheerun/vim-polyglot'            " Syntax/indent packs for many languages (notably improves Perl highlighting)
```

---

### Step 5 — Add the extra colorschemes

**Why:** User-requested: `gruvbox`, `molokai`, `dracula`, `nord-vim`, `onedark.vim`.

**Caution (do not fix, just be aware):** `nordtheme/vim` (declared above) and the new `arcticicestudio/nord-vim` may both register a colorscheme reachable as `nord`. Left as-is per the user's request.

- [x] In `vimrc`, in the `" Color schemes` block inside `call plug#begin()`, find:

```
Plug 'rafi/awesome-vim-colorschemes' "many color schemes:
```

  Replace with:

```
Plug 'rafi/awesome-vim-colorschemes' "many color schemes:
Plug 'morhetz/gruvbox'                 " gruvbox
Plug 'tomasr/molokai'                  " molokai
Plug 'dracula/vim'                     " dracula
Plug 'arcticicestudio/nord-vim'        " nord-vim (a different plugin from nordtheme/vim above - see caution note in the plan)
Plug 'joshdick/onedark.vim'            " onedark
```

---

### Step 6 — Create the `=> Custom mappings` section, and move the `^M`-strip mapping into it as `<leader>rc`

**Why:** Every mapping this plan adds is being kept together in one new, clearly-documented section (`=> Custom mappings`), instead of scattered across `=> Misc`, `=> Colors and Fonts`, etc. — per the user's explicit request, for discoverability. This step creates that section and is where all later mapping steps (11, 12, 13, 14) append their mappings.

Placed after `=> Drawbox key maps` and before the `vim-quickui` menu definitions — the same late-file position `vimrc_to_fix` uses for its own "Advanced mappings" section.

The `^M`-strip mapping (previously `<Leader>m` in `=> Misc`) is relocated here first, renamed to `<leader>rc`. Renaming frees the `<leader>m` prefix for `<leader>m0`/`<leader>m1` (Step 11) — without the rename, `<leader>m` would become an ambiguous prefix, delaying every use by `timeoutlen`.

**Important — overrides `plan.md`:** `plan.md`'s "Explicitly NOT changing" note about `<Leader>m` was about a different, resolved concern (the mapping's body was never broken). This step only relocates and renames the trigger key. The right-hand side of the mapping (everything after the mapping name) is copied byte-for-byte unchanged.

**Part A** — remove the mapping from `=> Misc`:

- [x] In `vimrc`, find:

```
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
```

  Replace with:

```
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Quickly open a buffer for scribble
```

**Part B** — create `=> Custom mappings` with the relocated, renamed mapping:

- [x] In `vimrc`, find:

```
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


" clear all the menus
call quickui#menu#reset()
```

  Replace with:

```
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
" => Custom mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" All mappings added while extending this vimrc live here, together,
" instead of scattered across the topical sections above. Each one is
" commented individually below.

" Remove the Windows ^M - when the encodings gets messed up
" (moved here from => Misc; renamed from <Leader>m to <leader>rc so it
" doesn't collide with the <leader>m0 / <leader>m1 mouse toggles below)
noremap <leader>rc mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm


" clear all the menus
call quickui#menu#reset()
```

---

### Step 7 — Add the commented `vim-airline` config as a documented switch from `lightline.vim`

**Why:** Pairs with Step 1: a ready-to-uncomment airline config next to the active lightline config, with switch instructions.

- [x] In `vimrc`, in the `=> Status line` section, find:

```
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
```

  Replace with:

```
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
```

---

### Step 8 — Add `ale`, `vim-session`, and `indentLine` configuration

**Why:** All three plugins need config to do anything. `g:ale_fix_on_save` stays `0` (off) — auto-formatting on save is a bigger behavior change than "add a linter"; the user can flip it on deliberately after reviewing the fixers. `indentLine` values are copied as-is from `vimrc_to_fix`; if indent guides look wrong on markdown/JSON, try `g:indentLine_concealcursor = ''` instead of `0`.

**Deviation from the Find/Replace below, applied during execution:** the user asked to drop `'tsserver'` from `g:ale_linters.typescript` (it duplicates type-check diagnostics that `tslint`-style linting doesn't need here, and ALE's `tsserver` integration is the older, heavier of the two). The typescript linter list actually applied is `['tslint']` only, not `['tslint', 'tsserver']` as shown below.

- [x] In `vimrc`, immediately before the `=> NERDTree key maps` section, find:

```
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERDTree key maps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <leader>n :NERDTree<CR>
noremap <leader>nh :help NERDTree<CR>
```

  Replace with:

```
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => ALE configuration (syntax/lint hinting)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_linters = {
\   'python': ['flake8', 'pylint'],
\   'javascript': ['eslint'],
\   'typescript': ['tslint', 'tsserver'],
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
" => Session configuration (vim-session)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:session_autosave = 'yes'
let g:session_autoload = 'no'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => IndentLine configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:indentLine_char = '┊'
let g:indentLine_enabled = 1
let g:indentLine_concealcursor = 0
let g:indentLine_setColors = 1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERDTree key maps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <leader>n :NERDTree<CR>
noremap <leader>nh :help NERDTree<CR>
```

---

### Step 9 — Add NERDTree auto-open / auto-quit / hidden-files / ignore behavior

**Why:** Auto-open NERDTree on a no-args `vim` launch, auto-quit Vim if NERDTree is the only window left, show dotfiles, ignore `__pycache__`/`.pyc`/`.git`/`.DS_Store`. Pure config on the already-installed `preservim/nerdtree` — no new plugin. (Not a mapping, so it stays here rather than moving to `=> Custom mappings`.)

- [x] In `vimrc`, in the `=> NERDTree key maps` section (as it now exists after Step 8), find:

```
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERDTree key maps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <leader>n :NERDTree<CR>
noremap <leader>nh :help NERDTree<CR>
```

  Replace with:

```
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERDTree key maps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
noremap <leader>n :NERDTree<CR>
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
```

---

### Step 10 — Add per-filetype indent-width `augroup`

**Why:** `vimrc` currently has one global `shiftwidth=4`/`tabstop=4` for everything. This adds per-language overrides matching real convention: Python 4/spaces, JS/HTML/CSS 2/spaces, Go 8/tabs, Vim 2/spaces, Make 8/tabs. Not a mapping, so it stays in its topical section rather than moving to `=> Custom mappings`.

- [x] In `vimrc`, in the `=> Text, tab and indent related` section, find:

```
set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
```

  Replace with:

```
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
```

---

### Step 11 — Add `<leader>m0` / `<leader>m1` (mouse off/on) and `<leader>rs` (strip trailing whitespace)

**Why:** Appends into `=> Custom mappings` (created in Step 6), right after `<leader>rc`. `<leader>m0` disables the mouse, `<leader>m1` re-enables it (`set mouse=a`, matching the file's existing default). `<leader>rs` strips trailing whitespace on demand for any filetype, distinct from the existing `CleanExtraSpaces()` autocmd (save-time only, limited filetypes).

**Do this step only after Step 6** (Step 6 both creates the section and frees the `<leader>m` prefix).

- [x] In `vimrc`, in the `=> Custom mappings` section, find:

```
" Remove the Windows ^M - when the encodings gets messed up
" (moved here from => Misc; renamed from <Leader>m to <leader>rc so it
" doesn't collide with the <leader>m0 / <leader>m1 mouse toggles below)
noremap <leader>rc mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm
```

  Replace with:

```
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
```

---

### Step 12 — Add the line-wrap toggle mapping, as `<leader>rw` (not `<leader>wr`)

**Why:** `vimrc` already maps bare `<leader>w` (fast-save). Any `<leader>w*` mapping — including `wr` — makes `,w` an ambiguous prefix and delays the fast-save. `<leader>rw` avoids that and groups with `rc`/`rs`.

- [x] In `vimrc`, in the `=> Custom mappings` section, find:

```
" Remove trailing whitespace from every line in the file
nnoremap <leader>rs :%s/\s\+$//e<CR>
```

  Replace with:

```
" Remove trailing whitespace from every line in the file
nnoremap <leader>rs :%s/\s\+$//e<CR>

" Toggle line wrap
nnoremap <leader>rw :setlocal wrap!<CR>
```

---

### Step 13 — Add colorscheme cycling (`<leader>cn` / `<leader>cp`)

**Why:** Cycles through a fixed list of colorschemes and echoes the active one's name — chosen over one key per scheme since `vimrc` has 14 colorschemes after Step 5. The list, its cycling function, and its two mappings are kept together as one block in `=> Custom mappings` (not split from `=> Colors and Fonts`), so the whole feature reads in one place.

Excluded from the list: `rafi/awesome-vim-colorschemes` (a multi-scheme bundle, not one name), `arcticicestudio/nord-vim` (name collision with `nordtheme/vim`, already in the list as `'nord'` — see Step 5's caution note), and the Neovim-only schemes (`catppuccin`, `tokyonight`, `rose-pine`, only installed `if has('nvim')` — including them here would error on plain Vim).

`g:my_colorscheme_idx` starts at `'nord'` because that's `vimrc`'s actual active default for non-Neovim (see the `=> Colors and Fonts` section — `colorscheme nord` is the live line there, `colorscheme PaperColor` is commented out). Each cycle call is wrapped in `try`/`catch`, matching this file's existing `colorscheme` convention, so landing on a scheme not yet installed (before `:PlugInstall`) shows a message instead of an error.

- [x] In `vimrc`, in the `=> Custom mappings` section, find:

```
" Toggle line wrap
nnoremap <leader>rw :setlocal wrap!<CR>
```

  Replace with:

```
" Toggle line wrap
nnoremap <leader>rw :setlocal wrap!<CR>

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
```

---

### Step 14 — Add `<leader>ev` mapping to quick-edit the vimrc itself

**Why:** Uses `$MYVIMRC`, not a hardcoded path, so it resolves correctly under both Vim (`~/.vimrc`) and Neovim (`~/.config/nvim/init.vim`) — same fix `plan.md` already applied to the quickui "Edit Configurations" menu item. **Design choice:** plain `:e` (current window), not `:tabedit`. `vimrc` does have a "new tab" convention elsewhere (`<leader>te`), so `:tabedit $MYVIMRC` is a one-word swap here if a fresh tab is preferred instead.

- [x] In `vimrc`, in the `=> Custom mappings` section, find:

```
nnoremap <leader>cn :call CycleColorscheme(1)<CR>
nnoremap <leader>cp :call CycleColorscheme(-1)<CR>
```

  Replace with:

```
nnoremap <leader>cn :call CycleColorscheme(1)<CR>
nnoremap <leader>cp :call CycleColorscheme(-1)<CR>

" Quickly edit this vimrc/init.vim
nnoremap <leader>ev :e $MYVIMRC<CR>
```

---

### Step 15 — Add `Pmenu`/`PmenuSel` highlight colors, reapplied on every colorscheme change

**Why:** Custom colors for the completion popup (and `vim-quickui`'s dropdown menus) so they stay legible across all 14 colorschemes, instead of inheriting each scheme's own (widely varying) `Pmenu` colors. Values are copied from `vimrc_to_fix`.

**Important technical detail:** `:colorscheme` clears all highlights (`hi clear`) before loading the new scheme, so a one-off `highlight Pmenu ...` command would get wiped the next time the colorscheme changes — including via the `<leader>cn`/`<leader>cp` cycling added in Step 13. This must be wrapped in a function and reapplied on every `ColorScheme` autocmd event, **and** called once immediately (the autocmd only fires on *future* changes, not for whichever scheme is already active from the `try`/`catch` block right above it in this same section).

- [x] In `vimrc`, in the `=> Colors and Fonts` section, find:

```
if !has('nvim')
  try
    " colorscheme PaperColor
    colorscheme nord
  catch
    colorscheme industry
  endtry  
endif
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
```

  Replace with:

```
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
```

---

### Step 16 — Update `AGENTS.md` to document all of the above

**Why:** Keeps `AGENTS.md`'s "Points worth knowing before editing" list accurate so none of this has to be rediscovered later.

**Do this step last**, after every other step in this plan is done.

- [x] In `AGENTS.md`, find:

```
- **NERDTree** is bound to `<leader>n`; box-drawing (`vim-boxdraw`) mappings toggle `virtualedit` via `<leader>be` / `<leader>bv`.
- A `BufWritePre` autocmd strips trailing whitespace for `*.txt,*.js,*.py,*.wiki,*.sh,*.coffee` via `CleanExtraSpaces()` — be aware this will silently rewrite trailing whitespace in those filetypes on save.
```

  Replace with:

```
- **NERDTree** is bound to `<leader>n`; box-drawing (`vim-boxdraw`) mappings toggle `virtualedit` via `<leader>be` / `<leader>bv`. NERDTree also now auto-opens on a no-args `vim` launch, auto-quits Vim if it's the last window open, shows hidden files, and ignores `.pyc`/`__pycache__`/`.git`/`.DS_Store`. `nerdtree-git-plugin` overlays git status flags in the tree.
- A `BufWritePre` autocmd strips trailing whitespace for `*.txt,*.js,*.py,*.wiki,*.sh,*.coffee` via `CleanExtraSpaces()` — be aware this will silently rewrite trailing whitespace in those filetypes on save. `<leader>rs` (in `=> Custom mappings`) does the same strip manually, on demand, for any filetype.
- **All mappings added after the initial cleanup pass live together in a `=> Custom mappings` section**, near the end of the file (after `=> Drawbox key maps`, before the `vim-quickui` menu definitions) — check there first. It holds: `<leader>rc` (the `^M`-strip mapping, relocated from `=> Misc`, renamed from `<Leader>m`), `<leader>m0`/`<leader>m1` (mouse off/on), `<leader>rs` (strip trailing whitespace), `<leader>rw` (toggle wrap — deliberately not `<leader>wr`, since `<leader>w` alone is the fast-save mapping), `<leader>cn`/`<leader>cp` (colorscheme cycling, see `g:my_colorschemes`), and `<leader>ev` (quick-edit `$MYVIMRC`, current window not a new tab).
- The status bar is `lightline.vim` by default; a commented-out `vim-airline` alternative (Plug lines + config) is kept under `=> Status line` with switch instructions.
- `ale` is configured for linting/syntax hints (see `=> ALE configuration`); `g:ale_fix_on_save` is intentionally off by default.
- `vim-session` is installed and configured (`g:session_autosave = 'yes'`, `g:session_autoload = 'no'`) but has no keybinding yet.
- `vim-fugitive` (git commands), `vim-surround` (surround text objects), `auto-pairs` (bracket/quote auto-closing), and `vim-polyglot` (broader language syntax/indent support, notably Perl) are installed with no additional configuration.
- `indentLine` is installed and configured (see `=> IndentLine configuration`) for visual indent guides.
- A `language_specific` augroup (under `=> Text, tab and indent related`) sets per-filetype indent widths for Python/JS/HTML/CSS/Go/Vim/Make, overriding the global 4-space default.
- `Pmenu`/`PmenuSel` (completion popup + quickui menu colors) are set via `ApplyPmenuColors()` under `=> Colors and Fonts`, reapplied on every `ColorScheme` event — don't set them with a one-off `highlight` command elsewhere, it will get wiped on the next colorscheme change.
```

---

## Pending / undecided — analyze only, do not implement

Empty — every item raised during planning has been either confirmed above or explicitly skipped below.

### Explicitly skipped (decided, not just pending)

- `SirVer/ultisnips` + `honza/vim-snippets` (snippet engine + library) — user said to skip snippets.
- `ervandew/supertab` — was only being considered as a Tab-completion pairing for UltiSnips; skipped for the same reason.
- `airblade/vim-gitgutter` — user chose to skip. `vim-fugitive` and `nerdtree-git-plugin` (Step 3) don't depend on it.
- `<leader>rn` (relative-number toggle) — user chose to dismiss.
- Terminal-mode mappings (`<Esc>` to exit terminal mode, `<leader>tt`/`<leader>tv`) — user chose to dismiss.
- "Vibe AI" plugin configuration block (`g:vibe_ai_*`) — user chose to dismiss.
- `junegunn/fzf` + `junegunn/fzf.vim` — user said fzf is out.

---

## Verification (run after all Confirmed steps above are done)

- [x] `grep -n "vim-airline" vimrc` — 5 matches (not the predicted 3: the two `Plug` lines plus three lines of Step 7's switch-instructions prose that also say "vim-airline"), all commented out / non-executing.
- [x] `grep -n "xolox/vim-misc\|xolox/vim-session\|tpope/vim-commentary\|dense-analysis/ale\|tpope/vim-fugitive\|Xuyuanp/nerdtree-git-plugin\|tpope/vim-surround\|jiangmiao/auto-pairs\|Yggdroot/indentLine\|sheerun/vim-polyglot" vimrc` — each exactly one match, uncommented.
- [x] `grep -n "morhetz/gruvbox\|tomasr/molokai\|dracula/vim\|arcticicestudio/nord-vim\|joshdick/onedark" vimrc` — each exactly one match.
- [x] `grep -c "=> Custom mappings" vimrc` — exactly `1`.
- [x] `sed -n '/=> Custom mappings/,/call quickui#menu#reset()/p' vimrc | grep -c "leader>rc\|leader>m0\|leader>m1\|leader>rs\|leader>rw\|leader>cn\|leader>cp\|leader>ev"` — 11 matching lines (not the predicted 8: 3 of those lines are the explanatory comments above `<leader>rc` and the colorscheme-cycling block, which also mention mapping names in prose). All eight actual mapping definitions are present together in this one section.
- [x] `sed -n '/=> Misc/,/=> Helper functions/p' vimrc | grep -c "leader>rc\|leader>m0\|leader>m1\|leader>rs\|leader>rw"` — 7, not the predicted `0`, but this is a false positive of the check itself: the sed range's start pattern `/=> Misc/` also matches Step 6's own comment text "(moved here from => Misc; ...)" inside `=> Custom mappings`, re-opening the range with no further `=> Helper functions` to close it, so sed prints to EOF. Checked directly (`sed -n '543,556p' vimrc`), the real `=> Misc` section is clean — none of the relocated/new mappings leaked back into it.
- [x] `grep -n "<Leader>m " vimrc` — 1 match, but it's the Step 6 comment text itself ("renamed from `<Leader>m` to `<leader>rc`"), not a live mapping. The old `noremap <Leader>m ...` line is fully removed.
- [x] `grep -n "g:ale_linters\|g:ale_fixers\|g:ale_fix_on_save\|g:session_autosave\|g:session_autoload\|g:indentLine_char" vimrc` — each exactly one match.
- [x] `grep -n "airline_powerline_fonts\|airline_theme" vimrc` — matches, all commented out, under `=> Status line`.
- [x] `grep -n "augroup language_specific\|NERDTreeShowHidden\|NERDTreeIgnore\|StdinReadPre" vimrc` — each exactly one match.
- [x] `grep -n "g:my_colorschemes\|CycleColorscheme" vimrc` — matches as expected, all inside `=> Custom mappings`.
- [x] `grep -n "ApplyPmenuColors\|autocmd ColorScheme" vimrc` — matches as expected, both under `=> Colors and Fonts`.
- [x] `vim -u vimrc -N -c 'qall'` — loads with no errors (verified with `TERM=dumb vim -u vimrc -N -es -c 'qall'`, exit code 0, no `E***` messages).
- [x] `:PlugInstall` — ran via `vim -u vimrc -N -c 'PlugInstall --sync'`. **Found and fixed two real bugs this surfaced** (see "Bugs found during PlugInstall/testing" note below): a `dracula/vim` install-directory collision with `nordtheme/vim`, and an `indentLine_concealcursor` type error. After both fixes, all 27 plugins install/update cleanly with no errors.
- [x] Functionally tested `<leader>rc` via scripted keystrokes on a file with literal `\r` line endings — `^M` correctly stripped.
- [x] Functionally tested `<leader>m0`/`<leader>m1` — `&mouse` toggles `a` → `` (off) → `a`.
- [x] Functionally tested `<leader>rs` — trailing spaces/tabs correctly stripped from every line.
- [x] Functionally tested `<leader>rw` — `&wrap` toggles `1` → `0`.
- [x] Functionally tested `<leader>cn`/`<leader>cp` — cycles `nord` → `jellybeans` → `gruvbox` → (two `cp`) → back to `nord`; confirmed starting point is `nord` and wraparound works both directions.
- [x] Functionally tested `<leader>ev` — opens `~/.vimrc` (confirmed via a real Vim startup reading `$MYVIMRC`, not the `-u vimrc` override, since `-u` doesn't set `$MYVIMRC`).
- [x] Functionally tested `gcc` (commented a `.py` line with `#`), `ysiw)` (`hello` → `(hello)`), and auto-pairs (typing `foo(` produced `foo()`).
- [x] Confirmed no errors opening a nested-indentation file with indentLine active (visual appearance of the guide characters themselves not confirmed — that part still needs your eyes).
- [x] Confirmed no errors opening a `.pl` file with vim-polyglot active (visual improvement in highlighting not confirmed — needs your eyes).
- [ ] Manually confirm ALE signs appear for a file in a configured language, after installing the relevant linter binaries. (Not testable headlessly without the linter binaries installed.)
- [ ] Manually confirm `:Git` (fugitive) opens a status window in a git repo, and NERDTree shows git status letters (nerdtree-git-plugin). (Not tested — no strong reason to expect an issue, but not verified.)
- [x] Functionally tested `.py`/`.go`/`.js` show correct `&shiftwidth`/`&tabstop`/`&expandtab` per the augroup — `4,4,expandtab` / `8,8,noexpandtab` / `2,2,expandtab` respectively, matching the spec.
- [x] Confirmed a no-args `vim` launch auto-opens NERDTree as a split (`winnr('$')` goes from 1 to 2, new window's `&filetype` is `nerdtree`). **Could not conclusively verify headlessly** that closing the other window then auto-quits Vim: this needs `BufEnter`/`WinEnter` to fire when focus returns to the sole NERDTree window, and in scripted `VimEnter`-nested test automation those events didn't fire reliably (a testing-harness limitation, not necessarily a vimrc defect — this exact snippet is the community-standard one from NERDTree's own docs). Please verify this one yourself interactively: launch `vim` with no args, close the non-tree window, confirm Vim exits instead of leaving a lone NERDTree pane.
- [ ] Manually confirm the completion popup (`<C-n>` in insert mode) and the `vim-quickui` menu (`<leader><space>`) show the custom Pmenu colors, and that they **stay** correct after cycling colorschemes with `<leader>cn`. (Not tested — needs visual confirmation in a real terminal.)

### Bugs found and fixed while running `:PlugInstall` and testing (not anticipated by the original plan text above)

1. **`dracula/vim` install-directory collision.** vim-plug names each plugin's install directory after the repo's last path segment. `nordtheme/vim` (pre-existing) and `dracula/vim` (added in Step 5) both resolve to `~/.vim/plugged/vim`, so `PlugInstall` failed with `Invalid URI ... PlugClean required` on the second one. This is a different problem from the `:colorscheme nord` name ambiguity the plan's Step 5 caution note already flagged — that one is about the runtime scheme name, this one is about the on-disk directory. Fixed by aliasing: `Plug 'dracula/vim', { 'as': 'dracula' }`.
2. **`g:indentLine_concealcursor = 0` threw `E539: Illegal character <0>`** on every buffer open, inside indentLine's own `SetConcealOption` function. `concealcursor`-style options are string-valued (`'n'`, `'v'`, `'i'`, `'c'`, or combinations, or empty), not numeric — `0` isn't a legal value. The plan's own Step 8 "Why" note had anticipated this as a *possible cosmetic issue* ("if indent guides look wrong... try `''` instead of `0`"), but it's actually a hard error on load, not a cosmetic one. Fixed by changing the value to `''`.

Both fixes are already applied in `vimrc`; the Find/Replace blocks earlier in this document still show the original (buggy) values from before these fixes, since this plan describes the edits as originally authored — treat the two notes above as the authoritative correction.
