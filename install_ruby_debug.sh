 #!bin/bash
 my_path="$HOME/.rvm/rubies/ruby-1.9.3-p194/include/ruby-1.9.1/ruby-1.9.3-p194/"
 dir="install_ruby_debug"
 echo "Installing ruby debug Plugin"
 echo -e "\n ----------------------------------------------------------------------------\n"
 echo "Are your ruby-includes located at: $my_path ?"
 read answer
 if [ "$answer" == "no" ]; then
  echo "Please tell me the correct path"
  read -e -p "ruby: " my_path
fi
echo -e "\n ----------------------------------------------------------------------------\n"
echo "Continuing with install"
mkdir -p dir
cd $_
wget http://rubyforge.org/frs/download.php/75414/linecache19-0.5.13.gem
wget http://rubyforge.org/frs/download.php/75415/ruby-debug-base19-0.11.26.gem
wget http://rubyforge.org/frs/download.php/63094/ruby-debug19-0.11.6.gem
wget http://rubyforge.org/frs/download.php/74596/ruby_core_source-0.1.5.gem
gem install archive-tar-minitar
gem install ruby_core_source-0.1.5.gem -- --with-ruby-include=$my_path
gem install linecache19-0.5.13.gem -- --with-ruby-include=$my_path
gem install ruby-debug-base19-0.11.26.gem -- --with-ruby-include=$my_path
gem install ruby-debug19-0.11.6.gem -- --with-ruby-include=$my_path

echo -e '\n ----------------------------------------------------------------------------\n'
echo "Cleaning up"
cd ..
rm -r dir
echo -e '\n ----------------------------------------------------------------------------\n'
echo "Finished Installing"
echo "Add the following lines to your gemfile if you want to debug"
cat << 'gemfile'
  group :development do
  gem "linecache19", "0.5.13"
  gem "ruby-debug-base19", "0.11.26"
  gem "ruby-debug19", require: 'ruby-debug'
  end
gemfile



