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

## Structure of `vimrc`

The file is organized into clearly marked sections (see the header comment block at the top of the file for the full list and line-level navigation): General, vim-plug plugin declarations, VIM user interface, Colors and Fonts, Files/backups, Text/tab/indent, Visual mode, Moving around (tabs/windows/buffers), Status line, Editing mappings, vimgrep/cope, Spell checking, Misc, Helper functions, then NERDTree/box-drawing keymaps and a `vim-quickui` menu definition at the end.

Points worth knowing before editing:
- **Leader key** is `,` (comma), set near the top under `=> General`.
- **Colorscheme selection is Vim/Neovim-conditional**: Neovim tries `tokyonight-night` first (falls back to `industry`); Vim tries `nord` (falls back to `industry`). Both are wrapped in `try/catch` since the colorscheme plugin may not be installed yet on a fresh checkout.
- **True-color (`termguicolors`) is only enabled outside tmux** (`if (empty($TMUX))`), with separate handling for old vs. new Neovim/Vim true-color support.
- **`vim-quickui`** provides the File/Edit/Option/Help menu at the bottom of the file, opened with `<leader><space>`. When adding new commands/mappings that should be user-discoverable, consider adding a corresponding quickui menu entry.
- **NERDTree** is bound to `<leader>n`; box-drawing (`vim-boxdraw`) mappings toggle `virtualedit` via `<leader>be` / `<leader>bv`.
- A `BufWritePre` autocmd strips trailing whitespace for `*.txt,*.js,*.py,*.wiki,*.sh,*.coffee` via `CleanExtraSpaces()` — be aware this will silently rewrite trailing whitespace in those filetypes on save.
- Neovim-only plugins (currently `catppuccin/nvim`, `folke/tokyonight.nvim`, `rose-pine/neovim`) are declared inside an `if has('nvim')` block within the `plug#begin()`/`plug#end()` section — keep new Neovim-only plugins inside that guard so Vim-only setups aren't affected.

## Working conventions in this repo

- Keep `vimrc` Vim/Neovim-compatible; guard Neovim-only features with `has('nvim')`.
- Wrap `colorscheme` assignments in `try/catch` so a missing/uninstalled colorscheme doesn't break the whole config.
- Comment new `Plug` lines with a short description of what the plugin does, matching the existing style.
