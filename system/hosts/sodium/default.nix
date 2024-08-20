{
  inputs,
  self,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix

    ../../users/different.nix

    ../../common/global
    ../../common/desktop

    ../../common/extra/hardware/nvidia.nix

    ../../common/extra/programs/alvr.nix
    ../../common/extra/programs/goxlr-utility.nix

    (import ../../common/extra/services/autologin.nix "different")
    ../../common/extra/services/keyd.nix
    ../../common/extra/services/tailscale.nix

    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  networking = {
    hostName = "sodium";
    hostId = "9471422d";
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs self;};
    users."different" = import "${self}/home/users/different/hosts/sodium.nix";
  };

  # nh default flake
  programs.nh.flake = "/home/different/nix-files";

  environment.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "1.5";
    GDK_SCALE = "2";
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
