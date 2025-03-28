+++
title = 'Development=settings'
description = ""
date = 2024-01-31T14:54:57+07:00
draft = true
tags = ['development']
author = "anhkhoakz"
+++

---

# Operating System

I'm using MacOS.

For the packet manager, I use [HomeBrew](https://brew.sh/). It's an easy way to install packages and applications.
I use [iTerm2](https://iterm2.com/) instead of default Terminal.
I use Z shell with [Oh My Zsh](https://ohmyz.sh/) for Unix Shell.
Theme: [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
Terminal font: [JetBrains Mono Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono)
Profile color: [One Dark](https://github.com/one-dark/iterm-one-dark-theme)

You can follow this tutorial for configurations: [How To Setup Your Mac Terminal](https://www.josean.com/posts/terminal-setup).

The font I'm currently use is [JetBrains Mono](https://github.com/JetBrains/JetBrainsMono/)

# Code Editor

I've 3 type of applications used for: fast, slow, slower cases.

For edit some file quickly, I use [NeoVim](https://neovim.io/) with [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) for configurations.

If I need a tool to work with my university homework? I will choose VSCode for its lightweight and extensibility.

## VSCode configurations and extensions

-   Python language: [Python](https://github.com/Microsoft/vscode-python), [Pylance](https://github.com/microsoft/pylance-release), [Ruff](https://github.com/astral-sh/ruff-vscode)
-   Theme: [One Dark Pro](https://github.com/Binaryify/OneDark-Pro), Product Icon: [Fluent Icons](https://github.com/miguelsolorio/vscode-fluent-icons), Icon Theme: [Material Icon Theme](https://github.com/PKief/vscode-material-icon-theme)
-   Markdown: [Markdown All in One](https://github.com/yzhang-gh/vscode-markdown)
-   Keymap: [VSCode NeoVim](https://github.com/vscode-neovim/vscode-neovim)
-   Formatter: [Prettier](https://github.com/prettier/prettier), [VSCode Workspace Formatter](https://github.com/franneck94/vscode-Workspace-formatter)
-   Other: [Path Intellisense](https://github.com/ChristianKohler/PathIntellisense)

## NeoVim configurations

My personal configuration file [anhkhoakz/kickstart.nvim](https://codeberg.org/anhkhoakz/kickstart.nvim) folked from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

Some my configurations: [keybindings.json](https://codeberg.org/anhkhoakz/Laboratory-Preparations/src/branch/main/src/keybindings.json), [settings.json](https://codeberg.org/anhkhoakz/Laboratory-Preparations/src/branch/main/src/settings.json)

## Integrated development environment

For my big projects I will use the IDEs for the best workflow and less configurations, I will choose the JetBrain's products.

## Environment Variables

I'm using [nvm](https://github.com/nvm-sh/nvm) to manage Node.js versions.

I'm using [SDKMAN!](https://github.com/sdkman/sdkman-cli) to manage Java versions.

I'm using [pyenv](https://github.com/pyenv/pyenv) to manage Python versions.

# Some Alternatives

I use [pnpm](https://pnpm.io/) instead of npm for better performance, and storage saving.

If you take privacy seriously, you can have a look at [VSCodium](https://vscodium.com/) to replace VSCode. It's fully open-source with telemetry-disabled by default.

You can check out [Nix: the package manager](https://nixos.org/download#nix-install-macos), it's more complicated but it's faster.

NeoVim configuration templates alternatives to [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim):

-   [LazyVim](https://github.com/LazyVim/LazyVim)
-   [LunarVim](https://github.com/lunarvim/lunarvim)
-   [AstroNvim](https://github.com/AstroNvim/AstroNvim)
-   [NvChad](https://github.com/NvChad/NvChad)
-   [Others](https://lazyman.dev/posts/Configuration-Distributions/)

---
