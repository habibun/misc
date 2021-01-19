# Ubuntu Setup Script
A setup script for ubuntu

## Usage

url=`https://raw.githubusercontent.com/habibun/ubuntu-setup/main/desktop.sh`

wget: `bash <(wget -qO- https://raw.githubusercontent.com/habibun/ubuntu-setup/main/desktop.sh)`

curl: `bash <(curl -s https://raw.githubusercontent.com/habibun/ubuntu-setup/main/desktop.sh)`

single function: `curl -s https://raw.githubusercontent.com/habibun/ubuntu-setup/main/desktop.sh | bash /dev/stdin function_name`

curl -sL https://raw.githubusercontent.com/habibun/ubuntu-setup/main/desktop.sh | sudo bash -

curl https://raw.githubusercontent.com/habibun/ubuntu-setup/main/desktop.sh | sudo bash

`sudo su -c "bash <(wget -qO- https://raw.githubusercontent.com/habibun/ubuntu-setup/main/desktop.sh)" root`