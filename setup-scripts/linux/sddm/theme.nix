let
  lock = builtins.fromJSON (builtins.readFile ../../../dot_config/home-manager/flake.lock);
  nixpkgs = builtins.fetchTree lock.nodes.nixpkgs.locked;
  pkgs = import nixpkgs.outPath { };
in
(pkgs.catppuccin-sddm.override {
  flavor = "mocha";
  accent = "teal";
  background = "/usr/share/wallpapers/cachyos-wallpapers/Skyscraper.png";
  loginBackground = true;
}).overrideAttrs (old: {
  # Basic controls otherwise use low-contrast placeholder text on this theme.
  postInstall = (old.postInstall or "") + ''
    substituteInPlace "$out/share/sddm/themes/catppuccin-mocha-teal/Components/"{UserField,PasswordField}.qml \
      --replace-fail '  placeholderText:' '  placeholderTextColor: "#A6ADC8"
      placeholderText:'
  '';
})
