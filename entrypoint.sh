#!/bin/bash

set -e

START_TIME=$(date)
echo "::set-output name=start-time::$START_TIME"

# TODO | We sould probably migrate this to something more
# TODO | easily testable than this bash script.

#-----------------------------------------------------------------------
# Collecting necessary environment/input variables from the Github execution environment
#-----------------------------------------------------------------------
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

# Get the current branch so we know which branch to push the revert to.
CURRENT_GIT_BRANCH=$(git branch --show-current)

# Check that the commit exists
git cat-file -t $GITHUB_SHA

# Revert and push the commit
git status
git revert $GITHUB_SHA --no-edit
git log -n 3 --oneline
git diff origin/$CURRENT_GIT_BRANCH --name-only
git diff HEAD~2 --name-only

echo "Reverting commit [$GITHUB_SHA] on current Git branch [$CURRENT_GIT_BRANCH]"
# git push origin $CURRENT_GIT_BRANCH
