#!/usr/bin/env bash
set -euo pipefail

if [[ $(uname -s) != Linux ]]; then
    echo "This setup requires Linux with SDDM." >&2
    exit 1
fi

if [[ ${1:-} != "" && ${1:-} != --preview ]]; then
    echo "Usage: $0 [--preview]" >&2
    exit 1
fi

script_dir=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
theme_package=$(nix-build "$script_dir/theme.nix" --no-out-link)
theme_dir="$theme_package/share/sddm/themes/catppuccin-mocha-teal"

if [[ ${1:-} == --preview ]]; then
    export QT_QUICK_CONTROLS_STYLE=Basic
    exec sddm-greeter-qt6 --test-mode --theme "$theme_dir"
fi

sudo install -d -m 0755 /usr/local/share/sddm/themes /etc/sddm.conf.d
sudo cp -R "$theme_dir" /usr/local/share/sddm/themes/
sudo install -m 0644 "$script_dir/sddm.conf" /etc/sddm.conf.d/90-chezmoi.conf

echo "SDDM theme installed and service accounts hidden. Changes apply at your next login screen."
