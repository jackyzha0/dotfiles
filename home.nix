{ config, pkgs, lib, ... }:

{
  home.username = "jzhao";
  home.homeDirectory = "/Users/jzhao";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    # shell ergonomics
    eza ripgrep fd bat jq procs httpstat
    diff-so-fancy
    fnm
    # editor
    neovim
    nodejs # for nvim LSPs / mason; per-repo node still comes from direnv
    gnumake gcc # telescope-fzf-native build
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    GOPATH = "$HOME/go";
  };
  home.sessionPath = [ "$HOME/go/bin" "$HOME/.local/bin" ];

  programs.home-manager.enable = true;

  # ---------------------------------------------------------------- zsh
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true; # home-manager sources this last

    history = {
      size = 100000;
      save = 100000;
      path = "$HOME/.zsh_history";
      extended = true;
      ignoreAllDups = true;
      ignoreSpace = true;
      share = false; # inc_append_history instead; atuin is the real history
    };

    # fast startup: trust cached dump, full re-scan at most once a day
    completionInit = ''
      autoload -Uz compinit
      _zcd=$HOME/.zcompdump
      if [[ -n $_zcd(#qN.mh+24) ]]; then
        compinit -d $_zcd && touch $_zcd
      else
        compinit -C -d $_zcd
      fi
      unset _zcd
    '';

    shellAliases = {
      v = "nvim";
      chrome = "open -a 'Google Chrome'";
      ls = "eza -lahF";
      l = "eza -lahF";
      ll = "eza -lahF";
      headers = "httpstat";
      procs = "procs --watch --sortd cpu";
      save = "git add . && git commit -m";
      rebuild = "sudo darwin-rebuild switch --flake ~/dotfiles";
      vm = "ssh jzhao-vm-with-ports";

      # the omz git aliases actually used
      g = "git";
      ga = "git add";
      gc = "git commit -v";
      gcmsg = "git commit -m";
      gco = "git checkout";
      gcb = "git checkout -b";
      gb = "git branch";
      gd = "git diff";
      gds = "git diff --staged";
      gst = "git status";
      gp = "git push";
      gpf = "git push --force-with-lease";
      gl = "git pull";
      glog = "git log --oneline --decorate --graph";
    };

    initContent = ''
      setopt auto_cd interactive_comments extended_glob inc_append_history

      # --- completion styling + fzf-tab (must come after compinit)
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*' menu no
      zstyle ':completion:*:descriptions' format '[%d]'
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh

      # --- keybindings
      bindkey -e
      autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search
      bindkey '^[[A' up-line-or-beginning-search
      bindkey '^[[B' down-line-or-beginning-search
      bindkey '^[[H' beginning-of-line
      bindkey '^[[F' end-of-line
      bindkey '^[[3~' delete-char
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
      bindkey '^[[1;3C' forward-word
      bindkey '^[[1;3D' backward-word

      # node via fnm (repo work gets its node from nix/direnv, which prepends later)
      eval "$(fnm env --use-on-cd --shell zsh)"

      [[ -d ~/projects ]] && cd ~/projects
    '';
  };

  programs.starship = {
    enable = true;
    # reuse the old text-symbol config verbatim
    settings = builtins.fromTOML (builtins.readFile ./starship.toml);
  };

  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
  };

  programs.fzf = {
    enable = true;
    historyWidget.command = ""; # atuin owns ctrl-r
  };

  # also wires up git's credential helper for github.com, so `git push` over https just works
  programs.gh = {
    enable = true;
    settings.git_protocol = "https";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # ---------------------------------------------------------------- git
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Jacky Zhao";
        email = "j.zhao2k19@gmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = false;
      push.default = "current";
      core.pager = "diff-so-fancy | less --tabs=4 -R";
      interactive.diffFilter = "diff-so-fancy --patch";
      color.ui = true;
      "color \"diff-highlight\"" = {
        oldNormal = "red bold";
        oldHighlight = "red bold 52";
        newNormal = "green bold";
        newHighlight = "green bold 22";
      };
      "color \"diff\"" = {
        meta = 11;
        frag = "magenta bold";
        func = "146 bold";
        commit = "yellow bold";
        old = "red bold";
        new = "green bold";
        whitespace = "red reverse";
      };
      diff-so-fancy.markEmptyLines = false;
    };
    ignores = [ ".DS_Store" ".direnv" ];
  };

  # ---------------------------------------------------------------- kitty
  # installed system-wide in darwin.nix; home-manager only writes the config
  programs.kitty = {
    enable = true;
    package = pkgs.emptyDirectory;
    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 15;
    };
    shellIntegration.enableZshIntegration = true;
    keybindings = lib.listToAttrs (map (n: {
      name = "cmd+${toString n}";
      value = "goto_tab ${toString n}";
    }) (lib.range 1 9));
    settings = {
      cursor_shape = "block";
      scrollback_lines = 3000;
      url_style = "straight";
      enable_audio_bell = "no";
      window_padding_width = "0 12"; # vertical horizontal
      confirm_os_window_close = 0;
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      editor = "nvim";
      startup_session = "~/.config/kitty/startup.session";
      macos_option_as_alt = "left";
      macos_quit_when_last_window_closed = "no";
      macos_titlebar_color = "#000000";

      background = "#000000";
      foreground = "#d9d7ce";
      cursor = "#20FFAF";
      selection_background = "#343f4c";
      selection_foreground = "#212733";
      color0 = "#191e2a";  color8 = "#686868";
      color1 = "#F65C5C";  color9 = "#F85E5E";
      color2 = "#20ffaf";  color10 = "#5bffc4";
      color3 = "#fad07b";  color11 = "#ffd580";
      color4 = "#00dbce";  color12 = "#0defe1";
      color5 = "#c4b2f0";  color13 = "#c4b2f0";
      color6 = "#91e9ee";  color14 = "#c5fffb";
      color7 = "#c7c7c7";  color15 = "#ffffff";
    };
  };
  xdg.configFile."kitty/startup.session".text = "cd ~/projects\n";
  # custom app icon (macOS Terminal's); kitty picks this up on launch
  home.file.".hushlogin".text = ""; # no "Last login" banner
  xdg.configFile."kitty/kitty.app.png".source = ./kitty/kitty.app.png;

  # ---------------------------------------------------------------- nvim
  # lazy.nvim bootstraps itself; lazy-lock.json stays writable so :Lazy update works
  xdg.configFile."nvim/init.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim/init.lua";
  xdg.configFile."nvim/lazy-lock.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim/lazy-lock.json";
}
