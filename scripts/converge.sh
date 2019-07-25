#!/usr/bin/env bash
declare -a organization_files
CIRCLE_BRANCH='One-more-test'
SAVEIFS=$IFS   # Save current IFS
IFS=$'\n'      # Change IFS to new line
IFS=$SAVEIFS   # Restore IFS

converge_organization () {
    for file_name in $files_modified; do
        if [[ $file_name = *"organization"* ]]; then
            organization_files+=("$file_name")
        fi
    done
    echo "python cli.py --pd-token 901ff31c40ab4a02ba6a917f02760578 --debug converge --email \"support@cloudreach.com\" --password \"nxICCc%4mJq#9v16\" --dry-run ${organization_files[@]}" 
}

converge_all () {
    echo "python cli.py --pd-token 901ff31c40ab4a02ba6a917f02760578 --debug converge --email \"support@cloudreach.com\" --password \"nxICCc%4mJq#9v16\" --dry-run" 
}

if [[ ! -z "$CIRCLE_BRANCH" && "$CIRCLE_BRANCH" != "master" ]]; then
	git checkout -q master && git reset  -q --soft origin/master && git checkout -q $CIRCLE_BRANCH && files_modified="$(git --no-pager diff --name-only master)"
    if [[ ${files_modified[*]} =~ signalfx ]]; then
        if [[ ${files_modified[@]} =~ specs || ${files_modified[@]} =~ detectors ]]; then
            converge_all
        elif [[ ${files_modified[@]} =~ organizations ]]; then
            converge_organization
        fi
    fi
fi