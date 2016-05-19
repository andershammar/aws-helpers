#
# connect-ec2-emr - Helper functions for connecting to and listing EC2/EMR instances
#
# Add the following functions to ~/.bashrc:
# Note that the functions below requires jq and jungle.
#  - jq: https://stedolan.github.io/jq/
#  - jungle: https://stedolan.github.io/jq/
#

alias ec2-ls="jungle ec2 ls -l"
alias emr-ls='aws emr list-clusters --active | jq -r ".Clusters[] | {Id: .Id, Name: .Name, State: .Status.State, InstanceHours: .NormalizedInstanceHours}"'

function ec2-ssh() {
    if [ $# -ne 2 ]; then
        echo usage: "ec2-ssh [instance-name] [key-file]"
        return
    fi
    jungle ec2 ssh --instance-name "*$1*" --username ec2-user --key-file $HOME/.ssh/$2
}

function emr-ssh() {
    if [ $# -ne 2 ]; then
        echo usage: "emr-ssh [cluster-id] [key-file]"
        return
    fi
    jungle emr ssh --cluster-id $1 --key-file $HOME/.ssh/$2
}

function _key_files() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    if [ $COMP_CWORD -eq 2 ]; then
        key_files=`ls -1 $HOME/.ssh | sed -e '/config/d' -e '/known_hosts/d'`
        COMPREPLY=($(compgen -W "$key_files" -- "$cur"))
    fi
}

complete -F _key_files ec2-ssh
complete -F _key_files emr-ssh

