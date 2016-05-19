#
# Helper functions for activate/deactivate an AWS profile
#
# Add the following functions to ~/.bashrc:
#

function activate-aws() {
    export AWS_ACCESS_KEY_ID=`aws configure --profile=$1 get aws_access_key_id`
    export AWS_SECRET_ACCESS_KEY=`aws configure --profile=$1 get aws_secret_access_key`
    export AWS_DEFAULT_PROFILE=$1
    echo "Activated $1 ($AWS_ACCESS_KEY_ID)" 1>&2
}

function deactivate-aws() {
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_DEFAULT_PROFILE
}

function ls-aws-profile() {
    profile=$(aws configure list | grep profile | awk '{print  $2}')
    echo "Active profile $profile"
}

function _aws_profiles() {
   local cur=${COMP_WORDS[COMP_CWORD]}
   # default aws profile is skipped
   aws_profiles=$(cat ~/.aws/config | grep profile | cut -d ' ' -f 2 | sed 's/]//')
   COMPREPLY=( $(compgen -W "$aws_profiles" -- "$cur") )
}
complete -F _aws_profiles activate-aws

