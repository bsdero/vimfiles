# vimfiles
My vim configurations.

Compatible with neovim. Just use:

```
mkdir -p ~/.local/share/nvim/site/autoload
mkdir ~/.config/nvim
cp ~/.vimrc ~/.config/nvim/init.vim
cp -R ~/.vim/autoload/plug.vim ~/.local/share/nvim/site/autoload/
```

For install neovim in ubuntu:
[https://how.wtf/how-to-install-neovim-on-ubuntu.html](https://how.wtf/how-to-install-neovim-on-ubuntu.html)

Plugins are managed with [vim-plug](https://github.com/junegunn/vim-plug); `vimrc`
bootstraps it automatically on first run. After pulling changes, run `:PlugInstall`
inside Vim/Neovim (and `:PlugClean` if a plugin was removed).

Leader key is `,`.

## Plugins

- **File explorer**: [NERDTree](https://github.com/preservim/nerdtree) (`<leader>n`),
  auto-opens on a no-args launch, shows hidden files, ignores
  `.pyc`/`__pycache__`/`.git`/`.DS_Store`; git status flags via
  [nerdtree-git-plugin](https://github.com/Xuyuanp/nerdtree-git-plugin).
- **Git**: [vim-fugitive](https://github.com/tpope/vim-fugitive) (`:Git`, `:Git blame`,
  `:Gdiffsplit`, ...).
- **Linting**: [ALE](https://github.com/dense-analysis/ale) — lints on save for
  Python, JavaScript, TypeScript, Go, C/C++; fixers configured but
  `g:ale_fix_on_save` is off by default.
- **Sessions**: [vim-session](https://github.com/xolox/vim-session), autosave on.
  Mappings: `<leader>So` open, `<leader>Ss` save, `<leader>Sc` close,
  `<leader>Sd` delete, `<leader>Sl` show current session name.
- **Editing helpers**: [vim-commentary](https://github.com/tpope/vim-commentary)
  (`gcc` / `gc`), [vim-surround](https://github.com/tpope/vim-surround)
  (`cs"'`, `ds"`, `ysiw)`), [auto-pairs](https://github.com/jiangmiao/auto-pairs)
  (auto-close brackets/quotes), [indentLine](https://github.com/Yggdroot/indentLine)
  (visual indent guides), [vim-polyglot](https://github.com/sheerun/vim-polyglot)
  (broader language syntax/indent support, notably Perl).
- **Status line**: [lightline.vim](https://github.com/itchyny/lightline.vim) by
  default; a commented-out [vim-airline](https://github.com/vim-airline/vim-airline)
  alternative with switch instructions lives in the `=> Status line` section.
- **Menus**: [vim-quickui](https://github.com/skywind3000/vim-quickui) menu bar,
  opened with `<leader>mm`. Covers File / Edit / Buffer / Option / Colors /
  Session / Help — each item mirrors an existing mapping/command where one
  exists (see its tip text).
- Also included: `vim-boxdraw` (box/line drawing), `vim-windowswap`.

## Colorschemes

PaperColor, everforest, rigel, hydrangea, lucario, nord (default), jellybeans,
gruvbox, molokai, dracula, nord-vim, onedark, plus the
[awesome-vim-colorschemes](https://github.com/rafi/awesome-vim-colorschemes) bundle.
Neovim also gets catppuccin, tokyonight, and rose-pine.

Cycle through the main list with `<leader>cn` (next) / `<leader>cp` (previous).

## Custom mappings

All mappings added on top of the original config live together in the
`=> Custom mappings` section near the end of `vimrc`:

| Mapping | Effect |
|---|---|
| `<leader>rc` | Strip Windows `^M` line endings |
| `<leader>m0` / `<leader>m1` | Mouse off / on |
| `<leader>rs` | Strip trailing whitespace (any filetype, on demand) |
| `<leader>rw` | Toggle line wrap |
| `<leader>cn` / `<leader>cp` | Cycle colorscheme next / previous |
| `<leader>ev` | Quick-edit this vimrc/init.vim |

## Per-language indent widths

Python: 4 spaces · JS/HTML/CSS: 2 spaces · Go: 8 (tabs) · Vim: 2 spaces ·
Make: 8 (tabs) — overriding the global 4-space default.

## Pending tasks

1. Add a good autocompletion plugin with hints (e.g. a completion engine with
   signature help/documentation popups) — nothing like this is installed yet.


