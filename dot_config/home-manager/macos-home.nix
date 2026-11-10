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

  # ByHost preferences must be written for the destination Mac, without copying its UUID.
  home.activation.configureHostPreferences = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run /usr/bin/defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true
    run /usr/bin/defaults -currentHost write com.apple.controlcenter Bluetooth -int 2
    run /usr/bin/defaults -currentHost write com.apple.controlcenter Sound -int 18
    run /usr/bin/defaults -currentHost write com.apple.controlcenter FocusModes -int 16
    run /usr/bin/defaults -currentHost write com.apple.controlcenter NowPlaying -int 0
    run /usr/bin/defaults -currentHost write com.apple.screensaver idleTime -int 0
  '';
}
