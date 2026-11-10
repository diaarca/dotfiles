{
  config,
  lib,
  pkgs,
  ...
}:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  applicationSupport =
    if isDarwin then
      "${config.home.homeDirectory}/Library/Application Support"
    else
      config.xdg.configHome;
  mergePreferences = import ./lib/merge-app-preferences.nix { inherit lib pkgs; };
in
{
  programs.vivaldi.enable = isLinux;
  home.packages = lib.optionals isDarwin [
    (pkgs.callPackage ./packages/vivaldi-darwin.nix { })
    pkgs.defaultbrowser
  ];

  xdg.mimeApps = lib.mkIf isLinux {
    enable = true;
    defaultApplications = {
      "text/html" = [ "vivaldi-stable.desktop" ];
      "x-scheme-handler/http" = [ "vivaldi-stable.desktop" ];
      "x-scheme-handler/https" = [ "vivaldi-stable.desktop" ];
      "x-scheme-handler/ftp" = [ "vivaldi-stable.desktop" ];
      "application/xhtml+xml" = [ "vivaldi-stable.desktop" ];
    };
  };

  home.activation.configureVivaldi =
    mergePreferences "Vivaldi" "vivaldi(-bin)?"
      "${applicationSupport}/${if isDarwin then "Vivaldi" else "vivaldi"}/Default/Preferences"
      {
        vivaldi = {
          address_bar = {
            position = 0;
            show_full_url = true;
            visible = true;
          };
          bookmarks.bar = {
            display = 3;
            position = 0;
            visible = true;
          };
          downloads = {
            notify_on_complete = false;
            open_panel_on_new = false;
            start_automatically = false;
          };
          panels = {
            as_overlay.enabled = false;
            position = 0;
            show_toggle = true;
          };
          quick_commands = {
            show_calculator = false;
            show_history = false;
            show_notes = false;
            show_page_actions = false;
            show_reading_list = false;
          };
          status_bar = {
            display = 1;
            minimized = 0;
          };
          tabs = {
            bar.position = 1;
            defer_loading_after_restore = false;
            visible = true;
          };
        };
      };

  home.activation.setDefaultBrowser = lib.mkIf isDarwin (
    lib.hm.dag.entryAfter [ "registerApplications" ] ''
      run ${lib.getExe pkgs.defaultbrowser} vivaldi
      if [[ ! -v DRY_RUN ]] && ! ${lib.getExe pkgs.defaultbrowser} | /usr/bin/grep -q '^\* vivaldi$'; then
        echo "Vivaldi is not yet the default browser. Accept the macOS confirmation or select it in System Settings > Desktop & Dock > Default web browser." >&2
      fi
    ''
  );
}
