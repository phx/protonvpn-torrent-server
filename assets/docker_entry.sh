#!/bin/bash

if [[ -f /home/user/.pvpn-cli/.initialized ]]; then
  sudo sed -i 's/killswitch = 0/killswitch = 2/' /home/user/.pvpn-cli/pvpn-cli.cfg
  sudo protonvpn r
else
  sudo protonvpn init && sudo protonvpn connect && touch /home/user/.pvpn-cli/.initialized
  sudo sed -i 's/killswitch = 0/killswitch = 2/' /home/user/.pvpn-cli/pvpn-cli.cfg
  exit
fi

transmission-daemon -f -g /home/user/.transmission

exec "$@";
