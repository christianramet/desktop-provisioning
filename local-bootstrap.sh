#!/bin/bash
PLAYBOOK=fedora-desktop-playbook.yml

ansible-playbook --inventory localhost --ask-become-pass --tags ${1:-all} $PLAYBOOK
