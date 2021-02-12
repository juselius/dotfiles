self: super:
let
in
{
  teams = super.teams.overrideAttrs (attrs: rec {
      version = "1.3.00.30857";
      src = super.fetchurl {
      url = "https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/teams_${version}_amd64.deb";
      sha256 = "06r48h1fr2si2g5ng8hsnbcmr70iapnafj21v5bzrzzrigzb2n2h";
      };
  });
}
