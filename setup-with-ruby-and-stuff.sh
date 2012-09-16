#!/bin/bash
sudo apt-get update
sudo apt-get upgrade
sudo apt-get -y install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config curl guake 


wget "http://c758482.r82.cf2.rackcdn.com/Sublime Text 2.0.1 x64.tar.bz2"
tar xf Sublime\ Text\ 2\ Build\ 2181\ x64.tar.bz2
sudo mv Sublime\ Text\ 2 /usr/lib/
sudo ln -s /usr/lib/Sublime\ Text\ 2/sublime_text /usr/bin/sublime
cat << 'sublime' | sudo tee -a  /usr/share/applications/sublime.desktop
[Desktop Entry]
Version=1.0
Name=Sublime Text 2
# Only KDE 4 seems to use GenericName, so we reuse the KDE strings.
# From Ubuntu's language-pack-kde-XX-base packages, version 9.04-20090413.
GenericName=Text Editor

Exec=sublime
Terminal=false
Icon=/usr/lib/Sublime Text 2/Icon/48x48/sublime_text.png
Type=Application
Categories=TextEditor;IDE;Development
X-Ayatana-Desktop-Shortcuts=NewWindow

[NewWindow Shortcut Group]
Name=New Window
Exec=sublime -n
TargetEnvironment=Unity
sublime

#make bash changes
sudo cat my_inputrc_changes.txt >> /etc/inputrc

cat << 'myinputrc' | sudo tee -a /etc/inputrc 

set match-hidden-files off
set visible-stats on

#history auto-complete with UP-Arrow
"\e[A": history-search-backward
"\e[B": history-search-forward
"\e[C": forward-char
"\e[D": backward-char

set completion-ignore-case on

set show-all-if-ambiguous on
"\M-d": menu-complete

myinputrc


cat >> ~/.bash_aliases << 'myaliases'
alias mkdir="mkdir -p" #always create nested directories
#alias cd="pushd" #go to dir and save in stack
#alias bd="popd" #go to last working dir
alias subl="sublime"
myaliases


cat >> ~/.bashrc << 'mybashscript'
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
#see: http://aplawrence.com/Linux/bash_history.html
# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=erasedups
# ... and don't clobber the history when closing multiple shells
shopt -s histappend
# ... and keep multi line commands together
shopt -s cmdhist

#Real-time history export amongst bash terminal windows (stackoverflow)
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=100000                   # big big history
export HISTFILESIZE=100000               # big big history
shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"


#Expand-o-Matic:
ex () {
  if [ "$1" == '' ] ; then
	echo "This is the Expand-o-Matic"
  elif [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1        ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1       ;;
      *.rar)       rar x $1     ;;
      *.gz)        gunzip $1     ;;
      *.tar)       tar xf $1        ;;
      *.tbz2)      tar xjf $1      ;;
      *.tgz)       tar xzf $1       ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}


#Bashrc
#Functions to start graphical programs in the back
function gedit
{
  command gedit "$@" &
}
function sublime
{
  command sublime "$@" &
}
function railss
{
command rvmsudo rails s
}

source ~/.local/bin/bashmarks.sh
mybashscript

#install bashmarks
cd Documents
git clone git://github.com/huyng/bashmarks.git
cd bashmarks && make install



curl -L https://get.rvm.io | bash -s stable --rails
#"send q"
source ~/.rvm/scripts/rvm
echo "type rvm | head -n 1"
echo "if answer is: rvm is a function, continue, else do a rvm reinstall 1.9.3"


echo "Installing NodeJS"
sudo apt-get install python-software-properties
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install nodejs npm


#install dependencies

#rvm reinstall 1.9.3 #???
#gem install rails


