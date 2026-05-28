{ pkgs, ... }:

let
  isLinux = pkgs.stdenv.isLinux;
in
{
  home.shellAliases = {
    ll = "ls -l";
    la = "ls -a";
    icat = "kitten icat";
    kitty = if isLinux then "nixGL kitty" else "kitty";
    nv = "nvim";
    gst = "git status";
    gcm = "git commit";
    gps = "git push";
    gdf = "git diff";
    gsw = "git switch";
    gad = "git add";
    gpl = "git pull";
    gft = "git fetch";
  };
}
