# Minimal server configuration

Start by cloning and entering the repository:
```
git clone https://github.com/S1M0N38/minimal-server-configuration.git
cd minimal-server-configuration
```

## Manual installations and configurations

The deliberate choice to avoid an installation script helps the final user to understand what is installed and how it is configured.
There is a small set of applications that greatly improve terminal experience:

- [`nvim`](https://neovim.io/): text editor
- [`fzf`](https://github.com/junegunn/fzf): extensible fuzzy finder
- [`fd`](https://github.com/sharkdp/fd): user-friendly alternative to `find`
- [`rg`](https://github.com/BurntSushi/ripgrep): user-friendly alternative to `grep`
- [`uv`](https://docs.astral.sh/uv/): Python package and project manager

### XDG directories

XDG is a standard for UNIX-like systems that defines a set of environment variables that point to a set of standard directories.

- `~/.config`: store configuration files
- `~/.local/share`: store data
- `~/.local/bin`: store binaries
- `~/.cache`: store cache

1. Create them with the following command:
```
mkdir -p ~/.config ~/.local/share ~/.local/share ~/.local/bin ~/.cache
```

2. Copy configuration files into `~/.config`
```
cp -r config/* ~/.config/
```

### Neovim

A text editor that you are comfortable with is really important for inspecting and editing files on the server quickly.
If you don't know Vim just skip this step and use `nano`.

1. Download pre-compiled binary
```
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
```

2. Extract the Archive
```
tar -xzf nvim-linux64.tar.gz
```

3. Move binary, libraries, and share files to the correct location
```
mv nvim-linux64/bin/nvim ~/.local/bin/
mv nvim-linux64/lib/* ~/.local/lib/
mv nvim-linux64/share/* ~/.local/share/
```

4. Delete the archive and the extracted folder
```
rm -rf nvim-linux64*
```

### fzf, fd & ripgrep

`fzf`, `fd` and `rg` release pre-compiled binaries for Linux (X86_64).

1. Install `fzf`
```
curl -LO https://github.com/junegunn/fzf/releases/download/v0.57.0/fzf-0.57.0-linux_amd64.tar.gz
tar -xzf fzf-0.57.0-linux_amd64.tar.gz
mv fzf ~/.local/bin/
rm -rf fzf-0.57.0-linux_amd64*
```

2. Install `fd`
```
curl -LO https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-x86_64-unknown-linux-musl.tar.gz
tar -xzf fd-v10.2.0-x86_64-unknown-linux-musl.tar.gz
mv fd-v10.2.0-x86_64-unknown-linux-musl/fd ~/.local/bin/
rm -rf fd-v10.2.0-x86_64-unknown-linux-musl*
```

3. Install `rg`
```
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.1/ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz
tar -xzf ripgrep-14.1.1-x86_64-unknown-linux-musl.tar.gz
mv ripgrep-14.1.1-x86_64-unknown-linux-musl/rg ~/.local/bin/
rm -rf ripgrep-14.1.1-x86_64-unknown-linux-musl*
```

### Bash

Ubuntu 22.04 uses `bash` as the default shell. The shell behavior can be configured with the `.bashrc` file. There should be a default `.bashrc` file in the home directory that you can inspect with `cat ~/.bashrc`.
The file `bashrc_extra` contains additional configuration that we want to append at the end of the `~/.bashrc` file.

1. Append the content of `bashrc_extra` to the end of the `~/.bashrc` file
```
cat bashrc_extra >> ~/.bashrc
```

2. Restart your terminal/ssh session so changes can take effect or use
```
source ~/.bashrc
```

3. Open `~/.bashrc` with your favorite editor, inspect the changes and modify it if needed.

4. Restart your terminal/ssh session one more time or source `~/.bashrc` again.

> [!IMPORTANT]
> Before proceeding with the next steps, make sure that the environment variables (the lines starting with `export`) are set correctly.
> Those variables will be used by the `uv` installer to specify custom locations where downloads and installations will be stored.

### Python

Python is not installed system-wide. The application `uv` can be used to:

- Install different Python versions (e.g. 3.9, 3.10, 3.11, 3.12)
- Manage Python virtual environments (create, install dependencies, lock versions, etc.)
- Install Python CLI applications (e.g. [huggingface-cli](https://huggingface.co/docs/huggingface_hub/main/en/guides/cli), [nvitop](https://github.com/XuehaiPan/nvitop), etc.)

1. Install uv with
```
curl -LsSf https://astral.sh/uv/install.sh | sh
```
2. Read the uv [Getting Started](https://docs.astral.sh/uv/getting-started/) section of the uv documentation

> [!TIP]
> uv documentation describes [how to use uv with Jupyter Notebooks](https://docs.astral.sh/uv/guides/integration/jupyter/) (from VS Code as well).


## Usage

Here are just **some custom** keymaps defined by this minimal configuration. All the default keymaps are still available.

- `+` means that the keys must be pressed together.
- no `+` means that the keys must be pressed separately one after the other.

### Tmux

- <kbd>⌥</kbd> + <kbd>h</kbd> : move to the right pane
- <kbd>⌥</kbd> + <kbd>j</kbd> : move to the bottom pane
- <kbd>⌥</kbd> + <kbd>k</kbd> : move to the top pane
- <kbd>⌥</kbd> + <kbd>l</kbd> : move to the left pane

### fzf

- <kbd>⌃</kbd> + <kbd>r</kbd> : fuzzy find in command history
- <kbd>⌃</kbd> + <kbd>t</kbd> : fuzzy find files

### Neovim

##### Windows

- <kbd>⌃</kbd> + <kbd>h</kbd> : move to the right window
- <kbd>⌃</kbd> + <kbd>j</kbd> : move to the bottom window
- <kbd>⌃</kbd> + <kbd>k</kbd> : move to the top window
- <kbd>⌃</kbd> + <kbd>l</kbd> : move to the left window
- <kbd>Space</kbd> <kbd>-</kbd> : split window below
- <kbd>Space</kbd> <kbd>|</kbd> : split window right

##### Buffers

- <kbd>⇧</kbd> + <kbd>h</kbd> : move to the previous buffer
- <kbd>⇧</kbd> + <kbd>l</kbd> : move to the next buffer
- <kbd>Space</kbd> <kbd>b</kbd> <kbd>d</kbd>: buffer delete
- <kbd>Space</kbd> <kbd>b</kbd> <kbd>y</kbd>: buffer yank (to system clipboard)

##### File-Tree Explorer

- <kbd>Space</kbd> <kbd>e</kbd> : toggle explorer (relative to buffer)
- <kbd>Space</kbd> <kbd>E</kbd> : toggle explorer (relative to cwd)

##### File Picker

- <kbd>Space</kbd> <kbd>Space</kbd> : find files
- <kbd>Space</kbd> <kbd>,</kbd> : find buffers
- <kbd>Space</kbd> <kbd>f</kbd> <kbd>r</kbd> : find recent files

##### Search Picker

- <kbd>Space</kbd> <kbd>s</kbd> <kbd>k</kbd> : search for available keymaps
- <kbd>Space</kbd> <kbd>s</kbd> <kbd>g</kbd> : search with ripgrep
- <kbd>Space</kbd> <kbd>s</kbd> <kbd>h</kbd> : search neovim help
