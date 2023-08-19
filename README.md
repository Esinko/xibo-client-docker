# xibo-client-docker
Run the Xibo Windows client in a Docker container.

# What is in here?
The `Dockerfile` includes all commands to build a version of [Docker-Wine](https://hub.docker.com/r/scottyhardy/docker-wine) capable of running the Xibo Windows Player program.

Do note that this is still largely a work in progress and I'm by no means a "pro" when it comes to Docker or WINE.

# Usage
## Build it
```bash
docker build . -t esinko/xibo-client-docker
```

## Run it
*The installer will run automatically. After it has finished, press finish and do not start the player automatically. Otherwise you might encounter issues.*

### With X11 forwarding
```bash
docker run -it \
  --hostname="$(hostname)" \
  --env="DISPLAY" \
  --volume="${XAUTHORITY:-${HOME}/.Xauthority}:/root/.Xauthority:ro" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:ro" \
  --volume="xibo-client-volume:/xibo-wine" \
  esinko/xibo-client-docker
```

## Flags
```
-o, Manually run the Player Options program.
-i, Manually run the Player Installer program.
```

## Limitations
- Docker-Wine's RDP & X11 forwarding functionality is unavailable.
- Only version `v3-R301.1` of the Xibo Player has been proven to work at least somewhat.

## Dependencies
- [scottyhardy/docker-wine](https://hub.docker.com/r/scottyhardy/docker-wine/)

# Known issues
- Sometimes WINE might start leaking memory. Currently it is believed this is an issue with CEF (Chromium Embedded Framework), which the player program uses to display (at least) web content. However, this memory leak should be relatively rare (expect occurrences every 48h of runtime).
- The about tab in the options program crashes everything.
- The Xibo Watchdog does not work at all. With it enabled, the player won't start at all.
