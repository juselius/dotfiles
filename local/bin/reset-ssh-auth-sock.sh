#!/bin/sh

export SSH_AUTH_SOCK=$(fd --owner jonas agent.\* /tmp/ssh-* | head -1)
