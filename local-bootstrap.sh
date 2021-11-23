#!/bin/bash
PLAYBOOK=fedora-desktop-playbook.yml
TAGS=$@

if [[ $# -eq 0 ]] ; then
    TAGS=all
fi

ansible-playbook --inventory localhost --ask-become-pass --tags $TAGS $PLAYBOOK
