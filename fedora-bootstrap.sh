#!/bin/bash

PLAYBOOK=fedora-playbook.yml
PACKAGES="ansible git"
COLLECTIONS="community.general"
SSH_KEY_NAME=id_ed25519
SSH_KEY_PATH=$HOME/.ssh/$SSH_KEY_NAME
GIT_PROJECT_URL=git@github.com:christianramet/fedora-provisioning.git

### Check and install prerequisites
if ! $(rpm -q $PACKAGES &> /dev/null); then
    sudo dnf install -y $PACKAGES
fi

ansible-galaxy collection install $COLLECTIONS

#### Check ssh configuration
if ! [[ -e $SSH_KEY_PATH ]]; then
    ssh-keygen -t ed25519 -f "$SSH_KEY_PATH" -N ""
    echo "Import the following key into your remote git account:"
    cat ~/.ssh/$SSH_KEY_NAME.pub
    read -p "Press Enter when done and ready to proceed with Ansible." </dev/tty
fi

ssh-add $SSH_KEY_PATH

### Execute Ansible payload
if [[ -e $PLAYBOOK ]]; then
    ansible-playbook --ask-become-pass \
                     --inventory localhost \
                     --tags ${1:-all} \
                     $PLAYBOOK
else
    ansible-pull --url $GIT_PROJECT_URL \
                 --accept-host-key \
                 --ask-become-pass \
                 --inventory localhost \
                 --tags ${1:-all} \
                 $PLAYBOOK
fi
