#!/bin/sh
set -e

sudo apt update
sudo apt upgrade -y

sudo apt-get install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings

# install docker
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# create github user
sudo mkdir -p /home/app
sudo useradd --no-create-home --home-dir /home/app --shell /bin/bash github
sudo usermod --append --groups docker github
sudo usermod --append --groups docker ubuntu
sudo chown github:github -R /home/app

github_pubkey='ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCvHzkeGDi4tBRleXB3m5/SXTR9BK4zVAyeuhWGNfbztNGBiRX/y04xkFJkWrBkYgnXsBOe1peSL850jJTHuVQcT7cLOyfp25DJqbRPihMnMtAMw2BMCCgUkFIGn4mAkzLpOf989BAHyNv227ovZ9H/TSciEwa36q7A5gFbpPrUlPxsFwAIkz4bZ0NiSUhW2CcijtaQvY2MXIUd3C6LiRYsg5lPm9B1wvYZhJqGkXidLwYX3I12rt6/Z7ybiaNc556J8yjUl48SQPzsWu0IzCoJ18x4ULuCf2Li5qP6XZGFOqRxaOc6K6+JjEUG5SEsLXaiB5acIJbmI01ELR5cFP1gnSpEj7odkLbO2teJOLhHXn4YOt2ycHs2EhP5tuYhXFMAxWt4avrjU76R2D77IRHbNs/SScfd/ZelpgZW2OpvLE50fTn2Cx/acKPQz0zQ7g9PlYzPdBELc9PTEhHNhYDkRS5ZKED+8V5MqRwwfAJbyAQ2FZVwPtHMSU3l6c5WHgs= gitMSI@Firas'

sudo -u github sh -c "mkdir -p /home/app/.ssh && echo $github_pubkey > /home/app/.ssh/authorized_keys"

sudo reboot
