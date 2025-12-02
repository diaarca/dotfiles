# Personnal Chezmoi configuration
In order to setup this configuration on a brand new machine:
1. Install the `nix` package manager via multi-user installation (recommended):
```bash
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
```
or via the single-user installation:
```bash
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
```
2. Install (temporarily) `chezmoi` in order to fetch the configuration of this repository
```bash
nix-shell -p chezmoi
```
3. Fetch and apply the configuration from this github repository:
```bash
chezmoi init https://github.com/diaarca/dotfiles.git
```
4. Exiting the temporary `nix-shell` since we do not anymore need chezmoi:
```bash
exit
```
5. Install `home-manager` which will become our environment manager:
```bash
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```
6. Setup the whole environment using `home-manager`:
```bash
home-manager switch
```
