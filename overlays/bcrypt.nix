self: super:
let
  version = "1.0.0";
  python = super.python3.withPackages (ps: with ps; [ passlib ]);

in {
  bcrypt = super.stdenv.mkDerivation {
      name = "bcrypt-${version}";

      unpackPhase = "true";
      buildCommand = ''
        . $stdenv/setup

        mkdir -p $out/bin
        echo "#!${python}/bin/python3" > $out/bin/bcrypt
        echo "from passlib.hash import bcrypt" >> $out/bin/bcrypt
        echo "import getpass" >> $out/bin/bcrypt
        echo 'print(bcrypt.using(rounds=12, ident="2y").hash(getpass.getpass()))' >> $out/bin/bcrypt
        chmod 755 $out/bin/bcrypt
      '';

      buildInputs = with super; [ python ];
  };
}
