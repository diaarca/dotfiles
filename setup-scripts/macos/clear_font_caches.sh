#!/bin/bash
# This script clears all macOS system and application font caches.
set -euo pipefail

echo "Clearing macOS system font cache..."
sudo atsutil databases -remove

echo "Font caches have been removed."
echo "IMPORTANT: A system reboot is highly recommended for these changes to take 
full effect."
