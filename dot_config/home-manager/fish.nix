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
      fish_greeting = ''
        set -l art \
          '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⢯⡿⣱⣿⣿⣿⣿⣱⣿⣿⣿⣾⣾⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆' \
          '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⢞⢡⣿⣿⣿⣿⠇⢻⣿⣿⣿⣿⡿⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀' \
          '⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⣺⣿⣿⣿⣿⣿⡿⠿⢿⣿⢇⣴⡏⣾⣿⣿⣿⣿⡀⣦⠻⣛⣯⣵⡆⣿⡟⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⣿⣷' \
          '⠀⠀⠀⠠⠤⠤⠤⠶⣊⣥⣾⣿⣿⣿⣿⠟⠉⣊⡻⣷⣡⣾⣿⢻⣿⣿⣿⣿⠇⣶⣾⣿⣿⣿⡿⣼⣿⢱⣿⣿⣿⣿⣿⣿⣿⡎⣿⣿⣿⣿⣇' \
          '⠀⠀⠀⢀⣀⣤⣵⣾⣿⣿⣿⣿⣿⣿⣣⣷⣿⠟⡓⢹⡏⡿⡋⣼⣿⣿⣿⣿⣸⣿⣿⣿⣿⡿⣰⣿⢃⣿⣿⣿⣿⣿⣿⣿⣿⣿⣸⣿⣿⣿⣿' \
          '⠀⠀⠀⠀⢀⣨⣵⣿⣿⢿⣿⣿⣿⣇⣿⣿⢡⣿⡋⢸⣧⣾⢧⣿⣿⣿⣿⡇⣿⣿⣿⣿⣿⢣⣿⢃⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⣿⣿⣿⣿' \
          '⠀⠀⠀ ⠘⠛⣫⣭⣶⣿⣿⣿⣿⣿⡜⣿⣌⢯⢸⣿⣿⡟⡌⣾⣿⣿⣿⢹⣿⣿⢿⣿⡏⣨⡟⡀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⢹⣿⣿⡝⡇' \
          '⠀⠀⠀⠀⠀⠙⣻⡽⣾⣿⣿⡿⠟⢩⡾⢸⣿⣎⣡⣿⣿⠓⣠⣿⣿⣿⡏⠞⣛⡻⠦⣉⠃⣿⠃⡇⣿⣿⣿⣿⢹⣿⣿⣿⣿⣿⣿⢸⣿⣿⣿⢹' \
          '⢀⣀⣤⣤⣤⣬⣀⣾⡿⢟⡫⢒⡵⢫⢊⣄⡛⢿⣿⣿⡏⢰⡏⣿⣿⣿⢷⣤⡀⠙⠻⣮⡁⣿⠃⠀⣿⣿⣿⣿⢸⢹⣿⣿⣿⣿⣿⡿⣿⣿⣿⡇⣇' \
          '⢸⣿⣿⣿⣿⣿⡏⢁⣠⢁⠔⢫⣾⢠⡟⠃⠛⡇⣿⣿⡇⣼⡇⣿⣿⡟⣸⣿⣷⣄⡀⠈⣡⠈⢠⠡⣙⢿⣿⢸⠈⠸⡟⣿⣿⣿⢻⡇⣿⣿⣿⣷⠘' \
          '⢸⣿⣿⣿⣿⣿⣟⣋⣠⣴⡌⠌⠋⣈⣶⣘⣤⠀⢿⣿⠇⣿⣧⣿⣿⣧⣿⣿⣿⣿⣿⣷⣿⣷⣾⣿⠖⠠⢬⣄⠈⢀⠃⢿⣿⣿⢸⠁⣿⣿⣿⠸⠀⡁ ' \
          '⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⡄⣿⣿⣿⣿⡾⡸⣿⡸⡿⣸⣿⡟⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⣠⡈⠍⠉⠡⣋⣴⣶⡎⠛⠀⠐⠛⠉⠁' \
          '⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠙⢌⢿⣿⣿⢇⣧⢹⡇⢧⣿⣿⢳⠋⠀⠛⢿⣿⣿⣿⣿⣿⣿⡀⣿⣿⣾⢣⣴⣿⣿⠟⠃' \
          '⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠸⡄⠳⠝⢡⣾⣿⣧⠃⢾⣿⢧⡇⢀⣀⠀⠐⠬⡻⣿⣗⡛⠛⣣⣿⡿⢡⢟⣫⣵⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢣⣾⣿⣶⣔⠄' \
          '⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠇⠖⠀⠀⣿⣿⠏⢄⣾⢣⣾⡇⡘⣿⣿⠇⣤⠀⣈⣿⣿⣿⡿⢟⡄⢠⣾⠟⠋⢉⣤⣍⡛⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣡⣿⣿⣿⣿⣿⣸' \
          '⠀⠈⠉⠻⢿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⣀⠀⡾⠋⢀⡾⠣⠘⣿⣇⢈⡲⣅⣠⣶⣿⡿⢿⣛⣭⡶⠉⠴⠟⢁⡄⢰⣿⠟⣫⠶⠓⠹⢠⣿⣿⣿⣿⣿⣿⢡⣿⣿⣿⣿⣿⣿⡿' \
          '⠀⠀⠀⠀⠀⠈⠛⢿⣿⣿⣿⣿⣿⡆⠀⣿⣧⡽⠣⠊⠈⢰⠟⠪⡻⣷⣾⠿⡛⠉⠁⠈⠻⣿⣿⠃⢲⠀⢸⠟⣠⣿⢏⡾⣡⡎⠀⠀⣸⣿⣿⣿⣿⣿⢣⣿⣿⣿⠿⣿⣿⣿⣧' \
          '⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠿⣿⣿⣿⠀⣿⣏⣨⠔⠀⠀⢰⣾⣧⣹⣷⣶⣿⣿⣆⠀⠀⠀⠈⠃⠀⢸⠀⢸⠀⣿⣇⡞⡀⢹⡇⢀⣴⣿⣿⣿⣿⣿⠏⠛⢉⣤⣴⣾⣿⣿⣿⡇' \
          '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⠇⢿⣿⠿⠀⠀⠀⢸⣿⡿⢣⣿⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠈⢸⠟⢈⣄⢇⣴⣾⣿⠿⠟⠛⠛⠛⢡⡔⢴⣿⣿⣿⣿⣿⣿⣿⠃'

        # Keep the portrait from wrapping in narrow terminal panes.
        for line in $art
          if test (string length --visible -- "$line") -gt "$COLUMNS"
            return
          end
        end

        printf '\n'
        # Hair pink/cyan, skin, blue shadows, purple shadows, coral, sleeve, jacket.
        set -l colors ffedff b9fbfc efffd5 739fe9 725667 ff967f d5fcff 3e164d
        # Each digit selects a color for the corresponding Braille cell above.
        set -l color_map \
          '555555555855551111111111111111111111111111111111' \
          '55555555555511111111111111111171111111111111111111' \
          '55555555557111111111117111111131113311111111111111' \
          '555222222277111133333111111113333333111111111111111' \
          '555244227777777333333111111113333331111111111111111' \
          '5554227722277233355333327777333333113111111111111111' \
          '55554222277777233533337277773333377371111111111111117' \
          '4544422277222222333333772777333332222277277777777772' \
          '44233372224422443333373777233633322427722272777222772' \
          '33333332222444555533333777733363332322224422772242722' \
          '3333333373355333333333322233333333333353242227222272284' \
          '333333333333533333333372273333333333336634444425222' \
          '333333333333553333533322235333333333333344444' \
          '333333333333355635553222356657333333333442333333333333333377772' \
          '333333333333354885552223336668533333344733335333333333333777777' \
          '883333333333338885522233366333333244443244555555333333337777777' \
          '888888333333338555225555333333884444844445555558833333377722777' \
          '888888885333333552588855555555888845848435542553333333322227777' \
          '888888888888333555888855555555588888888455433333333333277777777'
        set -l row 1
        for line in $art
          set -l column 1
          for run in (string match --regex --all '1+|2+|3+|4+|5+|6+|7+|8+' -- "$color_map[$row]")
            set -l color (string sub --length 1 -- "$run")
            set -l length (string length -- "$run")
            set_color $colors[$color]
            printf '%s' (string sub --start $column --length $length -- "$line")
            set column (math $column + $length)
          end
          printf '\n'
          set row (math $row + 1)
        end
        set_color normal
        printf '\n'
      '';

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
