{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "miermontoto";
    userEmail = "mier@mier.info";

    signing = {
      key = null;
      signByDefault = true;
      format = "ssh";
      signer = "${pkgs._1password-gui}/bin/op-ssh-sign";
    };

    extraConfig = {
      credential."https://github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
      credential."https://gist.github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
      push.autoSetupRemote = true;
      pull.rebase = true;
      init.defaultBranch = "main";
      core.pager = "delta";
      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = true;
        dark = true;
      };
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
  };
}
