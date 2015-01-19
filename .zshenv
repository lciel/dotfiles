# rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# rbenv
if [ -d ${HOME}/.rbenv  ] ; then
    export PATH=${HOME}/.rbenv/bin:${PATH}
fi
eval "$(rbenv init -)"
