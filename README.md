# My Dotfiles

Welcome to my **Dotfiles** repository! This is where I store the configuration files and scripts that shape my personalized Linux environment, optimized for Wayland with Sway and various custom setups. Feel free to explore, adapt, and contribute!

## Setup

These Dotfiles are managed using **GNU Stow** to keep everything modular and organized. To install, clone this repository and use `stow` to create symlinks for the configurations you need.

### Prerequisites

Make sure you have `stow` installed:

```bash
sudo pacman -S stow
```

### Installation

- Clone the repository to your home directory:

   ```bash
   git clone https://github.com/FrankTrani/dotfiles.git ~/dotfiles
   cd ~/Dotfiles
   ```

- Run install command. :

   ```bash
   scripts/run.sh
   ```
   #### The scripts are still a work in progress and might not work as expected


## License

This project is open-source and available under the [GNU GENERAL PUBLIC LICENSE](LICENSE).
