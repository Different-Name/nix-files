{
  hardware.bluetooth = {
    enable = true;
    # power the default bluetooth controller on boot
    powerOnBoot = true;
  };

  services.blueman.enable = true;
}
