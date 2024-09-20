{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix

    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  ### required config

  networking = {
    hostName = "potassium";
    hostId = "ea3a24c5";
  };

  environment.etc.machine-id.source = ./machine-id;

  programs.nh.flake = "/home/different/nix-files";

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";

  ### modules

  nix-files = {
    users.different.enable = true;

    profiles = {
      global.enable = true;
      graphical.enable = true;
      laptop.enable = true;
    };

    hardware.nvidia.enable = true;

    services.autologin = {
      enable = true;
      user = "different";
    };
  };

  ### host specific

  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };
}
