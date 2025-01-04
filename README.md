# dotfiles

## Linux

```bash
stow .
# stow --verbose .  # alternative
```

## Windows

* required environment variables

  ```pwsh
  ```

  ```pwsh
  [Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", "$env:USERPROFILE\.config", [System.EnvironmentVariableTarget]::User)
  [Environment]::SetEnvironmentVariable("KOMOREBI_CONFIG_HOME", "$env:XDG_CONFIG_HOME\komorebi", [System.EnvironmentVariableTarget]::User)
  ```

* symlinks for git and nvim (PowerShell)

  ```pwsh
  # this is so git actually works
  [Environment]::SetEnvironmentVariable("GCM_CREDENTIAL_STORE", "wincredman", [System.EnvironmentVariableTarget]::User)
  New-Item -ItemType SymbolicLink -Target "$env:USERPROFILE\src\dotfiles\dot-config\git" -Path "$env:XDG_CONFIG_HOME/git"
  New-Item -ItemType SymbolicLink -Target "$env:USERPROFILE\src\dotfiles\dot-config\nvim" -Path "$env:XDG_CONFIG_HOME/nvim"
  ```

## LazyVIM

* initial install

  ```sh
  git subtree --prefix dot-config/lazyvim add https://github.com/LazyVim/starter main
  ```

* updating

  ```sh
  git subtree --prefix dot-config/lazyvim pull https://github.com/LazyVim/starter main
  ```

## nix

* <https://nixos.org/manual/nixpkgs/unstable/>

### Configuration

Enable the `nix` command and `flakes` (e.g. `nix flake show`)

* `~/.config/nix/nix.conf`
* `/etc/nix/nix.conf`

    ```bash
    echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
    ```

> #### If on WSL
>
> put the following in `/etc/wsl.conf`
>
> ```text
> [boot]
> systemd = true
>
> # ...(more lines here)...
> ```

### Bootstrap Nix

```text
sudo dnf install --assumeyes --quiet git
sh <(curl -L https://nixos.org/nix/install) --daemon
mkdir --parent ~/.config/nix
echo "experimental-features = nix-command flakes" > ~/.config/nix/nix.conf
exec bash
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
home-manager --version
home-manager switch -b "bak$((RANDOM))" --flake .
```

#### Update the flake

```text
nix flake update --flake .
home-manager switch -b '' --flake .
```

### Other Info

* Create a new flake

    ```bash
    nix --extra-experimental-features 'nix-command flakes' flake init
    ```
* "Develop"
  Enters a new shell based on `devShells.x86_64-linux.default`

    ```bash
    nix  --extra-experimental-features 'nix-command flakes' develop
    ```


* Do it!
  This requires a program/package to be runable

    ```bash
    nix  --extra-experimental-features 'nix-command flakes' run
    ```

#### Random commands

```bash
nix --extra-experimental-features 'nix-command flakes' flake check
nix --extra-experimental-features 'nix-command flakes' flake
nix --extra-experimental-features 'nix-command flakes' flake info
nix --extra-experimental-features 'nix-command flakes' develop
nix --extra-experimental-features 'nix-command flakes' run
nix --extra-experimental-features 'nix-command flakes' build
nix --extra-experimental-features 'nix-command flakes' shell
```
