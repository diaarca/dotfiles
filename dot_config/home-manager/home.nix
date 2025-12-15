{
  config,
  pkgs,
  lib,
  ...
}:

let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dylan";
  home.homeDirectory = if isLinux then "/home/dylan" else "/Users/dylan";
  home.stateVersion = "24.05"; # Please read the comment before changing.

  imports = [
    ./packages.nix
    ./nvim.nix
    ./fish.nix
    ./kitty.nix
    ./aliases.nix
    ./vivaldi.nix
  ];

  home.sessionVariables = {
    PAGER = "less";
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
    # Ensure core Nix paths are always included by Home Manager
    PATH = "$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH";
  };

  home.file =
    if isLinux then
      {
        ".local/share/applications/kitty.desktop" = {
          text =
            let
              originalDesktopFile = builtins.readFile "${pkgs.kitty}/share/applications/kitty.desktop";
            in
            builtins.replaceStrings
              [
                "TryExec=kitty"
                "Exec=kitty"
              ]
              [
                ""
                "Exec=nixGL kitty"
              ]
              originalDesktopFile;
          force = true;
        };
        ".local/share/applications/btop.desktop" = {
          text =
            let
              originalDesktopFile = builtins.readFile "${pkgs.btop}/share/applications/btop.desktop";
            in
            builtins.replaceStrings
              [ "Exec=btop" "Terminal=true" ]
              [ "Exec=nixGL kitty -1 btop" "Terminal=false" ]
              originalDesktopFile;
          force = true;
        };
      }
    else
      { };

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
