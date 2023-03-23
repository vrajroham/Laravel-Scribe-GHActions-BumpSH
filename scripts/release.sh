#!/bin/bash

# Set your repository name and owner
repo_owner="vrajroham"
repo_name="Laravel-Scribe-GHActions-BumpSH"

# Checkout the master branch
git checkout master

# Pull the latest changes from the master branch
git pull origin master

# Prompt the user to enter the new version number
read -p "Enter the new version number: " new_version_number

# Update the version number in prime.php
sed -i "s/'version' => '[0-9]\+\.[0-9]\+'/\'version\' => '$new_version_number'/g" config/prime.php

# Create a commit with the updated version number
git add prime.php
git commit -m "Release $new_version_number"

# Push the changes to the master branch
git push origin master

# Checkout the production branch
git checkout production

# Set the body of the pull request
pull_request_body=$(git log --oneline --no-merges HEAD...origin/master | awk '{print "* "$0}')

# Prompt the user to enter the pull request title
pull_request_title="Release $new_version_number"

# Create a pull request using the `gh` command
gh pr create --title "$pull_request_title" --body "$pull_request_body" --base production --head master --repo "$repo_owner/$repo_name"
