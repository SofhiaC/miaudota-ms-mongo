#!/usr/bin/env bash
# Constrói e publica as imagens deste repositório no Docker Hub.
# Antes: docker login   (use a conta sofhiachromiec)
set -euo pipefail
cd "$(dirname "$0")"
docker build --platform linux/amd64 --build-arg SERVICO=usuarios -t sofhiachromiec/pjbl-usuarios:v1 .
docker push sofhiachromiec/pjbl-usuarios:v1
docker build --platform linux/amd64 --build-arg SERVICO=adocao -t sofhiachromiec/pjbl-adocao:v1 .
docker push sofhiachromiec/pjbl-adocao:v1
echo "Imagens publicadas."
