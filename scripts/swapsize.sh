sudo dphys-swapfile swapoff
sudo sed -i -e 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=1024/g' /etc/dphys-swapfile
sudo dphys-swapfile setup
sudo dphys-swapfile swapon
sudo reboot