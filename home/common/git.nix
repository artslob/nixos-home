{ ... }: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "artslob";
        email = "artslob@yandex.ru";
      };
      core.editor = "vim";
      core.quotePath = false;
      core.sshCommand = "ssh -i ~/.ssh/id_ed25519";
      init.defaultBranch = "main";
      user.signingkey = "~/.ssh/id_ed25519.pub";
      gpg.format = "ssh";
      commit.gpgsign = true;
      alias = {
        a = "add";
        au = "add -u";
        c = "commit";
        ca = "commit -a";
        ch = "checkout";
        d = "diff";
        dc = "diff --cached";
        fe = "fetch";
        l = "log";
        ll =
          "log --pretty=format:'%C(yellow)%h%C(reset) %C(blue)%ad%C(reset) %C(green)%an%C(reset) %s' --date=format:'%a %b %d %H:%M:%S %Y %z'";
        lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
        lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
        pl = "pull";
        pu = "push";
        re = "restore";
        s = "status";
        sh = "show";
        sw = "switch";
      };
    };
    includes = [{
      condition = "gitdir:~/onside/";
      contents = {
        user = {
          name = "artem.s";
          email = "artem.s@onside.io";
          signingkey = "~/.ssh/onside/id_ed25519.pub";
        };
        core.sshCommand = "ssh -i ~/.ssh/onside/id_ed25519";
        gpg.format = "ssh";
        commit.gpgsign = true;
      };
    }];
  };
}
