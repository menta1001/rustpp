#!/bin/bash

set -euo pipefail

if [ -z "${GITHUB_TOKEN:-}" ]; then
    echo "GITHUB_TOKEN is not set. Export a GitHub token before running this script."
    exit 1
fi

current_branch="$(git rev-parse --abbrev-ref HEAD)"

if [ "$current_branch" = "HEAD" ]; then
    echo "Unable to determine the current branch. Please checkout a branch first."
    exit 1
fi

git checkout -- package-lock.json

git stash

if [ $? -ne 0 ]; then
    echo "Could not successfully stash current changes"
    exit 1
fi

git -c http.extraheader="AUTHORIZATION: bearer ${GITHUB_TOKEN}" pull --rebase origin "${current_branch}"

if [ $? -ne 0 ]; then
    echo "Could not successfully pull the latest changes to your local repository"
    exit 1
fi

git stash pop

if [ $? -ne 0 ]; then
    echo "Could not successfully pop the stash"
    exit 1
fi

npm install

if [ $? -ne 0 ]; then
    echo "Could not successfully install packages"
    exit 1
fi
