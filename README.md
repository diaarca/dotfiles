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

```sh
nix-shell -p chezmoi home-manager
chezmoi init --apply https://github.com/diaarca/dotfiles.git
```

The encrypted SSH material requires the existing age identity/bootstrap process.
Keep that recovery material separately from this repository.

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

The flake targets the `dylan` account on `aarch64-darwin`. Review `darwin.nix`,
`macos-home.nix`, and `macos-defaults.nix` before adapting it to another Mac.
`flake.lock` pins Nixpkgs, Home Manager, and nix-darwin.

Build the complete configuration without activating it:

```sh
nix build "path:$HOME/.config/home-manager#darwinConfigurations.macbook.system" --no-link
```

For the first system activation, use the rebuild tool from the same lock file:

```sh
sudo nix run "path:$HOME/.config/home-manager#darwin-rebuild" -- switch \
  --flake "path:$HOME/.config/home-manager#macbook"
```

Subsequent system and Home Manager changes are applied together:

```sh
sudo darwin-rebuild switch --flake "path:$HOME/.config/home-manager#macbook"
```

Before adopting nix-darwin, the standalone macOS Home Manager configuration can
also be built/applied with `home-manager build` / `home-manager switch`. Once
nix-darwin is managing the machine, use `darwin-rebuild` to keep the two in sync.
Keep `home.stateVersion` and `system.stateVersion` unchanged when updating inputs.
To update the lock deliberately:

```sh
nix flake update --flake "path:$HOME/.config/home-manager"
```

Copy changes made here to the live configuration with chezmoi before rebuilding.
Alternatively, use `path:./dot_config/home-manager` from this repository in place
of `path:$HOME/.config/home-manager` in the commands above.

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
