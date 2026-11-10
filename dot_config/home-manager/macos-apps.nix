{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = [
    pkgs.keepingyouawake
    (pkgs.callPackage ./packages/vivaldi-darwin.nix { })
    (pkgs.callPackage ./packages/nextdns-darwin.nix { })
  ];

  # Spotlight indexes real app bundles rather than links into /nix/store.
  targets.darwin.linkApps.enable = false;
  targets.darwin.copyApps.enable = true;

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
  home.activation.configureKeepingYouAwake = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run /usr/bin/defaults write info.marcel-dierkes.KeepingYouAwake info.marcel-dierkes.KeepingYouAwake.ActivateOnLaunch -bool false
    run /usr/bin/defaults write info.marcel-dierkes.KeepingYouAwake info.marcel-dierkes.KeepingYouAwake.AllowDisplaySleep -bool false
    run /usr/bin/defaults write info.marcel-dierkes.KeepingYouAwake info.marcel-dierkes.KeepingYouAwake.BatteryCapacityThresholdEnabled -bool false
    run /usr/bin/defaults write info.marcel-dierkes.KeepingYouAwake SUEnableAutomaticChecks -bool false
    run /usr/bin/defaults write info.marcel-dierkes.KeepingYouAwake SUAutomaticallyUpdate -bool false
  '';

  home.activation.registerApplications =
    lib.hm.dag.entryBetween
      [ "setupLaunchAgents" ]
      [
        "copyApps"
        "configureRectangle"
        "configureKeepingYouAwake"
      ]
      ''
        for app in "$HOME/Applications/Home Manager Apps/"*.app; do
          [[ -d "$app" ]] || continue
          run /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$app"
          run /usr/bin/mdimport "$app"
        done
      '';
}
