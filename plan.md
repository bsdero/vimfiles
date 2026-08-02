# vimrc cleanup plan

Status legend: `[ ]` not done · `[x]` done · `[-]` skipped (see note)

## How to execute this plan (read first)

You are fixing `vimrc` in this repo. Follow these rules exactly:

1. Do the steps **in order**, one at a time.
2. For each step there is a **Find** block (exact current text) and a **Replace** block (exact new text).
3. Locate the spot to edit by **matching the Find text exactly**, character for character, including indentation and blank lines. **Do not use the line numbers given below to locate text** — they are only a reference from the version of the file reviewed on 2026-08-02, and will drift as soon as one edit is applied. Always search for the Find text itself.
4. If a Find block does **not** match anything in the current file (not even close), **stop and ask** instead of guessing or improvising a fix. Do not adapt, paraphrase, or "fix it your own way."
5. Only change what a step says to change. Do not reformat, rewrite comments, reindent, or "improve" any code outside the listed steps, even if it looks odd to you.
6. After finishing a step, check its checkbox (`[ ]` → `[x]`) in this file so progress is tracked.
7. After all steps are done, run the verification commands at the bottom of this file.

If you are unsure about anything, stop and ask the user — do not guess.

---

## Step 1 — Split the duplicate `<leader>bd` mapping

**Why:** `<leader>bd` is currently defined twice in `vimrc`: once to close the buffer/tab (intended, keep this), and once — later in the file — to disable `virtualedit`. The second definition silently overrides the first, so the buffer-close shortcut currently does nothing. Move the `virtualedit`-off mapping to `<leader>bv` instead, so it pairs cleanly with the existing `<leader>be` ("virtualedit on") mapping.

**Do not touch** the mapping `map <leader>bd :Bclose<cr>:tabclose<cr>gT` found earlier in the file (under `=> Moving around, tabs, windows and buffers`) — that one is correct and stays exactly as-is.

- [x] In `vimrc`, in the `=> Drawbox key maps` section, find:

```
noremap <leader>be :set virtualedit+=all<cr>
noremap <leader>bd :set virtualedit=<cr>
```

  Replace with:

```
noremap <leader>be :set virtualedit+=all<cr>
noremap <leader>bv :set virtualedit=<cr>
```

---

## Step 2 — Fix typo `feedky` → `feedkeys` in the File menu

**Why:** `feedky` is not a real Vim function (the real one is `feedkeys`). Clicking "Save As" in the quickui File menu currently throws an "Unknown function" error.

- [x] In `vimrc`, in the `quickui#menu#install('&File', ...)` block, find:

```
            \ [ "Save &As", 'call feedky(":saveas ")' ],
```

  Replace with:

```
            \ [ "Save &As", 'call feedkeys(":saveas ")' ],
```

---

## Step 3 — Fix "Set Mouse" menu label checking the wrong option

**Why:** The label for the mouse toggle reads `&paste` instead of `&mouse`, so the menu displays the wrong on/off state (it's a copy-paste leftover from the "Set Paste" line right above it). The action itself (`set mouse!`) is already correct — only the label text is wrong.

- [x] In `vimrc`, in the `quickui#menu#install("&Option", ...)` block, find:

```
            \ ['Set Mouse %{&paste? "Off":"On"}', 'set mouse!'],
```

  Replace with:

```
            \ ['Set Mouse %{&mouse? "Off":"On"}', 'set mouse!'],
```

---

## Step 4 — Remove the duplicate `set laststatus=2`

**Why:** `set laststatus=2` appears twice — once under `=> VIM user interface`, once under `=> Status line`. Keep the one under `=> Status line` (Step 5 builds on it) and remove the one under `=> VIM user interface`.

- [x] In `vimrc`, in the `=> VIM user interface` section, find:

```
" Always display the status line, even if only one window is displayed
set laststatus=2

```

  Replace with nothing (delete these two lines and the blank line after them entirely — the line before this block, `set ruler`, should be followed directly by the blank line that originally came after this block).

  Concretely: find this larger block for unambiguous matching —

```
" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
```

  Replace with:

```
" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Instead of failing a command because of unsaved changes, instead raise a
```

---

## Step 5 — Configure `lightline.vim` and remove the manual statusline

**Why:** `Plug 'itchyny/lightline.vim'` is installed but never configured, while a separate hand-written `set statusline=...` is also active. Both mechanisms try to control the status line, which is a conflict. Standardize on `lightline` (it's the plugin that's actually installed for this purpose) and give it an explicit, simple configuration instead of leaving it on defaults silently colliding with the manual statusline.

- [x] In `vimrc`, in the `=> Status line` section, find:

```
" Format the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c
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
```

---

## Step 6 — Remove the now-unused `HasPaste()` function

**Why:** `HasPaste()` was only ever called from the manual `set statusline=...` line removed in Step 5. `lightline`'s `'paste'` component (added in Step 5) replaces its purpose. After Step 5, nothing in the file calls `HasPaste()` anymore — leaving it in would be dead code.

**Do this step only after Step 5 is done.** Before deleting, double check by searching the whole file for the text `HasPaste` — it should appear in exactly one place after Step 5 (the `function!` definition itself, matched below). If it appears anywhere else, stop and ask instead of deleting.

- [x] In `vimrc`, in the `=> Helper functions` section, find:

```
" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

```

  Replace with nothing (delete this whole block, including the trailing blank line).

---

## Step 7 — Disable the unconfigured `vim-project` plugin

**Why:** `Plug 'leafOfTree/vim-project'` is declared but has no accompanying configuration anywhere in the file (no `g:vim_project_*` settings). It currently does nothing useful. Comment it out with a note rather than deleting it outright, so it's easy to re-enable later once someone actually configures it.

- [x] In `vimrc`, in the `call plug#begin()` block, find:

```
Plug 'leafOfTree/vim-project'
```

  Replace with:

```
" Plug 'leafOfTree/vim-project'  "disabled: installed but never configured (no g:vim_project_* settings exist anywhere). Re-enable once configured.
```

---

## Step 8 — Fix the misleading backup/undo comment

**Why:** The comment says "Turn backup off," but every `set` line under it is commented out, so nothing is actually turned off (backup/swap are left at Vim's built-in defaults). The comment currently describes behavior the file doesn't implement. This step only corrects the comment text — it does **not** change any actual setting/behavior.

- [x] In `vimrc`, in the `=> Files, backups and undo` section, find:

```
" Turn backup off, since most stuff is in SVN, git etc. anyway...
" set nobackup
" set nowb
" set noswapfile
```

  Replace with:

```
" Backup/swap/undo are left at Vim's built-in defaults; nothing is
" explicitly configured in this section.
```

---

## Step 9 — Use `$MYVIMRC` instead of a hardcoded `~/.vimrc` path

**Why:** The quickui "Edit Configurations" menu item hardcodes `~/.vimrc`. This repo's own README documents that under Neovim, this config is installed as `~/.config/nvim/init.vim`, not `~/.vimrc` — so on a Neovim setup this menu item can point at the wrong (or a nonexistent) file. `$MYVIMRC` is the variable Vim/Neovim both set to the actual config file in use, and it's already used correctly elsewhere in this same file (the vim-plug bootstrap block near the top uses `source $MYVIMRC`).

- [x] In `vimrc`, in the `quickui#menu#install("&Option", ...)` block, find:

```
            \ ['Edit Configurations', 'tabe ~/.vimrc', 'Edit configuration' ],
```

  Replace with:

```
            \ ['Edit Configurations', 'tabe $MYVIMRC', 'Edit configuration' ],
```

---

## Step 10 — Update `CLAUDE.md` to match Step 1's key rename

**Why:** `CLAUDE.md` documents the old key: "box-drawing (`vim-boxdraw`) mappings toggle `virtualedit` via `<leader>be` / `<leader>bd`." After Step 1, the correct key is `<leader>bv`, not `<leader>bd`. If this isn't updated, the project's own documentation will describe a mapping that no longer exists.

- [x] In `CLAUDE.md`, find:

```
- **NERDTree** is bound to `<leader>n`; box-drawing (`vim-boxdraw`) mappings toggle `virtualedit` via `<leader>be` / `<leader>bd`.
```

  Replace with:

```
- **NERDTree** is bound to `<leader>n`; box-drawing (`vim-boxdraw`) mappings toggle `virtualedit` via `<leader>be` / `<leader>bv`.
```

---

## Explicitly NOT changing (do not touch, do not re-flag)

- **`<Leader>m` mapping** (the `^M` / Windows-line-ending remover, around the `=> Editing mappings` section). It was initially suspected to be broken because it contains literal text `<C-v><cr>` instead of a raw control byte — but this is **correct, standard Vim `:map` key-notation syntax**, not a bug. `<C-v>` and `<cr>` are parsed by Vim into real keypresses (Ctrl-V, then Enter) when the mapping is defined; Ctrl-V inside a command-line context makes the following Enter get inserted as a literal carriage-return character instead of submitting the command. This is intentional and works as-is. **Leave it completely untouched.**
- **Colorscheme `Plug` list** (`papercolor-theme`, `everforest`, `rigel`, `hydrangea-vim`, `lucario`, `nordtheme/vim`, `jellybeans`, `awesome-vim-colorschemes`, `catppuccin/nvim`, `tokyonight.nvim`, `rose-pine/neovim`). Only a few of these are ever activated via `colorscheme`, but this is deliberate ongoing experimentation (matches recent repo commit history) — leave the whole list as-is.

---

## Verification (run after all steps above are done)

- [x] `grep -n '<leader>bd\|<leader>bv' vimrc` — should show `<leader>bd` exactly once (the `:Bclose<cr>:tabclose<cr>gT` mapping) and `<leader>bv` exactly once (the `virtualedit=` mapping).
- [x] `grep -n 'feedky' vimrc` — should show zero matches for bare `feedky(` — only `feedkeys(` should appear.
- [x] `grep -n 'HasPaste' vimrc` — should show zero matches (function and its one caller both removed).
- [x] `grep -n 'g:lightline' vimrc` — should show the new lightline config block.
- [x] `vim -u vimrc -c 'qall'` (or the Neovim equivalent per this repo's `CLAUDE.md`) — should load with no errors. (See note below — verified via alternate method since this exact invocation has a pre-existing environment quirk in this sandbox.)
- [ ] Open vim/neovim with this config and check the quickui `Option` menu (`<leader><space>`) — "Set Mouse" toggle label should now flip based on actual mouse state, not paste state.
- [ ] Optional: `:PlugClean` to remove the now-undeclared `vim-project` plugin from disk (safe — it's reversible by uncommenting the `Plug` line and running `:PlugInstall` again). Confirm with the user before running this if unsure.

**Note on the `vim -u vimrc -c 'qall'` check:** in this sandbox, that exact invocation leaves Vim in `'compatible'` mode (bare `-u <file>` doesn't trigger Vim's usual auto-`nocompatible` here), which breaks backslash line-continuation for *every* multi-line command in the file — not just the new `g:lightline` block, but the pre-existing `quickui#menu#install(...)` blocks too (confirmed by running the same check against the pre-edit file via `git stash`). Running `vim -u vimrc -N -c 'qall'` (explicit `-N`) removes all of that noise; the only errors left are `E117: Unknown function: quickui#menu#*`, because the `vim-quickui` plugin itself was never installed in this sandbox (only `plug.vim` bootstrapped — no `:PlugInstall` has been run here). Isolated sourcing of the new `g:lightline` block (`vim -u NONE -N -es -c 'source ...'`) also parses with zero errors. So the edits are syntactically sound; a real `vim -u vimrc -c 'qall'` on a normal (non-sandboxed) machine, or after `:PlugInstall`, should show no errors.
