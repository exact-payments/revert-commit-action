#!/bin/bash

set -e

START_TIME=$(date)
echo "::set-output name=start-time::$START_TIME"

# TODO | We sould probably migrate this to something more
# TODO | easily testable than this bash script.

#-----------------------------------------------------------------------
# Collecting necessary environment/input variables from the Github execution environment
#-----------------------------------------------------------------------
CURRENT_GIT_BRANCH=${GITHUB_REF#refs/head/}
echo "Current version: 0.0.7"
echo $CURRENT_GIT_BRANCH

if [[ -z "$GITHUB_SHA" ]]; then
	echo "GITHUB_SHA env variable must be set but was not."
	exit 1
fi

if [[ -z "$GITHUB_REPOSITORY" ]]; then
	echo "GITHUB_REPOSITORY env variable must be set but was not."
	exit 1
fi

if [[ -z "$GITHUB_TOKEN" ]]; then
	echo "GITHUB_TOKEN env variable must be set but was not."
	exit 1
fi

#-----------------------------------------------------------------------
# Push the revert commit to the Git repository
#-----------------------------------------------------------------------
git remote set-url origin https://x-access-token:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git
git config --global user.email "revert-commit@github.com"
git config --global user.name "GitHub Revert Commit Action"

set -o xtrace

# Checkout the repository code for the given relevant branch
# TODO | Potentially consider requiring the actions/checkoutv2 as a pre-requisite
git fetch origin $CURRENT_GIT_BRANCH
git checkout -b $CURRENT_GIT_BRANCH origin/$CURRENT_GIT_BRANCH

# Check that the commit exists
git cat-file -t $GITHUB_SHA
git revert $GITHUB_SHA --no-edit
# git push origin $GIT_BRANCH
