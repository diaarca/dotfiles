{ pkgs, lib, ... }:

let
  # fetch the delta themes files from github
  deltaThemes = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/dandavison/delta/main/themes.gitconfig";
    hash = "sha256-kPGzO4bzUXUAeG82UjRk621uL1faNOZfN4wNTc1oeN4=";
  };
in
{
  # delta is now its own top-level program
  programs.delta = {
    enable = true;

    enableGitIntegration = true;
    options = {
      navigate = true;
      light = false;
      side-by-side = true;
      line-numbers = true;
      features = "coracias-caudatus";
    };
  };

  # git configuration
  programs.git = {
    enable = true;
    lfs.enable = true;

    includes = [
      { path = "${deltaThemes}"; }
    ];

    ignores = [
      ".envrc"
      ".direnv/"
      ".DS_Store"
      ".antigravitycli/"
    ];

    settings = {
      user = {
        name = "Dylan Grousson";
        email = "59664001+diaarca@users.noreply.github.com";
      };

      init = {
        defaultBranch = "main";
      };

      push = {
        autoSetupRemote = true;
      };

      merge = {
        conflictstyle = "diff3";
      };

      url = {
        "ssh://git@github.com/" = {
          insteadOf = "https://github.com/";
        };
      };
    };
  };
}
