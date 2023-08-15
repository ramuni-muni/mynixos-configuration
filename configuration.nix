# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
	#sway config for DM
	swayConfig = pkgs.writeText "greetd-sway-config" ''
		output * bg ${pkgs.pantheon.elementary-wallpapers}/share/backgrounds/Nattu Adnan.jpg fill
    		# `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
    		exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l -s /etc/greetd/gtkgreet.css -c sway; swaymsg exit"
		exec "${pkgs.waybar}/bin/waybar -c /etc/greetd/waybar"
    		bindsym Mod4+q exec swaynag \
      		-t warning \
      		-m 'What do you want to do?' \
      		-b 'Poweroff' 'systemctl poweroff' \
      		-b 'Reboot' 'systemctl reboot'
  	'';
in
{
  	imports =
    	[ # Include the results of the hardware scan.
      		./hardware-configuration.nix
    	];

	#greetd DM
	services.greetd = {
	    	enable = true;
	    	settings = {
	      		default_session = {
	        		command = "${pkgs.sway}/bin/sway --config ${swayConfig}";
	      		};
	    	};
		package = pkgs.greetd.gtkgreet;
	};
	
	#waybar config for DM
	environment.etc."greetd/waybar".text = ''
		{
	    	"layer": "top",
    		"position": "bottom",
    		"height": 24,
    		"spacing": 0,
    		"margin-top": 0,
    		"margin-bottom": 0,
    		"mode": "dock",
    		"exclusive": true,
		    "ipc": true,
		
    		"modules-left":[ "custom/launcher" ],
    		"modules-right":[ "custom/exit" ],

		    "custom/launcher":{
		        "format": "   Reboot ↻",
		        "on-click": "systemctl reboot"
	    	},
	    	"custom/exit":{
		    	"format": " ⏻ Shutdown    ",
		      "on-click": "systemctl poweroff"
		    }
		 }
	 '';

	#available DE
	environment.etc."greetd/environments".text = ''
sway
bash
'';

	#CSS for gtkgreet DM
	environment.etc."greetd/gtkgreet.css".text = ''
		window {
			color: white;
			background-color: rgba(50, 50, 50, 0);
		   	/*background-image: url("file:///usr/share/backgrounds/background.jpg");
	   		background-size: cover;
	   		background-position: center;*/
		}
		box#body {	   
			color: white;
			background-color: rgba(50, 50, 50, 0.3);
			border-radius: 10px;
		   	padding: 50px;
		}
 	'';
	#sway config
	environment.etc."sway/config".text = ''
set $mod Mod4
set $left h
set $down j
set $up k
set $right l
set $term lxterminal
set $menu rofi -show drun
include /etc/sway/config-vars.d/*
output * bg ${pkgs.pantheon.elementary-wallpapers}/share/backgrounds/Nattu Adnan.jpg fill
input * xkb_numlock enable
seat seat0 xcursor_theme Numix-Cursor
bindsym $mod+Return exec $term
bindsym $mod+x kill
bindsym $mod+m exec $menu
bindsym Print exec grimshot save screen
bindsym $mod+Print exec grimshot save area
floating_modifier $mod normal
bindsym $mod+r reload
bindsym $mod+q exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'
bindsym $mod+f fullscreen
bindsym $mod+Alt+space floating toggle
bar swaybar_command waybar
set $gnome-schema org.gnome.desktop.interface
exec_always {
    gsettings set $gnome-schema gtk-theme 'Pop'
    gsettings set $gnome-schema icon-theme 'Tango'
    gsettings set $gnome-schema cursor-theme 'Numix-Cursor'
}
workspace_layout tabbed
exec nm-applet --indicator
exec swaymsg layout toggle float
exec_always lxqt-policykit-agent &
exec systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK
exec hash dbus-update-activation-environment 2>/dev/null && \
        dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK
 	'';

	# allow non free packet
	nixpkgs.config.allowUnfree = true;

	# waydroid
	#virtualisation = {
		#waydroid. enable = true;
    		#lxd.enable = true;
  	#};
        
	#virtual box
	#virtualisation.virtualbox.host.package = pkgs.virtualbox;
	#virtualisation.virtualbox.guest.enable = true;
	#virtualisation.virtualbox.host.enable = true;
	#virtualisation.virtualbox.host.addNetworkInterface = true;
	#services.boinc.extraEnvPackages = [ pkgs.ocl-icd pkgs.linuxPackages.nvidia_x11 ];

  	# kernel
  	boot.kernelPackages = pkgs.linuxPackages_latest;
  	#boot.kernelPackages = pkgs.linuxPackages_xanmod;
  	#boot.kernelPackages = pkgs.linuxPackages_zen;

	#Filesystem
	boot.supportedFilesystems = [
	  	"btrfs"
		"ntfs"
		"fat32"
		"fat16"
		"exfat"
	];

  	# Use the GRUB 2 boot loader.
  	boot.loader.grub.enable = true;
  	boot.loader.grub.version = 2;
  	# boot.loader.grub.efiSupport = true;
  	# boot.loader.grub.efiInstallAsRemovable = true;
  	# boot.loader.efi.efiSysMountPoint = "/boot/efi";
  	# Define on which hard drive you want to install Grub.
  	boot.loader.grub.device = "/dev/sdb"; # or "nodev" for efi only
  	boot.loader.grub.useOSProber = true;
  	boot.loader.grub.extraEntries = ''
##########################

###########################
	'';
  	
	# video driver
	services.xserver.videoDrivers = [
    		# "amdgpu"
    		# "radeon"
    		# "nouveau"
    		# "modesetting"
    		"fbdev"
  	];

  	# zram
  	zramSwap.enable = true;

	#network
  	networking.hostName = "Nixos"; # Define your hostname.
  	# Pick only one of the below networking options.
  	# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  	networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  	# Set your time zone.
  	time.timeZone = "Asia/Jakarta";

  	# Configure network proxy if necessary
  	# networking.proxy.default = "http://user:password@proxy:port/";
  	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  	# Select internationalisation properties.
  	i18n.defaultLocale = "en_US.utf8";
	
  	# Enable the X11 windowing system.
  	services.xserver.enable = false;

  	# desktop manager
  	services.xserver.displayManager.lightdm.enable = false;
  	services.xserver.desktopManager.plasma5.enable = false;
	services.xserver.windowManager.icewm.enable = false;

  	# desktop environtment
  	programs.sway.enable = true;
  	programs.sway.extraPackages = with pkgs; [
		  waybar
      rofi-wayland  		
		  sway-contrib.grimshot
		  grim
		  slurp		
  	];
  	hardware.opengl.enable = true;
  	programs.sway.extraSessionCommands = ''
  		# SDL:
  		export SDL_VIDEODRIVER=wayland
  		# QT (needs qt5.qtwayland in systemPackages):
  		export QT_QPA_PLATFORM=wayland
  		export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
  		# Fix for some Java AWT applications (e.g. Android Studio),
  		# use this if they aren't displayed properly:
  		export _JAVA_AWT_WM_NONREPARENTING=1
  		export XCURSOR_THEME=Numix-Cursor
		#export XDG_CURRENT_DESKTOP=Unity
  	'';
  	programs.sway.wrapperFeatures.gtk = true;
  	programs.waybar.enable = true;
	  qt5.platformTheme = "qt5ct";
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
  	services.xserver.libinput.enable = true;

  	# Define a user account. Don't forget to set a password with ‘passwd’.
  	users.users.guest = {
     		isNormalUser = true;
     		extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
     		packages = with pkgs; [  ];
  	};

	# Fonts
  	fonts.fonts = with pkgs; [
		font-awesome
  	];
  	# List packages installed in system profile. To search, run:
  	environment.systemPackages = with pkgs; [
		chromium
		xdg-utils
    wget
		curl
    htop
    lxtask
		neofetch
		libappindicator		
		networkmanagerapplet
		tango-icon-theme
		pop-gtk-theme
		glib
		numix-cursor-theme		
		gparted
		baobab
		lxterminal		
		xfce.mousepad
		pavucontrol
		lxqt.pcmanfm-qt
		lxqt.lximage-qt
   	lxde.lxmenu-data
		xarchiver
		zip
		unzip
		vlc	
		lxqt.lxqt-policykit
    lxqt.lxqt-admin
		pantheon.elementary-wallpapers
    libsForQt5.qt5ct
    e2fsprogs   
    gptfdisk
    pv
    vboot_reference
	];

  	# Some programs need SUID wrappers, can be configured further or are
  	# started in user sessions.
   	#programs.mtr.enable = true;
   	#programs.gnupg.agent = {
    	#enable = true;
     	#enableSSHSupport = true;
   	#};

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
  	system.stateVersion = "22.05"; # Did you read the comment?
}

