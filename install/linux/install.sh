#!/bin/bash
path=$PWD
path_linux=$path/install/linux

echo -e "\033[1;033m==> Installing Python and Dependences...\033[0m"
sudo apt-get update
sudo apt-get install -y python3.12 python3.12-venv python3-pip
$path_linux/python_setup.sh

echo -e "\033[1;033m==> Installing Docker...\033[0m"
$path_linux/docker_setup.sh

echo -e "\033[1;033m==> Installing Jenkins...\033[0m"
$path_linux/jenkins_setup.sh

echo -e "\033[1;033m==> Starting SonarQube...\033[0m"
docker compose -f $path/estrutura/docker-compose-sonar.yml up -d

echo -e "\033[1;033m==> Waiting SonarQube to start...\033[0m"
until curl -fs http://localhost:9000/api/system/status >/dev/null 2>&1; do
    sleep 5
done

echo -e "Jenkins can be accessed in \033[1;4;032mhttp://localhost:8080\033[0m"
echo -e "SonarQube can be accessed in \033[1;4;032mhttp://localhost:9000\033[0m"
echo -e "\033[1;032mEnvironment configured successfully!\033[0m"

