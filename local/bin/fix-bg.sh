#!/bin/bash
# vim:ft=sh

dconf write /org/gnome/desktop/background/show-desktop-icons true
sleep 1
dconf write /org/gnome/desktop/background/show-desktop-icons false

