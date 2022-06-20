#!/bin/bash
YLW='\033[1;33m'
CYAN='\033[1;36m'
GRN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'
DIR=/home/josh/compose

# Step through every dir with a docker-compose.yml file then update and restart the container

docker_pull() {
  for i in ./*/; do 
    cd $i
    local CDIR=$(pwd | rev | cut -d / -f 1 | rev)
    echo -e "${YLW}Pulling the latest update for ${CYAN}$CDIR ${NC}" 
    docker-compose pull
    echo 
    cd .. 
  done
}

docker_update() {
  for i in ./*/; do 
    cd $i
    local CDIR=$(pwd | rev | cut -d / -f 1 | rev)
    echo -e "${YLW}Applying an update to ${CYAN}$CDIR${YLW} if there is one. ${NC}" 
    docker-compose up -d
    echo
    cd .. 
  done
}

docker_prune() {
  echo -e "${YLW}Pruning unused images from the system. ${NC}"
  docker system prune -af
  echo
}

if [ -d != $DIR ]; then
  cd $DIR
fi

if (( $EUID != 0 )); then
  echo -e "Run this as ${RED}sudo/root. ${NC}" 
  exit 1
else
  docker_pull
  docker_update
  docker_prune
  echo -e "${GRN}Done!${NC}"
  exit
fi
