#!/bin/bash


init(){
  apt-get remove docker docker-engine docker.io containerd runc

  apt-get update -y
  apt-get upgrade -y
}

zsh() {
  apt-get install zsh
  chsh -s /bin/zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}  

docker(){
  apt-get install ca-certificates curl gnupg lsb-release

  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt update
  chmod a+r /etc/apt/keyrings/docker.gpg
  apt-get update
  apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
}

user() {
  adduser dandy --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
  echo "dandy:password" | chpasswd
  usermod -aG sudo dandy
  su - dandy

  mkdir ~/.ssh 
  cd ~/.ssh
  echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/tgIj/bq5zkqPQhb62bTCXDaxURwozvnv3+is3QH8d/wdAsWQKA1J6TzEPtL7xC01w8Ol42txgmIFeP5UIE/NagLd/5CJX52Z5osmV8ydVP8A1RirODKNeBwpYH9dOvZbsFAq3/bUr4a37TNqe1uJDhjTL2oEA4Z2n1d6dsrnylC3FfFiwfwVqP4t63nh03HaNxKLVzXTC9zIez05H1GfL99f8w7F/Nqyk0NSzzdV2rY4dHVY555fR5m7eyAIW1uGOA9088xUzpTdI9t9x6K8Be06ufqMPynQapHsDwakj3JxFOEX6C09qndNagpBGEdP7wq0uvwI/I3iALXwlLrGs+J3YaxTxmd33ISAz31QFh6hBRDw3S0Oahr7naHq8NYnqTnVW58MZxIylcXybKASFOPSeStqgMT4NYhTtodsSHKCCgkn14tJZvc4VDKNjuqxsQ1cXTGDGBVD1j4wMVQW86X11LcVf95FVDtOVI7ipm3FPAZrjsKkP47Y+YmjpN8= lewis@pop-os" > authorized_keys

  chmod 644 ~/.ssh/authorized_keys
}

cleanup() {
  exit
  passwd --expire dandy
  service sshd restart
}


init
# user
zsh
docker
# cleanup
