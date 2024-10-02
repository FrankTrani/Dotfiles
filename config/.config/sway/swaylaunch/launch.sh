#!/bin/bash
#sway --unsupported-gpu
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1
export QT_QPA_PLATFORM=wayland
export WLR_NO_HARDWARE_CURSORS=1
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_DESKTOP=sway
export MOZ_WAYLAND=1
export MOZ_ENABLE_WAYLAND=1
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export GDK_BACKEND="wayland,x11"
# export __GL_GSYNC_ALLOWED=0
# export __GL_VRR_ALLOWED=0
# export WLR_DRM_NO_ATOMIC=1
export GBM_BACKEND=nvidia-drm
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export QT_QPA_PLATFORMTHEME=qt5ct
export LIBVA_DRIVER_NAME=nvidia
export LIBGL_ALWAYS_SOFTWARE=1
sway --unsupported-gpu
