{
  config,
  lib,
  user,
  ...
}:

{
  imports = [
    ./home.nix
    ./macos-apps.nix
  ];

  # Keep the shared, channel-based Linux configuration independent of this flake.
  home.username = lib.mkForce user.username;
  home.homeDirectory = lib.mkForce user.homeDirectory;
  home.packages = lib.optional config.submoduleSupport.enable config.programs.home-manager.package;

  # Chezmoi owns init.lua; load Home Manager's generated initialization in the wrapper.
  programs.neovim.sideloadInitLua = true;

  # Menu-bar ByHost preferences are managed by nix-darwin in macos-menu-bar.nix.
  home.activation.configureHostPreferences = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run /usr/bin/defaults -currentHost write com.apple.screensaver idleTime -int 0
  '';
}
