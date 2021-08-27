self: super:
let
in
{
  teams = super.teams.overrideAttrs (attrs: rec {
      version = "1.4.00.13653";
      src = super.fetchurl {
      url = "https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/teams_${version}_amd64.deb";
      sha256 = "1kx4j837fd344zy90nl0j3r8cdvihy6i6gf56wd5n56zngx1fhjv";
      };
  });
}
