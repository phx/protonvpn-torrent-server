#!/bin/bash

DIR="$HOME/.torrentserver"

# check for docker:
if ! command -v docker >/dev/null 2>&1; then
  echo 'Docker must be installed in order for the torrent server to work.'
  exit 1
fi


set_env() {
  if [[ -f "${DIR}/.env" ]]; then
    export DOWNLOADS_DIR="$(grep 'DOWNLOADS_DIR' "${DIR}/.env" | cut -d '=' -f2-)"
    export HOST_PORT=$(grep 'HOST_PORT' "${DIR}/.env" | cut -d '=' -f2-)
  fi
  export DOWNLOADS_DIR=${DOWNLOADS_DIR:-"$HOME/Downloads"}
  export HOST_PORT=${HOST_PORT:-9091}
}


stop_and_remove() {
  docker stop torrentserver 2>/dev/null
  docker rm torrentserver 2>/dev/null
}

run_it() {
  stop_and_remove
  docker run --privileged --name torrentserver -it -p ${HOST_PORT}:9091 -v "${DIR}/assets/.pvpn-cli:/home/user/.pvpn-cli" -v "${DOWNLOADS_DIR}:/home/user/Downloads" torrentserver:latest /bin/bash
}

run_d() {
  stop_and_remove
  docker run --privileged --name torrentserver  --restart=always -d -p ${HOST_PORT}:9091 -v "${DIR}/assets/.pvpn-cli:/home/user/.pvpn-cli" -v "${DOWNLOADS_DIR}:/home/user/Downloads" torrentserver:latest /bin/bash
}

if [[ "$1" = "--install" ]]; then
  cp -r . "$DIR"
  set_env
  echo "Setting \$DOWNLOADS_DIR to ${DOWNLOADS_DIR}..."
  echo "Setting \$HOST_PORT to ${HOST_PORT}..."
  cd "${DIR}/assets" || exit 1
  echo -e "#!/bin/bash\n${DIR}/configure.sh --run" >> /usr/local/bin/torrentserver
  sudo chmod +x /usr/local/bin/torrentserver
  docker build -t torrentserver . &&\
  if [[ ! -f "${DIR}/assets/.pvpn-cli/.initialized" ]]; then
    run_it
    run_d
  else
    run_d
  fi
elif [[ "$1" = "--uninstall" ]]; then
  stop_and_remove
  docker rmi torrentserver 2>/dev/null
  rm -rf "$DIR"
  sudo rm -f /usr/local/bin/torrentserver
elif [[ "$1" = "--run" ]]; then
  run_d
else
  echo 'Script must be run with at least one parameter.'
  exit 1
fi
