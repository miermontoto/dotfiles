{ pkgs, ... }:
{
  programs.gh = {
    enable = true;
    # registra helpers credential.https://github.com y credential.https://gist.github.com automáticamente
    gitCredentialHelper.enable = true;
    settings.aliases.co = "pr checkout";
  };

  programs.delta = {
    enable = true;
    options = {
      navigate = true;
      dark = true;
    };
  };

  programs.git = {
    enable = true;

    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDFkLofLDr4kfFlnYm0G3p8Axhstz7x+1C6Gw8fRaqCA";
      signByDefault = true;
      format = "ssh";
      signer = "${pkgs._1password-gui}/bin/op-ssh-sign";
    };

    settings = {
      user = {
        name = "miermontoto";
        email = "mier@mier.info";
      };

      credential.helper = "store";
      push.autoSetupRemote = true;
      pull.rebase = true;
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
    };
  };
}
