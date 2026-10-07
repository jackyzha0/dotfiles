# dotfiles (nix-darwin + home-manager)

Fresh Mac bootstrap:

```sh
# 1. Xcode CLT (git)
xcode-select --install

# 2. Nix (Determinate installer: flakes on by default, survives macOS updates)
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
# open a NEW terminal

# 3. first apply
cd ~/dotfiles && git init && git add -A
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .

# afterwards
rebuild
```
