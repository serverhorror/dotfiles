#!/bin/bash

install_hyprland() {
    sudo dnf --assumeyes copr enable solopasha/hyprland
}

install_neovim() {
    # # Conflicts with libtree-sitter installed by emacs
    # sudo dnf --assumeyes copr enable agriffis/neovim-nightly
    sudo dnf --assumeyes install neovim
}

install_vscode() {
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null
}

if [ "${BASH_SOURCE[0]}" = "${0}" ]; then

    echo "yeah ... not working yet"
    exit 1

    install_hyprland
    install_neovim
    install_vscode

fi

echo "yeah ... not working yet"
exit 1
