+++
title = 'ZSH Configurations'
description = "ZSH Configuration Optimization Guide"
date = 2025-06-14T23:58:05+07:00
draft = true
tags = ["zsh", "optimization"]
author = "anhkhoakz"
+++

---

## Framework Selection and Initial Assessment

There are many frameworks for ZSH, and I've tried a few of them.

- Oh My ZSH [Unleash your terminal like never before](https://ohmyz.sh/)
- Prezto [The configuration framework for Zsh](https://github.com/sorin-ionescu/prezto)
- zsh4humans [A turnkey configuration for Zsh](https://github.com/romkatv/zsh4humans/tree/v5)

Yes, I've watched a lot of videos about Oh My ZSH, and I've tried it.
But I've found that it's too heavy for my use case.

The motivation for me to optimize my ZSH configuration comes
that after I read the [Speed Matters: How I Optimized My ZSH Startup to Under 70ms](https://santacloud.dev/posts/optimizing-zsh-startup-performance).

`.zshrc` file is the main configuration file for ZSH.

```bash
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

export POWERSHELL_TELEMETRY_OPTOUT=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export PATH="$PATH:$HOME/.pubcache/bin:/Applications/Docker.app/Contents/Resources/bin/:/bin:$HOME/.gem/bin:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$HOME/.composer/vendor/bin:/opt/homebrew/opt/uutils-coreutils/libexec/uubin:/$HOME/Library/Application Support/fnm"
export CHROME_EXECUTABLE="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
export BUN_INSTALL="$HOME/.bun"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export NODE_COMPILE_CACHE=$HOME/.cache/nodejs-compile-cache
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
export PATH="/opt/homebrew/opt/uutils-coreutils/libexec/uubin:$PATH"
export FNM_PATH="$HOME/Library/Application Support/fnm"
export LS_COLORS="$(vivid generate ayu)"

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

. "$HOME/.cargo/env"

if [ -d "$FNM_PATH" ]; then
  export PATH="$HOME/Library/Application Support/fnm:$PATH"
  eval "`fnm env`"
fi

# Aliases and Functions
# ...
# End of Aliases and Functions

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
```

`.preztorc` file is the configuration file for Prezto. Here is a list of
Prezto modules that I use:

```bash
zstyle ':prezto:load' pmodule \
  'environment' \
  'terminal' \
  'editor' \
  'history' \
  'directory' \
  'spectrum' \
  'utility' \
  'completion' \
  'fast-syntax-highlighting' \
  'history-substring-search' \
  'autosuggestions' \
  'prompt' \
  'osx' \
  'git' \
  'eza'
```

And you know what? This has the significant poor performance:

ZSH-bench results:

| Feature/Metric           | Initial       |
|--------------------------|:--------------:|
| creates_tty              |       0        |
| has_compsys              |       1        |
| has_syntax_highlighting  |       1        |
| has_autosuggestions      |       1        |
| has_git_prompt           |       1        |
| first_prompt_lag_ms      |    137.08      |
| first_command_lag_ms     |    195.358     |
| command_lag_ms           |    66.017      |
| input_lag_ms             |    10.483      |
| exit_time_ms             |    64.467      |

Where:

|name|  meaning |
| -- | -- |
|creates tty| the shell creates its own TTY by invoking tmux or screen|
|has compsys| the shell initializes compsys—the "new" completion system—by invoking compinit|
|has syntax highlighting| user input (the command line) is highlighted by zsh-syntax-highlighting|
|has autosuggestions| suggestions for command completions are offered automatically by zsh-autosuggestions|
|has git prompt| git branch is displayed in prompt|
| first prompt lag (ms) | from the start of the shell to the moment prompt appears on the screen |
| first command lag (ms) | from the start of the shell to the moment the first interactive command starts executing |
| command lag (ms) | from pressing Enter on an empty command line to the moment the next prompt appears; the same as zsh-prompt-benchmark (my project) |
| input lag (ms) | from pressing a regular key to the moment the corresponding character appears on the command line; this test is performed when the current command line is already fairly long |
| exit time (ms) | how long it takes to execute zsh -lic "exit"; this value is meaningless as far as measuring interactive shell latencies goes |

You can refer to the [How not to benchmark](https://github.com/romkatv/zsh-bench?tab=readme-ov-file#how-not-to-benchmark)

The raw zsh loadtime with `--no-rcs` is:

| Feature/Metric           | --no-rcs       |
|--------------------------|:--------------:|
| creates_tty              |       0        |
| has_compsys              |       0        |
| has_syntax_highlighting  |       0        |
| has_autosuggestions      |       0        |
| has_git_prompt           |       0        |
| first_prompt_lag_ms      |    17.993      |
| first_command_lag_ms     |    18.115      |
| command_lag_ms           |     0.063      |
| input_lag_ms             |     0.288      |
| exit_time_ms             |    17.049      |

This is the baseline, the "ideal" metric for the zsh startup time.

So I'm trying to reduce the first prompt lag, first command lag,
command lag, input lag, and exit time.

## Optimization Steps

I'm going to determine whether the prezto or my configurations
slow down the zsh startup time.

| Feature/Metric           | Disable Prezto | Disable My Configurations |
|--------------------------|:--------------:|:-------------------------:|
| creates_tty              |       0        |            0              |
| has_compsys              |       0        |            1              |
| has_syntax_highlighting  |       0        |            1              |
| has_autosuggestions      |       0        |            1              |
| has_git_prompt           |       1        |            0              |
| first_prompt_lag_ms      |    102.529     |         52.73             |
| first_command_lag_ms     |    102.731     |        63.196             |
| command_lag_ms           |     61.759     |        10.302             |
| input_lag_ms             |     0.223      |        10.099             |
| exit_time_ms             |    43.516      |        37.033             |

So I can conclude that my configurations are the main reason
that slows down the zsh startup time.

### Optimization 1: Remove virtual environment variables

I use fnm to manage Node.js versions, and it sets some
environment variables. Although the [fnm](https://github.com/Schniz/fnm) is considered as faster than
[nvm](https://github.com/nvm-sh/nvm). But I'm not using it frequently, and it adds
some overhead, so I can remove it from the startup time.

```bash
# if [ -d "$FNM_PATH" ]; then
#   export PATH="$HOME/Library/Application Support/fnm:$PATH"
#   eval "`fnm env`"
# fi
```

You can do the same for other virtual environment managers like `pyenv`,
`rbenv`, etc.

### Optimization 2: Remove homebrew completions

I love the homebrew completions, although it adds some overhead
to the zsh startup time. So I choose to keep it, but it also
predefined in prezto in [modules/completion/init.zsh](https://github.com/sorin-ionescu/prezto/blob/6e564503f1c5e6ddba2bcf5d9065e5872ca207d2/modules/completion/init.zsh#L18C1-L26C3).

```bash
fpath=(${0:h}/external/src $fpath)

if (( $+commands[brew] )); then
  brew_prefix=${HOMEBREW_PREFIX:-${HOMEBREW_REPOSITORY:-$commands[brew]:A:h:h}}
  [[ $brew_prefix == '/usr/local/Homebrew' ]] && brew_prefix=$brew_prefix:h
  fpath=($brew_prefix/opt/curl/share/zsh/site-functions(/N) $fpath)
  unset brew_prefix
fi
```

But it is keg-only brewed (a formula is keg-only if it is
not symlinked into Homebrew’s prefix). But I want more suggestions, so I edit
that completion file to add the homebrew completions path.

I also doesn't need the `zsh-completions` formula, so I remove it from the
completions path too.

```bash
# fpath=(${0:h}/external/src $fpath)
if (( $+commands[brew] )); then
  brew_prefix=${HOMEBREW_PREFIX:-${HOMEBREW_REPOSITORY:-$commands[brew]:A:h:h}}
  [[ $brew_prefix == '/usr/local/Homebrew' ]] && brew_prefix=$brew_prefix:h
  fpath=($brew_prefix/share/zsh/site-functions $fpath)
  unset brew_prefix
fi
```

### Optimization 3: Cache some files

I love the [vivid](https://github.com/sharkdp/vivid) tool to
generate the LS_COLORS, but it takes some time to generate
the colors every time I start zsh.
So I cache the output of the `vivid generate` command in a file
and source it in the `.zshrc` file.

```bash
LS_COLORS_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/LS_COLORS_nord"

if [[ ! -f "$LS_COLORS_CACHE" ]]; then
  vivid generate nord > "$LS_COLORS_CACHE"
fi

export LS_COLORS="$(<"$LS_COLORS_CACHE")"
unset LS_COLORS_CACHE
```

I will use the `zsource()` function [Speed Matters: How I Optimized My ZSH Startup to Under 70ms](https://santacloud.dev/posts/optimizing-zsh-startup-performance/#zsource:~:text=It%E2%80%99s%20about%20protecting%20flow.)
to source the file instead of the `source` command.

```bash
function zsource() {
  local file=$1
  local zwc="${file}.zwc"
  if [[ -f "$file" && (! -f "$zwc" || "$file" -nt "$zwc") ]]; then
    zcompile "$file"
  fi
  source "$file"
}
```

If you installed fzf using Homebrew, you maybe have the
`$HOME/.fzf.zsh` file, which is the fzf completion and key bindings.
We now just source it using the `zsource()` function.

```bash
zsource $HOME/.fzf.zsh
```

You can do the same for zoxide completion and key bindings.

```bash
if [[ ! -f $HOME/.zoxide.zsh ]]; then
  zoxide init --cmd=cd zsh > $HOME/.zoxide.zsh
fi
zsource $HOME/.zoxide.zsh
```

### Optimization 4: Change the prompt from `starship` to `powerlevel10k`

Although prezto offer the `prompt` module which come with some
predefined themes including `powerlevel10k`, I prefer to use
download the `powerlevel10k` theme and use it directly.

Don't use zsource for instant prompt [powerlevel10k instant prompt docs](https://github.com/romkatv/powerlevel10k/blob/36f3045d69d1ba402db09d09eb12b42eebe0fa3b/README.md?plain=1#L1047C1-L1048)

```bash
# eval "$(starship init zsh)"
# Start of the file
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Something here ...

# End of the file
zsource $HOME/powerlevel10k/powerlevel10k.zsh-theme
zsource $HOME/.p10k.zsh
```

### Optimization 5: Remove modules that you don't use

You can disable some modules that you don't use in the `.preztorc` file.
Here are the modules that I use:

```bash
zstyle ':prezto:load' pmodule \
  'editor' \
  'history' \
  'directory' \
  'utility' \
  'completion' \
  'osx' \
  'git' \
  'syntax-highlighting' \
  'autosuggestions'
```

### Optimization 6: Strip down some features

Using ZSH_AUTOSUGGEST_MANUAL_REBIND: This can be a big boost to performance, but you'll need to handle re-binding yourself if any of the widget lists change or if you or another plugin wrap any of the autosuggest widgets [zsh-users/zsh-autosuggestions/#disabling-automatic-widget-re-binding](https://github.com/zsh-users/zsh-autosuggestions?tab=readme-ov-file#disabling-automatic-widget-re-binding)

## Results

Here is a table after applying all the optimizations, I run the `zsh-bench` again

| config  | compsys | syntax highlight | auto suggest | git prompt | first prompt lag | first cmd lag | cmd lag | input lag |
|-|-:|-:|-:|-:|-:|-:|-:|-:|-:|
| Before |  ✔️ | ✔️ | ✔️ | ✔️ | 274% 🔴 | 130% 🟠 | 660% 🔴 | 52% 🟡 |
| After |  ✔️ | ✔️ | ✔️ | ✔️ | 24% 🟢 | 84% 🟡 | 40% 🟢 | 56% 🟡 |

zmodload zsh/zprof | zprof result:

```text
num  calls                time                       self            name
-----------------------------------------------------------------------------------
 1)   21          34.41     1.64   80.96%     16.14     0.77   37.98%  zsource
 2)    1           8.09     8.09   19.04%      5.49     5.49   12.92%  (anon) [$HOME/.cache/p10k-instant-prompt-anhkhoakz.zsh:3]
 3)    5          21.58     4.32   50.76%      4.49     0.90   10.56%  pmodload
 4)    1           3.77     3.77    8.87%      3.77     3.77    8.87%  compinit
 5)    1           3.03     3.03    7.12%      2.76     2.76    6.50%  (anon) [$HOME/powerlevel10k/powerlevel10k.zsh-theme:50]
 6)    1           2.04     2.04    4.81%      1.83     1.83    4.31%  _zsh_highlight_load_highlighters
 7)    9           1.78     0.20    4.19%      1.78     0.20    4.19%  (anon) [$HOME/.zprezto/init.zsh:109]
 8)    1           2.59     2.59    6.09%      1.30     1.30    3.05%  _p9k_preinit
 9)    1           1.04     1.04    2.44%      1.04     1.04    2.44%  (anon) [$HOME/.cache/p10k-instant-prompt-anhkhoakz.zsh:597]
1)     1           1.03     1.03    2.43%      1.02     1.02    2.41%  _zsh_highlight__function_callable_p
2)     1           0.86     0.86    2.03%      0.80     0.80    1.88%  (anon) [$HOME/.p10k.zsh:21]
3)     3           0.54     0.18    1.28%      0.51     0.17    1.20%  add-zle-hook-widget
```

All features are **still available**, but the startup time is
**significantly reduced**.

- first prompt lag is 12.2 times faster.
- first command lag is 1.43 times faster.
- command lag is 16.28 times faster.
- input lag is 1.087 times slower.
- exit time is 1.45 times faster.

 My final `.zshrc` file is:

 ```bash
function zsource() {
  local file=$1
  local zwc="${file}.zwc"
  if [[ -f "$file" && (! -f "$zwc" || "$file" -nt "$zwc") ]]; then
    # echo "Compiling $file..."
    zcompile "$file"
  fi
  # echo "Sourcing $file..."
  source "$file"
}

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Prezto Initialization
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  zsource "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# ------------------------------
# Environment Variables
# ------------------------------
export POWERSHELL_TELEMETRY_OPTOUT=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export ZSH_DISABLE_COMPFIX=1

# Prepend uutils-coreutils to prioritize its commands over macOS defaults
export PATH="/opt/homebrew/opt/uutils-coreutils/libexec/uubin:$PATH"
export PATH="$PATH:$HOME/.pubcache/bin"
export PATH="$PATH:/bin"
export PATH="$PATH:$HOME/.gem/bin"
export PATH="$PATH:$HOME/.composer/vendor/bin"
export PATH="$PATH:$HOME/Library/Application Support/fnm"
export PATH="$PATH:$HOME/.bun/bin"
export PATH="$PATH:$HOME/.local/share/nvim/lazy-rocks/hererocks/bin"
export CHROME_EXECUTABLE="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
export BUN_INSTALL="$HOME/.bun"
export NODE_COMPILE_CACHE=$HOME/.cache/nodejs-compile-cache
export FZF_CTRL_R_OPTS="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'"
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target"

# Start Aliases and Functions

# Your aliases and functions go here

# End Aliases and Functions

zsource $HOME/.fzf.zsh
zsource $HOME/.zoxide.zsh
. "$HOME/.cargo/env"

# To customize prompt, run `p10k configure` or edit $HOME/.p10k.zsh.
zsource $HOME/powerlevel10k/powerlevel10k.zsh-theme
zsource $HOME/.p10k.zsh

unfunction zsource
 ```

This is the final result of my ZSH configuration. Although it
still has some overhead, but it's much better than the initial
configuration.

[santacloud.dev](https://santacloud.dev/posts/optimizing-zsh-startup-performance) indicate that how they
optimize their ZSH startup time to under 70ms which is `exit_time_ms`
metric in this measure (63 ms). I also optimize
other metrics like `first_prompt_lag_ms`, `first_command_lag_ms`,
`command_lag_ms`, and `input_lag_ms`.

## Conclusion

### Do it waste my time?

Yes, it does. Those optimizations take me a few days to figure out,
reading a lot of articles, and testing different
configurations. But it is worth it. I can feel the difference
when I start a new terminal session, and it is much faster than before.
> [It’s about protecting flow](https://santacloud.dev/posts/optimizing-zsh-startup-performance/#zsource:~:text=It%E2%80%99s%20about%20protecting%20flow.)

### Meaningless changes

- Remove shell functions
- Change to fast syntax highlighting
- Deferred initialization
- Disable prezto
- Using boring colors
- Disable git prompt

## References

- [Comparison of ZSH frameworks and plugin managers](https://gist.github.com/laggardkernel/4a4c4986ccdcaf47b91e8227f9868ded)
- [Improving Zsh Performance](https://www.dribin.org/dave/blog/archives/2024/01/01/zsh-performance/)
- [Zsh benchmark for differences configs](https://docs.google.com/spreadsheets/d/e/2PACX-1vTyPZw11siFrMQEVjtU7NNs8AAYz6WU2p62nn3QX4hidlTbOYkDTzJVdSrZ93NoeoDhrsiKwbTYD-_F/pubhtml)
