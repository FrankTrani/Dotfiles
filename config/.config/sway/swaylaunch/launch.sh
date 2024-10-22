#!/bin/bash
export MOZ_WAYLAND=1
export MOZ_ENABLE_WAYLAND=1
export LIBVA_DRIVER_NAME=nvidia
export XDG_SESSION_TYPE=wayland
export GBM_BACKEND=nvidia-drm
export XDG_CURRENT_DESKTOP=sway
export GDK_BACKEND=wayland
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export WLR_RENDERER=vulcan
export WLR_NO_HARDWARE_CURSORS=1
sway --unsupported-gpu
