#!/bin/bash

space_before=$(df -h --output=size --total | awk 'END {print $1}')

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

space_after=$(df -h --output=size --total | awk 'END {print $1}')

space_reclaimed=(echo "$space_before - $space_after\n" | bc)

printf "Cleaning complete :)\nYou have reclaimed $space_reclaimed !\n\n"
