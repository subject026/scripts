#!/bin/bash

createFile() {
  echo "Creating stacklog file"
  touch /root/stacklog.txt
  echo "> created logfile!" >> /root/stacklog.txt
}

initLogs() {
  createFile
  echo "> initialized logs!" >> /root/stacklog.txt
}

user() {
  echo "> adding user..." >> /root/stacklog.txt
  # if zsh is installed first does this user take that shell?
  adduser bunty --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
  echo "bunty:password" | chpasswd
  usermod -aG sudo bunty
  cd /home/bunty

  mkdir .ssh && chown bunty .ssh && chgrp bunty .ssh
  cd .ssh
  echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/tgIj/bq5zkqPQhb62bTCXDaxURwozvnv3+is3QH8d/wdAsWQKA1J6TzEPtL7xC01w8Ol42txgmIFeP5UIE/NagLd/5CJX52Z5osmV8ydVP8A1RirODKNeBwpYH9dOvZbsFAq3/bUr4a37TNqe1uJDhjTL2oEA4Z2n1d6dsrnylC3FfFiwfwVqP4t63nh03HaNxKLVzXTC9zIez05H1GfL99f8w7F/Nqyk0NSzzdV2rY4dHVY555fR5m7eyAIW1uGOA9088xUzpTdI9t9x6K8Be06ufqMPynQapHsDwakj3JxFOEX6C09qndNagpBGEdP7wq0uvwI/I3iALXwlLrGs+J3YaxTxmd33ISAz31QFh6hBRDw3S0Oahr7naHq8NYnqTnVW58MZxIylcXybKASFOPSeStqgMT4NYhTtodsSHKCCgkn14tJZvc4VDKNjuqxsQ1cXTGDGBVD1j4wMVQW86X11LcVf95FVDtOVI7ipm3FPAZrjsKkP47Y+YmjpN8= lewis@pop-os" > authorized_keys

  chmod 644 authorized_keys
  echo "> finished adding user :)" >> /root/stacklog.txt
}

cleanup() {
  passwd --expire bunty
  service sshd restart
}

initLogs
user
cleanup
