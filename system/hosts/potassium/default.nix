{
  inputs,
  config,
  self,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix
    ../../global

    ../../extra/hardware/backlight.nix
    ../../extra/hardware/bluetooth.nix
    ../../extra/hardware/nvidia.nix

    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-nvidia
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  networking = {
    hostName = "potassium";
    hostId = "ea3a24c5";
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs self;};
    users.${config.nix-files.user} = import ../../../home/hosts/potassium.nix;
  };

  hardware.nvidia.prime = {
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
