{ ... }: {
  programs.git = {
    enable = true;
    userName = "artslob";
    userEmail = "artslob@yandex.ru";
    extraConfig = {
      core.editor = "vim";
      core.quotePath = false;
      core.sshCommand = "ssh -i ~/.ssh/id_ed25519";
      init.defaultBranch = "main";
      user.signingkey = "~/.ssh/id_ed25519.pub";
      gpg.format = "ssh";
      commit.gpgsign = true;
    };
    aliases = {
      a = "add";
      au = "add -u";
      c = "commit";
      ca = "commit -a";
      ch = "checkout";
      d = "diff";
      dc = "diff --cached";
      l = "log";
      lol = "log --graph --decorate --pretty=oneline --abbrev-commit";
      lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
      pu = "push";
      s = "status";
      sh = "show";
      sw = "switch";
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
