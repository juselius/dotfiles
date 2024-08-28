self: super:
let
in
{
  teams = super.teams.overrideAttrs (attrs: rec {
      version = "1.5.00.23861";
      src = super.fetchurl {
      url = "https://packages.microsoft.com/repos/ms-teams/pool/main/t/teams/teams_${version}_amd64.deb";
      sha256 = "sha256-h0YnCeJX//l4TegJVZtavV3HrxjYUF2Fa5KmaYmZW8E=";
      };
  });
}
