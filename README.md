# dotfiles
Dotfiles managed by `chezmoi`

# Initial setup
The first run will ask to fill out the `.chezmoi.yaml` settings file. There are two main tags I use which should be exclusive from each set:
* Email address: Main email for this user; used in git config
* Full name: Name of person; used in git config and other places
* Machine type: desktop, laptop, server, or container
* Context: personal or work

Other tags:
* Hackintosh - For use with non-apple hardware
* [workplace] - For use when a tool might be extremely specific to a company and might not carry forward to another job

## MacOS
```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install chezmoi 1password-cli
brew install --cask 1password
eval "$(/opt/homebrew/bin/brew shellenv)"
chezmoi init solarmicrobe/dotfiles
```

## WSL (Ubuntu)
```bash
sudo snap install chezmoi --classic
curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" | \
  sudo tee /etc/apt/sources.list.d/1password.list && \
  sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/ && \
  curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol | \
  sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol && \
  sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22 && \
  curl -sS https://downloads.1password.com/linux/keys/1password.asc | \
  sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg && \
  sudo apt update && sudo apt install 1password-cli
chezmoi init solarmicrobe/dotfiles
```
