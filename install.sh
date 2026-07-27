#!/bin/bash

set -e

echo "==> Instalando Python e dependências..."
./Estrutura/setup.sh

echo "==> Instalando Docker..."
./Estrutura/docker_setup.sh

echo "==> Instalando Jenkins..."
./Estrutura/jenkins_setup.sh

echo "==> Subindo SonarQube..."
docker compose -f Estrutura/docker-compose-sonar.yml up -d

echo "==> Aguardando SonarQube iniciar..."
until curl -fs http://localhost:9000/api/system/status >/dev/null 2>&1; do
    sleep 5
done

echo "Ambiente configurado com sucesso!"