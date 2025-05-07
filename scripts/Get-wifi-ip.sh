#/bin/bash
# Description: Get wifi ip assigned for the wifi device on Linux server

# Get pci slot of the wifi device
pci_slot=$(lspci |egrep -i "wireless|wifi" |awk '{print $1;}')
[ "${pci_slot:-null}" == 'null' ] && echo No wifi device found && exit
device=$(ls -l /sys/class/net/* |grep $pci_slot | awk -F"/" '{print $NF;}')
[ "${device:-null}" == 'null' ] && echo No device found for pci slot $pci_slot && exit
ip_address=$(ip -4 addr show $device |awk '/inet/{sub("/.*","",$2);print $2;}')
[ "${ip_address:-null}" == 'null' ] && echo No ipv4 address found for PCI slot $pci_slot, device $device && exit
echo $pci_slot $device $ip_address