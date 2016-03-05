#!/bin/bash

#Install Axel
function install_axel {
    sudo apt-get -y install axel
}

#Install Telegram
function install_telegram {
    sudo add-apt-repository ppa:atareao/telegram
    apt_update
    sudo apt-get -y install telegram
}

#Install Dropbox
function install_dropbox {
    dropbox_version="2015.10.28_amd64"
    wget https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_$dropbox_version.deb -O "$HOME/dropbox_$dropbox_version.deb"    
    sudo dpkg -yi "$HOME/dropbox_$dropbox_version.deb"
    sudo apt-get -y install -f
    rm "$HOME/dropbox_$dropbox_version.deb"
}

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
function unattended_upgrades {
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
function clean_up {
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
function apt_update {
    sudo apt-get -y update
}

#Vim
function install_vim {
    install_git
    sudo apt-get install -y vim
    mkdir -p ~/.vim/bundle
    git clone https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
    wget https://raw.githubusercontent.com/sougat818/cheatsheet/master/vim/.vimrc -O "$HOME/.vimrc"
    vim +PluginInstall +qall
}

#aptupgrade
function apt_upgrade {
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
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
     sudo apt-get install -y php5-curl
}

#Mysql
function mysql5 {
    sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $1"
    sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $1"
    sudo apt-get -y install mysql-server
}

#Git
function install_git {
    sudo apt-get install -y git
}

#Mail
function mail {
     sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q mailutils
}

#Node
function node {
  NPMVersion="v5.0.0";
  wget  "http://nodejs.org/dist/$NPMVersion/node-$NPMVersion-linux-x64.tar.gz" -P "$HOME"
  tar -xzvf "$HOME/node-$NPMVersion-linux-x64.tar.gz" -C "$HOME"
  rm "$HOME/node-$NPMVersion-linux-x64.tar.gz"
  rm "$HOME/node"
  ln -s "$HOME/node-$NPMVersion-linux-x64" "$HOME/node"
  echo "export PATH=$HOME/node/bin:$PATH" >> "$HOME/.bashrc"
  export PATH=$HOME/node/bin:$PATH
}

#JHipster
function jhipster {
  npm install -g yo
  npm install -g bower
  npm install -g grunt-cli
  npm install -g generator-jhipster
  cd "$HOME/node/lib/node_modules/generator-jhipster" || exit
  npm install aws-sdk progress node-uuid
}

#Arc
function arc {
    mkdir $HOME/ben10/libphutil
    mkdir $HOME/ben10/arcanist
    git clone https://github.com/phacility/libphutil.git "$HOME/ben10/libphutil"
    git clone https://github.com/phacility/arcanist.git "$HOME/ben10/arcanist"
    echo "export PATH=$HOME/ben10/arcanist/bin:$PATH" >> "$HOME/.bashrc"
}

#GoogleChrome
function install_google_chrome {
    if [ ! -f /etc/apt/sources.list.d/google-chrome.list ]; then 
        wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
        sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
    fi
    sudo apt-get update
    sudo apt-get -y install google-chrome-stable
}

#Help Message
function helpmessage {
    echo "Usage : "
    echo "$0 --unattended_upgrades"
    echo "$0 --install_google_chrome"
    echo "$0 --install_vim"
    echo "$0 --install_git"
    echo "$0 --clean_up"
    echo "$0 --apt_update"
    echo "$0 --install_dropbox"
    echo "$0 --apt_upgrade"
    echo "$0 --install_axel"
    echo "$0 --install_telegram"
    echo "$0 [--java8] [--php5] [--node] [--jhipster] [--mail] [--mysql5 password] [--hostname subdomain.hostname.com] [--sonar password] [--awscli] [--arc] "
}


while true; do
  case "$1" in
    --unattended_upgrades ) unattended_upgrades ; shift;break ;;    
    --install_dropbox ) install_dropbox ; shift ; break;;
    --install_vim ) install_vim ; shift ; break;;
    --install_telegram ) install_telegram ; shift ; break;;
    --clean_up ) clean_up ; shift;break ;;
    --apt_update ) apt_update ; shift ;break;;
    --apt_upgrade ) apt_update ;  apt_upgrade; shift;break ;;
    --java8 ) java8 ; shift;break ;;
    --php5 ) php5; shift ;break;;
    --install_git ) install_git; shift; break ;;
    --node ) node ; shift ;break;;
    --jhipster ) jhipster ; shift ;break;;
    --mail ) mail ; shift;break ;;
    --awscli ) awscli ; shift;break ;;
    --arc ) arc ; shift;break;;
    --install_axel ) install_axel ; shift;break;;
    --install_google_chrome ) install_google_chrome ;  shift; break ;;
    --mysql5 ) mysql5 "$2"; shift 2;break ;;
    --hostname ) hostname "$2"; shift 2;break ;;
    --sonar ) sonar "$2"; shift 2;break ;;
    * ) helpmessage ; break ;;
  esac
done



