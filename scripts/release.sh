#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Set your repository name and owner
repo_owner="vrajroham"
repo_name="Laravel-Scribe-GHActions-BumpSH"

echo ""
echo -e "\033[31;47m1. Checking out to master branch\033[0m"
# Checkout the master branch
git checkout master

# ensure git working directory is clean
if [ -z "$(git status --porcelain)" ]; then
  echo "Working directory is clean, continuing..."
else
  echo -e "\033[31;47m Working directory not clean. Commit or stash changes first \033[0m"

  exit 2
fi

echo ""
echo -e "\033[31;47m2. Pulling latest from master branch\033[0m"
# Pull the latest changes from the master branch
git pull origin master

# Add a blank line
echo "------------------------------------------------------------"

echo ""
echo -e "\033[31;47m3. Select the release type\033[0m"
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

echo ""
echo -e "\033[31;47mNew version number: $new_version\033[0m"

# Add a blank line
echo "------------------------------------------------------------"

# Run the tests
echo ""
echo -e "\033[31;47m4. Running tests\033[0m"
./vendor/bin/phpunit

# Add a blank line
echo "------------------------------------------------------------"

# Commit and push the changes
echo ""
echo -e "\033[31;47m5. Committing changes\033[0m"
git add config/prime.php
git commit -m "Release $new_version"

# Add a blank line
echo "------------------------------------------------------------"

echo ""
echo -e "\033[31;47m6. Pushing changes to upstream master branch\033[0m"
# Push the changes to the master branch
git push origin master

echo ""
echo -e "\033[31;47m7. Checkout to production branch\033[0m"
# Checkout the production branch
git checkout production

echo ""
echo -e "\033[31;47m8. Pull latest from production branch\033[0m"
# Pull the latest changes from the production branch
git pull origin production

# Add a blank line
echo "------------------------------------------------------------"

# Set the body of the pull request
pull_request_body=$(git log --oneline --no-merges HEAD...origin/master | awk '{print "* "$0}')

# Prompt the user to enter the pull request title
pull_request_title="Release $new_version"

# Get the pull request number
pull_request_number=$(gh pr list --base production --head master --repo "$repo_owner/$repo_name" | awk '{print $1}')

# Check if pull request already exists
if [ -n "$pull_request_number" ]; then

  # Update the body and title of the existing pull request
  echo ""
  echo -e "\033[31;47m9. Updating the body of the existing pull request. Number: $pull_request_number\033[0m"
  gh pr edit "$pull_request_number" --title "$pull_request_title" --body "$pull_request_body" --repo "$repo_owner/$repo_name"

else

    # Create a pull request using the `gh` command
    echo ""
    echo -e "\033[31;47m9. Creating new pull request\033[0m"
    gh pr create --title "$pull_request_title" --body "$pull_request_body" --base production --head master --repo "$repo_owner/$repo_name"

fi

# Checkout the master branch
git checkout master

# Add a blank line
echo "------------------------------------------------------------"

echo ""
echo -e "\033[42m\033[1;37m Done! \033[0m"

# Open PR in browser
updated_pull_request_number=$(gh pr list --base production --head master --repo "$repo_owner/$repo_name" | awk '{print $1}')
gh pr view "$updated_pull_request_number" --repo "$repo_owner/$repo_name" --web




