# configuration.nix - Space-Themed NixOS Configuration
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

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # User configuration
  users.users.cosmonaut = {
    isNormalUser = true;
    description = "Space Explorer";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    shell = pkgs.zsh;
  };

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
    ghostty
    zsh
    oh-my-zsh
    starship
    
    # File management
    thunar
    ranger
    
    # Media and graphics
    feh
    mpv
    pavucontrol
    
    # Development
    vscode
    git
    
    # Space-themed applications
    stellarium  # Planetarium software
    # celestia    # 3D space simulator (may need unstable channel)
    
    # System utilities
    htop
    tree
    unzip
    
    # Fonts
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Iosevka" ]; })
    font-awesome
  ];

  # Enable services
  services = {
    xserver.enable = true;
    displayManager.sddm = {
      enable = true;
      # Note: Custom themes may need additional configuration in 25.05
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;  # Added for 25.05
    };
  };

  # Security and hardware
  security.rtkit.enable = true;  # For pipewire
  hardware.pulseaudio.enable = false;  # Use pipewire instead
  
  # Graphics drivers (uncomment as needed)
  # hardware.opengl.enable = true;  # For older configs
  # hardware.graphics.enable = true;  # New in 25.05
  
  # Hyprland configuration
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # systemd.setPath.enable = true;  # May be needed for some setups
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

  # Fonts
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      jetbrains-mono
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Iosevka" ]; })
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

  # Home Manager configuration (you'll need to add home-manager to your flake or channels)
  # Uncomment and configure if using home-manager
  # home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.cosmonaut = { pkgs, ... }: {
      home.stateVersion = "24.05";
      
      # Ghostty terminal configuration
      home.file.".config/ghostty/config".text = ''
        # Space-themed Ghostty configuration
        theme = "cosmic-nebula"
        font-family = "JetBrains Mono Nerd Font"
        font-size = 12
        
        # Colors - Deep space theme
        background = 0c0c16
        foreground = e0e0ff
        
        # Black colors
        palette = 0=#1a1a2e
        palette = 8=#16213e
        
        # Red colors  
        palette = 1=#ff6b9d
        palette = 9=#ff8fab
        
        # Green colors
        palette = 2=#4ecdc4
        palette = 10=#6ee7de
        
        # Yellow colors
        palette = 3=#ffe66d
        palette = 11=#ffed85
        
        # Blue colors
        palette = 4=#4d79a4
        palette = 12=#6596c3
        
        # Magenta colors
        palette = 5=#bc85e3
        palette = 13=#d4a5f7
        
        # Cyan colors
        palette = 6=#87ceeb
        palette = 14=#a5ddf0
        
        # White colors
        palette = 7=#e0e0ff
        palette = 15=#ffffff
        
        # Window settings
        window-decoration = false
        window-padding-x = 10
        window-padding-y = 10
        
        # Cursor
        cursor-style = block
        cursor-style-blink = true
        
        # Bell
        audible-bell = false
        visual-bell = true
      '';
      
      # Hyprland configuration
      home.file.".config/hypr/hyprland.conf".text = ''
        # Hyprland Space-Themed Configuration
        
        # Monitor configuration
        monitor=,preferred,auto,1
        
        # Input configuration
        input {
            kb_layout = us
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
        windowrulev2 = opacity 0.9 0.9, class:^(ghostty)$
        windowrulev2 = opacity 0.95 0.95, class:^(code)$
        
        # Keybindings
        $mainMod = SUPER
        
        # Application shortcuts
        bind = $mainMod, Return, exec, ghostty
        bind = $mainMod, Q, killactive,
        bind = $mainMod, M, exit,
        bind = $mainMod, E, exec, thunar
        bind = $mainMod, V, togglefloating,
        bind = $mainMod, R, exec, wofi --show drun
        bind = $mainMod, P, pseudo,
        bind = $mainMod, J, togglesplit,
        bind = $mainMod, F, fullscreen,
        bind = $mainMod, C, exec, code
        bind = $mainMod, B, exec, firefox
        
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
      
      # Waybar configuration
      home.file.".config/waybar/config".text = ''
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
                    "1": "🚀",
                    "2": "🌌",
                    "3": "⭐",
                    "4": "🌙",
                    "5": "🪐",
                    "6": "☄️",
                    "7": "🛸",
                    "8": "🌠",
                    "9": "🔭",
                    "10": "👨‍🚀"
                }
            },
            
            "clock": {
                "format": "{:%H:%M 🌍 %Y-%m-%d}",
                "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>"
            },
            
            "battery": {
                "states": {
                    "warning": 30,
                    "critical": 15
                },
                "format": "{capacity}% {icon}",
                "format-icons": ["🔋", "🔋", "🔋", "🔋", "🔋"]
            },
            
            "network": {
                "format-wifi": "{essid} 📡",
                "format-ethernet": "Connected 🌐",
                "format-disconnected": "Disconnected ❌"
            },
            
            "pulseaudio": {
                "format": "{volume}% {icon}",
                "format-muted": "🔇",
                "format-icons": {
                    "default": ["🔈", "🔉", "🔊"]
                }
            }
        }
      '';
      
      # Waybar styling
      home.file.".config/waybar/style.css".text = ''
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
        }
        
        #workspaces button {
            padding: 0 8px;
            background: transparent;
            color: #87ceeb;
            border-radius: 8px;
            margin: 2px;
        }
        
        #workspaces button.active {
            background: linear-gradient(45deg, #4ecdc4, #bc85e3);
            color: #0c0c16;
        }
        
        #clock, #battery, #network, #pulseaudio {
            padding: 4px 8px;
            margin: 2px;
            background: rgba(78, 205, 196, 0.2);
            border-radius: 8px;
            color: #e0e0ff;
        }
        
        #battery.warning {
            background: rgba(255, 230, 109, 0.3);
        }
        
        #battery.critical {
            background: rgba(255, 107, 157, 0.3);
        }
      '';
      
      # Wofi launcher configuration
      home.file.".config/wofi/config".text = ''
        width=600
        height=400
        location=center
        show=drun
        prompt=Launch into orbit...
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
      
      # Wofi styling
      home.file.".config/wofi/style.css".text = ''
        window {
            margin: 0px;
            border: 3px solid #4ecdc4;
            background: linear-gradient(135deg, rgba(12, 12, 22, 0.95), rgba(26, 26, 46, 0.95));
            border-radius: 16px;
        }
        
        #input {
            margin: 8px;
            border: 2px solid #bc85e3;
            color: #e0e0ff;
            background: rgba(26, 26, 46, 0.8);
            border-radius: 8px;
            padding: 8px;
            font-size: 14px;
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
        }
        
        #entry {
            margin: 2px;
            border: none;
            border-radius: 8px;
            background: transparent;
        }
        
        #entry:selected {
            background: linear-gradient(45deg, rgba(78, 205, 196, 0.3), rgba(188, 133, 227, 0.3));
        }
      '';
      
      # Hyprpaper wallpaper configuration
      home.file.".config/hypr/hyprpaper.conf".text = ''
        preload = ~/.config/wallpapers/nebula.jpg
        wallpaper = ,~/.config/wallpapers/nebula.jpg
        splash = false
      '';
      
      # Starship prompt configuration
      home.file.".config/starship.toml".text = ''
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
        
        [git_status]
        style = "bold yellow"
        
        [character]
        success_symbol = "[🚀](bold green)"
        error_symbol = "[💥](bold red)"
        
        [cmd_duration]
        style = "bold yellow"
        format = "took [$duration]($style) "
      '';
      
      # ZSH configuration
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        
        shellAliases = {
          ll = "ls -la";
          la = "ls -la";
          l = "ls -l";
          ".." = "cd ..";
          "..." = "cd ../..";
          orbit = "cd ~";
          launch = "sudo nixos-rebuild switch";
          explore = "ranger";
          telescope = "stellarium";
          cosmos = "celestia";
        };
        
        initExtra = ''
          # Starship prompt
          eval "$(starship init zsh)"
          
          # Custom space-themed functions
          function rocket() {
            echo "🚀 Launching $1..."
            $@
          }
          
          function nebula() {
            echo "🌌 Exploring the cosmos..."
            ls -la --color=auto
          }
          
          # Set terminal title
          precmd() {
            print -Pn "\e]0;%n@%m: %~\a"
          }
        '';
      };
  # };

  # Alternative: Create config files directly in environment
  environment.etc = {
    "skel/.config/ghostty/config".text = ''
  system.stateVersion = "24.05";
}
