{ lib, pkgs, ... }:
lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
  home.packages = [ (pkgs.callPackage ./packages/nextdns-darwin.nix { }) ];
}
