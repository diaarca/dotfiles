{ pkgs, lib, ... }: # Make sure lib is available

lib.mkIf pkgs.stdenv.isLinux {
  # All the Vivaldi-related configuration goes inside here
  programs.vivaldi = {
    enable = true;
    # Any other Vivaldi settings
  };

  # Set default browser via xdg
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = [ "vivaldi-stable.desktop" ];
      "x-scheme-handler/http" = [ "vivaldi-stable.desktop" ];
      "x-scheme-handler/https" = [ "vivaldi-stable.desktop" ];
      "x-scheme-handler/ftp" = [ "vivaldi-stable.desktop" ];
      "application/xhtml+xml" = [ "vivaldi-stable.desktop" ];
    };
  };
}
