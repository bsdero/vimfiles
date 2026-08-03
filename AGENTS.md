# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

This is a personal Vim/Neovim configuration repository (dotfiles), not a software application. There is no build system, package manifest, linter, or test suite — the repository consists almost entirely of a single `vimrc` file (VimScript) plus documentation.

## Files

- `vimrc` — the active, working Vim/Neovim configuration. Compatible with both Vim and Neovim (many settings are gated with `has('nvim')` checks).
- `vimrc_to_fix` — a work-in-progress draft of a much larger rewrite of `vimrc` (many more plugins: ALE, fzf, fugitive, gitgutter, ultisnips, vim-airline, an AI assistant plugin config, etc.). It is **not** the active config and is **not yet working** — treat it as a scratch/staging file being iterated on, not as source of truth. Do not assume its contents are correct or should be merged wholesale into `vimrc`.
- `README.md` — install instructions for using this vimrc with Neovim.
- `LICENSE` — BSD 3-Clause.

## Installing / activating the config (for manual verification)

Vim:
```
cp vimrc ~/.vimrc
vim +PlugInstall +qall
```

Neovim (per README.md):
```
mkdir -p ~/.local/share/nvim/site/autoload
mkdir ~/.config/nvim
cp vimrc ~/.config/nvim/init.vim
cp -R ~/.vim/autoload/plug.vim ~/.local/share/nvim/site/autoload/
```

Plugins are managed with `vim-plug`. The `vimrc` auto-bootstraps `plug.vim` if missing (via `curl`, into `stdpath('data')` for Neovim or `~/.vim` for Vim). After editing plugin declarations, run `:PlugInstall` (and `:PlugClean` if plugins were removed) inside Vim/Neovim to apply changes — there is no CLI/headless test for this.

## Sanity-checking changes

There is no automated test suite. To verify a change to `vimrc`:
- `vim -u vimrc -c 'qall'` (or the Neovim equivalent) to confirm it loads without error.
- `:PlugInstall` to confirm any newly added `Plug` lines resolve.
- `:checkhealth` in Neovim is useful after plugin/colorscheme changes.
- Gotcha when testing headlessly (`vim -es -c 'source vimrc' -c '...'`): vim-plug defers loading each plugin's `plugin/*.vim` until the `VimEnter` autocommand, which doesn't fire in `-es` batch mode. So commands like `:OpenSession` won't `exist()` yet even though the plugin loaded fine — run `:runtime plugin/session.vim` (or the relevant plugin) first if you need to exercise its commands from a headless script. This is a headless-testing artifact only; interactive Vim usage is unaffected since `VimEnter` fires normally before you can type.

## Structure of `vimrc`

The file is organized into clearly marked sections (see the header comment block at the top of the file for the full list and line-level navigation): General, vim-plug plugin declarations, VIM user interface, Colors and Fonts, Files/backups, Text/tab/indent, Visual mode, Moving around (tabs/windows/buffers), Status line, Editing mappings, vimgrep/cope, Spell checking, Misc, Helper functions, then NERDTree/box-drawing keymaps, `=> Session key maps`, `=> Custom mappings`, and a `vim-quickui` menu definition at the end.

Points worth knowing before editing:
- **Leader key** is `,` (comma), set near the top under `=> General`.
- **Colorscheme selection is Vim/Neovim-conditional**: Neovim tries `tokyonight-night` first (falls back to `industry`); Vim tries `nord` (falls back to `industry`). Both are wrapped in `try/catch` since the colorscheme plugin may not be installed yet on a fresh checkout.
- **True-color (`termguicolors`) is only enabled outside tmux** (`if (empty($TMUX))`), with separate handling for old vs. new Neovim/Vim true-color support.
- **`vim-quickui`** provides the File/Edit/Buffer/Option/Colors/Session/Help menu at the bottom of the file, opened with `<leader>mm` (renamed from `<leader><space>`). When adding new commands/mappings that should be user-discoverable, consider adding a corresponding quickui menu entry — most existing items include a tip string pointing back at the equivalent `<leader>` mapping, e.g. `'Same as <leader>cn'`; keep that convention for new items.
- **NERDTree** is bound to `<leader>n`; box-drawing (`vim-boxdraw`) mappings toggle `virtualedit` via `<leader>be` / `<leader>bv`. NERDTree also now auto-opens on a no-args `vim` launch, auto-quits Vim if it's the last window open, shows hidden files, and ignores `.pyc`/`__pycache__`/`.git`/`.DS_Store`. `nerdtree-git-plugin` overlays git status flags in the tree.
- A `BufWritePre` autocmd strips trailing whitespace for `*.txt,*.js,*.py,*.wiki,*.sh,*.coffee` via `CleanExtraSpaces()` — be aware this will silently rewrite trailing whitespace in those filetypes on save. `<leader>rs` (in `=> Custom mappings`) does the same strip manually, on demand, for any filetype.
- **All mappings added after the initial cleanup pass live together in a `=> Custom mappings` section**, near the end of the file (after `=> Session key maps`, before the `vim-quickui` menu definitions) — check there first. It holds: `<leader>rc` (the `^M`-strip mapping, relocated from `=> Misc`, renamed from `<Leader>m`), `<leader>m0`/`<leader>m1` (mouse off/on), `<leader>rs` (strip trailing whitespace), `<leader>rw` (toggle wrap — deliberately not `<leader>wr`, since `<leader>w` alone is the fast-save mapping), `<leader>cn`/`<leader>cp` (colorscheme cycling, see `g:my_colorschemes`), and `<leader>ev` (quick-edit `$MYVIMRC`, current window not a new tab). The session mappings (`<leader>So`/`Ss`/`Sc`/`Sd`/`Sl`) live in their own `=> Session key maps` section just above this one, not inside it.
- The status bar is `lightline.vim` by default; a commented-out `vim-airline` alternative (Plug lines + config) is kept under `=> Status line` with switch instructions.
- `ale` is configured for linting/syntax hints (see `=> ALE configuration`); `g:ale_fix_on_save` is intentionally off by default. TypeScript uses `tslint` only — `tsserver` was deliberately left out.
- `vim-session` is installed and configured (`g:session_autosave = 'yes'`, `g:session_autoload = 'no'`). Keybindings live in `=> Session key maps` (capital `S` deliberately, so they don't collide with the lowercase `<leader>s*` spell mappings): `<leader>So`/`Ss`/`Sc`/`Sd` (open/save/close/delete), `<leader>Sl` (echo current session name via `xolox#session#find_current_session()`, or "No session open"). Note: `xolox#session#get_names()` requires a boolean argument (`0` to exclude name suggestions) — omitting it throws `E119`, as the quickui "List Sessions" item did until fixed.
- `vim-fugitive` (git commands), `vim-surround` (surround text objects), `auto-pairs` (bracket/quote auto-closing), and `vim-polyglot` (broader language syntax/indent support, notably Perl) are installed with no additional configuration.
- `indentLine` is installed and configured (see `=> IndentLine configuration`) for visual indent guides.
- A `language_specific` augroup (under `=> Text, tab and indent related`) sets per-filetype indent widths for Python/JS/HTML/CSS/Go/Vim/Make, overriding the global 4-space default.
- `Pmenu`/`PmenuSel` (completion popup + quickui menu colors) are set via `ApplyPmenuColors()` under `=> Colors and Fonts`, reapplied on every `ColorScheme` event — don't set them with a one-off `highlight` command elsewhere, it will get wiped on the next colorscheme change.
- Neovim-only plugins (currently `catppuccin/nvim`, `folke/tokyonight.nvim`, `rose-pine/neovim`) are declared inside an `if has('nvim')` block within the `plug#begin()`/`plug#end()` section — keep new Neovim-only plugins inside that guard so Vim-only setups aren't affected.

## Pending tasks (tracked in README.md)

1. **No autocompletion plugin is installed.** There's linting (`ale`) and syntax packs (`vim-polyglot`) but nothing providing completion with hints/signature help (e.g. `coc.nvim`, `nvim-cmp` + LSP, or ALE's own completion support). Worth adding.

The `vim-quickui` menus were previously flagged as stale; they've since been expanded with Buffer/Colors/Session menus and additional Option toggles (ALE, NERDTree, wrap, trailing whitespace) — see `call quickui#menu#install(...)` at the end of `vimrc`. `vim-fugitive` is still deliberately not represented in any menu (skipped by request). When adding menu items here, follow the existing `[text, command, tip]` list format and keep the `%{...}` inline-eval convention used for the toggle items in the `&Option` menu.

## Working conventions in this repo

- Keep `vimrc` Vim/Neovim-compatible; guard Neovim-only features with `has('nvim')`.
- Wrap `colorscheme` assignments in `try/catch` so a missing/uninstalled colorscheme doesn't break the whole config.
- Comment new `Plug` lines with a short description of what the plugin does, matching the existing style.
