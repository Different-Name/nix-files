# nix-files

My NixOS configuration files

> [!WARNING]
> This configuration is a work in progress - see [issues](https://github.com/Different-Name/nix-files/issues), and is intended for personal use only

### About

- Flake
- Multi host
- Single user
- Ephemeral root and home (state is opt in, managed by [impermanence](https://github.com/nix-community/impermanence))
- Declarative home with [home-manager](https://github.com/nix-community/home-manager)
- Hyprland

## Contents

| Folder             | Description                |
| ------------------ | -------------------------- |
| [`system`](system) | System level configuration |
| [`home`](home)     | Home level configuration   |
| [`pkgs`](pkgs)     | Package definitions        |

### Acknowledgements

- [Graham Christensen - Erase your darlings](https://grahamc.com/blog/erase-your-darlings/)
- [Misterio77/nix-starter-configs](https://github.com/Misterio77/nix-starter-configs)
- [fufexan/dotfiles](https://github.com/fufexan/dotfiles)