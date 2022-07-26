alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias tailf="tail -f"
alias ll="ls -alF"
function mkcd { mkdir -p $1; cd $1; }

alias scs='grep -r --include \*.cs'
alias freeze-req='pip freeze > requirements.txt'

alias del_merged_branches='git branch --merged develop | grep -vE "(develop|master)" | xargs git bd'

alias g=git
complete -o bashdefault -o default -o nospace -F __git_wrap__git_main g

alias dotfiles="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
complete -o bashdefault -o default -o nospace -F __git_wrap__git_main dotfiles
dotfiles config --local status.showUntrackedFiles no

alias todo="vim ~/todo"
