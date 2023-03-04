# based on ubuntu server 18.04
# todo - on progress

declare -A flag
LOGGED_USER_HOME=$(eval echo ~${SUDO_USER})
LOGGED_USER=$(logname)
ACTIVE_USER=$USER
TMP_DIR=/tmp
CODE_NAME=$(lsb_release -csu 2> /dev/null || lsb_release -cs)
FUNCTION_NAME=$1
cd $TMP_DIR

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
  if type $FUNCTION_NAME &>/dev/null
  then
    eval $FUNCTION_NAME
  else
    echo "Function $FUNCTION_NAME does not exist."
  fi

  if [ ! -z $FUNCTION_NAME ]; then exit 1; fi
}

select_packages()
{
  echo "Please confirm package for installation..."

  confirm "install_vim->(y|n)" "install_vim"
  confirm "install_openssh_server->(y|n)" "install_openssh_server"
  confirm "install_git->(y|n)" "install_git"
  confirm "install_composer->(y|n)" "install_composer"
  confirm "install_nginx->(y|n)" "install_nginx"
  confirm "install_php_fpm->(y|n)" "install_php_fpm"
  confirm "install_symfony_php_extension->(y|n)" "install_symfony_php_extension"
  confirm "install_nvm->(y|n)" "install_nvm"
  confirm "install_mysql_server->(y|n)" "install_mysql_server"
  confirm "install_docker->(y|n)" "install_docker"

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

install_openssh_server()
{
  if is_package_installed openssh-server ; then return 1; fi

  sudo apt-get install -y openssh-server

  echo "Openssh server have been installed for you :)"
}

install_git()
{
  if is_package_installed git ; then return 1; fi

  add-apt-repository -y ppa:git-core/ppa
  sudo apt update
  sudo apt install -y git

  echo "Git have been installed for you :)"
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
  mv composer.phar /usr/local/bin/composer
  exit $RESULT
  chown -R $LOGGED_USER:$LOGGED_USER /usr/local/bin/composer


  echo "Composer have been installed for you :)"
}