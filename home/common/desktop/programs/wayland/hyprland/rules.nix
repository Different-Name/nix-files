{lib, ...}: {
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = let
      gameClasses = [
        "hl2_linux"
        "Paradox Launcher"
        ''AcrossTheObelisk\.x86_64''
        ''TerraTechLinux64\.x86_64''
        ''diablo iv\.exe''
      ];
      gameClassesStr = lib.concatStringsSep "|" gameClasses;
      gameRule = rule: (rule + ", class:^(steam_app_[0-9]+|${gameClassesStr})$, title:.+");
    in [
      # global
      "suppressevent maximize, class:.*"

      # qalculate
      "float, class:^(qalculate-gtk)$"
      "size 850 575, class:^(qalculate-gtk)$"

      # brave PiP
      "float, title:^(Picture-in-picture)$"
      "pin, title:^(Picture-in-picture)$"
      "size 480 270, title:^(Picture-in-picture)$"
      "keepaspectratio, title:^(Picture-in-picture)$"

      # gtk popups
      "float, class:^(xdg-desktop-portal-gtk)$"

      # pavucontrol
      ''float, class:^(org\.pulseaudio\.pavucontrol)$''
      ''size 1000 750, class:^(org\.pulseaudio\.pavucontrol)$''

      # thunar file operations
      "float, title:^(File Operation Progress)$"
      "float, class:^(file-roller)$"

      # hyprland share picker
      "float, title:^(MainPicker)$"

      # games
      (gameRule "suppressevent fullscreen")
      (gameRule "fullscreen")
      (gameRule "workspace 2")
      # fix for various mouse issues
      # possibly related to https://github.com/hyprwm/Hyprland/issues/6543
      "stayfocused, class:^(steam_app_[0-9]+)$, title:.+"

      # wine system tray
      "unset, title:Wine System Tray"
      "workspace special:hidden silent, title:Wine System Tray"
      "noinitialfocus, title:Wine System Tray"
    ];
  };
}
