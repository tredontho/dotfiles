{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "tredontho";
  home.homeDirectory = "/home/tredontho";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = [
    pkgs.acpi
    pkgs.bottom
    pkgs.dmenu
    pkgs.ripgrep
    pkgs.scrot
    pkgs.xclip
  ];

  xdg.configFile.nvim = {
    source = ./config-nvim;
    recursive = true;
  };

  programs = {
    firefox = {
      enable = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "rg --files";
      fileWidgetCommand = "rg --files";
    };

    git = {
      enable = true;
      aliases = {
        last = "log -1 --stat";
        cp = "cherry-pick";
        co = "checkout";
        cl = "clone";
        ci = "commit";
        st = "status -sb";
        br = "branch";
        dc = "diff --cached";
        # lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %Cblue<%an>%Creset' --abbrev-commit --date=relative ";
        # lga = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %Cblue<%an>%Creset' --abbrev-commit --date=relative --all";
        # lol = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
        please = "push --force-with-lease";
      };
      userEmail = "tredontho@gmail.com";
      userName = "tredontho";
      extraConfig = {
        core = {
          editor = "nvim";
        };
        diff = {
          tool = "nvimdiff";
        };
        push = {
          default = "current";
        };
        log.date = "iso-local";
        merge = {
          tool = "nvimdiff";
          conflictstyle = "diff3";
        };
        mergetool = {
          keepBackup = false;
          trustExitCode = false;
          prompt = true;
        };
        rerere.enabled = true;
        rebase.autoSquash = true;
        mergetool."nvimdiff" = {
          layout = "LOCAL,MERGED,REMOTE";
        };
      };
    };

    neovim = {
      enable = true;
      extraConfig = ''
        :luafile ~/.config/nvim/lua/init.lua
      '';
      plugins = with pkgs.vimPlugins; [
        cmp-nvim-lsp
        cmp-nvim-lsp-signature-help
        fzf-vim
        legendary-nvim
        nvim-cmp
        nvim-lspconfig
        nvim-metals
        packer-nvim
        plenary-nvim
        tmux-navigator
        vim-fugitive
        vim-illuminate
        vim-monokai-pro
        vim-nix
        vim-sensible
      ];
      extraPackages = with pkgs; [
        coursier
        haskellPackages.haskell-language-server
        metals
        sumneko-lua-language-server
      ];
      vimAlias = true;
      vimdiffAlias = true;
    };

    sioyek = {
      enable = true;
      bindings = {
        "move_up" = "k";
        "move_down" = "j";
        "move_left" = "h";
        "move_right" = "l";
        "screen_down" = [ "d" "<C-d>" ];
        "screen_up" = [ "u" "<C-u>" ];
      };
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };

    tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      prefix = "C-a";
      historyLimit = 50000;
      customPaneNavigationAndResize = true;
      plugins = with pkgs; [
        tmuxPlugins.vim-tmux-navigator
      ];
      extraConfig = ''
       bind u attach-session -t . -c '#{pane_current_path}'
       bind '"' split-window -v -c "#{pane_current_path}"
       bind '%' split-window -h -c "#{pane_current_path}"
       bind-key -T copy-mode-vi 'v' send-keys -X begin-selection
       bind-key -T copy-mode-vi 'y' send-keys -X copy-selection
      '';
    };

    urxvt = {
      enable = true;
      extraConfig = {
        # perl-ext-common = "resize-font"
        "keysym.C-minus" = "resize-font:smaller";
        "keysym.C-plus" = "resize-font:bigger";
        "keysym.C-0" = "resize-font:reset";
        "keysym.C-question" = "resize-font:show";
      };
      fonts = [
        "xft:Hack Nerd Font:size=10"
      ];
      keybindings = {
        "C-minus" = "resize-font:smaller";
        "C-plus" = "resize-font:bigger";
        "C-0" = "resize-font:reset";
        "C-question" = "resize-font:show";
        "Shift-Control-C" = "eval:selection_to_clipboard";
        "Shift-Control-V" = "eval:paste_clipboard";
      };
      shading = 0;
    };

    xmobar = {
      enable = true;
      extraConfig = ''
        Config { overrideRedirect = False
               , font     = "xft:Hack Nerd Font:size=9"
               , additionalFonts  = ["xft:FontAwesome-12"]
               , bgColor  = "#5f5f5f"
               , fgColor  = "#f8f8f2"
               , position = TopW L 90
               , commands = [ Run Weather "KMSN"
                                [ "--template", "<weather> <tempF>°F"
                                , "-L", "32"
                                , "-H", "75"
                                , "--low"   , "lightblue"
                                , "--normal", "#f8f8f2"
                                , "--high"  , "red"
                                ] 36000
                            , Run Cpu
                                [ "-L", "3"
                                , "-H", "50"
                                , "--high"  , "red"
                                , "--normal", "green"
                                ] 10
                            , Run Alsa "default" "Master"
                                [ "--template", "<volumestatus>"
                                , "--suffix"  , "True"
                                , "--"
                                , "--on", ""
                                ]
                            , Run Memory ["--template", "Mem: <usedratio>%"] 10
                            , Run Swap [] 10
                            , Run Date "%a %Y-%m-%d <fc=#8be9fd>%H:%M</fc>" "date" 10
                            , Run Battery
                                ["-t", "<acstatus> -- <timeleft> (<left>%)"
                                , "-L", "10", "-H", "80", "-p", "3"
                                , "--", "-O", "<fc=green>On</fc> - ", "-i", ""
                                , "-L", "-15", "-H", "-5"
                                , "-l", "red", "-m", "blue", "-h", "green"
                                , "-a", "notify-send -u critical 'Battery running out!!'"
                                , "--lows"   , "<fn=1>\62020</fn>  "
                                , "--mediums", "<fn=1>\62018</fn>  "
                                , "--highs"  , "<fn=1>\62016</fn>  "
                                , "-A", "3"]
                               600
                            , Run XMonadLog
                            ]
               , sepChar  = "%"
               , alignSep = "}{"
               , template = "%XMonadLog% }{ %cpu% | %memory% * %swap% | %KMSN% | %battery% | %date% "
               }
      '';
    };
    zsh = {
      enable = true;
      enableCompletion = false; # disable for now because it causes some sort of issue?

      # defaultKeymap = "vicmd";
      defaultKeymap = "viins";

      history = {
        ignoreDups = true;
        save = 50000;
        size = 50000;
      };

      sessionVariables = {
        EDITOR = "nvim";
      };

      shellAliases = {
        ll = "ls -l";
      };
    };
  };

  services = {
    blueman-applet.enable = true;

    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };

    pasystray.enable = true;

    trayer = {
      enable = true;
      settings = {
        SetDockType = true;
        SetPartialStrut = true;
        align = "right";
        edge = "top";
        expand = true;
        height = 18;
        tint = 6250335;
        transparent = true;
        width = 10;
      };
    };

    xscreensaver = {
      enable = true;
    };
  };

  xresources.extraConfig = ''
    #define S_base03        #002b36
    #define S_base02        #073642
    #define S_base01        #586e75
    #define S_base00        #657b83
    #define S_base0         #839496
    #define S_base1         #93a1a1
    #define S_base2         #eee8d5
    #define S_base3         #fdf6e3

    *background:            S_base03
    *foreground:            S_base0
    *fadeColor:             S_base03
    *cursorColor:           S_base1
    *pointerColorBackground:S_base01
    *pointerColorForeground:S_base1

    #define S_yellow        #b58900
    #define S_orange        #cb4b16
    #define S_red           #dc322f
    #define S_magenta       #d33682
    #define S_violet        #6c71c4
    #define S_blue          #268bd2
    #define S_cyan          #2aa198
    #define S_green         #859900

    !! black dark/light
    *color0:                S_base02
    *color8:                S_base03

    !! red dark/light
    *color1:                S_red
    *color9:                S_orange

    !! green dark/light
    *color2:                S_green
    *color10:               S_base01

    !! yellow dark/light
    *color3:                S_yellow
    *color11:               S_base00

    !! blue dark/light
    *color4:                S_blue
    *color12:               S_base0

    !! magenta dark/light
    *color5:                S_magenta
    *color13:               S_violet

    !! cyan dark/light
    *color6:                S_cyan
    *color14:               S_base1

    !! white dark/light
    *color7:                S_base2
    *color15:               S_base3

  '';

  xsession = {
    enable = true;
  };
}
