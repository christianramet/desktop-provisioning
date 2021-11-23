# Ansible playbook for provisioning a Fedora Workstation

This Ansible project is meant for provisioning a complete workstation for my
personal needs. It is built for a Fedora Workstation version 35 at least, but
should be compatible with other versions with some tweaks.

The bootstrap process makes sure the `ansible` package is already installed with
the required collections. It also create an ssh key if none is present to
allow the usage of `ansible-pull`, and for the various git pulls provided in
some tasks.

# How to use this project

Bootstrap the project for the first time. This script can also be used
everytime, with or without tags as parameters.

`./bootstrap.sh "tag1,tag2"`

Use the playbook locally, with or without tags:

`ansible-playbook --inventory localhost --ask-become-pass <playbook>.yml`

`ansible-playbook --inventory localhost --ask-become-pass <playbook>.yml --tags "tag1,tag2"`

Test the playbook for diagnostics:

`ansible-playbook --ask-become-pass --check <playbook>.yml`
