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

On a fresh macOS installation, install upstream Nix from Terminal:

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

The flake targets Apple Silicon (`aarch64-darwin`). Chezmoi renders `user.json`
with the deploying user's username and actual home directory. Run chezmoi as
your regular user; the generated identity stays the same when rebuilding with
`sudo`, without requiring impure Nix evaluation. The standalone Home Manager
profile is named after that username; the system profile remains `macbook`.
Review the saved preferences before adapting them to another Mac. `flake.lock`
pins Nixpkgs, Home Manager, and nix-darwin.

Build the complete configuration without activating it:

```sh
nix build "path:$HOME/.config/home-manager#darwinConfigurations.macbook.system" --no-link
```

Standalone macOS Home Manager installs `darwin-rebuild` from the same lock file.
Apply the user configuration first, then activate the system configuration:

```sh
home-manager switch
sudo "$HOME/.nix-profile/bin/darwin-rebuild" switch \
  --flake "path:$HOME/.config/home-manager#macbook"
```

Subsequent system and Home Manager changes are applied together:

```sh
sudo darwin-rebuild switch --flake "path:$HOME/.config/home-manager#macbook"
```

`home-manager switch` applies only the user configuration. Once nix-darwin is
managing the machine, use `darwin-rebuild` to apply system and user changes
together; nix-darwin itself provides the rebuild tool in that setup.
Keep `home.stateVersion` and `system.stateVersion` unchanged when updating inputs.
To update the lock deliberately:

```sh
nix flake update --flake "path:$HOME/.config/home-manager"
```

Copy changes made here to the live configuration with
`chezmoi apply ~/.config/home-manager` before rebuilding. Build from the deployed
directory: the source repository contains `user.json.tmpl`, which chezmoi must
render to `user.json` first.

The captured preferences include Dock placement and pinned apps, Finder, keyboard
repeat and text input, language/region, trackpad gestures, clock, Stage Manager,
and selected accessibility preferences. `macos-home.nix` also restores selected
Control Center settings and the screensaver timeout for the destination Mac.
`macos-shortcuts.json` stores the Mac's
system keyboard shortcuts. Values absent from the capture are left to macOS.
Custom preference keys are implementation details and may change with macOS;
some settings need an application restart or logout to take effect. Removing a
declaration does not necessarily reset the corresponding preference.

Rectangle is installed through Nix. Its working Control–Option shortcut preset
and repeated-command behavior are saved in `macos-home.nix`. Automatic update
checks are disabled so updates come from Nix. Grant Accessibility permission after
installation, and quit BentoBox before using it. Open Rectangle from
`~/Applications/Home Manager Apps`; left/right halves use Control–Option–Left/Right,
and maximize uses Control–Option–Return. Restart Rectangle after applying changed
preferences. Enable launch at login in its settings if desired.

No Homebrew installation or removal is performed. This configuration is not a
complete inventory of `/Applications`: software such as Vivaldi, Amphetamine,
NextDNS's GUI, and CPLEX still needs migration decisions. In this lock, the
Nixpkgs Vivaldi package supports Linux only. Nix can install packaged macOS apps,
including binary distributions, but cannot provide every App Store/proprietary
application or replace Apple's system software.

## Recovery and storage

Keep a verified Time Machine backup before resetting the Mac. This repository
does not restore documents, application databases, Keychain/Apple ID state,
Touch ID, privacy permissions, or the complete set of system settings. Display
layouts, network/VPN configuration, per-device settings, and power settings also
need review after reinstalling. Export application data not already managed here
and retain licenses and recovery credentials separately.

Nix retains package generations for rollback and can consume significant disk
space. Review unused generations before garbage collection; this configuration
does not automatically delete them or other user data.

For a recovery rehearsal, start with a fresh Apple Silicon macOS VM, create an
administrator account such as `vmtest`, and follow Bootstrap and macOS above.
Do not migrate the host's home directory or update `flake.lock` during the test.
After activation, reboot the guest, check the applications and visible settings,
and run `darwin-rebuild switch` again. Test restoring important files from Time
Machine separately before resetting the physical Mac.

Use `nix build` for validation without activation. In the pinned nix-darwin
version, `darwin-rebuild check` can apply system changes because its check flag
is lost when the activation script clears its environment.
