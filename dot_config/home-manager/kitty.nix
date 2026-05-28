{
  pkgs,
  lib,
  config,
  ...
}:

let
  # Platform detection
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;

  # Common settings
  kittyCommonSettings = {
    os_window_state = "maximized";
    placement_strategy = "top-left";
    confirm_os_window_close = 0;
    hide_window_decorations = "yes";
    copy_on_select = true;
    enabled_layouts = "tall,horizontal,vertical,fat,stack";
    shell = "${config.home.homeDirectory}/.nix-profile/bin/fish";
    "map ctrl+shift+w" = "close_window";
  };

  # OS-specific mappings and options
  kittyDarwinSettings = {
    # New window
    "map cmd+enter" = "new_window_with_cwd";
    "map ctrl+shift+enter" = "new_window";

    # Window swap
    "map cmd+h" = "neighboring_window left";
    "map cmd+l" = "neighboring_window right";
    "map cmd+j" = "neighboring_window down";
    "map cmd+k" = "neighboring_window up";
    "map cmd+left" = "neighboring_window left";
    "map cmd+right" = "neighboring_window right";
    "map cmd+down" = "neighboring_window down";
    "map cmd+up" = "neighboring_window up";

    # Layout management
    "map cmd+shift+v" = "goto_layout horizontal";
    "map cmd+shift+h" = "goto_layout vertical";
    "map cmd+shift+f" = "goto_layout fat";
    "map cmd+shift+t" = "goto_layout tall";

    # Deleting tab management
    "map cmd+t" = "no_op";
    "map ctrl+shift+t" = "no_op";
  };

  kittyLinuxSettings = {
    # New window
    "map alt+enter" = "new_window_with_cwd";
    "map ctrl+shift+enter" = "new_window";

    # Window swap
    "map alt+h" = "neighboring_window left";
    "map alt+l" = "neighboring_window right";
    "map alt+j" = "neighboring_window down";
    "map alt+k" = "neighboring_window up";
    "map alt+left" = "neighboring_window left";
    "map alt+right" = "neighboring_window right";
    "map alt+down" = "neighboring_window down";
    "map alt+up" = "neighboring_window up";

    # Layout management
    "map alt+shift+v" = "goto_layout horizontal";
    "map alt+shift+h" = "goto_layout vertical";
    "map alt+shift+f" = "goto_layout fat";
    "map alt+shift+t" = "goto_layout tall";

    # Deleting tab management
    "map alt+t" = "no_op";
    "map ctrl+shift+t" = "no_op";
  };
in
{
  # Add nixGL to packages only on Linux
  home.packages = lib.mkIf isLinux [
    (import (fetchTarball "https://github.com/nix-community/nixGL/archive/main.tar.gz") { })
    .auto.nixGLDefault
  ];

  programs.kitty = {
    enable = true;

    font = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font Mono";
      size = 14;
    };
    shellIntegration.enableFishIntegration = true;

    settings =
      kittyCommonSettings
      // (if isDarwin then kittyDarwinSettings else { })
      // (if isLinux then kittyLinuxSettings else { });
  };

  xdg.configFile."kitty/dark-theme.auto.conf".text = builtins.readFile (
    pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/kovidgoyal/kitty-themes/master/themes/GitHub_Dark.conf";
      sha256 = "sha256-23D48bQgQJjcRk6kfD3lBxaXvWzCxPnTYGjDDdluuCQ=";
    }
  );

  xdg.configFile."kitty/light-theme.auto.conf".text = builtins.readFile (
    pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/kovidgoyal/kitty-themes/master/themes/GitHub_Light.conf";
      sha256 = "sha256-AtxguOM3Cfyvco2uyFiCA57OcVab/B5ch1cYGySdzpw=";
    }
  );
}
