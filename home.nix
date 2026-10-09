{ config, pkgs, lib, ... }:

{
  home.username = "jzhao";
  home.homeDirectory = "/Users/jzhao";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    # shell ergonomics
    eza ripgrep fd jq procs httpstat
    diff-so-fancy
    # toolchains: global defaults. python comes from uv (`uv python install`), rust from
    # rustup (`rustup default stable`), node from nixpkgs; projects override via flake + direnv
    nodejs_24
    uv
    rustup
    pnpm
    go
    # editor
    neovim
    gnumake gcc # telescope-fzf-native build
    tree-sitter # nvim-treesitter (main branch) compiles parsers with the CLI
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    GOPATH = "$HOME/go";
    UV_PYTHON_PREFERENCE = "only-managed"; # never pick up a nix/system python by accident
  };
  home.sessionPath = [ "$HOME/go/bin" "$HOME/.local/bin" "$HOME/.cargo/bin" ];

  programs.home-manager.enable = true;

  home.file.".hushlogin".text = ""; # no "Last login" banner

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
      l = "eza -lahF"; # no `ls` override: keeps ls/cat stock so agents aren't confused
      ll = "eza -lahF";
      headers = "httpstat";
      pw = "procs --watch --sortd cpu"; # not named `procs`: that would hang agents
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

      # only from $HOME: never yank a shell that was started inside a project
      [[ $PWD == $HOME && -d ~/projects ]] && cd ~/projects
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
    # needs ~/.ssh/id_ed25519 to exist (see README) or commits will fail
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519.pub";
      signByDefault = true;
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*" = {
      AddKeysToAgent = "yes";
      IgnoreUnknown = "UseKeychain";
      UseKeychain = "yes"; # passphrase lives in the macOS keychain
    };
  };

  # ---------------------------------------------------------------- ghostty
  # installed system-wide in darwin.nix (ghostty-bin); home-manager only writes the config
  programs.ghostty = {
    enable = true;
    package = null;
    installBatSyntax = false;
    settings = {
      font-family = "JetBrainsMono Nerd Font Mono";
      font-size = 15;
      cursor-style = "bar";
      adjust-cursor-thickness = 3;
      shell-integration-features = "no-cursor"; # integration otherwise forces a bar at the prompt
      window-padding-x = 12;
      window-padding-y = 0;
      confirm-close-surface = false;
      macos-option-as-alt = "left";
      macos-titlebar-style = "transparent"; # titlebar takes the background color
      quit-after-last-window-closed = false;

      background = "000000";
      foreground = "d9d7ce";
      cursor-color = "20ffaf";
      selection-background = "343f4c";
      selection-foreground = "212733";
      palette = [
        "0=#191e2a" "8=#686868"
        "1=#F65C5C" "9=#F85E5E"
        "2=#20ffaf" "10=#5bffc4"
        "3=#fad07b" "11=#ffd580"
        "4=#00dbce" "12=#0defe1"
        "5=#c4b2f0" "13=#c4b2f0"
        "6=#91e9ee" "14=#c5fffb"
        "7=#c7c7c7" "15=#ffffff"
      ];
    };
  };

  # ---------------------------------------------------------------- nvim
  # lazy.nvim bootstraps itself; lazy-lock.json stays writable so :Lazy update works
  xdg.configFile."nvim/init.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim/init.lua";
  xdg.configFile."nvim/lazy-lock.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim/lazy-lock.json";
}
