return {
    main_mod = "SUPER",
    file_manager = "",
    app_launcher = "wofi --show drun",
    terminal = [["$HOME/.nix-profile/bin/nixGL" "$HOME/.nix-profile/bin/kitty"]],
    idle_handler = "swayidle -w timeout 300 'swaylock -f -c 000000' before-sleep 'swaylock -f -c 000000'",
    browser = [["$HOME/.nix-profile/bin/vivaldi"]],
    shot_region = "grimblast copy area",
    shot_window = "grimblast copy active",
    shot_screen = "grimblast copy output",
}
