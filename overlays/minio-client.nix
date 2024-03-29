self: super:
let
  minio-client = { stdenv, buildGoModule, fetchFromGitHub }:

  buildGoModule rec {
    pname = "minio-client";
    version = "2022-03-17T20-25-06Z";

    src = fetchFromGitHub {
      owner = "minio";
      repo = "mc";
      rev = "RELEASE.${version}";
      sha256 = "15bkl3q0jidrwy04l0cdmha43r9wlxmlqkhmwz98b57rjrq6grql";
    };

    vendorHash = "1fsx8zl2qkyf1gx3s6giccd86xawx9d1h4jdnyn1m36clsq9jkpc";

    doCheck = false;

    subPackages = [ "." ];

    patchPhase = ''
      sed -i "s/Version.*/Version = \"${version}\"/g" cmd/build-constants.go
      sed -i "s/ReleaseTag.*/ReleaseTag = \"RELEASE.${version}\"/g" cmd/build-constants.go
      sed -i "s/CommitID.*/CommitID = \"${src.rev}\"/g" cmd/build-constants.go
    '';

    meta = with super.lib; {
      homepage = "https://github.com/minio/mc";
      description = "A replacement for ls, cp, mkdir, diff and rsync commands for filesystems and object storage";
      maintainers = with maintainers; [ eelco bachp ];
      platforms = platforms.unix;
      license = licenses.asl20;
    };
  };
in
  {
    minio-client = minio-client {
      stdenv = super.stdenv;
      buildGoModule = super.buildGoModule;
      fetchFromGitHub = super.fetchFromGitHub;
    };
  }
