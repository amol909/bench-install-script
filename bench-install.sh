#!/bin/bash

if (($EUID != 0)); then
  if [[ -t 1 ]]; then
    sudo "$0" "$@" 
  else
    exec 1>output_file 
    gksu "$0 $@" 
  fi
  exit
fi

echo "Starting frappe bench installation" &&

sudo apt-get update -y && sudo apt-get upgrade -y &&

echo $'\=====================> All packages updated! <=======================\ ' &&

echo  $' \n Installing git \n' &&

sudo apt-get install git &&

echo $' \n git Installed \n ' &&

echo $' \n Installing python dependencies \n '

sudo apt-get install python3-dev python3.10-dev python3-setuptools python3-pip python3-distutils 

echo $' \n Python dependencies installed \n ' 

echo $' \n Installing python virtual env \n ' 

sudo apt-get install python3.10-venv 

echo $' \n Python virtual env installed \n ' 

sudo apt-get install software-properties-common

echo $' \n Installing mariadb \n '

sudo apt install mariadb-server mariadb-client

echo $' \n MariaDB installed \n '

echo $' \n Installing redis \n '

sudo apt-get install redis-server

echo $' \n Redis installed \n ' &&

echo $' \n Installing other dependencies required by ERPNext \n ' &&

sudo apt-get install xvfb libfontconfig wkhtmltopdf libmysqlclient-dev

echo $' \n Other dependencies installed \n ' &&

echo $' \n Setup mysql server \n ' &&

sudo mysql_secure_installation &&

echo $' \n Updating mysql conf \n ' &&

cat ./sql_conf.txt >> /etc/mysql/my.cnf &&

echo $' \n Restarting mysql server \n ' &&

sudo service mysql restart &&

echo $' \n Mysql server setup completed \n ' &&

echo $' \n Installing other dependencies \n ' &&

sudo apt install curl &&

curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash &&

source ~/.profile || source ~/.bashrc &&

export NVM_DIR="$HOME/.nvm" &&
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" &&
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" &&

nvm install 18 &&

sudo apt-get install npm &&

sudo npm install -g yarn

sudo pip3 install frappe-bench &&

read -p "Bench init name [frappe-bench] : " bench_name &&
bench_name=${bench_name:-frappe-bench} &&

echo $' \n Initializing bench \n ' &&

bench init --frappe-branch version-15 $bench_name &&

cd $bench_name &&

chmod -R o+rx /home/$USER &&

echo $' \n Bench initialized \n '




