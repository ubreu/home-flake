{pkgs, lib, config, ...}: with lib; {
    home.username = "ubreu";
    home.homeDirectory = "/Users/ubreu";
    home.stateVersion = "22.05";
    
    programs.home-manager.enable = true;

    programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableAutosuggestions = true;

        sessionVariables = {
            EDITOR = "vim";
            COPYFILE_DISABLE=true;
            LANG="en_US.UTF-8";
            LC_ALL="en_US.UTF-8";
            NVM_DIR="~/.nvm";
        };

        shellAliases = {
            burp="brew update && brew upgrade --greedy";
            c="code";
            cp="cp -i";
            d="docker";
            dl="cd ~/Downloads/;ls -latr";
            dk="cd ~/Desktop/;ls -latr";
            d2t="date +%s";
            gitclean="git branch --merged $(git rev-parse --abbrev-ref HEAD) | grep -v $(git rev-parse --abbrev-ref HEAD) | grep -v master | xargs -n1 git branch -d";
            hg="history | rg -N";
            k="kubectl --insecure-skip-tls-verify";
            kc="kubectl config";
            l="ls -la";
            lt="ls -latr";
            mount-home="open smb://fshome/home";
            mount-data="open smb://fsdata/data";
            mount-docs="open smb://fsdocs/docs";
            mount-projects="open smb://fsprojects/projects";
            mount-pd="open smb://fspd/pd";
            mv="mv -i";
            nocors="open /Applications/Google\ Chrome.app -n --args --user-data-dir=`mktemp -d` --disable-web-security";
            sn="spotify next";
            ss="spotify status";
            sp="spotify pause";
            stree="/Applications/SourceTree.app/Contents/Resources/stree";
            t2d="date -j -f %s";
        };

        initExtra = ''
        jdk() {
            version=$1
            export JAVA_HOME=$(/usr/libexec/java_home -v"$version");
            java -version
        }

        function dlog () {
            command grep -i $1 ~/Documents/logbooks/ -r | sort
        }

        function conn () {
            nc -w 5 -v localhost $1 </dev/null; echo $?
        }

        source $(brew --prefix nvm)/nvm.sh
        source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        export PATH="/nix/var/nix/profiles/default/bin:$PATH"
        '';

        oh-my-zsh = {
            enable = true;
            plugins = ["git" "sudo" "docker" "kubectl" "macos" "wd"];
            theme = "af-magic";
        };
    };

    programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableZshIntegration = config.programs.zsh.enable;
        stdlib = ''
            : ''${XDG_CACHE_HOME:=$HOME/.cache}
            declare -A direnv_layout_dirs
            direnv_layout_dir() {
            echo "''${direnv_layout_dirs[$PWD]:=$(
                echo -n "$XDG_CACHE_HOME"/direnv/layouts/
                echo -n "$PWD" | shasum | cut -d ' ' -f 1
                )}"
            }
        '';
    };

    programs.git = {
        enable = true;
        userName = "Urs Breu";
        delta.enable = true;
        delta.options = {dark = true;};
        ignores = [
            ".old"
            ".tmp"
            "*~"
            ".DS_Store"
        ];
    };
}