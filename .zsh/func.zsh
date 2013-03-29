function project(){
    vim -c ":Project $@"
}

function pr(){
    project $@
}
