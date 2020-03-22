# Clean, simple, compatible and meaningful.
# Tested on Linux, Unix and Windows under ANSI colors.
# It is recommended to use with a dark background.
# Colors: black, red, green, yellow, *blue, magenta, cyan, and white.
#
# Mar 2013 Yad Smood

# VCS
YS_VCS_PROMPT_PREFIX1=" "
YS_VCS_PROMPT_PREFIX2=":%{$fg[yellow]%}"
YS_VCS_PROMPT_PREFIX2_MASTER=":%{$fg[cyan]%}"
YS_VCS_PROMPT_SUFFIX="%{$reset_color%}"
YS_VCS_PROMPT_DIRTY=" %{$fg[red]%}x"
YS_VCS_PROMPT_CLEAN=" %{$fg[green]%}o"

# Editor info

local editor_info='$(ys_editor_prompt_info)'
ys_editor_prompt_info() {
  echo "${YS_VCS_PROMPT_PREFIX1}editor${YS_VCS_PROMPT_PREFIX2}$EDITOR${YS_VCS_PROMPT_SUFFIX}"
}

# Kubectl context

local kubectl_context='$(ys_kubectl_context_prompt_info)'
ys_kubectl_context_prompt_info() {
  echo "${YS_VCS_PROMPT_PREFIX1}kube${YS_VCS_PROMPT_PREFIX2}$(kubectl config current-context)${YS_VCS_PROMPT_SUFFIX}"
}

# Git info
local git_info='$(ys_git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${YS_VCS_PROMPT_PREFIX1}git${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_PREFIX_MASTER="${YS_VCS_PROMPT_PREFIX1}git${YS_VCS_PROMPT_PREFIX2_MASTER}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"

# Git
ys_git_prompt_info() {
  local ref
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
      ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
	  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
      if [ "${ref#refs/heads/}" = 'master' ]; then
	  echo "$ZSH_THEME_GIT_PROMPT_PREFIX_MASTER${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
      else
	  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
      fi
  fi
}

# HG info
local hg_info='$(ys_hg_prompt_info)'
ys_hg_prompt_info() {
	# make sure this is a hg dir
	if [ -d '.hg' ]; then
		echo -n "${YS_VCS_PROMPT_PREFIX1}hg${YS_VCS_PROMPT_PREFIX2}"
		echo -n $(hg branch 2>/dev/null)
		if [ -n "$(hg status 2>/dev/null)" ]; then
			echo -n "$YS_VCS_PROMPT_DIRTY"
		else
			echo -n "$YS_VCS_PROMPT_CLEAN"
		fi
		echo -n "$YS_VCS_PROMPT_SUFFIX"
	fi
}

local exit_code="%(?,,C:%{$fg[red]%}%?%{$reset_color%})"

# Prompt format:
#
# PRIVILEGES USER @ MACHINE in DIRECTORY on git:BRANCH STATE [TIME] C:LAST_EXIT_CODE
# $ COMMAND
#
# For example:
#
# % ys @ ys-mbp in ~/.oh-my-zsh on git:master x [21:47:42] C:0
# $
PROMPT="
%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} \
%(#,%{$bg[yellow]%}%{$fg[black]%}%n%{$reset_color%},%{$fg[cyan]%}%n) \
%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}\
${editor_info}\
${kubectl_context}\
${hg_info}\
${git_info}\
 \
%{$fg[white]%}[%*] $exit_code
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"
