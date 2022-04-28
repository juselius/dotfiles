self: super:
let
in
{
  teams = super.teams.overrideAttrs (attrs: rec {
      version = "1.5.00.10453";
      src = super.fetchurl {
      url = "https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/teams_${version}_amd64.deb";
      sha256 = "1w0midg7rnxj5wdk9rcgqmimhd70n47qwww4d9pfncajmkcp1dbw";
      };
  });
}
