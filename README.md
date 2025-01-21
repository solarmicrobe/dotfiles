# dotfiles
Dotfiles managed by `chezmoi`

# Initial setup
The first run will ask to fill out the `.chezmoi.yaml` settings file. There are two main tags I use which should be exclusive from each set:
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
chezmoi
```
