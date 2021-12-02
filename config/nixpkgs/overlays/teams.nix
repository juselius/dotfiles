self: super:
let
in
{
  teams = super.teams.overrideAttrs (attrs: rec {
      version = "1.4.00.26453";
      src = super.fetchurl {
      url = "https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/teams_${version}_amd64.deb";
      sha256 = "0ndqk893l17m42hf5fiiv6mka0v7v8r54kblvb67jsxajdvva5gf";
      };
  });
}
