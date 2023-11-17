#!/bin/bash

# This script makes it easy to change the git branch which in terns changes the interface

# Save the current directory
current_directory=$(pwd)

# Move to the /var/www/ directory
cd /var/www/ || exit

# Get the current branch
current_branch=$(git rev-parse --abbrev-ref HEAD)

echo ""

# Display the current branch
echo "Current Branch: $current_branch"

# Show all available branches
echo "Available Branches:"
git branch

# Ask the user if they want to switch to another branch
read -p "Do you want to switch to another branch? (y/n): " switch_branch

if [ "$switch_branch" == "y" ]; then
    # Ask the user which branch they want to switch to
    read -p "Enter the branch name you want to switch to: " desired_branch

    # Check if the desired branch exists
    if git show-ref --verify --quiet "refs/heads/$desired_branch"; then
        # Perform a git checkout to the desired branch
        sudo git checkout "$desired_branch"
        echo ""
        echo "Switched to branch $desired_branch successfully. Returning to the main menu in 4 seconds..."
    else
        echo "Branch $desired_branch does not exist. Returning to the main menu in 4 seconds..."
    fi
else
    echo "Not switching branches. Returning to the main menu in 4 seconds..."
fi

cd "$current_directory"
sleep 4
# Return to the main script
exec ./scripts/system/main.sh
