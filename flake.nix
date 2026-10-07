{
  description = "jzhao's macs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nix-darwin, home-manager, ... }: {
    # per-project dev shell: `nix flake init -t ~/dotfiles && direnv allow`
    templates.default = {
      path = ./templates/dev;
      description = "direnv + flake dev shell";
    };

    # rebuild with: darwin-rebuild switch --flake ~/dotfiles   (alias: `rebuild`)
    darwinConfigurations."jzhao-mbp" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./darwin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.jzhao = import ./home.nix;
        }
      ];
    };
  };
}
