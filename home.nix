{pkgs, lib, config, ...}: with lib; {
    home.username = "ubreu";
    home.homeDirectory = "/Users/ubreu";
    home.stateVersion = "22.05";
    
    home.packages = with pkgs; [
        du-dust
        exa
        jq
        ripgrep
        unixtools.watch
    ];

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
        };

        shellAliases = {
            burp="brew update && brew upgrade";
            c="/Applications/Visual\\ Studio\\ Code.app/Contents/Resources/app/bin/code";
            cp="cp -i";
            d="docker";
            dl="cd ~/Downloads/;exa --long --git";
            dk="cd ~/Desktop/;exa --long --git";
            d2t="date +%s";
            gitclean="git branch --merged $(git rev-parse --abbrev-ref HEAD) | grep -v $(git rev-parse --abbrev-ref HEAD) | grep -v master | xargs -n1 git branch -d";
            hg="history | rg -N";
            k="kubectl --insecure-skip-tls-verify";
            kc="kubectl config";
            l="exa -a --long --git";
            lt="exa -a --long --git --sort=newest";
            mount-home="open smb://fshome/home";
            mount-data="open smb://fsdata/data";
            mount-docs="open smb://fsdocs/docs";
            mount-projects="open smb://fsprojects/projects";
            mount-pd="open smb://fspd/pd";
            mv="mv -i";
            nocors="open /Applications/Google\\ Chrome.app -n --args --user-data-dir=`mktemp -d` --disable-web-security";
            sha1sum="shasum";
            sn="spotify next";
            ss="spotify status";
            sp="spotify pause";
            stree="/Applications/SourceTree.app/Contents/Resources/stree";
            t2d="date -j -f %s";
            tree="exa -a --tree";
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

        source /nix/var/nix/profiles/default/etc/profile.d/nix.sh
        export PATH="/nix/var/nix/profiles/default/bin:$PATH"
        # Set PATH, MANPATH, etc., for Homebrew.
        eval "$(/opt/homebrew/bin/brew shellenv)"

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
        userEmail = "urs.breu@ergon.ch";
        delta.enable = true;
        delta.options = {dark = true;};
        ignores = [
            ".old"
            ".tmp"
            "*~"
            ".DS_Store"
            ".vscode/*"
            "!.vscode/settings.json"
            "!.vscode/tasks.json"
            "!.vscode/launch.json"
            "!.vscode/extensions.json"
            "!.vscode/*.code-snippets"
            ".history/"
            ".idea/**/workspace.xml"
            ".idea/**/tasks.xml"
            ".idea/**/usage.statistics.xml"
            ".idea/**/dictionaries"
            ".idea/**/shelf"
            ".idea/**/dataSources/"
            ".idea/**/dataSources.ids"
            ".idea/**/dataSources.local.xml"
            ".idea/**/sqlDataSources.xml"
            ".idea/**/dynamic.xml"
            ".idea/**/uiDesigner.xml"
            ".idea/**/dbnavigator.xml"
            ".idea/**/gradle.xml"
            ".idea/**/libraries"
        ];
        aliases = {
            what = "log --author=urs --pretty=format:'%h - %an, %>(14)%ar : %s'";
            releasenotes = "log --date=short --pretty=format:'%h | %<(15,trunc)%an | %ad | %<(100,trunc)%s'";
            ci = "commit";
	        co = "checkout";
            df = "diff";
            dc = "diff --cached";
            lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(normal)%s%C(reset) %C(dim normal)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
            ls = "log --pretty=format:%C(green)%h\\ %C(yellow)[%ad]%Cred%d\\ %Creset%s%Cblue\\ [%an] --decorate --date=relative";
            ll = "log --pretty=format:%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [a:%an,c:%cn] --decorate --numstat";
            st = "status";
        };
    };
}
