#!/usr/bin/env bash

LUKS_PART=/dev/sda1

KEY_LENGTH=512
ITERATIONS=1000000
STORAGE=/boot/crypt-storage/default

# SLOT=2
# ykpersonalize -"$SLOT" -ochal-resp -ochal-hmac

rbtohex() {
    ( od -An -vtx1 | tr -d ' \n' )
}

hextorb() {
    ( tr '[:lower:]' '[:upper:]' | sed -e 's/\([0-9A-F]\{2\}\)/\\\\\\x\1/gI'| xargs printf )
}

pbkdf2=~/.dotfiles/scripts/pbkdf2-sha512

compile_pbkdf2 () {
    cc -O3 \
       -I$(nix-build "<nixpkgs>" --no-build-output -A openssl.dev)/include \
       -L$(nix-build "<nixpkgs>" --no-build-output -A openssl.out)/lib \
       $(nix eval "(with import <nixpkgs> {}; pkgs.path)")/nixos/modules/system/boot/pbkdf2-sha512.c \
       -o $pbkdf2 -lcrypto
}

[ ! -x $pbkdf2 ] && compile_pbkdf2

create_salt () {
    SALT_LENGTH=16
    salt="$(dd if=/dev/random bs=1 count=$SALT_LENGTH 2>/dev/null | rbtohex)"
    sudo mkdir -p "$(dirname $STORAGE)"
    sudo sh -c "echo -ne \"$salt\n$ITERATIONS\" > $STORAGE"
}

[ ! -f $STORAGE ] && create_salt

salt=$(head -1 $STORAGE)
challenge="$(echo -n $salt | openssl dgst -binary -sha512 | rbtohex)"
response="$(ykchalresp -2 -x $challenge 2>/dev/null)"

k_luks="$(echo | $pbkdf2 $(($KEY_LENGTH / 8)) $ITERATIONS $response | rbtohex)"

k_tmp=/tmp/k_luks.$$
echo -n "$k_luks" | hextorb > $k_tmp

# sudo cryptsetup luksFormat --key-file=$k_tmp "$LUKS_PART"

sudo cryptsetup luksAddKey $LUKS_PART $k_tmp
# rm $k_tmp

#echo -n "$k_luks" | hextorb | cryptsetup luksOpen $LUKS_PART $LUKSROOT --key-file=-
