{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    interactiveShellInit = ''
      # source personal fish config if it exists
      if test -f ~/.fishrc
        source ~/.fishrc
      end

      # dynamically create aliases for git project directories
      set git_dir "$HOME/git"
      if test -d "$git_dir"
        for dir in "$git_dir"/*
          if test -d "$dir"
            set -l alias_name (basename "$dir")
            alias "$alias_name" "cd $dir"
          end
        end
      end

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

    functions = {
      multicd = "echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)";
    };

    shellAbbrs = {
      dotdot = {
        regex = ''^\.\.+$'';
        function = ''multicd'';
      };
    };
  };
}
