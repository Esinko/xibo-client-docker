DOCKER_DIR=/mnt/wsl/shared-docker
mkdir -p /mnt/wsl/shared-docker
sudo chgrp docker "$DOCKER_DIR"
sudo ln -s /mnt/wsl/shared-docker/docker.sock /var/run/docker.sock
sudo dockerd