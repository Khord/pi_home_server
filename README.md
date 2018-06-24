# Pi Home Lab Server

**Initial Setup Checklist (Raspbian Lite)**
```shell
sudo raspi-config
  # password
  # hostname
  # static ip
  # locale
echo -e "\ndtoverlay=pi3-disable-wifi\ndtoverlay=pi3-disable-bt" | sudo tee -a /boot/config.txt
sudo apt-get update
sudo apt-get dist-upgrade
sudo reboot

curl -L https://install.pivpn.io | bash
pivpn -a

# scp .bash_profile to ~/ then:
alias motd=". ~/.bash_profile"
```

**Package Checklist**
- fail2ban
- [log2ram](https://github.com/azlux/log2ram)
- bind9

**NoIP DUC**
- http://www.noip.com/support/knowledgebase/install-ip-duc-onto-raspberry-pi/
- https://www.raspberrypi.org/forums/viewtopic.php?f=91&t=27558
```shell
sudo cp /usr/local/src/noip-2.1.9-1/debian.noip.sh /etc/init.d/noip2.sh
sudo chmod 755 /etc/init.d/noip2.sh
sudo update-rc.d noip2.sh defaults 94 6
sudo reboot
```
- http://unix.stackexchange.com/questions/199886/noip2-cant-update-my-ip-address-correctly-after-computer-reboot
```shell
sudo vi /etc/init.d/noip2.sh
sleep 10 (append after first echo line in case 1)
```

**PiVPN**
- https://yaleman.org/2013/04/22/openvpn-gateway-inside-mikrotik-router/
- Setting up the firewall to port forward for UDP port 1194 to the VPN gateway:
```
/ip firewall nat chain=dstnat action=dst-nat to-addresses=192.168.215.3 to-ports=1194 protocol=udp in-interface=pppoe-out1 dst-port=1194
```
- Adding a static route to point any VPN-destined traffic to the VPN gateway:
```
/ip route dst-address=10.8.0.0/24 gateway=192.168.215.3 gateway-status=192.168.215.3 reachable via ether2-local-master distance=1 scope=30 target-scope=10
```

**HomeAssistant**
- https://home-assistant.io/docs/installation/raspberry-pi/
- https://home-assistant.io/docs/autostart/systemd/
