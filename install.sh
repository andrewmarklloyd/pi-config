#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

config_auth() {
  printf "\n${CYAN}Enter the Heroku app name that contains the configuration secrets: ${NC}"
  read HEROKU_APP
  if [[ -z ${HEROKU_APP} ]]; then
    return 1
  else
    printf "\n${CYAN}Enter the Heroku API key: ${NC}"
    read -s HEROKU_API_KEY
    tokenCheckError=$(curl -s -n https://api.heroku.com/apps/${HEROKU_APP}/config-vars \
      -H "Accept: application/vnd.heroku+json; version=3" \
      -H "Authorization: Bearer ${HEROKU_API_KEY}" | jq -r '.id')
    if [[ ${tokenCheckError} != "null" ]]; then
      printf "\n${RED}Unable to authenticate with Heroku, received error '${tokenCheckError}'${NC}\n\n"
      return 1
    else
      printf "\n\n${GREEN}Successfully authenticated with Heroku${NC}\n\n"
      return 0
    fi
  fi
}

sudo apt-get update
sudo apt-get install -y jq

until config_auth; do : ; done

curl -O -s -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/andrewmarklloyd/pi-config/main/assets/app.service.tmpl
curl -O -s -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/andrewmarklloyd/pi-config/main/assets/config-app.sh

# use ~ as a delimiter
sed -e "s~{{.HEROKU_APP}}~${HEROKU_APP}~" \
    -e "s~{{.HEROKU_API_KEY}}~${HEROKU_API_KEY}~" \
    app.service.tmpl \
    > app.service
sudo mv app.service /etc/systemd/system/app.service
rm app.service.tmpl

sudo systemctl enable app.service
sudo systemctl start app.service
echo "Installation complete"
