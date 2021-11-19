# How to use this project

Normal usage:
ansible-playbook --ask-become-pass <playbook>.yml
ansible-playbook --ask-become-pass <playbook>.yml --tags apps

Test:
ansible-playbook --ask-become-pass --check <playbook>.yml

Bootstrap:
./bootstrap.sh
