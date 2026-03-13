{ config, lib, pkgs, ... }:
{
  imports =
    [ 
      ./hardware-configuration.nix
    ];
  
  # Kernel
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1"; 
  boot.loader.grub.configurationLimit = 5;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "quiet" "loglevel=3" ];

  # Network
  networking.hostName = "amalthea"; # Define your hostname.
  networking.wireless.iwd = {
    enable = true;
    settings = {
      Settings = {
        AutoConnect = true;
      };
    };
  };

  # Localization
  time.timeZone = "Asia/Ho_Chi_Minh";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
    ];
  };
  
  # Services
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };
  services.libinput.enable = true;
  services.openssh.enable = true;
  services.undervolt = {
    enable = true;
    coreOffset = -110;
    gpuOffset = -100;
    uncoreOffset = -110;
  };
  services.auto-cpufreq = {
    enable = true;
    settings = {
      charger = {
        governor = "performance";
        energy_performance_preference = "performance";
        turbo = "auto";
      };
      battery = {
        governor = "powersave";
        energy_performance_preference = "power";
        turbo = "never";
      };
    };
  };
  services.blueman.enable = true;
  services.fcitx5-lotus = {
    enable = true;
    user = "fhasl";
  };
  services.dbus.enable = true;
  services.fstrim.enable = true;
  services.fwupd = {
    enable = true;
    daemonSettings.DisabledPlugins = [ "test" "invalid" "bios" ];
  };
  services.journald.extraConfig = ''
    SystemMaxUse=500M
    RuntimeMaxUse=200M
  '';

  # User shits
  users.users.fhasl = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" "input" "rtkit" "networkmanager" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
    ];
  };
  
# Programs
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.zsh = {
    enable = true;
  };
  programs.dconf.enable = true;
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    jetbrains-mono
  ];
  environment.systemPackages = with pkgs; [
    neovim
    git
    thunar
    tumbler
    wget
    kitty
    matugen
    pavucontrol
    rofi
    swww
    cargo
    bibata-cursors
    nwg-look
    bat
    brightnessctl
    hyprshot
    unzip
    vesktop
    wineWow64Packages.stable
    spotify
    spicetify-cli
    wl-clipboard
    hyprpicker
    nodejs
    yt-dlp
    btop
    fastfetch
    zoxide
    eza
    pay-respects
    duf
    github-cli
    ripgrep
    pywal16
    obsidian
    waybar
    kdePackages.kdenlive
  ];

  # Miscs
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };
  hardware.graphics.extraPackages = with pkgs; [ 
    intel-vaapi-driver 
    intel-media-driver 
  ];
  security.rtkit.enable = true;
  security.polkit.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.services = {
    systemd-udev-settle.enable = false;
  };
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # NixOS shits
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    max-jobs = "auto";
    cores = 0;
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than-3d";
  };
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  system.stateVersion = "25.11"; 
  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;
}

