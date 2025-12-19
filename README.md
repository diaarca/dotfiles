# Personnal Chezmoi configuration
In order to setup this configuration on a brand new machine (both Linux and apple silicon macOS and handled):
1. Install the `nix` package manager via multi-user installation (recommended):
```bash
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
```
or via the single-user installation:
```bash
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
```
2. Install (temporarily) `chezmoi` and `home-manager` in order to fetch and deploy the configuration of this repository
```bash
nix-shell -p chezmoi home-manager
```
3. Fetch and apply the configuration from this github repository:
```bash
chezmoi init https://github.com/diaarca/dotfiles.git
```
4. Setup the whole environment using `home-manager`:
```bash
home-manager switch
```
5. You can easily exit the nix-shell environment:
```bash
exit
```
