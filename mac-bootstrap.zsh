#!/bin/zsh

PLAYBOOK=mac-playbook.yml
COLLECTIONS="community.general"
SSH_KEY_NAME=id_ed25519
SSH_KEY_PATH=$HOME/.ssh/$SSH_KEY_NAME
GIT_PROJECT_URL=git@github.com:christianramet/mac-provisioning.git

### Check prerequisites
if xcode-select -p &>/dev/null;then XCODE=installed fi
if pgrep oahd &>/dev/null; then ROSETTA=installed fi
if which brew &>/dev/null; then BREW=installed fi
if which ansible &>/dev/null; then ANSIBLE=installed fi

### Install prerequisites
if [ "$XCODE" != installed ]; then
    xcode-select --install
fi

if [ "$ROSETTA" != installed ]; then
    softwareupdate --install-rosetta --agree-to-license
fi

if [ "$BREW" != installed ]; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/chris/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ "$BREW" = installed && "$ANSIBLE" != installed ]]; then
    brew install ansible
fi

### Check ssh configuration
if [[ ! -e $SSH_KEY_PATH ]]; then
    ssh-keygen -t ed25519 -f "$SSH_KEY_PATH" -N ""
    echo "Import the following key into your remote git account:"
    cat ~/.ssh/$SSH_KEY_NAME.pub
    read "press?Press Enter when done and ready to proceed." </dev/tty
fi

### Execute Ansible payload
if [[ -e $PLAYBOOK ]]; then
    ansible-playbook --inventory localhost \
                     --tags ${1:-all} \
                     $PLAYBOOK
else
    ansible-pull --url $GIT_PROJECT_URL \
                 --accept-host-key \
                 --inventory localhost \
                 --tags ${1:-all} \
                 $PLAYBOOK
fi
