# mkapra's dotfiles

## (n)vim

My (n)vim configuration file works for both editors. This makes it possible
to simply link the configuration:

```bash
ln -s $HOME/.vimrc $HOME/.config/nvim/init.vim
```

## Shells

I maintain configurations for:

* `bash`
* `zsh`

The aim is to provide a configuration that nearly works the same on both
shells for the basic stuff. The main difference is that `zsh` has more features.

For local specific configuration use the `.local_shrc` file. This file will be
automatically sourced by both.
