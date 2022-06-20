#!/bin/bash

# Used for https://github.com/billchurch/webssh2 app on a linux box

startWEBSSH() {
  local NPM=$(which npm)
  ( cd /home/josh/webssh2/app/ && nohup $NPM start & ) > /dev/null 2>&1
}

stopWEBSSH() {
  local SSHPID=$(pgrep node)
  ( kill -9 $SSHPID; sleep .5 ) > /dev/null 2>&1
}

helper() {
   echo "Start and stop the webssh2 node application."
   echo
   echo "Syntax: webssh2 [-h|-s|-q|-r]"
   echo "options:"
   echo "h     Print this Help."
   echo "s     Start webssh2"
   echo "q     Stop webssh2"
   echo "r     Restart webssh2"
   echo
}

while getopts ":hsqr:" option; do
   case $option in
      h)
         helper
         exit;;
      s) 
         startWEBSSH
         exit;;
      q) 
         stopWEBSSH
         exit;;
      r)
         stopWEBSSH && startWEBSSH
         exit;;
     \?)
         echo "Error: Invalid option"
         exit;;
   esac
done
