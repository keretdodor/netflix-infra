#!/bin/bash

apt-get update
apt-get install -y docker.io
systemctl start docker
systemctl enable docker

docker pull keretdodor/netflix-frontend
docker run -d --name netflix-frontend -p 3000:3000 keretdodor/netflix-frontend