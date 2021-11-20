#!/bin/bash
GIT_PROJECT_URL=git@github.com:christianramet/fedora-provisioning.git
PLAYBOOK=fedora-desktop-playbook.yml
TAGS=$@

if [[ $# -eq 0 ]] ; then
    TAGS=all
fi

REQUIREMENTS="ansible git"

SSH_KEY_NAME=$USER@$HOSTNAME
SSH_KEY_PATH=$HOME/.ssh/$SSH_KEY_NAME

# Check prerequisites
if ! $(rpm -q $REQUIREMENTS &> /dev/null); then
    sudo dnf install -y $REQUIREMENTS
fi

ansible-galaxy collection install community.general

# Check ssh configuration
if ! [[ -e $SSH_KEY_PATH ]]; then
    ssh-keygen -t ed25519 -f "$SSH_KEY_PATH" -N ""
    echo "Import the following key into your remote git account:"
    cat ~/.ssh/$SSH_KEY_NAME.pub
    read -p "Press Enter when done and ready to proceed with ansible-pull." </dev/tty
fi

# Execute Ansible payload
ssh-add $SSH_KEY_PATH
ansible-pull --url $GIT_PROJECT_URL \
             --accept-host-key \
             --ask-become-pass \
             --inventory localhost \
             --tags $TAGS \
             $PLAYBOOK
