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

echo "Running entrypoint.sh script"

# Output current git version for debugging
git --version

#-----------------------------------------------------------------------
# Push the revert commit to the Git repository
#-----------------------------------------------------------------------
git remote set-url origin https://x-access-token:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git
git config --global user.email "revert-commit@github.com"
git config --global user.name "GitHub Revert Commit Action"

# Workaround for Git Security Vulnerability https://github.com/actions/checkout/issues/760
git config --global --add safe.directory $GITHUB_WORKSPACE
git config --global --add safe.directory /github/workspace

echo "Finished setting up git configurations."
echo "$GITHUB_WORKSPACE"
echo $GITHUB_WORKSPACE

set -o xtrace

# Get the current branch so we know which branch to push the revert to.
CURRENT_GIT_BRANCH=$(git branch --show-current)

# Check that the commit exists
git cat-file -t $GITHUB_SHA

# Revert and push the commit
git revert $GITHUB_SHA --no-edit
git diff origin/$CURRENT_GIT_BRANCH --name-only

# Sanity check for debugging to see what files changed
echo "Outputting the files that have changed in the revert."
echo "These files should match the files modified in the commit."
echo "-----------------------------------------------------"
git diff $GITHUB_SHA --name-only | cat
echo "-----------------------------------------------------"

echo "Outputting the files that have changed across the"
echo "revert and incoming commit. This should be empty!"
echo "-----------------------------------------------------"
git diff $GITHUB_SHA~1 --name-only | cat
echo "-----------------------------------------------------"

echo "About to revert commit [$GITHUB_SHA] on current Git branch [$CURRENT_GIT_BRANCH]"

if [ "$IS_PUSH_ENABLED" == 'true' ]
then
	echo "Executing push since push is ENABLED via Github Action inputs"
	git push origin $CURRENT_GIT_BRANCH
else
	echo "Bypassing push since push is DISABLED via Github Action inputs"
fi
