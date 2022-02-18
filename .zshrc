# Load version control info
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '(%b)'

# Set prompt
setopt PROMPT_SUBST
PROMPT='%B%F{cyan}%n%f %F{green}%1~%f %F{red}${vcs_info_msg_0_}%f ->%b '
