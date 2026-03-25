#!/bin/sh

hyprctl --instance 0 'keyword misc:allow_session_lock_restore 0'
hyprctl --instance 0 'dispatch exec hyprlock'
