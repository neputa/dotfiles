#!/bin/bash

# echo "# Installing Docker"
#
# if ! dpkg -l | grep -q docker; then
#   sudo apt update
#   sudo apt install -y ca-certificates curl gnupg
#   sudo mkdir -p /etc/apt/keyrings
#   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg
#   echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
#   sudo apt update
#   sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# fi
