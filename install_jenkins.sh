
#!/bin/bash

sudo apt update -y

sudo apt install default-jre -y

sudo apt install default-jdk -y

java -version

sudo apt upgrade -y

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

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

