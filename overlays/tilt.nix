self: super:
{
  tilt = super.tilt.overrideAttrs (attrs: rec {
      version = "0.33.4";

      src = super.fetchFromGitHub {
          owner  = "tilt-dev";
          repo   = attrs.pname;
          rev    = "v${version}";
          sha256 = "sha256-rQ5g5QyGyuJAHmE8zGFzqtpqW2xEju5JV386y9Cn+cs=";
      };
  });
}
