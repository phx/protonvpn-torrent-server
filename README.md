# ProtonVPN Torrent Server

*Requires: Bash and Docker*

This is a self-contained torrent server that uses ProtonVPN-cli and Transmission in order to segregate torrent traffic to the `docker0` interface, which will allow you to...download Linux ISOs...in the comfort of knowing that your connection is secure.

Killswitch is enabled by default, so no Internet traffic will flow into or out of this container if ProtonVPN is not connected.

I created this for myself when I borked my Raspberry Pi, which I was previously using as a torrent server, and I decided to open source this project since it could prove useful to others besides myself.


## Install

```
./configure.sh --install
```

The Docker image will be built and run interactively once to configure the ProtonVPN settings.

You may tweak the `.env.example` file and rename to `.env` in order to change the host port and host download location, which default to `$HOME/Downloads` and `9091`, respectively.

An executable script will be created at `/usr/local/bin/torrentserver` which you can run whenever you want to start or restart the container.


## Uninstall

```
./configure.sh --uninstall
```

All settings files will be removed, along with `/usr/local/bin/torrentserver`, as well as the Docker container and image.


## Run

```
/usr/local/bin/torrentserver
```

## Stop

```
docker stop torrentserver
```

