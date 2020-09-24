#!/bin/bash

if ! grep -q pam_tid.so /etc/pam.d/sudo; then
  sudo cp /etc/pam.d/sudo{,.bak}
  sudo bash -c 'echo -e "auth sufficient pam_tid.so\n$(cat /etc/pam.d/sudo)" >/etc/pam.d/sudo'
fi

NEW_HOSTNAME='hamlet'
sudo scutil --set HostName ${NEW_HOSTNAME}
sudo scutil --set LocalHostName ${NEW_HOSTNAME}
sudo scutil --set ComputerName ${NEW_HOSTNAME}
dscacheutil -flushcache

defaults write -g AppleInterfaceStyle Dark

defaults write com.apple.dock orientation left
defaults write com.apple.Dock autohide -bool TRUE
killall Dock

defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
defaults write -g ApplePressAndHoldEnabled 0

defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain NSRecentDocumentsLimit 20

killall Finder

#bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

brew cask install avibrazil-rdm
/Applications/RDM.app/Contents/MacOS/SetResX -w 2880 -h 1800 -s 1.0

# disable macos firewall (prefer little snitch)
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 0

brew install coreutils moreutils findutils gnupg pinentry-mac gnu-sed bash zsh curl dos2unix gettext hugo jq mtr nmap tree pwgen rsync telnet tofrodos watch wget whois
brew install bitwarden-cli git gh tmux vim
brew install azure-cli

brew cask install bitwarden 1password 1password-cli
brew cask install boom-3d charles docker iterm2 istat-menus karabiner-elements little-snitch keepingyouawake moom
brew cask install choosy dropbox fantastical slack vlc zoomus
brew cask install firefox homebrew/cask-versions/firefox-developer-edition
brew cask install gitkraken goland visual-studio-code
brew cask install microsoft-office microsoft-teams omnigraffle spotify
brew cask install parallels the-unarchiver wireshark

brew cask install little-snitch
open /usr/local/Caskroom/little-snitch/*/LittleSnitch-*.dmg

brew install mas
mas install 442160987 # Flycut
mas install 496437906 # Shush
mas install 497799835 # Xcode

brew install dockutil
dockutil --remove Launchpad
dockutil --remove FaceTime
dockutil --remove Maps
dockutil --remove Photos
dockutil --remove Calendar
dockutil --remove Reminders
dockutil --remove Music
dockutil --remove Podcasts
dockutil --remove TV
dockutil --remove News
dockutil --remove App\ Store
dockutil --remove System\ Preferences
dockutil --add /Applications/iTerm.app --position 1
dockutil --add /Applications/Firefox.app --position 2
dockutil --add "/Applications/Firefox Developer Edition.app" --position 3
dockutil --add /Applications/Slack.app --after Safari
dockutil --add /Applications/Fantastical.app --after Mail
dockutil --add /Applications/zoom.us.app --after Fantastical
dockutil --add /Applications/Charles.app

osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Flycut.app", hidden:false}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/iStat Menus.app", hidden:true}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/KeepingYouAwake.app", hidden:false}'
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Moom.app", hidden:true}'

open /Applications/Moom.app
open /Applications/KeepingYouAwake.app
open /Applications/Flycut.app

# small icons in finder

# clone and setup dotfiles
# clone and setup secrets

# gpg --import ~/secrets/gpg/tom@bamford.io.asc
