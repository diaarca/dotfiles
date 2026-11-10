{
  description = "Home Manager and macOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      user = builtins.fromJSON (builtins.readFile ./user.json);

      homeManagerSupport =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        let
          upstream = import "${home-manager}/modules/home-environment.nix" {
            inherit config lib pkgs;
          };
        in
        {
          # CLI helpers such as news must use the locked source, without a channel.
          programs.home-manager.path = toString home-manager;

          # Keep upstream's installation logic while replacing its deprecated Nix alias.
          home.activation.installPackages = lib.mkForce (
            upstream.config.home.activation.installPackages
            // {
              data =
                builtins.replaceStrings [ "profile install" ] [ "profile add" ]
                  upstream.config.home.activation.installPackages.data;
            }
          );
        };
    in
    {
      packages.aarch64-darwin.darwin-rebuild = nix-darwin.packages.aarch64-darwin.darwin-rebuild;
      packages.aarch64-darwin.home-manager =
        (import nixpkgs { system = "aarch64-darwin"; }).callPackage "${home-manager}/home-manager"
          {
            path = toString home-manager;
          };

      homeConfigurations.${user.username} = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit user; };
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
        modules = [
          ./macos-home.nix
          homeManagerSupport
          {
            home.packages = [ nix-darwin.packages.aarch64-darwin.darwin-rebuild ];
          }
        ];
      };

      darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit user; };
        modules = [
          home-manager.darwinModules.home-manager
          ./darwin.nix
          { home-manager.sharedModules = [ homeManagerSupport ]; }
        ];
      };
    };
}
