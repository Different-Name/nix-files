{
  imports = [
    ../.
  ];

  nix-files = {
    profiles = {
      global.enable = true;
      graphical.enable = true;
    };
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
