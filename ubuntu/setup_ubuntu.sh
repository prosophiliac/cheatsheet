#!/bin/bash

#AWS Cli
function awscli {
    curl -O https://bootstrap.pypa.io/get-pip.py
    sudo -H python2.7 get-pip.py
    rm get-pip.py
    sudo -H pip install awscli        
}

#Sonar
function sonar {
    echo -e "\ndeb http://downloads.sourceforge.net/project/sonar-pkg/deb binary/" \ | sudo tee -a /etc/apt/sources.list    
    sudo apt-get update
    sudo apt-get -y --force-yes install sonar
    sudo sed -i '25 s/^#//' /opt/sonar/conf/sonar.properties 
    sudo sed -i '14 s/^#//' /opt/sonar/conf/sonar.properties 
    sudo sed -i "15 s/^$/sonar.jdbc.password=$2" /opt/sonar/conf/sonar.properties 
}

#Unattended Upgrades
function unattendedupgrades {
    sudo apt-get -y install unattended-upgrades
    sudo dpkg-reconfigure -plow unattended-upgrades
    sudo sed -i '3 s/^/\n\/\//' /etc/apt/apt.conf.d/50unattended-upgrades
    sudo sed -i '3 s/^/\"\*:\*\";/' /etc/apt/apt.conf.d/50unattended-upgrades
    sudo sed -i '28 s/^\/\///' /etc/apt/apt.conf.d/50unattended-upgrades
    echo "APT::Periodic::Unattended-Upgrade \"1\";" |  sudo tee -a /etc/apt/apt.conf.d/10periodic
    sudo sed -i '2 s/0/1/' /etc/apt/apt.conf.d/10periodic
    sudo sed -i '3 s/0/7/' /etc/apt/apt.conf.d/10periodic
}

#Clean Up
function cleanup {
    sudo apt-get autoclean
    sudo apt-get autoremove
    sudo apt-get install
}

#Hostname
function hostname {
    echo "$1" | sudo tee /etc/hostname
    echo "127.0.0.1 $1" | sudo tee --append /etc/hosts
}

#Apt Update
function aptupdate {
    sudo apt-get -y update
}

#Vim
function vim {
    sudo apt-get install -y vim
    mkdir -p ~/.vim/bundle
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim 
    wget https://raw.githubusercontent.com/sougat818/cheatsheet/master/vim/.vimrc -O $HOME/.vimrc
    command vim +PluginInstall +qall
}

#aptupgrade
function aptupgrade {
    sudo DEBIAN_FRONTEND=noninteractive aptitude -y dist-upgrade
}

#Java
function java8 {
    sudo add-apt-repository ppa:webupd8team/java -y
    aptupdate
    echo debconf shared/accepted-oracle-license-v1-1 select true | \sudo debconf-set-selections
    echo debconf shared/accepted-oracle-license-v1-1 seen true | \sudo debconf-set-selections
    sudo apt-get install -y oracle-java8-installer
    sudo apt-get install -y oracle-java8-set-default

}

#PHP
function php5 {
     sudo aptitude install -y php5-curl
}

#Mysql
function mysql5 {
    sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $1"
    sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $1"
    sudo aptitude -y install mysql-server
}

#Git
function git {
    sudo aptitude install -y git
}

#Mail
function mail {
     sudo DEBIAN_FRONTEND=noninteractive aptitude install -y -q mailutils
}

#Node
function node {
  NPMVersion="v5.0.0";
  wget  http://nodejs.org/dist/$NPMVersion/node-$NPMVersion-linux-x64.tar.gz -P $HOME
  tar -xzvf $HOME/node-$NPMVersion-linux-x64.tar.gz -C $HOME
  rm $HOME/node-$NPMVersion-linux-x64.tar.gz
  rm $HOME/node
  ln -s $HOME/node-$NPMVersion-linux-x64 $HOME/node
  echo "export PATH=$HOME/node/bin:$PATH" >> $HOME/.bashrc
  export PATH=$HOME/node/bin:$PATH
}

#JHipster
function jhipster {
  npm install -g yo
  npm install -g bower
  npm install -g grunt-cli
  npm install -g generator-jhipster
  cd $HOME/node/lib/node_modules/generator-jhipster
  npm install aws-sdk progress node-uuid
}

#Arc
function arc {
    mkdir $HOME/ben10/libphutil
    mkdir $HOME/ben10/arcanist
    git clone https://github.com/phacility/libphutil.git $HOME/ben10/libphutil
    git clone https://github.com/phacility/arcanist.git $HOME/ben10/arcanist
    echo "export PATH=$HOME/ben10/arcanist/bin:$PATH" >> $HOME/.bashrc
}

#Help Message
function helpmessage {
    echo "Usage : $0 [--unattendedupgrades] [--vim] [--cleanup] [--aptupdate] [--aptupgrade] [--java8] [--php5] [--git] [--node] [--jhipster] [--mail] [--mysql5 password] [--hostname subdomain.hostname.com] [--sonar password] [--awscli] [--arc]"
}


while true; do
  case "$1" in
    --unattendedupgrades ) unattendedupgrades ; shift ;;    
    --vim ) vim ; shift ;;
    --cleanup ) cleanup ; shift ;;
    --aptupdate ) aptupdate ; shift ;;
    --aptupgrade ) aptupdate ;  aptupgrade; shift ;;
    --java8 ) java8 ; shift ;;
    --php5 ) php5; shift ;;
    --git ) git; shift ;;
    --node ) node ; shift ;;
    --jhipster ) jhipster ; shift ;;
    --mail ) mail ; shift ;;
    --awscli ) awscli ; shift ;;
    --arc ) arc ; shift;;
    --mysql5 ) mysql5 "$2"; shift 2 ;;
    --hostname ) hostname "$2"; shift 2 ;;
    --sonar ) sonar $2; shift 2 ;;
    * ) helpmessage ; break ;;
  esac
done



