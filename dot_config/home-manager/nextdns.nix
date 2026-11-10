{
  config,
  lib,
  pkgs,
  ...
}:
lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
  home.packages = [ (pkgs.callPackage ./packages/nextdns-darwin.nix { }) ];

  launchd.agents.nextdns = {
    enable = true;
    config = {
      ProgramArguments = [
        "/usr/bin/open"
        "-g"
        "-a"
        "${config.home.homeDirectory}/Applications/Home Manager Apps/NextDNS.app"
      ];
      RunAtLoad = true;
      LimitLoadToSessionType = "Aqua";
    };
  };
}
