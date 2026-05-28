{
  config,
  pkgs,
  lib,
  ...
}:

let
  isLinux = pkgs.stdenv.isLinux;
  isDarwin = pkgs.stdenv.isDarwin;
  username = builtins.getEnv "USER";
in
{
  home.username = username;
  home.homeDirectory = if isLinux then "/home/${username}" else "/Users/${username}";
  home.stateVersion = "24.05";

  imports = [
    ./packages.nix
    ./nvim.nix
    ./fish.nix
    ./kitty.nix
    ./git.nix
    ./aliases.nix
    ./direnv.nix
    ./vivaldi.nix
  ];

  home.sessionVariables = {
    PAGER = "less";
    EDITOR = "nvim";
    VISUAL = "nvim";
    TERMINAL = "kitty";
    # ensure core nix paths are always included by home manager
    PATH = "$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$HOME/.local/bin:$PATH";
  };

  home.file =
    if isLinux then
      {
        ".config/fontconfig/conf.d/10-nix-fonts.conf".text = ''
          <?xml version='1.0'?>
          <!DOCTYPE fontconfig SYSTEM 'fonts.dtd'>
          <fontconfig>
            <dir>~/.nix-profile/share/fonts/</dir>
          </fontconfig>
        '';
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
