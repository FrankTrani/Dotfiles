#!/bin/bash
export MOZ_WAYLAND=1
export MOZ_ENABLE_WAYLAND=1
axport LIBVA_DRIVER_NAME=nvidia
export XDG_SESSION_TYPE=wayland
export GBM_BACKEND=nvidia-drm
export XDG_CURRENT_DESKTOP=sway
export GDK_BACKEND=wayland
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export WLR_RENDERER=vulcan
export WLR_NO_HARDWARE_CURSORS=1
#export WLR_DRM_NO_MODIFIERS=1
export TF_ENABLE_ONEDNN_OPTS=0
export QT_QPA_PLATFORM=xcb
sway --unsupported-gpu
