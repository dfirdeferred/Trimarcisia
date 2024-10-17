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
#REPOS=(
#  "ADAuditingGroup"
#  "PowerPUG"
#  "Locksmith"
#  "BlueTuxedo"
#  "Find-and-Fix"
#  "papers"
#  "New-KrbtgtKeys.ps1"
#  "SPN-Descriptions"
#  "Create-Vulnerable-ADDS"
#  "Invoke-TrimarcADChecks"
#  "TailscaleLogAnalyticIngestor"
#  "play.backdoorsandbreaches.com"
#)
REPOS=$(curl -s https://api.github.com/users/Trimarc/repos | jq -r '.[].name')

# Check if wget and unzip are installed, if not, install them
if ! command -v wget &> /dev/null; then
  echo "wget not found. Installing..."
  sudo apt-get install wget -y
fi

if ! command -v unzip &> /dev/null; then
  echo "unzip not found. Installing..."
  sudo apt-get install unzip -y
fi

# Function to download and unzip the repository
download_repo() {
  local repo_name="$1"
  if [ ! -d "$repo_name" ]; then
    echo "Downloading $repo_name..."
    wget "https://github.com/Trimarc/$repo_name/archive/refs/heads/main.zip" -O "$repo_name.zip"
    echo "Unzipping $repo_name..."
    unzip "$repo_name.zip" -d "$repo_name"
    rm "$repo_name.zip"
    xdg-open "$repo_name" 
  else
    echo "$repo_name already downloaded."
    xdg-open "$repo_name" 
  fi
  cd "$repo_name"/* 2>/dev/null || cd "$repo_name" || exit
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


