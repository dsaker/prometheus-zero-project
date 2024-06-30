# ==================================================================================== #
# VARIABLES
# ==================================================================================== #

raspberrypi_hostname = "raspberrypi.local"
username = "dsaker"

# ==================================================================================== #
# HELPERS
# ==================================================================================== #

## help: print this help message
help:
	@echo 'Usage:'
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'


# ==================================================================================== #
# SETUP
# ==================================================================================== #

## swapsize: increase swapfile size so you can run sudo apt upgrade on raspberrypi zero 2W
swapsize:
	ssh -t ${username}@${raspberrypi_hostname} '\
    		sudo dphys-swapfile swapoff \
            sudo sed -i -e 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=1024/g' /etc/dphys-swapfile \
            sudo dphys-swapfile setup \
            sudo dphys-swapfile swapon \
            sudo reboot'

## copyfiles: copy all files to your raspberry pi
copyfiles:
	rsync -rP . ${username}@${raspberrypi_hostname}:~

# ==================================================================================== #
# MAINTENANCE
# ==================================================================================== #

## connect: ssh into your raspberry pi
connect:
	ssh ${username}@${raspberrypi_hostname}

## prom/config: update prometheus.yml and restart prometheus
prom/config:
	rsync -rP --delete ./configs/prometheus.yml ${username}@${raspberrypi_hostname}:~
	ssh ${username}@${raspberrypi_hostname} '\
		sudo mv prometheus.yml  /etc/prometheus/prometheus.yml'
	curl -X POST http://${raspberrypi_hostname}:9090/-/reload

## prom/rules: update prometheus rules and restart prometheus
prom/rules:
	rsync -rP rules/ ${username}@${raspberrypi_hostname}:~/rules/
	ssh ${username}@${raspberrypi_hostname} '\
		sudo cp -TR ~/rules/  /etc/prometheus/rules/'
	curl -X POST http://${raspberrypi_hostname}:9090/-/reload

## alert/config: update alertmanager.yml and restart alertmanager
alert/config:
	rsync -rP --delete ./configs/alertmanager.yml ${username}@${raspberrypi_hostname}:~
	ssh ${username}@${raspberrypi_hostname} '\
		sudo mv alertmanager.yml  /etc/alertmanager/alertmanager.yml'
	curl -X POST http://${raspberrypi_hostname}:9093/-/reload
