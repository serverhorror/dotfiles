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
