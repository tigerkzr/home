########################################################################
# colors
########################################################################

local reset="%{[00m%}"


########################################################################
# powerline symbols (require powerline font or terminal)
########################################################################

local powerline_hard_left_divider='%{%G%}'
local powerline_soft_left_divider='%{%G%}'
local powerline_hard_right_divider='%{%G%}'
local powerline_soft_right_divider='%{%G%}'
local powerline_branch='%{%G%}'
local powerline_line_number='%{%G%}'
local powerline_lock='%{%G%}'


########################################################################
# vcs info (git)
########################################################################

type vcs_info > /dev/null 2>&1 || autoload -Uz vcs_info

# vcs_info_precmd () { vcs_info }
# add-zsh-hook precmd vcs_info_precmd
precmd() { vcs_info }

zstyle ':vcs_info:*' enable git  # disable other backends
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' use-prompt-escapes true

# %{%b%} is branch (%%{%b%} is bold)
# %i is revision
# %u is value of unstagedstr
# %c is value of stagedstr
# %a is action in progress (for autoformats)

zstyle ':vcs_info:*' actionformats '%b%i%c%u%a'
zstyle ':vcs_info:*' formats '%b%i%c%u'

type is-at-least > /dev/null 2>&1 || autoload -Uz is-at-least
if is-at-least 4.3.11; then
  zstyle ':vcs_info:git+set-message:*' hooks git-action         \
                                             git-branch         \
                                             git-revision       \
                                             git-staged-files   \
                                             git-unstaged-files
fi

function git-has-unstaged-files {
  git status --porcelain | grep '??' &> /dev/null
}

function git-has-staged-files {
  git status --porcelain | grep '^A\b' &> /dev/null
}

function +vi-git-branch {
  hook_com[branch]="%F{1}%K{1}$powerline_hard_right_divider%f%k"
  hook_com[branch]+="%F{0}%K{1}${hook_com[branch_orig]} $powerline_branch %f%k"
}

function +vi-git-revision {
  hook_com[revision]="%F{16}%K{1}$powerline_hard_right_divider%f%k"
  hook_com[revision]+="%F{0}%K{16} ${hook_com[revision_orig][0,10]} %f%k"
}

function +vi-git-unstaged-files {
  if git-has-unstaged-files || [[ -n "${hook_com[unstaged_orig]}" ]]; then
    hook_com[unstaged]="%F{0}%K{16}$powerline_soft_right_divider%f%k"
    hook_com[unstaged]+='%F{0}%K{16} %{✭%G%} %f%k'
  fi
}

function +vi-git-staged-files {
  if git-has-staged-files || [[ -n "${hook_com[staged_orig]}" ]]; then
    hook_com[staged]="%F{0}%K{16}$powerline_soft_right_divider%f%k"
    hook_com[staged]+='%F{0}%K{16} %{✚%G%} %f%k'
  fi
}

function +vi-git-action {
  hook_com[action]="${hook_com[action_orig]}"
}


########################################################################
# prompt
########################################################################

PROMPT='%F{0}%K{4} %{%B%(!.#.ϟ)%b%G%} %f%k'
PROMPT+='%F{4}%K{19}$powerline_hard_left_divider%f%k'
PROMPT+='%F{19}%K{18}$powerline_hard_left_divider%f%k'
PROMPT+='%F{18}$powerline_hard_left_divider%f '

RPROMPT='%F{18}$powerline_hard_right_divider%f%}'
RPROMPT+='%F{19}%K{18}$powerline_hard_right_divider%f%k'
RPROMPT+='%F{7}%K{19} %B%m%b %f%k'
RPROMPT+='%F{4}%K{19}$powerline_hard_right_divider%f%k'
RPROMPT+='%F{0}%K{4}%B%30<...<%~%<<%u%b %f%k'
RPROMPT+='%F{1}%K{4}$powerline_hard_right_divider%f%k'
RPROMPT+='%F{0}%K{1}${vcs_info_msg_0_}%f%k'  # needs to be single-quoted
