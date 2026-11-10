{
  config,
  lib,
  pkgs,
  ...
}:

let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  applicationSupport =
    if isDarwin then
      "${config.home.homeDirectory}/Library/Application Support"
    else
      config.xdg.configHome;
  pgrep = if isDarwin then "/usr/bin/pgrep" else "${pkgs.procps}/bin/pgrep";
  jsonFormat = pkgs.formats.json { };

  mergePreferences =
    name: process: path: settings:
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if ${pgrep} -ix ${lib.escapeShellArg process} > /dev/null; then
        echo "Skipping ${name} preferences: quit ${name} and rebuild to apply them." >&2
      else
        ${lib.hm.generators.mkImpureConfigMerger {
          inherit pkgs path;
          format = "json";
          empty = "{}";
          jqOperation = "$dynamic * $static";
          staticSettings = jsonFormat.generate "${name}-preferences.json" settings;
          mode = "600";
        }}
      fi
    '';
in
{
  home.activation.configureDiscord =
    mergePreferences "Discord" "discord" "${applicationSupport}/discord/settings.json"
      {
        SKIP_HOST_UPDATE = true;
        BACKGROUND_COLOR = "#000000";
        enableHardwareAcceleration = true;
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
}
