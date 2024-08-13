{
  pkgs,
  config,
  lib,
  ...
}: {
  age.secrets.user-password.file = ../../../secrets/user/password.age;

  nix-files.user = "different";

  users.users.${config.nix-files.user} = {
    isNormalUser = true;
    hashedPasswordFile = config.age.secrets.user-password.path;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIoe3VveHt2vXoHdkRbLE0Xx5il0T3v8PiWxFvdniSLg different@sodium"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAmh/7dgdq32eSKcp6kwN28UF+PuyKJmvFRZKKUnyvf0 different@potassium"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILnaWNZ2Q4sAkqK1KFbNfNb84l7uWVwCE7HnIHJzD8r1" # phone
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
    overrideStrategy = "asDropin"; # https://discourse.nixos.org/t/autologin-for-single-tty/49427
    serviceConfig.ExecStart = [
      "" # override upstream default with an empty ExecStart
      (gettyCmd "--noclear --keep-baud %I 115200,38400,9600 $TERM")
    ];
  };
}
