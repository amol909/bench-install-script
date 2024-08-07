#!/bin/bash

if (($EUID != 0)); then
  if [[ -t 1 ]]; then
    sudo "$0" "$@" &&
  else
    exec 1>output_file &&
    gksu "$0 $@" &&
  fi
  exit
fi

echo "Starting frappe bench installation" &&

sudo apt-get update -y && sudo apt-get upgrade -y &&

echo $'\=====================> All packages updated! <=======================\ ' &&

echo $ ' \ Installing git \ ' &&

sudo apt-get install git &&

echo $' \ git Installed \ ' &&

echo $' \ Installing python dependencies \ ' &&

sudo apt-get install python3-dev python3.10-dev python3-setuptools python3-pip python3-distutils &&

echo $' \ Python dependencies installed \ ' &&

echo $' \ Installing python virtual env \ ' &&

sudo apt-get install python3.10-venv &&

echo $' \ Python virtual env installed \ ' &&

sudo apt-get install software-properties-common &&

echo $' \ Installing mariadb \ ' &&

sudo apt install mariadb-server mariadb-client &&

echo $' \ MariaDB installed \ ' &&

echo $' \ Installing redis \ ' &&

sudo apt-get install redis-server &&

echo $' \ Redis installed \ ' &&

echo $' \ Installing other dependencies required by ERPNext \ ' &&

sudo apt-get install xvfb libfontconfig wkhtmltopdf &&

sudo apt-get install libmysqlclient-dev &&

echo $' \ Other dependencies installed \ ' &&

echo $' \ Setup mysql server \ ' &&

sudo mysql_secure_installation &&

echo $' \ Updating mysql conf \ ' &&

cat ./sql_conf.txt >> /etc/mysql/my.cnf &&

echo $' \ Restarting mysql server \ ' &&

sudo service mysql restart &&

echo $' \ Mysql server setup completed \ ' &&

echo $' \ Installing other dependencies \ ' &&

sudo apt install curl &&

curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash &&

source ~/.profile &&

nvm install 18 &&

sudo apt-get install npm &&

sudo npm install -g yarn &&

sudo pip3 install frappe-bench &&

read -p "Bench init name [frappe-bench] : " bench_name &&
bench_name=${bench_name:-frappe-bench} &&

echo $' \ Initializing bench \ ' &&

bench init --frappe-branch version-15 $bench_name &&

cd $bench_name &&

chmod -R o+rx /home/$USER &&

echo $' \ Bench initialized \ '




