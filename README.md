# Personal chezmoi configuration

Shared development configuration for Linux and Apple Silicon macOS. Home Manager
manages applications and dotfiles; the macOS flake also uses nix-darwin for system
preferences. Chezmoi deploys the source files into `~/.config/home-manager`.

## Bootstrap

Install multi-user Nix using the current instructions for your platform:
[Nix installation](https://nixos.org/download/) or
[nix-darwin prerequisites](https://github.com/nix-darwin/nix-darwin#prerequisites).
The macOS configuration assumes upstream Nix; Determinate Nix requires different
integration. Then fetch and apply the dotfiles:

On a fresh macOS installation, first grant Terminal **Full Disk Access** in
System Settings → Privacy & Security → Full Disk Access. Add Terminal if it is
not listed, enable it, then quit Terminal completely and reopen it. This was
needed for the Nix installer to complete in the macOS VM. For a VM rehearsal,
grant this permission inside the guest.

Then install upstream Nix from Terminal:

```sh
curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh
```

Open a new Terminal after the installer finishes. Run the remaining commands as
your regular user, using `sudo` only where shown. For a VM rehearsal, run them
inside the guest. Start a temporary shell with the bootstrap tools and keep it
open through the first Home Manager activation:

```sh
nix-shell -p git chezmoi home-manager
export NIX_CONFIG="experimental-features = nix-command flakes"
chezmoi init --apply https://github.com/diaarca/dotfiles.git
```

The temporary flakes setting is needed before Home Manager writes the user's
Nix configuration. Git is provided by Nix for the initial repository clone.
The key bootstrap script prompts for the passphrase protecting `key.txt.age`
when the age identity is missing, then restores the encrypted SSH files. Keep
that passphrase/recovery material separately from this repository.

## Linux

Keep the existing Home Manager and Nixpkgs channels configured, then run:

```sh
home-manager switch
```

The shared `home.nix` still derives the username from `$USER` and uses `/home` on
Linux. Chezmoi excludes the macOS flake and modules from Linux deployments, so
Home Manager continues using the channel-based configuration. Linux's existing
nixGL import remains unpinned; this change only introduces a locked macOS setup.

## macOS

Build the complete configuration without activating it:

```sh
nix build "path:$HOME/.config/home-manager#darwinConfigurations.macbook.system" --no-link
```

Standalone macOS Home Manager installs `darwin-rebuild` from the same lock file.
Apply the user configuration first using the locked Home Manager CLI. This also
works in the temporary bootstrap shell without a Home Manager channel:

```sh
nix run "path:$HOME/.config/home-manager#home-manager" -- switch \
  --flake "path:$HOME/.config/home-manager"
```

After the first successful activation, open a new Terminal window so the shell
loads the installed programs and updated `PATH`. Run the following commands in
that new terminal. First activate the system configuration:

```sh
sudo "$HOME/.nix-profile/bin/darwin-rebuild" switch \
  --flake "path:$HOME/.config/home-manager#macbook"
```

After this first nix-darwin activation, open another new Terminal window to load
the system environment. Subsequent system and Home Manager changes are applied
together using the system tool's explicit path, which also works when `sudo`
does not include Nix directories in its search path:

```sh
sudo /run/current-system/sw/bin/darwin-rebuild switch \
  --flake "path:$HOME/.config/home-manager#macbook"
```

`home-manager switch` applies only the user configuration. Once nix-darwin is
managing the machine, use `darwin-rebuild` to apply system and user changes
together; nix-darwin itself provides the rebuild tool in that setup.
Keep `home.stateVersion` and `system.stateVersion` unchanged when updating inputs.
To update the lock deliberately:

```sh
nix flake update --flake "path:$HOME/.config/home-manager"
```

## Desktop applications

Configured apps have their own modules: `kitty.nix`, `vivaldi.nix`, `discord.nix`,
`rectangle.nix`, `keepingyouawake.nix`, and `nextdns.nix`. Rectangle,
KeepingYouAwake, and NextDNS are enabled only on macOS. Obsidian has no declared
settings and stays in `packages.nix`. Shared macOS app copying and Spotlight
registration live in `macos-apps.nix`.

Quit Vivaldi and Discord before rebuilding to apply their saved preferences.
Vivaldi is the default browser on Linux; macOS activation requests the same and
may require confirmation. If it remains unchanged, select Vivaldi in System
Settings → Desktop & Dock → Default web browser.

## Recovery and storage

Keep a verified Time Machine backup before resetting the Mac. This repository
does not restore documents, application databases, Keychain/Apple ID state,
Touch ID, privacy permissions, or the complete set of system settings. Display
layouts, network/VPN configuration, per-device settings, and power settings also
need review after reinstalling. Export application data not already managed here
and retain licenses and recovery credentials separately.
