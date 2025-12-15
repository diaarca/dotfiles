{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      # Source personal fish config if it exists
      if test -f ~/.fishrc
        source ~/.fishrc
      end

      set fish_greeting # Disable greeting
      if command -q nix-your-shell
        nix-your-shell fish | source
      end
      set -gx pure_enable_single_line_prompt true
      set -gx pure_enable_nixdevshell true
      set -gx pure_enable_virtualenv true
      set fish_color_command blue
    '';

    plugins = [
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "pure";
        src = pkgs.fishPlugins.pure.src;
      }
    ];

    shellAbbrs = {
      dotdot = {
        regex = ''^\.\.+$'';
        function = ''multicd'';
      };
    };
  };
}
