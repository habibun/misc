#!/bin/bash

declare -A flag
LOGGED_USER_HOME=$(eval echo ~${SUDO_USER})
LOGGED_USER=$USER
TMP_DIR=/tmp
CODE_NAME=$(lsb_release -csu 2> /dev/null || lsb_release -cs)
FUNCTION_NAME=$1

# utility
init()
{
  execute_function
  select_packages
  install_packages
  install_configuration
}

execute_function()
{
if [ "$FUNCTION_NAME" ]; then
    type $FUNCTION_NAME &>/dev/null && eval $FUNCTION_NAME || echo "function $FUNCTION_NAME does not exist."
  exit 1
fi
}

select_packages()
{
  echo "Please confirm package for installation..."

#  confirm "install_gnome_tweak_tool->(y|n)" "install_gnome_tweak_tool"
#  confirm "install_vim->(y|n)" "install_vim"
#  confirm "install_openssh_server->(y|n)" "install_openssh_server"
#  confirm "install_git->(y|n)" "install_git"
#  confirm "install_composer->(y|n)" "install_composer"
#  confirm "install_nginx->(y|n)" "install_nginx"
#  confirm "install_php_fpm->(y|n)" "install_php_fpm"
#  confirm "install_symfony_php_extension->(y|n)" "install_symfony_php_extension"
#  confirm "install_symfony->(y|n)" "install_symfony"
#  confirm "install_codesniffer->(y|n)" "install_codesniffer"
#  confirm "install_php_cs_fixer->(y|n)" "install_php_cs_fixer"
#  confirm "install_virtualbox->(y|n)" "install_virtualbox"
#  confirm "install_nvm->(y|n)" "install_nvm"
#  confirm "install_phpstorm->(y|n)" "install_phpstorm"
#  confirm "install_datagrip->(y|n)" "install_datagrip"
#  confirm "install_postman->(y|n)" "install_postman"
#  confirm "install_skype->(y|n)" "install_skype"
#  confirm "install_mysql_server->(y|n)" "install_mysql_server"
#  confirm "install_docker->(y|n)" "install_docker"
#  confirm "install_mpv->(y|n)" "install_mpv"
#  confirm "install_google_chrome->(y|n)" "install_google_chrome"
#  confirm "install_chrome_gnome_shell->(y|n)" "install_chrome_gnome_shell"
#  confirm "install_slack->(y|n)" "install_slack"
  confirm "install_team_viewer->(y|n)" "install_team_viewer"

  echo "Package confirmation done :)"
}

install_packages()
{
  echo "This can take a while. Please be patient..."

  cd $TMP_DIR
  sudo apt-get update && sudo apt-get upgrade
  for flagkey in "${!flag[@]}"; do
    if (${flag[$flagkey]} == true)
    then
      $flagkey
    fi
  done

  echo "Installation done :)"
}

install_configuration()
{
  echo "Installing configuration..."

  config_generate_ssh_key
  config_git
  config_mysql
  config_bash_aliases
  config_nginx_virtual_host

  echo "Configuration have been installed for you :)"
}

confirm(){
    read -p `echo "$1"` yn
    case $yn in [Yy]* )
    flag["$2"]=true;
    esac
}

# installation
install_openssh_server()
{
  echo "Installing openssh server..."

  sudo apt-get install -y openssh-server

  echo "Openssh server have been installed for you :)"
}

install_gnome_tweak_tool()
{
  echo "Installing gnome tweak tool..."

  sudo apt-get install -y gnome-tweak-tool

  echo "Gnome tweak tool have been installed for you :)"
}

install_vim()
{
  echo "Installing vim..."

  sudo apt-get install -y vim

  echo "Vim have been installed for you :)"
}

install_php_fpm()
{
  echo "Installing php7.2-fpm..."

  sudo apt-get install -y php7.2-fpm

  echo "php7.2-fpm have been installed for you :)"
}

install_codesniffer()
{
  echo "Installing codesniffer..."

  wget https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
  wget https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar
  chmod a+x phpcs
  chmod a+x phpcbf
  mv phpcs.phar /usr/local/bin/phpcs
  mv phpcbf.phar /usr/local/bin/phpcbf
  chown -R $LOGGED_USER:$LOGGED_USER /usr/local/bin/phpcs
  chown -R $LOGGED_USER:$LOGGED_USER /usr/local/bin/phpcbf

  echo "Codesniffer have been installed for you :)"
}

install_php_cs_fixer()
{
  echo "Installing php cs fixer..."

  wget https://cs.symfony.com/download/php-cs-fixer-v2.phar -O php-cs-fixer
  chmod a+x php-cs-fixer
  mv php-cs-fixer /usr/local/bin/php-cs-fixer
  chown -R $LOGGED_USER:$LOGGED_USER /usr/local/bin/php-cs-fixer

  echo "php cs fixer have been installed for you :)"
}

install_symfony_php_extension()
{
  echo "Installing php extension required for symfony application..."

  sudo apt-get install -y  php7.2-xml\
                      php7.2-mbstring\
                      php7.2-intl\
                      php7.2-mysql

  echo "php extension have been installed for you :)"
}

install_nginx()
{
  echo "Installing nginx..."
  s1="deb [arch=amd64] https://nginx.org/packages/ubuntu/ $CODE_NAME nginx";
  s2="deb-src https://nginx.org/packages/ubuntu/ $CODE_NAME nginx";

  wget https://nginx.org/keys/nginx_signing.key
  sudo apt-key add nginx_signing.key
  grep -qxF "$s1" /etc/apt/sources.list || echo "$s1" >> /etc/apt/sources.list
  grep -qxF "$s2" /etc/apt/sources.list || echo "$s2" >> /etc/apt/sources.list
  sudo apt update
  sudo apt install -y nginx
  service nginx start

  echo "Nginx have been installed for you :)"
}

install_git()
{
  echo "Installing git..."

  add-apt-repository -y ppa:git-core/ppa
  sudo apt update
  sudo apt install -y git

  echo "Git have been installed for you :)"
}

install_symfony()
{
  echo "Installing symfony..."

  wget https://get.symfony.com/cli/installer -O - | bash
  mv ${USER_HOME}/.symfony/bin/symfony /usr/local/bin/symfony
  chown -R $LOGGED_USER:$LOGGED_USER ${USER_HOME}/.symfony
  chown -R $LOGGED_USER:$LOGGED_USER /usr/local/bin/symfony
  chown -R $LOGGED_USER:$LOGGED_USER /tmp/.symfony

  echo "Symfony have been installed for you :)"
}

install_composer()
{
  echo "Installing composer..."

  EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

  if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
  then
      >&2 echo 'ERROR: Invalid installer checksum'
      rm composer-setup.php
      exit 1
  fi

  php composer-setup.php --quiet
  RESULT=$?
  rm composer-setup.php
  mv composer.phar /usr/local/bin/composer
  chown -R $LOGGED_USER:$LOGGED_USER /usr/local/bin/composer

  echo "Composer have been installed for you :)"
}

install_virtualbox()
{
  echo "Installing virtualbox..."

  version=$(curl http://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT)
  version="$(echo $version| cut -d'.' -f1).$(echo $version| cut -d'.' -f2)"
  source="deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian $CODE_NAME contrib";
  grep -qxF "$source" /etc/apt/sources.list || echo "$source" >> /etc/apt/sources.list
  wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | apt-key add -
  wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | apt-key add -
  sudo apt-get update
  sudo apt-get install -y virtualbox-$version

  echo "Virtualbox have been installed for you :)"
}

install_nvm()
{
  echo "Installing NVM..."

  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  nvm install node stable

  echo "NVM have been installed for you :)"
}

install_phpstorm()
{
  echo "Installing phpstorm..."

  sudo snap install phpstorm --classic

  echo "Phpstorm have been installed for you :)"
}

install_datagrip()
{
  echo "Installing datagrip..."

  sudo snap install datagrip --classic

  echo "Datagrip have been installed for you :)"
}

install_postman()
{
  echo "Installing postman..."

  sudo snap install postman

  echo "Postman have been installed for you :)"
}

install_skype()
{
  echo "Installing skype..."

  sudo snap install skype --classic

  echo "Skype have been installed for you :)"
}

install_slack()
{
  echo "Installing slack..."

  sudo snap install slack --classic

  echo "Slack have been installed for you :)"
}

install_mpv()
{
  echo "Installing mpv..."

  sudo add-apt-repository -y ppa:mc3man/mpv-tests
  sudo apt-get update
  sudo apt-get install -y mpv

  echo "Mpv have been installed for you :)"
}

install_docker()
{
  echo "Installing docker..."
  sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo apt-key fingerprint 0EBFCD88
  sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io

  sudo usermod -aG docker $LOGGED_USER

  echo "Docker have been installed for you :)"
}

install_mysql_server()
{
  echo "Installing mysql server..."

  sudo apt-get install -y mysql-server

  echo "Mysql server have been installed for you :)"
}

install_google_chrome()
{
  echo "Installing google chrome..."

  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
  sudo apt-get update
  sudo apt-get install google-chrome-stable

  echo "Google chrome have been installed for you :)"
}

install_chrome_gnome_shell()
{
  echo "Installing chrome gnome shell..."

  sudo apt-get install -y chrome-gnome-shell

  echo "Chrome gnome shell have been installed for you :)"
}

install_team_viewer()
{
  echo "Installing team viewer..."

  wget https://download.teamviewer.com/download/linux/signature/TeamViewer2017.asc
  sudo apt-key add TeamViewer2017.asc
  sudo sh -c 'echo "deb http://linux.teamviewer.com/deb stable main" >> /etc/apt/sources.list.d/teamviewer.list'
  sudo apt update
  sudo apt install teamviewer

  echo "Team viewer have been installed for you :)"
}

# configuration
config_generate_ssh_key()
{
  echo "Configuring ssh..."

  read -p "Please enter email address : " email
  ssh-keygen -t ed25519 -C "$email"
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_ed25519
  echo "your public key: "$(cat ~/.ssh/id_ed25519.pub)

  echo "Ssh have been configured for you :)"
}

config_git()
{
  echo "Configuring git..."

  read -p "Please enter your email address : " email
  read -p "Please enter your name : " name

  git config --global init.defaultBranch master
  git config --global user.email "$email"
  git config --global user.name "$name"

  echo "Git have been configured for you :)"
}

config_mysql()
{
  echo "Configuring mysql..."

  mysql -uroot -e 'USE mysql; UPDATE user SET plugin="mysql_native_password" WHERE User="root"; FLUSH PRIVILEGES;'
  sudo mysql_secure_installation

  echo "Mysql have been configured for you :)"
}

config_bash_aliases()
{
  echo "Configuring bash aliases..."
  # todo - add bash aliases
  echo "Bash aliases have been configured for you :)"
}

config_nginx_virtual_host()
{
  echo "Configuring nginx virtual host..."

  NGINX_VHOSTS_DIR='/etc/nginx/conf.d'
  WEB_ROOT_DIR="$LOGGED_USER_HOME/Projects"
  read -p "Enter domain name : " domain
  mkdir -p $WEB_ROOT_DIR

  vhost_file=$NGINX_VHOSTS_DIR/$domain-vhost.conf
  test -f $vhost_file || sudo touch $vhost_file
  el="$domain"_error
  ac="$domain"_access

  # Create nginx config file

cat <<EOT >> $vhost_file
server {
    server_name $domain.local www.$domain.local;
    root $WEB_ROOT_DIR/$domain/public;

    location / {
        try_files \$uri /index.php\$is_args\$args;
    }

    location ~ ^/index\.php(/|$) {
        fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;
        fastcgi_param DOCUMENT_ROOT \$realpath_root;
        internal;
    }

    location ~ \.php$ {
        return 404;
    }

    error_log /var/log/nginx/$el.log;
    access_log /var/log/nginx/$ac.log;
}
EOT

  hosts_line="127.0.0.1    $domain.local"
  host_file="/etc/hosts"

  www_conf_file="/etc/php/7.2/fpm/pool.d/www.conf"
  w_c_old_val="www-data"
  w_c_new_val="nginx"

  grep -qxF "$hosts_line" $host_file || echo "$hosts_line" >> $host_file

  sed -i -e 's/www-data/nginx/g' $www_conf_file

  sudo service nginx restart

  echo "Nginx virtual host have been configured for you :)"
}

config_mpv_subtitle()
{
  echo "Configuring mpv subtitle..."

  mkdir -p ~/.config/mpv/scripts
  autosub_lua=~/.config/mpv/scripts/autosub.lua
  if [ ! -f $autosub_lua ]; then
    wget -O $autosub_lua https://raw.githubusercontent.com/davidde/mpv-autosub/master/autosub.lua
  fi

  # replace language to bangla
  sed -i 's/'Dutch.*dut'/'Bangla', 'bn', 'ben'/g' $autosub_lua

  sudo apt-get install python-pip
  sudo pip install subliminal

  # update subliminal path
  subliminal_old_path="/opt/anaconda3/bin/subliminal"
  subliminal_new_path=$(which subliminal)
  sed -i "s|$subliminal_old_path|$subliminal_new_path|g" $autosub_lua

  echo "Mpv subtitle have been configured for you :)"
}

init
