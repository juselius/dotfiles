{

    home.file = {
      # ssh = {
      #   source = ~/.dotfiles/ssh;
      #   target = ".ssh";
      #   recursive = true;
      # };
      # gnupg = {
      #   source = ~/.dotfiles/gnupg;
      #   target = ".gnupg";
      #   recursive = true;
      # };
    };

    ssh = {
      matchBlocks = {
        example = {
          user = "example";
          hostname = "example.com";
        };
      };
    };

    git = {
      userEmail = "";
      userName = "";
    };
}
