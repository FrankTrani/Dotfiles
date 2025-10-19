#!/usr/bin/env bash
set -euo pipefail

# Detect any JetBrainsMono Nerd Font family (covers JetBrainsMono, JetBrainsMonoNL, Mono variants)
if ! fc-list | grep -qiE 'JetBrainsMono.*Nerd Font'; then
  echo "JetBrainsMono Nerd Font not found. Install a Nerd Font variant (e.g., JetBrainsMono Nerd Font)." >&2
  exit 1
fi

FONT_FAMILY='JetBrainsMono Nerd Font'
FONT_SIZE_NUM='12'
FONT_CSS="$FONT_FAMILY"
FONT_GUI="$FONT_FAMILY:h$FONT_SIZE_NUM"

echo "Setting $FONT_FAMILY as default where applicable…"

# --- Kitty ---
kitty_cfg="$HOME/.config/kitty/kitty.conf"
mkdir -p "$(dirname "$kitty_cfg")"
touch "$kitty_cfg"
# Replace or add font_family
if grep -qi '^font_family' "$kitty_cfg"; then
  sed -i -E "s|^font_family.*$|font_family $FONT_FAMILY|i" "$kitty_cfg"
else
  printf "font_family %s\n" "$FONT_FAMILY" >> "$kitty_cfg"
fi
# Optional: keep weights consistent if user has them
for k in bold_font italic_font bold_italic_font; do
  if ! grep -qi "^$k" "$kitty_cfg"; then
    printf "%s %s\n" "$k" "$FONT_FAMILY" >> "$kitty_cfg"
  fi
done
echo "[kitty] configured."

# --- Waybar (CSS, not JSON) ---
waybar_css="$HOME/.config/waybar/style.css"
mkdir -p "$(dirname "$waybar_css")"
if [[ -f "$waybar_css" ]]; then
  # Ensure a universal font-family rule exists or replace existing in a universal block
  if grep -q '^\s*\*\s*{' "$waybar_css"; then
    # inside the first universal block, replace/add font-family
    awk -v repl="  font-family: \"$FONT_CSS\", monospace;" '
      BEGIN{inblock=0; done=0}
      /^\s*\*\s*\{/ {inblock=1}
      inblock && /^\s*font-family:/ { $0=repl; done=1 }
      { print }
      inblock && /^\s*\}/ {
        if(!done){ print repl }
        inblock=0
      }
    ' "$waybar_css" > "$waybar_css.tmp" && mv "$waybar_css.tmp" "$waybar_css"
  else
    # prepend a universal rule
    printf "/* font injected */\n* {\n  font-family: \"%s\", monospace;\n}\n\n" "$FONT_CSS" | cat - "$waybar_css" > "$waybar_css.tmp" && mv "$waybar_css.tmp" "$waybar_css"
  fi
else
  cat > "$waybar_css" <<EOF
/* Generated */
* {
  font-family: "$FONT_CSS", monospace;
}
EOF
fi
echo "[waybar] configured."

# --- Rofi (Wayland) .rasi config ---
rofi_cfg="$HOME/.config/rofi/config.rasi"
mkdir -p "$(dirname "$rofi_cfg")"
if [[ -f "$rofi_cfg" ]]; then
  # If a configuration block exists, set font there; else add a theme-wide rule
  if grep -q 'configuration\s*{' "$rofi_cfg"; then
    # replace or insert font in configuration { }
    awk -v font="  font: \"$FONT_FAMILY $FONT_SIZE_NUM\";" '
      BEGIN{inconf=0; have=0}
      /configuration[[:space:]]*\{/ {inconf=1}
      inconf && /^[[:space:]]*font:/ { $0=font; have=1 }
      { print }
      inconf && /^\}/ { if(!have){ print font } inconf=0 }
    ' "$rofi_cfg" > "$rofi_cfg.tmp" && mv "$rofi_cfg.tmp" "$rofi_cfg"
  else
    # add a universal theme rule
    printf '/* font injected */\n* { font: "%s %s"; }\n\n' "$FONT_FAMILY" "$FONT_SIZE_NUM" | cat - "$rofi_cfg" > "$rofi_cfg.tmp" && mv "$rofi_cfg.tmp" "$rofi_cfg"
  fi
else
  cat > "$rofi_cfg" <<EOF
/* Generated */
configuration {
  font: "$FONT_FAMILY $FONT_SIZE_NUM";
}
EOF
fi
echo "[rofi] configured."

# --- Neovim (GUI frontends only: neovide, nvim-qt, goneovim) ---
nvim_dir="$HOME/.config/nvim"
mkdir -p "$nvim_dir"
if [[ -f "$nvim_dir/init.lua" ]]; then
  # Replace existing guifont or append
  if grep -q 'vim\.opt\.guifont' "$nvim_dir/init.lua"; then
    sed -i -E "s|vim\.opt\.guifont\s*=.*|vim.opt.guifont = \"$FONT_GUI\"|" "$nvim_dir/init.lua"
  else
    printf '\n-- font injected\vim.opt.guifont = "%s"\n' "$FONT_GUI" >> "$nvim_dir/init.lua"
  fi
elif [[ -f "$nvim_dir/init.vim" ]]; then
  if grep -qi '^set\s\+guifont=' "$nvim_dir/init.vim"; then
    sed -i -E "s|^set\s+guifont=.*$|set guifont=%s|" "$nvim_dir/init.vim"
    # re-run with a literal to avoid printf-style expansion
    sed -i "s|^set guifont=.*$|set guifont=$(printf %s "$FONT_FAMILY" | sed 's/ /\\ /g'):h$FONT_SIZE_NUM|" "$nvim_dir/init.vim"
  else
    printf 'set guifont=%s:h%s\n' "$(printf %s "$FONT_FAMILY" | sed 's/ /\\ /g')" "$FONT_SIZE_NUM" >> "$nvim_dir/init.vim"
  fi
else
  # default to Lua
  printf 'vim.opt.guifont = "%s"\n' "$FONT_GUI" > "$nvim_dir/init.lua"
fi
echo "[nvim GUI] configured."

# --- Dunst ---
dunst_cfg="$HOME/.config/dunst/dunstrc"
mkdir -p "$(dirname "$dunst_cfg")"
if [[ -f "$dunst_cfg" ]]; then
  if grep -q '^font\s*=' "$dunst_cfg"; then
    sed -i -E "s|^font\s*=.*$|font = $FONT_FAMILY $FONT_SIZE_NUM|" "$dunst_cfg"
  else
    # Insert under [global] if present; otherwise append at end
    if grep -q '^\[global\]' "$dunst_cfg"; then
      awk -v line="font = $FONT_FAMILY $FONT_SIZE_NUM" '
        BEGIN{printed=0}
        { print }
        /^\[global\]$/ && !printed { print line; printed=1 }
      ' "$dunst_cfg" > "$dunst_cfg.tmp" && mv "$dunst_cfg.tmp" "$dunst_cfg"
    else
      printf "\n[global]\nfont = %s %s\n" "$FONT_FAMILY" "$FONT_SIZE_NUM" >> "$dunst_cfg"
    fi
  fi
else
  cat > "$dunst_cfg" <<EOF
# Generated
[global]
font = $FONT_FAMILY $FONT_SIZE_NUM
EOF
fi
echo "[dunst] configured."

# --- Starship (optional; Nerd Font only affects glyph rendering) ---
starship_cfg="$HOME/.config/starship.toml"
mkdir -p "$(dirname "$starship_cfg")"
touch "$starship_cfg"
# leave user config; ensure a glyph to verify NF rendering if empty
if ! grep -q '^\[character\]' "$starship_cfg"; then
  cat >> "$starship_cfg" <<'EOF'

# Generated (uses Nerd Font glyphs)
[character]
success_symbol = "[❯](bold)"
error_symbol = "[✗](bold)"
EOF
fi
echo "[starship] configured."

echo "Done. JetBrainsMono Nerd Font applied to Kitty, Waybar, Rofi, Neovim (GUI), Dunst, and Starship."
