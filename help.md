# How to use these files

This is a small guide/checklist to help set up new installations.

## vim

1. [Install NodeJS](https://nodejs.dev/learn/how-to-install-nodejs) (this is a
    dependency of CoC).

1. [Install vim-plug](https://github.com/junegunn/vim-plug).

1. Create symlinks for `.vimrc` and `.vim`.

    ```bash
    ln -s FULL_PATH_TO_VIMRC ~/.vimrc
    ln -s FULL_PATH_TO_VIMDIR ~/.vim
    ```

1. Install vim packages `:PlugUpdate`.

1. Install CoC extensions.

## fish

1. [Install pure](https://github.com/pure-fish/pure).

1. Symlink `config.fish`.

    ```bash
    ln -s FULL_PATH_TO_CONFIG.FISH ~/.config/fish/config.fish
    ```

1. Set up the custom prompt.

    Symlink `_custom_prompt_time.fish`:

    ```bash
    ln -s FULL_PATH_TO_PROMPT_TIME ~/.config/fish/functions/_custom_prompt_time.fish
    ```

    Change the `_pure_prompt_first_line.fish` function to use the custom time.
    Something like:

    ```fish
    set --local custom_time (_custom_prompt_time)

    # Then add `$custom_time` at the end of both `prompt_components`.
    ```

## Scripts

1. Create a directory where custom scripts will be stored and add it to the
    path.

    Modify `~/.profile` like this: `PATH=$PATH:YOUR_DIR`.

1. Symlink all the scripts you want to that directory. For example:
    `ln -s FULL_PATH_TO_CFINIT YOUR_DIR/cfinit`.
