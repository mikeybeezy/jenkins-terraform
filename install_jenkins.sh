
#!/bin/bash

sudo apt update -y

sudo apt install default-jre -y

sudo apt install default-jdk -y

java -version

sudo apt upgrade -y

## install Docker ##

sudo apt install docker.io -y

docker -version

sudo systemctl start docker

# sudo systemctl enable docker

sudo systemctl status docker

## install kubectl 
sudo snap install kubectl  --classic

kubectl version --client

## instal Jenkins 

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

sudo apt update -y 

sudo  add-apt-repository universe -y

sudo apt install jenkins -y

sudo systemctl start jenkins

sudo systemctl enable jenkins

sudo systemctl status jenkins

sudo ufw allow 8080

sudo ufw status

# sudo usermod -aG docker jenkins 

sudo systemctl restart docker.service 

sudo echo "jenkins ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/jenkins

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

