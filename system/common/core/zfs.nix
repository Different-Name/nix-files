{
  lib,
  config,
  pkgs,
  ...
}: {
  options.nix-files.core.zfs.enable = lib.mkEnableOption "ZFS config";

  config = lib.mkIf config.nix-files.core.zfs.enable {
    services.zfs = {
      trim.enable = true;
      autoScrub.enable = true;
    };

    boot = {
      zfs = {
        package = pkgs.zfs_unstable;
        devNodes = "/dev/"; # compatability for disks with no serial numbers
        forceImportAll = true; # force import zpools at boot
      };

      # rollback the root and home datasets to empty! impermanence :o
      initrd.systemd.services.rollback = {
        description = "Rollback root and home datasets";
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        unitConfig.DefaultDependencies = "no";
        wantedBy = ["initrd.target"];
        after = ["zfs-import.target"]; # run after zfs import complete
        before = ["sysroot.mount"]; # run before the datasets are mounted
        path = [config.boot.zfs.package];
        script = ''
          zfs rollback -r rpool/root@empty
          zfs rollback -r rpool/home@empty
        '';
      };
    };

    environment.persistence."/persist/system" = lib.mkIf config.nix-files.core.persistence.enable {
      directories = [
        "/etc/zfs/keys"
      ];
    };
  };
}
