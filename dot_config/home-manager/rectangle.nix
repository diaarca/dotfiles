{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
  home.packages = [ pkgs.rectangle ];

  launchd.agents.rectangle = {
    enable = true;
    config = {
      ProgramArguments = [
        "/usr/bin/open"
        "-g"
        "-a"
        "${config.home.homeDirectory}/Applications/Home Manager Apps/Rectangle.app"
      ];
      RunAtLoad = true;
      LimitLoadToSessionType = "Aqua";
    };
  };

  # Merge selected preferences so Rectangle can retain other settings from its UI.
  home.activation.configureRectangle =
    lib.hm.dag.entryBetween [ "setupLaunchAgents" ] [ "writeBoundary" ]
      ''
        run /usr/bin/defaults write com.knollsoft.Rectangle alternateDefaultShortcuts -bool true
        run /usr/bin/defaults write com.knollsoft.Rectangle allowAnyShortcut -bool true
        run /usr/bin/defaults write com.knollsoft.Rectangle subsequentExecutionMode -int 1
        run /usr/bin/defaults write com.knollsoft.Rectangle SUEnableAutomaticChecks -bool false
      '';
}
