Install a recent version of Neovim.

Copy these files to `~/.config/nvim`. You can also use `stow` for this, like:

```shell
mkdir ~/.config/nvim
stow -d . -t ~/.config/nvim .
```

Then open `nvim` to install the plugins automatically.

Language servers need to be installed separately. You might want to remove
lines from `lua/config/lazy.lua` (around `lspconfig`'s `config` function).
