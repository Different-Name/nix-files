{
  pkgs,
  config,
  lib,
  ...
}: {
  nix-files.user = "different";

  users.users.${config.nix-files.user} = {
    password = "nixos"; # TODO agenix
    isNormalUser = true;

    openssh.authorizedKeys.keys = [
      # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
    ];

    extraGroups = [
      "wheel"
      "audio"
      "video"
      "input"
      "networkmanager"
      "libvirtd"
    ];
  };

  # Autologin for tty1 only
  # https://github.com/NixOS/nixpkgs/blob/53e81e790209e41f0c1efa9ff26ff2fd7ab35e27/nixos/modules/services/ttys/getty.nix#L107-L113
  systemd.services."getty@tty1" = let
    cfg = config.services.getty;

    baseArgs =
      [
        "--login-program"
        "${cfg.loginProgram}"
        "--autologin"
        config.nix-files.user
      ]
      ++ lib.optionals (cfg.loginOptions != null) [
        "--login-options"
        cfg.loginOptions
      ]
      ++ cfg.extraArgs;

    gettyCmd = args: "@${pkgs.util-linux}/sbin/agetty agetty ${lib.escapeShellArgs baseArgs} ${args}";
  in {
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = [
      "" # override upstream default with an empty ExecStart
      (gettyCmd "--noclear --keep-baud %I 115200,38400,9600 $TERM")
    ];
  };
  # systemd.services."getty@tty1" = {
  #   serviceConfig.ExecStart = ["" "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram} --autologin different --noclear --keep-baud %I 115200,38400,9600 $TERM"];
  # };
}
