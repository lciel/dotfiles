function project(){
    vim -c ":Project $@"
}

function pr(){
    project $@
}

function psg(){
    ps aux | head -n 1
    ps aux | grep -v "ps -auxwww" | grep -v grep | grep $*
}
