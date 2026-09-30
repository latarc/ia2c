#!/bin/sh

# Updates the local package list and installs necessary dependencies
sudo apt update
sudo apt install ca-certificates curl

# Creates the directory to store the Docker GPG key
sudo install -m 0755 -d /etc/apt/keyrings

# Downloads the Docker GPG key and changes its permissions
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Adds the Docker repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Updates the local package list and installs the Docker plugins
VERSION_DOCKER=5:27.4.0-1~ubuntu.24.04~noble
sudo apt-get update
sudo apt-get install -y docker-ce=$VERSION_DOCKER docker-ce-cli=$VERSION_DOCKER containerd.io docker-buildx-plugin docker-compose-plugin
