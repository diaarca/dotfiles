{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dylan";
  home.homeDirectory = "/home/dylan";

  home.stateVersion = "25.05"; # Please read the comment before changing.

  imports =
    (if builtins.match ".*-linux" (builtins.currentSystem or "") != null then [ ./dconf.nix ] else [ ])
    ++ [
      ./packages.nix
      ./nvim.nix
      ./fish.nix
      ./kitty.nix
      ./aliases.nix
    ];

  home.sessionVariables = {
    PAGER = "less";
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
    PATH = "$HOME/.nix-profile/bin:$PATH";
  };

  home.file = {
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
  };

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
