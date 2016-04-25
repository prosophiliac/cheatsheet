#!/bin/bash

#STS 
function install_sts {
sts_desktop="\
[Desktop Entry]
Name=Spring Tool Suite
GenericName=IDE
Exec=/opt/sts-bundle/sts-3.7.3.RELEASE/STS
TryExec=/opt/sts-bundle/sts-3.7.3.RELEASE/STS
Icon=/opt/sts-bundle/sts-3.7.3.RELEASE/icon.xpm
Terminal=false
Type=Application
Categories=Programming;"
    sudo wget http://dist.springsource.com/release/STS/3.7.3.RELEASE/dist/e4.5/spring-tool-suite-3.7.3.RELEASE-e4.5.2-linux-gtk-x86_64.tar.gz -O /opt/spring-tool-suite.tar.gz
    sudo tar -xvf  /opt/spring-tool-suite.tar.gz -C /opt/
     echo -e "$sts_desktop" | sudo tee /usr/share/applications/sts.desktop
}

#GP Rename
function install_gprename {
    sudo apt-get -y install gprename
}

#Glances
function install_glances {
    sudo apt-get -y install python-pip build-essential python-dev
    sudo pip install Glances
    sudo pip install PySensors
}

#Install Android Studio
function install_android_studio {
    sudo apt-add-repository ppa:paolorotolo/android-studio 
    apt_update
    sudo apt-get install android-studio lib32stdc++6
}


#Install Axel
function install_axel {
    sudo apt-get -y install axel
}

#Install FreeFileSync 
function install_free_file_sync {
    sudo add-apt-repository ppa:freefilesync/ffs
    apt_update
    sudo apt-get -y install freefilesync
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
function set_hostname {
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
function install_java8 {
    sudo add-apt-repository ppa:webupd8team/java -y
    apt_update
    echo debconf shared/accepted-oracle-license-v1-1 select true | \sudo debconf-set-selections
    echo debconf shared/accepted-oracle-license-v1-1 seen true | \sudo debconf-set-selections
    sudo apt-get install -y oracle-java8-installer oracle-java8-set-default

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
    git config --global credential.helper cache
    git config --global credential.helper "cache --timeout=86400"
 
}

#Mail
function mail {
     sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q mailutils
}

#Node
function install_node {
  NPMVersion="v5.11.0";
  wget  "http://nodejs.org/dist/$NPMVersion/node-$NPMVersion-linux-x64.tar.gz" -P "$HOME"
  tar -xzvf "$HOME/node-$NPMVersion-linux-x64.tar.gz" -C "$HOME"
  rm "$HOME/node-$NPMVersion-linux-x64.tar.gz"
  rm "$HOME/node"
  ln -s "$HOME/node-$NPMVersion-linux-x64" "$HOME/node"
  echo "export PATH=$HOME/node/bin:$PATH" >> "$HOME/.bashrc"
  export PATH=$HOME/node/bin:$PATH
}

#JHipster
function install_jhipster {
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

#Vagrant
function install_vagrant {
    wget "https://releases.hashicorp.com/vagrant/1.8.1/vagrant_1.8.1_x86_64.deb" -P "$HOME"
    sudo dpkg -i "$HOME/vagrant_1.8.1_x86_64.deb"
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
    echo "$0 --install_free_file_sync"
    echo "$0 --install_java8 "
    echo "$0 --install_glances "
    echo "$0 --install_android_studio"
    echo "$0 --set_hostname subdomain.hostname.com"
    echo "$0 --install_gprename"
    echo "$0 --install_sts"
    echo "$0 --install_node"
    echo "$0 --install_jhipster"
    echo "$0 --install_vagrant"
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
    --install_java8 ) install_java8 ; shift;break ;;
    --php5 ) php5; shift ;break;;
    --install_git ) install_git; shift; break ;;
    --install_node ) install_node ; shift ;break;;
    --install_jhipster ) install_jhipster ; shift ;break;;
    --mail ) mail ; shift;break ;;
    --awscli ) awscli ; shift;break ;;
    --install_vagrant ) install_vagrant ; shift;break ;;
    --install_sts ) install_sts ; shift;break;;
    --install_gprename ) install_gprename ; shift;break;;
    --install_free_file_sync ) install_free_file_sync ; shift;break;;
    --install_axel ) install_axel ; shift;break;;
    --install_android_studio ) install_android_studio ; shift;break;;
    --install_google_chrome ) install_google_chrome ;  shift; break ;;
    --install_glances ) install_glances ;  shift; break ;;
    --mysql5 ) mysql5 "$2"; shift 2;break ;;
    --set_hostname ) set_hostname "$2"; shift 2;break ;;
    --sonar ) sonar "$2"; shift 2;break ;;
    * ) helpmessage ; break ;;
  esac
done



