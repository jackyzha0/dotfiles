{
  description = "dev shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { nixpkgs, ... }:
    let
      systems = [ "aarch64-darwin" "x86_64-darwin" "aarch64-linux" "x86_64-linux" ];
      forAll = f: nixpkgs.lib.genAttrs systems (s: f nixpkgs.legacyPackages.${s});
    in {
      devShells = forAll (pkgs: {
        default = pkgs.mkShell {
          # keep what the project needs, delete the rest
          packages = with pkgs; [
            nodejs_24
            pnpm
            # python: use `uv` (global) with a pinned .python-version instead
            # rustc cargo rust-analyzer clippy rustfmt   # or use rustup + rust-toolchain.toml
            # go
          ];
        };
      });
    };
}
