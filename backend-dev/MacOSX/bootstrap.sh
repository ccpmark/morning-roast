#!/usr/bin/env bash

# Install homebrew
echo "Installing homebrew";
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";

# Run our brewfile
echo "Installing brew formulas"
brew tap homebrew/boneyard;
brew bundle;

read -p "WARNING: The rest of this script will have to run with sudo permissions, continue? (y/n)" -n 1;
echo "";
if [[ $REPLY =~ ^[Nn]$ ]]; then
   exit 1;
fi;

# Install phpbrew

if hash phpbrew 2>/dev/null; then
   echo "php brew already installed";
else
   echo "Installing phpbrew";
   curl -L -O https://github.com/phpbrew/phpbrew/raw/master/phpbrew;
   chmod +x phpbrew;
   sudo mv phpbrew /usr/bin/phpbrew;
fi

# Install a php version
phpbrew known;
echo "Please enter a php version listed above: ";
read version;
sudo phpbrew install $version +default +mysql +fpm +openssl +debug -- --with-pdo-mysql --with-gmp;
phpbrew switch $version;
phpbrew clean $version;

# Install some extra extensions
phpbrew ext install xdebug stable;
phpbrew ext install mongo;

# Install some extra components
phpbrew install-composer;
phpbrew install-phpunit;

# Setup some global stuff ;)
mysql -u root -e "SET GLOBAL sql_mode = 'ALLOW_INVALID_DATES';";
php -d date.timezone='GMT';

exit 0;
