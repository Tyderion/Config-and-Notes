#!/bin/bash
#TODO: Install snippets
installed=""
subl_packages_default_path="$HOME/.config/sublime-text-2/Packages"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
function install_package {
cd $subl_packages_path
var=(`echo $@ | awk -F";" '{print $1 $2 $3}'`)
if [ "$var" == "Link" ]; then
  return 1
fi
echo "Do you want to install ${var[2]}"
answer="default"
while [ "$answer" == "1" ] || [ "$answer" == "2" ] || [ "$answer" == "default" ]
do
  read -n1 -s -p "Press y:install, 1:go to github, 2:Read Description or anything else to abort" answer </dev/tty
  if [ "$answer" == "" ]; then
    answer="y"
  elif [ "$answer" == "1" ]; then
    echo $var
    gnome-www-browser "http"${var:3:${#var}-7} #Strip git and .git

  elif [ "$answer" == "2" ]; then
    echo $@ | awk -F";" '{print "\n"$4}'
  fi
done
if [ "$answer" != "y" ]; then
  echo -e "\nNot installing ${var[2]}"
  return 1
fi
echo -e "\nInstalling ${var[2]}"
if [ "${var[1]}" == "default" ]; then
  git clone $var
else
  git clone $var ${var[1]}
fi
installed=$installed"\n"${var[2]}
cd $DIR
}

function create_settings {
  echo -e "{" > tmp_prefs.sublime-settings
  cat preferences/Preferences.sublime-settings >> tmp_prefs.sublime-settings
  cat linux/Preferences.sublime-settings >> tmp_prefs.sublime-settings
  echo -e "}" >> tmp_prefs.sublime-settings
  cat tmp_prefs.sublime-settings > $subl_packages_path"/User/Preferences.sublime-settings"
  exit
  rm tmp_prefs.sublime-settings
}

echo "This Programm will install a few Sublime plugins and some settings, all customizable via text files."
read -e -p "Sublime Package Folder: $subl_packages_default_path ?" subl_packages_path </dev/tty
if ["$subl_packages_path" == ""]; then
  subl_packages_path=$subl_packages_default_path
  echo "Using Standard Path: $subl_packages_path"
else
  echo "Using $subl_packages_path"
fi

echo "Do you want to install packages?"
read -n1 -s -p "Press y to continue or anything else to skip installing packages" cont
if [ "$cont" == "y" ]; then
  echo "\nInstalling Packages..."
  while read line; do
    install_package $line;
  done <"packages/packages.txt";
  echo -e "Installed the following packages\n $installed"
fi
echo -e "\nDo you want to install the settingsfile?"
read -n1 -s -p "Press y to continue or anything else to skip installing the settingsfile" cont
if [ "$cont" == "y" ]; then
  create_settings
fi
echo -e "\n"




