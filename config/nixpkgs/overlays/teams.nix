self: super:
let
in
{
  teams = super.teams.overrideAttrs (attrs: rec {
      version = "1.3.00.25560";
      src = super.fetchurl {
      url = "https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/teams_${version}_amd64.deb";
      sha256 = "0kpcd9q6v2qh0dzddykisdbi3djbxj2rl70wchlzrb6bx95hkzmc";
      };
  });
}
