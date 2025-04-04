#!/bin/bash

# ===========================
# Constants and Configurations
# ===========================

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging
mkdir -p $HOME/logs
LOG_FILE="$HOME/logs/cleaner_vagrant.log"

# ===========================
# Utility Functions
# ===========================

run_as_sudo() {
	if [ "$EUID" -ne 0 ]; then
		log ERROR "Please run this script with sudo."
		exit 1
	fi
}


log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    local color

    case "$level" in
        INFO) color="$GREEN";;
        WARN) color="$YELLOW";;
        ERROR) color="$RED";;
        *) color="$BLUE";;
    esac

    echo -e "$timestamp ${color}[$level]${NC} $message" | tee -a "$LOG_FILE"
}

handle_error() {
    log ERROR "$1"
}

# ===========================
# Core Functions
# ===========================

cleanup_virtualbox() {
    log INFO "Cleaning up VirtualBox VMs and disk images..."
    VBoxManage list vms | awk '{print $1}' | tr -d '{}' | while read vm_name; do
        VBoxManage unregistervm "$vm_name" --delete
    done
    log INFO "VirtualBox VMs and disk images cleaned up."
}

cleanup_docker() {
    log INFO "Stopping and removing all Docker containers..."
    docker ps -q | xargs -r docker stop
    docker ps -aq | xargs -r docker rm

    log INFO "Removing unused Docker networks..."
    docker network prune -f

    log INFO "Removing unused Docker volumes..."
    docker volume prune -f

    log INFO "Removing all Docker images..."
    docker images -q | xargs -r docker rmi -f

    log INFO "Docker cleanup complete."
}

cleanup_k3d() {
    log INFO "Cleaning up k3d clusters..."
    k3d cluster delete --all || true
    log INFO "k3d clusters cleaned up."
}

# ===========================
# Main Script Execution
# ===========================

run_as_sudo

echo "To clean up the vagrant run the following commands in the vagrant folders :"
echo "vagrant destroy -f"
echo "rm -rf .vagrant/"

log INFO "Vagrant cleanup complete. VBoxManager cleanup in process..."
cleanup_virtualbox

log INFO "VboxManager cleanup complete. Docker cleanup in process..."
cleanup_docker

log INFO "Docker cleanup complete. K3d cleanup in process..."
cleanup_k3d

echo -e "${GREEN}"
echo "╔═══════════════════════════════════════╗"
echo "║         🧹 Cleanup Complete 🧹        ║"
echo "╚═══════════════════════════════════════╝"
echo -e "${NC}"
