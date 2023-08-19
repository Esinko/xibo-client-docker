docker run -it \
  --hostname="$(hostname)" \
  --env="DISPLAY" \
  --volume="${XAUTHORITY:-${HOME}/.Xauthority}:/root/.Xauthority:ro" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:ro" \
  --volume="xibo-client-volume:/xibo-wine" \
  esinko/xibo-client-docker -o