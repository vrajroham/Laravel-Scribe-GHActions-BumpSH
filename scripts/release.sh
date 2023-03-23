#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Set your repository name and owner
repo_owner="vrajroham"
repo_name="Laravel-Scribe-GHActions-BumpSH"

# Checkout the master branch
git checkout master

# Pull the latest changes from the master branch
git pull origin master

#!/bin/bash

set -e

# Ask the user if it's a major or minor release
read -p "Is this a major or minor release? (major/minor): " release_type

# Set the current version number
version=$(grep -Eo "'version' => '[0-9]+\.[0-9]+\.[0-9]+'" config/prime.php | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+")

if [[ "$release_type" == "major" ]]; then
  # Increment the major version number
  new_version=$(echo "$version" | awk -F. '{print $1 "." $2+1 ".0"}')
elif [[ "$release_type" == "minor" ]]; then
  # Increment the minor version number
  new_version=$(echo "$version" | awk -F. '{print $1 "." $2 "." $3+1}')
else
  # Invalid release type
  echo "Invalid release type: $release_type"
  exit 1
fi

# Update the version number in the config file
awk -v new_version="$new_version" -F\' '/version/ {OFS=FS; $4=new_version} 1' config/prime.php > temp && mv temp config/prime.php

echo "Updated version to $new_version"

# Run the tests
echo "Running tests..."
./vendor/bin/phpunit

# Commit and push the changes
echo "Committing changes..."
git add config/prime.php
git commit -m "Release $new_version"

# Create a pull request
#echo "Creating pull request..."
#gh pr create --title "Release $new_version" --body "Changes since $version:"$(git log --oneline --no-merges "v$version.." --pretty=' - %s (%h)') --base production --head master

#echo "Pull request created!"


# Push the changes to the master branch
git push origin master

# Checkout the production branch
git checkout production

# Pull the latest changes from the production branch
git pull origin production

# Set the body of the pull request
pull_request_body=$(git log --oneline --no-merges HEAD...origin/master | awk '{print "* "$0}')

# Prompt the user to enter the pull request title
pull_request_title="Release $new_version_number"

# Create a pull request using the `gh` command
gh pr create --title "$pull_request_title" --body "$pull_request_body" --base production --head master --repo "$repo_owner/$repo_name"
