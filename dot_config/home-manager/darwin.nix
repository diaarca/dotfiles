{ ... }:

{
  imports = [ ./macos-defaults.nix ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  system.primaryUser = "dylan";
  system.stateVersion = 7;
  users.users.dylan.home = "/Users/dylan";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  programs.fish.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    # Preserve ~/.nix-profile paths used by the existing Kitty and Fish setup.
    useUserPackages = false;
    users.dylan = {
      imports = [ ./macos-home.nix ];
      # The system configuration owns Nix settings on macOS.
      nix.enable = false;
    };
  };
}
