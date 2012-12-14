#!/bin/bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get -y install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config curl guake

echo "Installing Sublime Text 2"
wget "http://c758482.r82.cf2.rackcdn.com/Sublime Text 2.0.1 x64.tar.bz2"
tar xf Sublime\ Text\ 2\ Build\ 2181\ x64.tar.bz2
sudo mv Sublime\ Text\ 2 /usr/lib/
sudo ln -s /usr/lib/Sublime\ Text\ 2/sublime_text /usr/bin/sublime
cat sublime_desktop | sudo tee -a  /usr/share/applications/sublime.desktop

#make bash changes
cat inputrc_tweaks | sudo tee -a /etc/inputrc
cat my_aliases >> ~/.bash_aliases
cat bashrc_tweaks >> ~/.bashrc

#install bashmarks
cd Documents
git clone git://github.com/huyng/bashmarks.git
cd bashmarks && make install

echo "Installing NodeJS"
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install nodejs npm

curl -L https://get.rvm.io | bash -s stable --rails
#"send q"
source ~/.rvm/scripts/rvm
echo "type rvm | head -n 1"
echo "if answer is: rvm is a function, continue, else do a rvm reinstall 1.9.3"





#install dependencies

#rvm reinstall 1.9.3 #???
#gem install rails


