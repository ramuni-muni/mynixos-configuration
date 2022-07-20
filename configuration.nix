# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # kernel
  #boot.kernelPackages = pkgs.linuxPackages_5_18;
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sdc"; # or "nodev" for efi only
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.extraEntries = ''
  	# GRUB 1 example (not GRUB 2 compatible)
  	title Windows
  	  chainloader (hd0,1)+1
  
  	# GRUB 2 example
  	menuentry "Windows 7" {
  	  chainloader (hd0,4)+1
  	}
  
  	# GRUB 2 with UEFI example, chainloading another distro
  	menuentry "Fedora" {
  	  set root=(hd1,1)
  	  chainloader /efi/fedora/grubx64.efi
  	}
  '';
  boot.supportedFilesystems = 
	[
  		"btrfs"
		"ntfs"
		"fat32"
		"fat16"
	];

  # zram
  zramSwap.enable = true;

  networking.hostName = "RamUniX"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Jakarta";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # desktop manager
   services.xserver.displayManager.lightdm.enable = true;
  # services.xserver.displayManager.lightdm.greeters.pantheon.enable = true;

  # desktop environtment
  # services.xserver.desktopManager.pantheon.enable = true;
  programs.sway.enable = true;
  programs.sway.extraPackages = with pkgs; [
  	rofi 
	waybar
	sway-contrib.grimshot
	grim
	slurp
	lxqt.qterminal
  ];
  hardware.opengl.enable = true;
  programs.sway.extraSessionCommands = 
''
  # SDL:
  export SDL_VIDEODRIVER=wayland
  # QT (needs qt5.qtwayland in systemPackages):
  export QT_QPA_PLATFORM=wayland-egl
  export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
  # Fix for some Java AWT applications (e.g. Android Studio),
  # use this if they aren't displayed properly:
  export _JAVA_AWT_WM_NONREPARENTING=1
'';
 programs.sway.wrapperFeatures.gtk = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire.enable = true;
  services.pipewire.pulse.enable = true;
  services.pipewire.jack.enable = true;
  services.pipewire.alsa.enable = true;


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.guest = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     thunderbird
  #   ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
	lxqt.lximage-qt
	xfce.mousepad
	pcmanfm-qt
	neofetch
	htop
	lxtask
	xarchiver
	zip
	unzip
	chromium
	gparted
	baobab
	tango-icon-theme
	font-awesome
	pop-gtk-theme
	pavucontrol
	networkmanagerapplet
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

