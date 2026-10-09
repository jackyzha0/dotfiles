{ pkgs, ... }:

{
  # Nix itself is managed by the Determinate installer, so nix-darwin stays out of it.
  nix.enable = false;
  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true; # chrome, spotify

  networking.hostName = "jzhao-mbp";
  networking.localHostName = "jzhao-mbp";
  networking.computerName = "jzhao-mbp";

  system.primaryUser = "jzhao";
  users.users.jzhao = {
    name = "jzhao";
    home = "/Users/jzhao";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true; # keeps nix on PATH for login shells
  environment.shells = [ pkgs.zsh ];

  # GUI apps (symlinked into /Applications/Nix Apps so Spotlight finds them)
  environment.systemPackages = with pkgs; [
    google-chrome
    spotify
    ghostty-bin
    rectangle
    obsidian
    # discord: nixpkgs' darwin build modifies the bundle and breaks its signature
    # ("damaged and can't be opened"); install it from discord.com instead
  ];

  # weekly gc (Determinate Nix owns nix.conf, so nix.gc isn't available)
  launchd.daemons.nix-gc = {
    command = "/nix/var/nix/profiles/default/bin/nix-collect-garbage --delete-older-than 14d";
    serviceConfig = {
      StartCalendarInterval = [{ Weekday = 0; Hour = 3; Minute = 0; }];
      StandardOutPath = "/var/log/nix-gc.log";
      StandardErrorPath = "/var/log/nix-gc.log";
    };
  };

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  # touch id for sudo 
  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false; # key repeat instead of accent popup
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      AppleShowAllExtensions = true;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      "com.apple.swipescrolldirection" = true;
    };
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      show-recents = false;
      mru-spaces = false;
      persistent-apps = [
        # Finder is always first and can't be listed
        "/Applications/Nix Apps/Google Chrome.app"
        "/System/Applications/Mail.app"
        "/Applications/Claude.app" # installed manually, not via nix
        "/Applications/Amie.app" # installed manually, not via nix
        "/Applications/Nix Apps/Ghostty.app"
        "/Applications/Nix Apps/Spotify.app"
        "/Applications/Nix Apps/Obsidian.app"
        "/System/Applications/Messages.app"      ];
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXPreferredViewStyle = "Nlsv"; # list view
      _FXShowPosixPathInTitle = true;
    };
    trackpad = {
      Clicking = true; # tap to click
      TrackpadThreeFingerDrag = true;
    };
    screencapture.location = "~/Downloads";

    CustomUserPreferences."com.knollsoft.Rectangle".launchOnLogin = true;

    # Mail shortcuts are set by hand in System Settings > Keyboard > App Shortcuts, not here:
    # ctrl-e archive, ctrl-r reply, ctrl-a reply all, ctrl-f forward, ctrl-c new message.
    # (plain letters fight the message list's type-to-select; writing Mail's prefs from nix
    # needs Full Disk Access for the terminal and aborts rebuilds without it)

    # cmd+shift+4 copies the selection to the clipboard instead of saving a file.
    # 30 = save selection to file, 31 = copy selection to clipboard.
    # params: [ascii of "4", keycode of "4", modifiers (shift+cmd)]
    CustomUserPreferences."com.apple.symbolichotkeys".AppleSymbolicHotKeys = {
      "30".enabled = false;
      "31" = {
        enabled = true;
        value = {
          type = "standard";
          parameters = [ 52 21 1179648 ];
        };
      };
    };
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  system.stateVersion = 6;
}
