#!/usr/bin/env bash

#
#   Copyright (C) 2024
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
#   https://github.com/menta1001/rustpp
#

if [ -z "${BASH_VERSION:-}" ]; then
    exec bash "$0" "$@"
fi

set -euo pipefail

REPO_URL="https://github.com/menta1001/rustpp.git"
TOKEN="${GITHUB_TOKEN:-${1:-}}"

if [ -z "$TOKEN" ]; then
    echo "GitHub token not provided. Set GITHUB_TOKEN or pass as first argument."
    echo "Usage: GITHUB_TOKEN=your_token ./update_with_token.sh"
    echo "   or: ./update_with_token.sh your_token"
    exit 1
fi

git checkout -- package-lock.json

git stash

git remote set-url origin "$REPO_URL"

git -c http.extraHeader="Authorization: Bearer ${TOKEN}" pull --rebase origin master

git stash pop

npm install
