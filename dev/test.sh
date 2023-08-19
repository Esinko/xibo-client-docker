# Short little test script to quickly run everything
echo "Building ..."
docker build . -t esinko/xibo-client-docker --build-arg CACHE_BREAK=$(date +%Y-%m-%d:%H:%M:%S)
echo ""
echo "Testing ..."
docker run -it \
  --rm \
  --hostname="$(hostname)" \
  --env="DISPLAY" \
  --volume="${XAUTHORITY:-${HOME}/.Xauthority}:/root/.Xauthority:ro" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:ro" \
  --volume="xibo-client-volume:/xibo-wine" \
  esinko/xibo-client-docker