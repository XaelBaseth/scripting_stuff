#!/bin/bash

# Clean APT cache
sudo apt-get clean
sudo apt-get autoremove

# Remove APT lists
sudo rm -r /var/lib/apt/lists/*
sudo apt-get update

# Clean the dangling docker images
docker system prune -a --volumes -f

# Remove the compressed logs
sudo find /var/log -type f -name "*.gz" -delete

printf "Cleaning complete :)\n\n"
