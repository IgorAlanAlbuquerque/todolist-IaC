#!/bin/bash
# Atualize os pacotes
sudo apt-get update -y

# Instale Python 3, pip3 e o pacote para garantir que `python` aponte para `python3`
sudo apt-get install -y python3 python3-pip python-is-python3

# Instale o Ansible
sudo pip3 install ansible

# Instale o pacote `six` globalmente
sudo pip3 install six
