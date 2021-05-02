#!/bin/bash
# based on ubuntu 20.04

declare -A flag
LOGGED_USER_HOME=$(eval echo ~"${SUDO_USER}")
LOGGED_USER=$(logname)
ACTIVE_USER=$USER
TMP_DIR=/tmp
CODE_NAME=$(lsb_release -csu 2> /dev/null || lsb_release -cs)
FUNCTION_NAME=$1
cd $TMP_DIR || exit

# init
init()
{
  particular_function
  select_packages
  install_packages
  install_configuration
}

# utility
is_package_installed()
{
  if command -v $1 &> /dev/null
  then
    echo "$1 is already installed";
    return 0
  else
    echo "Installing $1..."
    return 1
  fi
}

is_file_exists()
{
  if [ -e $1 ]
  then
      return 0
  else
      return 1
  fi
}

confirm(){
    read -p `echo "$1"` yn
    case $yn in [Yy]* )
    flag["$2"]=true;
    esac
}

confirm_immediate(){
    read -p `echo "$1"` yn
    case $yn in [Yy]* )
    eval $2
    esac
}

particular_function()
{
  if type "$FUNCTION_NAME" &>/dev/null
  then
    eval "$FUNCTION_NAME"
  else
    echo "Function $FUNCTION_NAME does not exist."
  fi

  if [ ! -z "$FUNCTION_NAME" ]; then exit 1; fi
}

select_packages()
{
  echo "Please confirm package for installation..."

  confirm "install_vim->(y|n)" "install_vim"
  confirm "install_git->(y|n)" "install_git"
  confirm "install_composer->(y|n)" "install_composer"
  confirm "install_nginx->(y|n)" "install_nginx"
  confirm "install_php_fpm->(y|n)" "install_php_fpm"
  confirm "install_symfony->(y|n)" "install_symfony"
  confirm "install_codesniffer->(y|n)" "install_codesniffer"
  confirm "install_php_cs_fixer->(y|n)" "install_php_cs_fixer"
  confirm "install_nvm->(y|n)" "install_nvm"
  confirm "install_phpstorm->(y|n)" "install_phpstorm"
  confirm "install_datagrip->(y|n)" "install_datagrip"
  confirm "install_postman->(y|n)" "install_postman"
  confirm "install_skype->(y|n)" "install_skype"
  confirm "install_mysql_server->(y|n)" "install_mysql_server"
  confirm "install_docker->(y|n)" "install_docker"
  confirm "install_mpv->(y|n)" "install_mpv"
  confirm "install_google_chrome->(y|n)" "install_google_chrome"
  confirm "install_chrome_gnome_shell->(y|n)" "install_chrome_gnome_shell"
  confirm "install_slack->(y|n)" "install_slack"
  confirm "install_team_viewer->(y|n)" "install_team_viewer"
  confirm "install_kazam->(y|n)" "install_kazam"
  confirm "install_yarn->(y|n)" "install_yarn"

  echo "Package confirmation done :)"
}

install_packages()
{
  echo "This can take a while. Please be patient..."

  sudo apt-get update && sudo apt-get -y upgrade
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

  confirm_immediate "config_generate_ssh_key->(y|n)" "config_generate_ssh_key"
  confirm_immediate "config_git->(y|n)" "config_git"
  confirm_immediate "config_mysql->(y|n)" "config_mysql"
  confirm_immediate "config_bash_aliases->(y|n)" "config_bash_aliases"
  confirm_immediate "config_nginx_virtual_host->(y|n)" "config_nginx_virtual_host"
  confirm_immediate "config_mpv_subtitle->(y|n)" "config_mpv_subtitle"

  echo "Configuration have been installed for you :)"
}

# installation
install_openssh_server()
{
  if is_package_installed openssh-server ; then return 1; fi

  sudo apt-get install -y openssh-server

  echo "Openssh server have been installed for you :)"
}

install_gnome_tweak_tool()
{
  if is_package_installed gnome-tweak-tool ; then return 1; fi

  sudo apt-get install -y gnome-tweak-tool

  echo "Gnome tweak tool have been installed for you :)"
}

install_vim()
{
  if is_package_installed vim ; then return 1; fi

  sudo apt-get install -y vim

  echo "Vim have been installed for you :)"
}

install_yarn()
{
  if is_package_installed yarn ; then return 1; fi

  npm install --global yarn

  echo "Yarn have been installed for you :)"
}

install_kazam()
{
  if is_package_installed kazam ; then return 1; fi

  sudo apt-get install -y kazam

  echo "Kazam have been installed for you :)"
}

install_php_fpm()
{
  if is_package_installed php7.4-fpm ; then return 1; fi

  sudo apt-get install -y php7.4-fpm\
                      php7.4-xml\
                      php7.4-mbstring\
                      php7.4-intl\
                      php7.4-mysql\
                      php7.4-sqlite3\
                      php7.4-gd\
                      php7.4-http\
                      php7.4-curl\
                      php7.4-mysql

  echo "php7.4-fpm have been installed for you :)"
}

install_codesniffer()
{
  if is_package_installed phpcs ; then return 1; fi

  wget https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
  wget https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar
  chmod a+x phpcs
  chmod a+x phpcbf
  mv phpcs.phar /usr/local/bin/phpcs
  mv phpcbf.phar /usr/local/bin/phpcbf
  chown -R "$LOGGED_USER":"$LOGGED_USER" /usr/local/bin/phpcs
  chown -R "$LOGGED_USER":"$LOGGED_USER" /usr/local/bin/phpcbf

  echo "Codesniffer have been installed for you :)"
}

install_php_cs_fixer()
{
  if is_package_installed php-cs-fixer ; then return 1; fi

  wget https://cs.symfony.com/download/php-cs-fixer-v2.phar -O php-cs-fixer
  chmod a+x php-cs-fixer
  mv php-cs-fixer /usr/local/bin/php-cs-fixer
  chown -R $LOGGED_USER:$LOGGED_USER /usr/local/bin/php-cs-fixer

  echo "php cs fixer have been installed for you :)"
}

install_nginx()
{
  if is_package_installed nginx ; then return 1; fi

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
  if is_package_installed git ; then return 1; fi

  add-apt-repository -y ppa:git-core/ppa
  sudo apt update
  sudo apt install -y git

  echo "Git have been installed for you :)"
}

install_symfony()
{
  if is_package_installed symfony ; then return 1; fi

  wget https://get.symfony.com/cli/installer -O - | bash
  mv "${LOGGED_USER_HOME}"/.symfony/bin/symfony /usr/local/bin/symfony

  echo "Symfony have been installed for you :)"
}

install_composer()
{
  if is_package_installed composer ; then return 1; fi

  EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

  if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
  then
      >&2 echo 'ERROR: Invalid installer checksum'
      rm composer-setup.php
      exit 1
  fi

  sudo apt-get install -y zip\
                          unzip
  php composer-setup.php --quiet
  RESULT=$?
  rm composer-setup.php
  exit $RESULT
  mv composer.phar /usr/local/bin/composer
  chown -R $LOGGED_USER:$LOGGED_USER /usr/local/bin/composer

  echo "Composer have been installed for you :)"
}

install_virtualbox()
{
  version=$(curl http://download.virtualbox.org/virtualbox/LATEST-STABLE.TXT)
  version="$(echo $version| cut -d'.' -f1).$(echo $version| cut -d'.' -f2)"

  if is_package_installed virtualbox-$version ; then return 1; fi

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
  if is_package_installed nvm ; then return 1; fi

  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  nvm install node stable

  echo "NVM have been installed for you :)"
}

install_phpstorm()
{
  if is_package_installed phpstorm ; then return 1; fi

  sudo snap install phpstorm --classic

  echo "Phpstorm have been installed for you :)"
}

install_datagrip()
{
  if is_package_installed datagrip ; then return 1; fi

  sudo snap install datagrip --classic

  echo "Datagrip have been installed for you :)"
}

install_postman()
{
  if is_package_installed postman ; then return 1; fi

  sudo snap install postman

  echo "Postman have been installed for you :)"
}

install_skype()
{
  if is_package_installed skype ; then return 1; fi

  sudo snap install skype --classic

  echo "Skype have been installed for you :)"
}

install_slack()
{
  if is_package_installed slack ; then return 1; fi

  sudo snap install slack --classic

  echo "Slack have been installed for you :)"
}

install_mpv()
{
  if is_package_installed mpv ; then return 1; fi

  sudo add-apt-repository -y ppa:mc3man/mpv-tests
  sudo apt-get update
  sudo apt-get install -y mpv

  echo "Mpv have been installed for you :)"
}

install_docker()
{
  if is_package_installed docker ; then return 1; fi

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
  if is_package_installed mysql-server ; then return 1; fi

  sudo apt-get install -y mysql-server

  echo "Mysql server have been installed for you :)"
}

install_google_chrome()
{
  if is_package_installed google-chrome-stable ; then return 1; fi

  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
  sudo apt-get update
  sudo apt-get install google-chrome-stable

  echo "Google chrome have been installed for you :)"
}

install_chrome_gnome_shell()
{
  if is_package_installed chrome-gnome-shell ; then return 1; fi

  sudo apt-get install -y chrome-gnome-shell

  echo "Chrome gnome shell have been installed for you :)"
}

install_team_viewer()
{
  if is_package_installed teamviewer ; then return 1; fi

  wget https://download.teamviewer.com/download/linux/signature/TeamViewer2017.asc
  sudo apt-key add TeamViewer2017.asc
  sudo sh -c 'echo "deb http://linux.teamviewer.com/deb stable main" >> /etc/apt/sources.list.d/teamviewer.list'
  sudo apt update
  sudo apt install -y teamviewer

  echo "Team viewer have been installed for you :)"
}

# configuration
config_generate_ssh_key()
{
  public_key_path=$LOGGED_USER_HOME/.ssh/id_ed25519.pub
  if is_file_exists $public_key_path ;
    then
      echo "SSH key already exists"
      return 1;
  fi

  echo "Configuring ssh..."

  read -p "Please enter email address for ssh configuration: " email
  sudo -H -u $LOGGED_USER bash -c 'ssh-keygen -t ed25519 -C "$email"'
  eval "$(ssh-agent -s)"
  ssh-add $LOGGED_USER_HOME/.ssh/id_ed25519
  echo "your public key: "$(cat $public_key_path)

  echo "Ssh have been configured for you :)"
}

config_git()
{
  if [[ $(git config --get user.email) ]]; then
      echo "Git already configured"
      return 1;
  fi

  echo "Configuring git..."

  read -p "Please enter your email address for git configuration: " email
  read -p "Please enter your name for git configuration: " name

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
  mysql -uroot -p -e 'ALTER USER "root"@"localhost" IDENTIFIED WITH mysql_native_password BY ""; FLUSH PRIVILEGES;'
  echo "Mysql have been configured for you :)"
}

config_bash_aliases()
{
  alias_path=$LOGGED_USER_HOME/.bash_aliases
  if [[ ! -e $alias_path ]]; then
    touch $alias_path
    else
      echo "Bash aliases already added"
      return 1;
  fi

  echo "Configuring bash aliases..."

  # git
  gs="alias gs=\"git status\""
  gac="alias gac=\"git add . && git commit -m\""
  gpo="alias gpo='git push origin \"\$(git symbolic-ref --short HEAD)\"'"
  glo="alias glo='git pull origin \"\$(git symbolic-ref --short HEAD)\"'"
  gcb="alias gcb=\"git checkout -b\""
  gl="alias glo=\"git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit\""

  grep -qxF "$gs" $alias_path || echo "$gs" >> $alias_path
  grep -qxF "$gac" $alias_path || echo "$gac" >> $alias_path
  grep -qxF "$gpo" $alias_path || echo "$gpo" >> $alias_path
  grep -qxF "$glo" $alias_path || echo "$glo" >> $alias_path
  grep -qxF "$gcb" $alias_path || echo "$gcb" >> $alias_path
  grep -qxF "$gl" $alias_path || echo "$gl" >> $alias_path

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
  if is_file_exists $vhost_file ;
  then
    echo "Virtual host already exists for $domain"
    return 1;
  fi

  test -f $vhost_file || sudo touch $vhost_file
  el="$domain"_error
  ac="$domain"_access

cat <<EOT >> $vhost_file
server {
    server_name $domain.local www.$domain.local;
    root $WEB_ROOT_DIR/$domain/public;

    location / {
        try_files \$uri /index.php\$is_args\$args;
    }

    location ~ ^/index\.php(/|$) {
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
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
  mkdir -p $LOGGED_USER_HOME/.config/mpv/scripts
  autosub_lua=$LOGGED_USER_HOME/.config/mpv/scripts/autosub.lua

  if is_file_exists $autosub_lua ;
  then
    echo "MPV automatic subtitle download already configured"
    return 1;
  fi

  echo "Configuring mpv subtitle..."

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

# todo - xdebug
