#!/bin/bash

update() {
  apt-get update --force-yes -y
  apt-get upgrade --force-yes -y
}

zsh() {
  apt-get install zsh -y  
  chsh -s /bin/zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}  

docker(){
  apt-get remove docker docker-engine docker.io containerd runc
  apt-get-update
  apt-get install ca-certificates curl gnupg lsb-release -y

  mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt update
  chmod a+r /etc/apt/keyrings/docker.gpg
  apt-get update
  apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
}


update

docker
zsh
