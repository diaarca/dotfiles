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
  mergePreferences = import ./lib/merge-app-preferences.nix { inherit lib pkgs; };
in
{
  home.packages = [ pkgs.discord ];

  home.activation.configureDiscord =
    mergePreferences "Discord" "discord" "${applicationSupport}/discord/settings.json"
      {
        SKIP_HOST_UPDATE = true;
        BACKGROUND_COLOR = "#000000";
        enableHardwareAcceleration = true;
      };
}
