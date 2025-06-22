# configuration.nix - Space-Themed NixOS 25.05 Configuration
{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Boot configuration with space theme
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;
  boot.kernelParams = [ "quiet" "splash" ];

  # Networking
  networking.hostName = "nebula-station";
  networking.networkmanager.enable = true;

  # Time zone and locale
  time.timeZone = "UTC";
  i18n.defaultLocale = "en_US.UTF-8";

  # Console keyboard layout
  console = {
    keyMap = "de";
  };

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # User configuration - cosmonaut as normal user with sudo privileges and no password
  users.users.cosmonaut = {
    isNormalUser = true;
    description = "Space Explorer";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    shell = pkgs.zsh;
    hashedPassword = "";  # Empty password hash
  };

  # Root user configuration - allow empty password
  users.users.root = {
    hashedPassword = "";  # Allow root login with empty password
  };

  # Allow empty passwords and passwordless sudo
  security.sudo.wheelNeedsPassword = false;
  security.pam.services.su.allowNullPassword = true;
  security.pam.services.login.allowNullPassword = true;

  # System packages
  environment.systemPackages = with pkgs; [
    # Essential tools
    wget curl git vim neovim
    firefox chromium
    
    # Hyprland and Wayland essentials
    hyprland
    hyprpaper
    hyprlock
    hypridle
    waybar
    wofi
    dunst
    grim
    slurp
    wl-clipboard
    swappy
    
    # Terminal and shell
    alacritty  # Using alacritty instead of ghostty for better compatibility
    zsh
    starship
    
    # File management
    xfce.thunar
    ranger
    
    # Media and graphics
    feh
    mpv
    pavucontrol
    
    # Development
    git
    
    # Space-themed applications
    stellarium  # Planetarium software
    
    # System utilities
    htop
    tree
    unzip
    
    # Additional utilities for ASCII art
    figlet
    lolcat
    neofetch
  ];

  # Enable services
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "de";
        variant = "";
      };
    };
    displayManager.sddm = {
      enable = true;
      # Theme configuration for 25.05
      theme = "breeze";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  # Security and hardware
  security.rtkit.enable = true;  # For pipewire
  services.pulseaudio.enable = false;  # Use pipewire instead
  
  # Graphics drivers - Updated for 25.05
  hardware.graphics.enable = true;  # Replaces hardware.opengl in 25.05
  
  # Hyprland configuration
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # ZSH configuration
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" "kubectl" ];
      theme = "agnoster";
    };
  };

  # Fonts - Updated for NixOS 25.05 compatibility
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      jetbrains-mono
      # Updated nerdfonts syntax for 25.05
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Iosevka" ]; })
      # ASCII art fonts
      figlet
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "JetBrains Mono" ];
      };
    };
  };

  # Create configuration directories and files
  environment.etc = {
    "skel/.config/alacritty/alacritty.toml".text = ''
      # Space-themed Alacritty configuration
      
      [env]
      TERM = "xterm-256color"
      
      [window]
      padding = { x = 10, y = 10 }
      decorations = "none"
      opacity = 0.9
      
      [font]
      normal = { family = "JetBrains Mono Nerd Font", style = "Regular" }
      bold = { family = "JetBrains Mono Nerd Font", style = "Bold" }
      italic = { family = "JetBrains Mono Nerd Font", style = "Italic" }
      size = 12.0
      
      [colors.primary]
      background = "#0c0c16"
      foreground = "#e0e0ff"
      
      [colors.normal]
      black = "#1a1a2e"
      red = "#ff6b9d"
      green = "#4ecdc4"
      yellow = "#ffe66d"
      blue = "#4d79a4"
      magenta = "#bc85e3"
      cyan = "#87ceeb"
      white = "#e0e0ff"
      
      [colors.bright]
      black = "#16213e"
      red = "#ff8fab"
      green = "#6ee7de"
      yellow = "#ffed85"
      blue = "#6596c3"
      magenta = "#d4a5f7"
      cyan = "#a5ddf0"
      white = "#ffffff"
      
      [cursor]
      style = { shape = "Block", blinking = "On" }
      
      [bell]
      animation = "EaseOutExpo"
      duration = 0
    '';

    "skel/.config/hypr/hyprland.conf".text = ''
      # Hyprland Space-Themed Configuration
      
      # Monitor configuration
      monitor=,preferred,auto,1
      
      # Input configuration
      input {
          kb_layout = de
          follow_mouse = 1
          touchpad {
              natural_scroll = no
          }
          sensitivity = 0
      }
      
      # General settings
      general {
          gaps_in = 8
          gaps_out = 16
          border_size = 3
          col.active_border = rgba(4ecdc4ff) rgba(bc85e3ff) 45deg
          col.inactive_border = rgba(1a1a2eff)
          layout = dwindle
      }
      
      # Decoration settings
      decoration {
          rounding = 12
          blur {
              enabled = true
              size = 8
              passes = 3
              new_optimizations = true
              xray = true
              ignore_opacity = true
          }
          drop_shadow = true
          shadow_range = 20
          shadow_render_power = 3
          col.shadow = rgba(0c0c16ff)
          col.shadow_inactive = rgba(0c0c1699)
      }
      
      # Animation settings
      animations {
          enabled = yes
          bezier = cosmic, 0.25, 0.46, 0.45, 0.94
          bezier = stellar, 0.16, 1, 0.3, 1
          
          animation = windows, 1, 7, cosmic
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = borderangle, 1, 8, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, stellar
      }
      
      # Layout settings
      dwindle {
          pseudotile = yes
          preserve_split = yes
      }
      
      # Window rules
      windowrule = float, ^(pavucontrol)$
      windowrule = float, ^(thunar)$
      windowrulev2 = opacity 0.9 0.9, class:^(Alacritty)$
      
      # Keybindings
      $mainMod = SUPER
      
      # Application shortcuts
      bind = $mainMod, Return, exec, alacritty
      bind = $mainMod, Q, killactive,
      bind = $mainMod, M, exit,
      bind = $mainMod, E, exec, thunar
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, R, exec, wofi --show drun
      bind = $mainMod, P, pseudo,
      bind = $mainMod, J, togglesplit,
      bind = $mainMod, F, fullscreen,
      bind = $mainMod, B, exec, firefox
      bind = $mainMod, N, exec, alacritty -e neofetch
      
      # Move focus
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d
      
      # Switch workspaces
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10
      
      # Move windows to workspaces
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8
      bind = $mainMod SHIFT, 9, movetoworkspace, 9
      bind = $mainMod SHIFT, 0, movetoworkspace, 10
      
      # Screenshots
      bind = , Print, exec, grim -g "$(slurp)" - | swappy -f -
      bind = SHIFT, Print, exec, grim - | swappy -f -
      
      # Volume controls
      bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      
      # Autostart
      exec-once = waybar
      exec-once = hyprpaper
      exec-once = dunst
      exec-once = hypridle
    '';

    "skel/.config/waybar/config".text = ''
      {
          "layer": "top",
          "position": "top",
          "height": 32,
          "spacing": 8,
          
          "modules-left": ["hyprland/workspaces", "hyprland/mode"],
          "modules-center": ["clock"],
          "modules-right": ["pulseaudio", "network", "battery", "tray"],
          
          "hyprland/workspaces": {
              "disable-scroll": true,
              "all-outputs": true,
              "format": "{icon}",
              "format-icons": {
                  "1": "[ * ]",
                  "2": "[***]",
                  "3": "[ + ]",
                  "4": "[ o ]",
                  "5": "[oOo]",
                  "6": "[ ~ ]",
                  "7": "[^^^]",
                  "8": "[---]",
                  "9": "[###]",
                  "10": "[@@@]"
              }
          },
          
          "clock": {
              "format": "{:%H:%M [EARTH] %d-%m-%Y}",
              "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>"
          },
          
          "battery": {
              "states": {
                  "warning": 30,
                  "critical": 15
              },
              "format": "{capacity}% [PWR]",
              "format-charging": "{capacity}% [CHG]",
              "format-plugged": "{capacity}% [AC]"
          },
          
          "network": {
              "format-wifi": "{essid} [WIFI]",
              "format-ethernet": "Connected [LAN]",
              "format-disconnected": "Disconnected [X]"
          },
          
          "pulseaudio": {
              "format": "{volume}% [VOL]",
              "format-muted": "[MUTE]",
              "on-click": "pavucontrol"
          }
      }
    '';

    "skel/.config/waybar/style.css".text = ''
      * {
          font-family: "JetBrains Mono Nerd Font";
          font-size: 13px;
          border: none;
          border-radius: 0;
          min-height: 0;
      }
      
      window#waybar {
          background: linear-gradient(45deg, rgba(12, 12, 22, 0.9), rgba(26, 26, 46, 0.9));
          color: #e0e0ff;
          border-radius: 12px;
          margin: 8px;
          padding: 0 8px;
          border: 2px solid #4ecdc4;
      }
      
      #workspaces button {
          padding: 0 8px;
          background: transparent;
          color: #87ceeb;
          border-radius: 8px;
          margin: 2px;
          font-family: monospace;
      }
      
      #workspaces button.active {
          background: linear-gradient(45deg, #4ecdc4, #bc85e3);
          color: #0c0c16;
          font-weight: bold;
      }
      
      #clock, #battery, #network, #pulseaudio {
          padding: 4px 8px;
          margin: 2px;
          background: rgba(78, 205, 196, 0.2);
          border-radius: 8px;
          color: #e0e0ff;
          border: 1px solid rgba(78, 205, 196, 0.3);
          font-family: monospace;
      }
      
      #battery.warning {
          background: rgba(255, 230, 109, 0.3);
          border-color: rgba(255, 230, 109, 0.5);
      }
      
      #battery.critical {
          background: rgba(255, 107, 157, 0.3);
          border-color: rgba(255, 107, 157, 0.5);
      }
    '';

    "skel/.config/wofi/config".text = ''
      width=600
      height=400
      location=center
      show=drun
      prompt=[ LAUNCH SEQUENCE INITIATED ]
      filter_rate=100
      allow_markup=true
      no_actions=true
      halign=fill
      orientation=vertical
      content_halign=fill
      insensitive=true
      allow_images=true
      image_size=32
      gtk_dark=true
    '';

    "skel/.config/wofi/style.css".text = ''
      window {
          margin: 0px;
          border: 3px solid #4ecdc4;
          background: linear-gradient(135deg, rgba(12, 12, 22, 0.95), rgba(26, 26, 46, 0.95));
          border-radius: 16px;
          font-family: "JetBrains Mono Nerd Font", monospace;
      }
      
      #input {
          margin: 8px;
          border: 2px solid #bc85e3;
          color: #e0e0ff;
          background: rgba(26, 26, 46, 0.8);
          border-radius: 8px;
          padding: 8px;
          font-size: 14px;
          font-family: monospace;
      }
      
      #inner-box {
          margin: 8px;
          border: none;
          background: transparent;
      }
      
      #outer-box {
          margin: 8px;
          border: none;
          background: transparent;
      }
      
      #scroll {
          margin: 0px;
          border: none;
      }
      
      #text {
          margin: 5px;
          border: none;
          color: #e0e0ff;
          font-family: monospace;
      }
      
      #entry {
          margin: 2px;
          border: none;
          border-radius: 8px;
          background: transparent;
      }
      
      #entry:selected {
          background: linear-gradient(45deg, rgba(78, 205, 196, 0.3), rgba(188, 133, 227, 0.3));
          border: 1px solid rgba(78, 205, 196, 0.5);
      }
    '';

    "skel/.config/hypr/hyprpaper.conf".text = ''
      preload = ~/.config/wallpapers/nebula.jpg
      wallpaper = ,~/.config/wallpapers/nebula.jpg
      splash = false
      ipc = off
    '';

    "skel/.config/starship.toml".text = ''
      format = """
      [╭─](bold cyan)$username$hostname$directory$git_branch$git_status$cmd_duration
      [╰─](bold cyan)$character"""
      
      [username]
      show_always = true
      style_user = "bold purple"
      style_root = "bold red"
      format = "[$user]($style) "
      
      [hostname]
      ssh_only = false
      style = "bold blue"
      format = "on [$hostname]($style) "
      
      [directory]
      style = "bold cyan"
      format = "in [$path]($style) "
      truncate_to_repo = false
      
      [git_branch]
      style = "bold green"
      format = "\\[[$symbol$branch]($style)\\] "
      symbol = "[GIT] "
      
      [git_status]
      style = "bold yellow"
      
      [character]
      success_symbol = "[>>](bold green)"
      error_symbol = "[XX](bold red)"
      
      [cmd_duration]
      style = "bold yellow"
      format = "took [$duration]($style) "
    '';

    "skel/.config/neofetch/config.conf".text = ''
      # Neofetch config for space theme
      
      print_info() {
          info title
          info underline
          
          info "OS" distro
          info "Host" model
          info "Kernel" kernel
          info "Uptime" uptime
          info "Packages" packages
          info "Shell" shell
          info "Resolution" resolution
          info "DE" de
          info "WM" wm
          info "WM Theme" wm_theme
          info "Theme" theme
          info "Icons" icons
          info "Terminal" term
          info "Terminal Font" term_font
          info "CPU" cpu
          info "GPU" gpu
          info "Memory" memory
          
          info cols
      }
      
      # ASCII Art
      ascii_distro="nixos_small"
      ascii_colors=(4 6 1 8 8 6)
      ascii_bold="on"
      
      # Colors
      colors=(4 6 1 8 8 7)
      
      # Text Options
      bold="on"
      underline_enabled="on"
      underline_char="-"
      separator=" ->"
      
      # Other
      image_backend="ascii"
      image_source="auto"
    '';

    "skel/.zshrc".text = ''
      # Space-themed ZSH configuration
      
      # ASCII Art Welcome
      echo ""
      echo "    ███╗   ██╗███████╗██████╗ ██╗   ██╗██╗      █████╗ "
      echo "    ████╗  ██║██╔════╝██╔══██╗██║   ██║██║     ██╔══██╗"
      echo "    ██╔██╗ ██║█████╗  ██████╔╝██║   ██║██║     ███████║"
      echo "    ██║╚██╗██║██╔══╝  ██╔══██╗██║   ██║██║     ██╔══██║"
      echo "    ██║ ╚████║███████╗██████╔╝╚██████╔╝███████╗██║  ██║"
      echo "    ╚═╝  ╚═══╝╚══════╝╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝"
      echo ""
      echo "    ███████╗████████╗ █████╗ ████████╗██╗ ██████╗ ██╗   ██╗"
      echo "    ██╔════╝╚══██╔══╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║"
      echo "    ███████╗   ██║   ███████║   ██║   ██║██║   ██║██╔██╗ ██║"
      echo "    ╚════██║   ██║   ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║"
      echo "    ███████║   ██║   ██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║"
      echo "    ╚══════╝   ╚═╝   ╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝"
      echo ""
      echo "    Welcome to the NEBULA STATION, Cosmonaut!"
      echo "    System Status: [ OPERATIONAL ]"
      echo "    Mission Control: Ready for your commands"
      echo ""
      
      # Enable Powerlevel10k instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
      
      # Starship prompt
      eval "$(starship init zsh)"
      
      # Aliases
      alias ll='ls -alF'
      alias la='ls -A'
      alias l='ls -CF'
      alias ..='cd ..'
      alias ...='cd ../..'
      alias grep='grep --color=auto'
      alias space='neofetch'
      alias mission='htop'
      alias launch='sudo nixos-rebuild switch'
      alias orbit='systemctl status'
      alias dock='thunar'
      
      # Space-themed functions
      nebula() {
          echo "    ╔══════════════════════════════════════╗"
          echo "    ║        NEBULA SYSTEM STATUS          ║"
          echo "    ╠══════════════════════════════════════╣"
          echo "    ║ Hostname: $(hostname)                     ║"
          echo "    ║ Uptime: $(uptime -p)                 ║"
          echo "    ║ Load: $(uptime | awk -F'load average:' '{print $2}') ║"
          echo "    ╚══════════════════════════════════════╝"
      }
      
      # History settings
      HISTSIZE=10000
      SAVEHIST=10000
      setopt SHARE_HISTORY
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_REDUCE_BLANKS
      
      # Auto-completion
      autoload -U compinit
      compinit
      
      # Key bindings
      bindkey '^R' history-incremental-search-backward
      
      # Export environment variables
      export EDITOR=nvim
      export BROWSER=firefox
      export TERMINAL=alacritty
    '';
  };

  # Create wallpaper directory and sample ASCII wallpaper
  systemd.tmpfiles.rules = [
    "d /home/cosmonaut/.config/wallpapers 0755 cosmonaut users"
    "d /home/cosmonaut/.config/neofetch 0755 cosmonaut users"
  ];

  # Set system state version
  system.stateVersion = "25.05";
}
