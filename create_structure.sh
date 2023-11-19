#!/bin/bash

# Define the base directory (current directory assumed)
BASE_DIR=$(pwd)

# Create the .github workflows directory
mkdir -p "$BASE_DIR/.github/workflows"

# Create an empty GitHub Actions workflow file
touch "$BASE_DIR/.github/workflows/deploy.yml"

# Create the Terraform modules and environments directory structure
mkdir -p "$BASE_DIR/terraform/modules"
mkdir -p "$BASE_DIR/terraform/environments/dev"

# Create the source code directory
mkdir -p "$BASE_DIR/src"

# Create .gitignore and README.md
touch "$BASE_DIR/.gitignore"
touch "$BASE_DIR/README.md"

echo "Project structure with GitHub Actions workflow file created successfully."
