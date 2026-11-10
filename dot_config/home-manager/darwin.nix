{ user, ... }:

{
  imports = [ ./macos-defaults.nix ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  system.primaryUser = user.username;
  system.stateVersion = 7;
  users.users.${user.username}.home = user.homeDirectory;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # Accept the reviewed bootstrap nix.conf; activation backs up the original.
  environment.etc."nix/nix.conf".knownSha256Hashes = [
    "549c6deb3684806cc4975a57d7a09330fe50e74ac710de8711f83ab799422360"
  ];
  programs.fish.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit user; };
    useGlobalPkgs = true;
    # Preserve ~/.nix-profile paths used by the existing Kitty and Fish setup.
    useUserPackages = false;
    users.${user.username} = {
      imports = [ ./macos-home.nix ];
      # The system configuration owns Nix settings on macOS.
      nix.enable = false;
    };
  };
}
