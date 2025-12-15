#!/bin/bash
# This script ensures that `fish` from Nix is set as the default shell on macOS.
# It should be run manually after `home-manager switch` has completed
# successfully

set -euo pipefail

NIX_FISH_PATH="/Users/dylan/.nix-profile/bin/fish"

# --- Dependency Check ---
if ! [ -x "${NIX_FISH_PATH}" ]; then
    echo "Error: Fish not found at ${NIX_FISH_PATH}." >&2
    echo "Please run 'home-manager switch' successfully before running this
        script."
    >&2
    exit 1
fi

# Add fish to /etc/shells if not already present
if ! grep -q "^${NIX_FISH_PATH}$" /etc/shells; then
    echo "Adding ${NIX_FISH_PATH} to /etc/shells..."
    echo "${NIX_FISH_PATH}" | sudo tee -a /etc/shells >/dev/null
else
    echo "${NIX_FISH_PATH} already in /etc/shells."
fi

# Change default shell if not already fish
CURRENT_SHELL=$(dscl . -read "/Users/$USER" UserShell | awk '{print $NF}')

if [ "${CURRENT_SHELL}" != "${NIX_FISH_PATH}" ]; then
    echo "Changing default shell to ${NIX_FISH_PATH}..."
    chsh -s "${NIX_FISH_PATH}"
    echo "Default shell has been changed. Please log out and back in for it to
  take effect."
else
    echo "Default shell is already set to ${NIX_FISH_PATH}."
fi

echo "Default shell setup script finished."
