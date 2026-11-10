{ lib, ... }:
{
  # Spotlight indexes real app bundles rather than links into /nix/store.
  targets.darwin.linkApps.enable = false;
  targets.darwin.copyApps.enable = true;

  home.activation.registerApplications =
    lib.hm.dag.entryBetween [ "setupLaunchAgents" ] [ "copyApps" ]
      ''
        for app in "$HOME/Applications/Home Manager Apps/"*.app; do
          [[ -d "$app" ]] || continue
          run /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$app"
          run /usr/bin/mdimport "$app"
        done
      '';
}
