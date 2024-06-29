install raspberry pi os with Raspberry Pi Imager and config setup
choose Raspberry Pi OS (other) > Raspberry Pi OS Lite (64 bit) with no desktop environment 
EDIT SETTINGS 
GENERAL > Set username and password > Configure wireless LAN > set locale
(when I enabled Set local settings in imaging ssh failed)
SERVICES > Enable SSH (if you are doing this a second time you either have to change the hostname in GENERAL or delete rapsberrypi.local from ~/.ssh/known_hosts)

set variables in Makefile
raspberrypi_hostname = "raspberrypi.local"
username = "<your_username>"

run 
make copyfiles