alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB
alias tailf="tail -f"
alias ll="ls -alF"

alias open=xdg-open

function mkcd { mkdir -p $1; cd $1; }

alias pyfreeze='pip freeze > requirements.txt'

alias g=git
complete -o bashdefault -o default -o nospace -F __git_wrap__git_main g
alias gp="git pull"

alias dotfiles="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
complete -o bashdefault -o default -o nospace -F __git_wrap__git_main dotfiles
dotfiles config --local status.showUntrackedFiles no

alias todo="vim ~/todo"
function show_path_lines { echo $PATH | sed 's/:/\n/g'; }
