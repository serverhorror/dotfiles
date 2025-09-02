{ config, pkgs, buildInputs, ... }@inputs:
let
  f = "a";
  lib = config.lib;

in {
  # Home Manager needs a bit of information
  # about you and the paths it should manage.
  home.username = "${inputs.systemUserName}";
  home.homeDirectory = "/home/${inputs.systemUserName}";

  xdg = { enable = true; };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = buildInputs;
  # home.packages = [
  #     # # Adds the 'hello' command to your environment. It prints a friendly
  #     # # "Hello, world!" when run.
  #     # pkgs.hello
  #
  #     # # It is sometimes useful to fine-tune packages, for example, by applying
  #     # # overrides. You can do that directly here, just don't forget the
  #     # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
  #     # # fonts?
  #     # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
  #
  #     # # You can also create simple shell scripts directly inside your
  #     # # configuration. For example, this adds a command 'my-hello' to your
  #     # # environment:
  #     # (pkgs.writeShellScriptBin "my-hello" ''
  #     #   echo "Hello, ${config.home.username}!"
  #     # '')
  #   ];

  # # how?
  # home.activation = {
  #   init = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
  #     mkdir -p ~/bin
  #   '';
  # };


  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/${inputs.systemUserName}/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    # GOBIN  = "~/bin";

    # if we have the command 'code' then code otherwise vim
    EDITOR = "command -v code >/dev/null 2>&1 && code --wait - || vim";
    VISUAL = "command -v code >/dev/null 2>&1 && code --wait - || vim";
    PATH = "$HOME/bin:$PATH";
    LC_ALL = "C.utf8";
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
      # dotDir = "/home/${inputs.systemUserName}/.config/zsh";
      enableCompletion = true;
      history = {
        ignoreDups = true;
        ignoreAllDups = true;
        ignoreSpace = true;
        ignorePatterns = [ "cd *" "exit" "ll" "ls *" "ls" "history" ];
      };
      historySubstringSearch = {
        enable = false;
      };
      initContent = ''
        eval "$(oh-my-posh init zsh)"
        if [ -r "$HOME/.config/zsh/zsh.local" ]; then source "$HOME/.config/zsh/zsh.local"; fi
      '';
    };

    bash = {
      enable = true;
      historyControl = [ "erasedups" "ignoredups" "ignorespace" "ignoreboth" ];
      historyIgnore = [ "cd .." "cd" "exit" "ll" "ls -l" "ls" "history" ];
      ## near the start
      profileExtra = ''
        # profileExtra
        if [ -d "$HOME/.nix-profile/bin" ]; then
          export PATH="$HOME/.nix-profile/bin:$PATH"
        fi
      '';
      initExtra = ''
        if [ -e /home/${inputs.systemUserName}/.nix-profile/etc/profile.d/nix.sh ]; then . /home/${inputs.systemUserName}/.nix-profile/etc/profile.d/nix.sh; fi                                  # added by Nix installer
        if [ -r /etc/profiles/per-user/${inputs.systemUserName}/etc/profile.d/hm-session-vars.sh ]; then . /etc/profiles/per-user/${inputs.systemUserName}/etc/profile.d/hm-session-vars.sh; fi  # added by Nix installer
        if [ -r ~/.nix-profile/etc/profile.d/hm-session-vars.sh ]; then echo "sourcing session vars"; . ~/.nix-profile/etc/profile.d/hm-session-vars.sh; fi                                                                    # added by Nix installer
      '';

      ## near the end
      bashrcExtra = ''
        if [ -r "$HOME/.bashrc.local" ]; then source "$HOME/.bashrc.local"; fi
      '';
    };
  };
}
