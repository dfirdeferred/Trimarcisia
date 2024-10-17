#!/bin/bash

##################################################################
# Trimarcisia.sh v1.0.0                                          #
#                                                                #
#              Written by Darryl G. Baker                        #
##################################################################

# Print ASCII Art
echo " _____   _   _                                          "
echo "|___ /  | | | | ___  _ __ ___  ___ _ __ ___   ___ _ __  "
echo "  |_ \  | |_| |/ _ \| '__/ __|/ _ \ '_ \` _ \ / _ \ '_ \ "
echo " ___) | |  _  | (_) | |  \__ \  __/ | | | | |  __/ | | |"
echo "|____/  |_| |_|\___/|_|  |___/\___|_| |_| |_|\___|_| |_|"

# List of repositories
REPOS=$(curl -s https://api.github.com/users/Trimarc/repos | jq -r '.[].name')

# Check if curl and unzip are installed, if not, install them
if ! command -v curl &> /dev/null; then
  echo "curl not found. Installing..."
  sudo apt-get install curl -y
fi

if ! command -v unzip &> /dev/null; then
  echo "unzip not found. Installing..."
  sudo apt-get install unzip -y
fi

# Function to download and unzip the repository
download_repo() {
    repo_name=$1

    # Check if the directory exists
    if [ ! -d "$repo_name" ]; then
        echo "Downloading $repo_name..."
        
        # Get repository information
        repo=$(curl -s "$api/$repo_name")
        current_branch=$(echo "$repo" | jq -r '.default_branch')
        
        # Construct the zip file URL
        zip_url=$(echo "$repo" | jq -r '.archive_url' | sed "s/{archive_format}{\/ref}/zipball\/$current_branch/")
        
        # Download and unzip the repository
        curl -L -o "$repo_name.zip" "$zip_url"
        echo "Unzipping $repo_name..."
        unzip "$repo_name.zip" -d "$repo_name"
        
        # Clean up the zip file
        rm "$repo_name.zip"
        
        # Open the folder
        xdg-open "$repo_name" >/dev/null 2>&1 &
    else
        echo "$repo_name already downloaded."
        
        # Open the folder if it exists
        xdg-open "$repo_name" >/dev/null 2>&1 &
    fi
}

# Display list of repositories
echo "Please select a repository to download/open:"
echo "0. Download all repositories"
for i in "${!REPOS[@]}"; do
  echo "$((i+1)). ${REPOS[$i]}"
done

# Read user input
read -rp "Enter the number of the repository you want to download/open: " selection

# Validate user input
if [[ "$selection" -eq 0 ]]; then
  for repo_name in "${REPOS[@]}"; do
    download_repo "$repo_name"
  done
  echo "All repositories have been downloaded."
elif [[ "$selection" -ge 1 && "$selection" -le ${#REPOS[@]} ]]; then
  repo_name="${REPOS[$((selection-1))]}"
  download_repo "$repo_name"
else
  echo "Invalid selection. Exiting."
  exit 1
fi


