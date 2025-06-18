+++
title = 'ZSH Configurations'
description = "My ZSH configurations"
date = 2025-06-14T23:58:05+07:00
draft = false
tags = ["zsh", "configuration"]
author = "anhkhoakz"
+++

---

## Choosing a framework

There are many frameworks for ZSH, and I've tried a few of them.

- Oh My ZSH[^1]
- Prezto[^2]
- zsh4humans[^3]

Yes, I've watched a lot of videos about Oh My ZSH, and I've tried it.
But I've found that it's too heavy for my use case.

The motivation for me to optimize my ZSH configuration comes
that after I read the Speed Matters: How I Optimized My ZSH Startup to Under 70ms[^4] gist, I found that

## Initial Configuration

`.zshrc` file is the main configuration file for ZSH.

```bash
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

export POWERSHELL_TELEMETRY_OPTOUT=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export PATH="$PATH:$HOME/.pubcache/bin:/Applications/Docker.app/Contents/Resources/bin/:/bin:$HOME/.gem/bin:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$HOME/.composer/vendor/bin:/opt/homebrew/opt/uutils-coreutils/libexec/uubin:/Users/anhkhoakz/Library/Application Suppo$BUN_INSTALLrt/fnm"
export CHROME_EXECUTABLE="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
export BUN_INSTALL="$HOME/.bun"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export NODE_COMPILE_CACHE=~/.cache/nodejs-compile-cache
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

alias cls='clear'
alias t='trash'
alias brewup='brew update && brew upgrade'
alias denv='dotenv-linter'
alias denvf='dotenv-linter --quiet fix'
alias rclone-gui='rclone rcd --rc-web-gui --rc-user admin --rc-pass LKVtGcX5S2ZaJpdj'
alias benchmark='hyperfine'
alias bathelp='bat --plain --language=help'
alias gF='git-flow'
alias nv='nvim'

alias pnup='bunx npm-check-updates -u'
alias json-server='bunx json-server'
alias grm='git clean -Xdf > /dev/null 2>&1'
alias cs='cursor'
alias bss='bunx browser-sync start --server'
alias szsh='source ~/.zshrc && source ~/.zprofile source ~/.zpreztorc'

function pdpdf() {
  input_file="$1"
  output_file="${input_file%.*}.pdf"
  pandoc "$input_file" -o "$output_file" --pdf-engine=xelatex
  echo "Output file created at: $(realpath "$output_file")"
}

function dimg() {
  docker images --digests --filter "reference=$1"
}

function help() {
    "$@" --help 2>&1 | bathelp
}

function falias() {
  local search_term="$*"
  if [ -z "$search_term" ]; then
    alias
  else
    alias | rg "$search_term"
  fi
}

function y() {
 local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
 yazi "$@" --cwd-file="$tmp"
 if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
  builtin cd -- "$cwd"
 fi
 rm -f -- "$tmp"
}

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
```

`.preztorc` file is the configuration file for Prezto. Here is a list of Prezto modules that I use:

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
  'eza' \
```

And you know what? This has the significant poor performance:

```bash
creates_tty=0
has_compsys=1
has_syntax_highlighting=1
has_autosuggestions=1
has_git_prompt=1
first_prompt_lag_ms=137.08
first_command_lag_ms=195.358
command_lag_ms=66.017
input_lag_ms=10.483
exit_time_ms=64.467
```

If you search how to benchmark zsh startup, you'll find the following command snippet:

```bash
time zsh -lic "exit"
```

This metric is shown as exit_time_ms when using `zsh-bench` tool.

This metric is unnecessary for the benchmarking process.
You can refer to the How not to benchmark[^5]

The raw zsh config with `--no-rcs` is:

```bash
creates_tty=0
has_compsys=0
has_syntax_highlighting=0
has_autosuggestions=0
has_git_prompt=0
first_prompt_lag_ms=17.993
first_command_lag_ms=18.115
command_lag_ms=0.063
input_lag_ms=0.288
exit_time_ms=17.049
```

This is the baseline, the "ideal" metric for the zsh startup time.

So I'm trying to reduce the first prompt lag, first command lag,
command lag, input lag, and exit time.

## Optimization Steps

I'm going to determine whether the prezto or my configurations
slow down the zsh startup time.

Feature/Metric |  Disable Prezto | Disable My Configurations
--- | --- | ---
creates_tty | 0 | 0
has_compsys | 0 | 1
has_syntax_highlighting | 0 | 1
has_autosuggestions | 0 | 1
has_git_prompt | 1 | 0
first_prompt_lag_ms | 102.529 | 52.73
first_command_lag_ms | 102.731 | 63.196
command_lag_ms | 61.759 | 10.302
input_lag_ms | 0.223 | 10.099
exit_time_ms | 43.516 | 37.033

So I can conclude that my configurations are the main reason
that slows down the zsh startup time.

### Optimization 1: Remove virtual environment variables

I use fnm to manage Node.js versions, and it sets some
environment variables. Although the fnm[^6] is considered as faster than nvm[^7]. But I'm not using it frequently, and it adds
some overhead, so I can remove it from the startup time.

```bash
# if [ -d "$FNM_PATH" ]; then
#   export PATH="$HOME/Library/Application Support/fnm:$PATH"
#   eval "`fnm env`"
# fi
```

You can do the same for other virtual environment managers like `pyenv`, `rbenv`, etc.

### Optimization 2: Remove homebrew completions

I love the homebrew completions, although it adds some overhead
to the zsh startup time. So I choose to keep it, but it also
predefined in prezto in [`modules/completion/init.zsh`](https://github.com/sorin-ionescu/prezto/blob/6e564503f1c5e6ddba2bcf5d9065e5872ca207d2/modules/completion/init.zsh#L18C1-L26C3).

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
not symlinked into Homebrew’s prefix). But I want more suggestions, so I edit that completion file to add the homebrew completions path.

I also doesn't need the `zsh-completions` formula, so I remove it from the completions path too.

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

I love the vivid[^8] tool to
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

Refer to [Speed Matters: How I Optimized My ZSH Startup to Under 70ms](https://santacloud.dev/posts/optimizing-zsh-startup-performance/#zsource)

I will use the `zsource()` function to source the file instead of the `source` command.

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

### Optimization 4: Change the prompt from `starship` to `powerlevel10k`

Although prezto offer the `prompt` module which come with some
predefined themes including `powerlevel10k`, I prefer to use
download the `powerlevel10k` theme and use it directly.

```bash
# eval "$(starship init zsh)"
# Start of the file || Don't use zsource for instant prompt https://github.com/romkatv/powerlevel10k/blob/36f3045d69d1ba402db09d09eb12b42eebe0fa3b/README.md?plain=1#L1047C1-L1048
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Something here ...

# End of the file
zsource ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || zsource ~/.p10k.zsh
```

### Optimization 5: Remove modules that you don't use

You can disable some modules that you don't use in the `.preztorc` file. Here are the modules that I use:

```bash
zstyle ':prezto:load' pmodule \
  'editor' \
  'history' \
  'directory' \
  'utility' \
  'completion' \
  'autosuggestions' \
  'osx' \
  'git' \
  'zsh-syntax-highlighting' \
```

## Results

 Feature/Metric            | Before         | After
---------------------------|:--------------:|:-------
 creates_tty               | 0              | 0
 has_compsys               | 1              | 1
 has_syntax_highlighting   | 1              | 1
 has_autosuggestions       | 1              | 1
 has_git_prompt            | 1              | 1
 first_prompt_lag_ms       | 137.08         | 20.285
 first_command_lag_ms      | 195.358        | 149.823
 command_lag_ms            | 66.017         | 13.901
 input_lag_ms              | 10.483         | 12.753
 exit_time_ms              | 64.467         | 62.953

 My final `.zshrc` file is:

 ```bash
function zsource() {
  local file=$1
  local zwc="${file}.zwc"
  if [[ -f "$file" && (! -f "$zwc" || "$file" -nt "$zwc") ]]; then
    zcompile "$file"
  fi
  source "$file"
}

LS_COLORS_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/LS_COLORS_nord"

if [[ ! -f "$LS_COLORS_CACHE" ]]; then
  vivid generate nord > "$LS_COLORS_CACHE"
fi

export LS_COLORS="$(<"$LS_COLORS_CACHE")"
unset LS_COLORS_CACHE

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source Prezto.
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

function fnm() {
  unset -f fnm
  eval "$(fnm env --use-on-cd --shell zsh)"
  fnm "$@"
}

#
# ------------------------------
# Aliases
# ------------------------------
alias cls='clear'
alias t='trash'
alias nv='nvim'
alias senv="exec zsh"
alias zj='zellij'
alias zja='zellij attach $( zellij list-sessions --no-formatting --short | fzf)'
alias pnup='bunx npm-check-updates -u'
alias json-server='bunx json-server'
alias bss='bunx browser-sync start --server'
alias grm='git clean -Xdf'
alias rclone-gui='rclone rcd --rc-web-gui --rc-user admin --rc-pass LKVtGcX5S2ZaJpdj'
alias lzd='lazydocker'
alias gtw='gittower'
alias vsc='code .'
alias docker='podman'
alias ghb='gh browse'
alias ghg='gh gist'
alias gbi='git branch | fzf | cut -c 3- | xargs git checkout'
alias tldri='tldr --list | fzf | xargs tldr'
alias hyperfine="${aliases[hyperfine]:-hyperfine} --min-runs 50 --warmup 3 --shell none"
alias zsh_bench='/Users/anhkhoakz/CodeVault/ShellScripts/src/apps/zsh-bench/zsh-bench'
alias human_bench='/Users/anhkhoakz/CodeVault/ShellScripts/src/apps/zsh-bench/human-bench'

# ------------------------------
# Functions
# ------------------------------
function pdpdf() {
  [[ -z "$1" ]] && { echo "Usage: pdpdf <input_file>"; return 1 }
  local input_file="$1"
  local output_file="${input_file%.*}.pdf"
  pandoc "$input_file" -o "$output_file" --pdf-engine=xelatex || return 1
  echo "Output file created at: $(realpath "$output_file")"
}

function dimg() {
  [[ -z "$1" ]] && { podman images --digests; return 1 }
  podman images --digests --filter "reference=$1"
}

function shellfix() {
  [[ $# -eq 0 ]] && { echo "Usage: shellfix <file ...>"; return 1 }

  fd -t f -e sh -e bash -e zsh "$@" | while read -r file; do
    echo "Processing $file..."
    shellcheck -f diff "$file" --enable=all | git apply -p1 || echo "Failed to fix $file"
  done

  echo "Run 'git diff --cached' to see all changes." && git diff --cached
}

function zrf() {
  [[ -z "$*" ]] && { echo "Usage: zrf <command>"; return 1 }
  zellij run --name "$*" --floating -- zsh -ic "$*"
}

function brewup() {
  brew update
  brew upgrade
  brew cleanup
}


# ------------------------------
# Shell Integration
# ------------------------------

zsource <(fzf --zsh)
eval "$(zoxide init --cmd=cd zsh)"
. "$HOME/.cargo/env"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
zsource ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || zsource ~/.p10k.zsh
 ```

 This is the final result of my ZSH configuration. Although it
 still has some overhead, but it's much better than the initial
 configuration.

[Speed Matters: How I Optimized My ZSH Startup to Under 70ms](https://santacloud.dev/posts/optimizing-zsh-startup-performance) indicate that how they
optimize their ZSH startup time to under 70ms which is `exit_time_ms` metric in this measure (63 ms). I also optimize
other metrics like `first_prompt_lag_ms`, `first_command_lag_ms`, `command_lag_ms`, and `input_lag_ms`.

### Do it waste my time?

Yes, it does. Those optimizations take me a few days to figure out, reading a lot of articles, and testing different
configurations. But it is worth it. I can feel the difference
when I start a new terminal session, and it is much faster than before.
> [It’s about protecting flow](https://santacloud.dev/posts/optimizing-zsh-startup-performance/#zsource:~:text=It%E2%80%99s%20about%20protecting%20flow.)

## References

- [Speed Matters: How I Optimized My ZSH Startup to Under 70ms](https://santacloud.dev/posts/optimizing-zsh-startup-performance)
- [Comparison of ZSH frameworks and plugin managers](https://gist.github.com/laggardkernel/4a4c4986ccdcaf47b91e8227f9868ded)

## Footnotes

[^1]: [Oh My ZSH](https://ohmyz.sh/): Unleash your terminal like never before

[^2]: [Prezto](https://github.com/sorin-ionescu/prezto): The configuration framework for Zsh

[^3]: [zsh4humans](https://github.com/romkatv/zsh4humans/tree/v5): A turnkey configuration for Zsh

[^4]: [Speed Matters: How I Optimized My ZSH Startup to Under 70ms](https://santacloud.dev/posts/optimizing-zsh-startup-performance)

[^5]: [zsh-bench/how-not-to-benchmark](https://github.com/romkatv/zsh-bench?tab=readme-ov-file#how-not-to-benchmark)

[^6]: [fnm](https://github.com/Schniz/fnm): 🚀 Fast and simple Node.js version manager, built in Rust

[^7]: [nvm](https://github.com/nvm-sh/nvm): Node Version Manager - POSIX-compliant bash script to manage multiple active node.js versions

[^8]: [vivid](https://github.com/sharkdp/vivid): A themeable LS_COLORS generator with a rich filetype datebase
