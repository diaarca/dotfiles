{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
  home.packages = [ pkgs.keepingyouawake ];

  launchd.agents.keepingyouawake = {
    enable = true;
    config = {
      ProgramArguments = [
        "/usr/bin/open"
        "-g"
        "-a"
        "${config.home.homeDirectory}/Applications/Home Manager Apps/KeepingYouAwake.app"
      ];
      RunAtLoad = true;
      LimitLoadToSessionType = "Aqua";
    };
  };

  # Match the former Amphetamine preferences: manual activation, display kept awake.
  home.activation.configureKeepingYouAwake =
    lib.hm.dag.entryBetween [ "setupLaunchAgents" ] [ "writeBoundary" ]
      ''
        run /usr/bin/defaults write info.marcel-dierkes.KeepingYouAwake info.marcel-dierkes.KeepingYouAwake.ActivateOnLaunch -bool false
        run /usr/bin/defaults write info.marcel-dierkes.KeepingYouAwake info.marcel-dierkes.KeepingYouAwake.AllowDisplaySleep -bool false
        run /usr/bin/defaults write info.marcel-dierkes.KeepingYouAwake info.marcel-dierkes.KeepingYouAwake.BatteryCapacityThresholdEnabled -bool false
        run /usr/bin/defaults write info.marcel-dierkes.KeepingYouAwake SUEnableAutomaticChecks -bool false
        run /usr/bin/defaults write info.marcel-dierkes.KeepingYouAwake SUAutomaticallyUpdate -bool false
      '';
}
