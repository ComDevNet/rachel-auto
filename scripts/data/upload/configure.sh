#!/bin/bash

# Check if AWS CLI is already configured
if aws configure list &> /dev/null; then
    echo "AWS CLI is already configured with the following settings:"
    aws configure list
    read -p "Do you want to change the configuration? (y/n): " choice
    if [[ $choice == "y" ]]; then
        aws configure
    else
        echo "No changes made to the configuration."
        sleep 2
        exec ./scripts/data/upload/main.sh
    fi
else
    read -p "AWS CLI is not configured. Do you want to configure it? (y/n): " choice
    if [[ $choice == "y" ]]; then
        aws configure
    else
        echo "AWS CLI configuration skipped."
        sleep 2
        exec ./scripts/data/upload/main.sh
    fi
fi
