# A fork of the ys theme

# VCS
VCS_PROMPT_PREFIX1=" "
VCS_PROMPT_PREFIX2=":%{$fg[yellow]%}"
VCS_PROMPT_PREFIX2_MAIN=":%{$fg[cyan]%}"
VCS_PROMPT_PREFIX3=":%{$fg[blue]%}"
VCS_PROMPT_SUFFIX="%{$reset_color%}"
VCS_PROMPT_DIRTY=" %{$fg[red]%}x"
VCS_PROMPT_CLEAN=" %{$fg[green]%}o"

# Kubectl context
local kubectl_context='$(kubectl_context_prompt_info)'
kubectl_context_prompt_info() {
  echo "${VCS_PROMPT_PREFIX1}kube${VCS_PROMPT_PREFIX3}$(kubectl config current-context)${VCS_PROMPT_SUFFIX}"
}

# Git info
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${VCS_PROMPT_PREFIX1}git${VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_PREFIX_MAIN="${VCS_PROMPT_PREFIX1}git${VCS_PROMPT_PREFIX2_MAIN}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$VCS_PROMPT_CLEAN"

git_prompt_info() {
  local ref
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
      ref=$(command git symbolic-ref HEAD 2> /dev/null) || ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
      if [ "${ref#refs/heads/}" = 'master' ]; then
        echo "$ZSH_THEME_GIT_PROMPT_PREFIX_MAIN${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
      elif [ "${ref#refs/heads/}" = 'main' ]; then
        echo "$ZSH_THEME_GIT_PROMPT_PREFIX_MAIN${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
      else
        echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
      fi
  fi
}

local exit_code="%(?,,C:%{$fg[red]%}%?%{$reset_color%})"

PROMPT="
%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} \
%(#,%{$bg[yellow]%}%{$fg[black]%}%n%{$reset_color%},%{$fg[cyan]%}%n) \
%{$terminfo[bold]$fg[magenta]%}%~%{$reset_color%}\
${kubectl_context}\
${git_info}\
 \
%{$fg[white]%}[%*] $exit_code
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"
