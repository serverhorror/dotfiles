# dotfiles

## Bootstrap Nix

```text
sh <(curl -L https://nixos.org/nix/install) --no-daemon --no-channel-add
exec bash
nix --extra-experimental-features 'nix-command flakes' shell nixpkgs#git nixpkgs#git-credential-oauth nixpkgs#home-manager
#source $HOME/.nix-profile/etc/profile.d/hm-session-vars.sh
home-manager --version
git -c credential.helper='oauth --device' clone 'https://github.com/serverhorror/dotfiles.git' src/dotfiles
cd src/dotfiles/
mkdir --parent ~/.config/nix
echo "experimental-features = nix-command flakes" >~/.config/nix/nix.conf
home-manager -v switch -b "'$(date +%F)'" --flake ~/src/dotfiles # that will take a while!
rm -rf ~/.config/nix
cd ~/src/dotfiles
stow --adopt . --simulate
git reset --hard '@{u}'
stow .
```

```text
sh <(curl -L https://raw.githubusercontent.com/serverhorror/dotfiles/master/install)
```

### Update the flake

```text
nix flake update --flake .
home-manager switch -b '' --flake .
```

## Linux

```bash
stow --verbose . --simulate
# stow --verbose .             # alternative
# stow .                       # alternative
```

## Windows

> [!WARNING]
> This is a work in progress!
> Use at your own risk!

* required environment variables

  generally:

  ```pwsh
  [Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", "$env:USERPROFILE\.config", [System.EnvironmentVariableTarget]::User)
  [Environment]::SetEnvironmentVariable("KOMOREBI_CONFIG_HOME", "$env:XDG_CONFIG_HOME\komorebi", [System.EnvironmentVariableTarget]::User)
  ```

  for `git`:

  ```pwsh
  [Environment]::SetEnvironmentVariable("GCM_CREDENTIAL_STORE", "wincredman", [System.EnvironmentVariableTarget]::User)
  ```

* symlinks for `git`, `nvim`, ...

  ```pwsh
  # this is so git actually works
  [Environment]::SetEnvironmentVariable("GCM_CREDENTIAL_STORE", "wincredman", [System.EnvironmentVariableTarget]::User)
  New-Item -ItemType SymbolicLink -Target "$env:USERPROFILE/src/dotfiles/scripts" -Path "$env:USERPROFILE/Scripts"
  New-Item -ItemType SymbolicLink -Target "$env:USERPROFILE\src\dotfiles\dot-config\git" -Path "$env:XDG_CONFIG_HOME/git"
  New-Item -ItemType SymbolicLink -Target "$env:USERPROFILE\src\dotfiles\dot-config\nvim" -Path "$env:XDG_CONFIG_HOME/nvim"
  New-Item -ItemType SymbolicLink -Target "$env:USERPROFILE\src\dotfiles\dot-config\komorebi" -Path "$env:XDG_CONFIG_HOME/komorebi"
  New-Item -ItemType SymbolicLink -Target "$env:USERPROFILE\src\dotfiles\dot-config\whkdrc" -Path "$env:XDG_CONFIG_HOME/whkdrc"
  ```

## LazyVIM

> [!NOTE]
> LazVim is already in the `dot-config` directory.

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

* to bootstrap Nix See above!
* to update the flake See above!

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
