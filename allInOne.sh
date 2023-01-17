#!/bin/bash
#
# run this as root
#
STACKSCRIPT_USERNAME=bunty
LOG_PATH=/root/stackscript.log
logToFile() {
  echo "$USER >> $1" >> $LOG_PATH
}
createUser() {
  logToFile "adding user..."
  # if zsh is installed first does this user take that shell?
  adduser $STACKSCRIPT_USERNAME --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
  echo "$STACKSCRIPT_USERNAME:password" | chpasswd
  usermod -aG sudo $STACKSCRIPT_USERNAME
  cd /home/$STACKSCRIPT_USERNAME
  mkdir .ssh && chown $STACKSCRIPT_USERNAME .ssh && chgrp $STACKSCRIPT_USERNAME .ssh
  cd .ssh
  echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/tgIj/bq5zkqPQhb62bTCXDaxURwozvnv3+is3QH8d/wdAsWQKA1J6TzEPtL7xC01w8Ol42txgmIFeP5UIE/NagLd/5CJX52Z5osmV8ydVP8A1RirODKNeBwpYH9dOvZbsFAq3/bUr4a37TNqe1uJDhjTL2oEA4Z2n1d6dsrnylC3FfFiwfwVqP4t63nh03HaNxKLVzXTC9zIez05H1GfL99f8w7F/Nqyk0NSzzdV2rY4dHVY555fR5m7eyAIW1uGOA9088xUzpTdI9t9x6K8Be06ufqMPynQapHsDwakj3JxFOEX6C09qndNagpBGEdP7wq0uvwI/I3iALXwlLrGs+J3YaxTxmd33ISAz31QFh6hBRDw3S0Oahr7naHq8NYnqTnVW58MZxIylcXybKASFOPSeStqgMT4NYhTtodsSHKCCgkn14tJZvc4VDKNjuqxsQ1cXTGDGBVD1j4wMVQW86X11LcVf95FVDtOVI7ipm3FPAZrjsKkP47Y+YmjpN8= lewis@pop-os" > authorized_keys
  chmod 644 authorized_keys
  logToFile "finished adding user $STACKSCRIPT_USERNAME :)"
}
setupFirewall() {
  logToFile "setting up firewall..."
  ufw allow 22
  ufw allow http
  ufw enable
  logToFile "firewall active :)"
}
cleanup() {
  passwd --expire $STACKSCRIPT_USERNAME
  service sshd restart
  logToFile "set $STACKSCRIPT_USERNAME to require password reset"
}

update() {
  logToFile "running apt-get update..."
  apt-get update -y
  logToFile "running apt-get upgrade..."
  apt-get upgrade -y --force-yes
  logToFile "apt-get updates complete :)"
}

zsh() {
  logToFile "installing zsh..."
  apt-get install zsh -y  
  logToFile "zsh installed :)"
  # change shell for new user
  usermod -s /bin/zsh $STACKSCRIPT_USERNAME
  logToFile "$STACKSCRIPT_USERNAME shell set to zsh :)"
  # run install script as new user
  runuser -l $SCRIPT_USERNAME -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
  logToFile "ohmyzsh installed :)"
}  
docker(){
  logToFile "installing docker..."
  apt-get remove docker docker-engine docker.io containerd runc
  apt-get update
  apt-get install ca-certificates curl gnupg lsb-release -y
  mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
  chmod a+r /etc/apt/keyrings/docker.gpg
  apt-get update 
  apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
  logToFile "docker installed :)"
  usermod -aG docker $STACKSCRIPT_USERNAME
  logToFile "$STACKSCRIPT_USERNAME added to docker group"
}
createUser
setupFirewall
cleanup

update

zsh
docker