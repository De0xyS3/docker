#!/bin/bash
apt -y install dmidecode hwdata ucf hdparm
apt -y install perl libuniversal-require-perl libwww-perl libparse-edid-perl
apt -y install libproc-daemon-perl libfile-which-perl libhttp-daemon-perl
apt -y install libxml-treepp-perl libyaml-perl libnet-cups-perl libnet-ip-perl
apt -y install libdigest-sha-perl libsocket-getaddrinfo-perl libtext-template-perl
apt -y install libxml-xpath-perl libyaml-tiny-perl
wget https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.6/fusioninventory-agent_2.6-1_all.deb
dpkg -i fusioninventory-agent_2.6-1_all.deb
echo Ingresa la IP del servidor GLPI
read IP
echo "Se ha registrado la siguiente ip:  $IP"

cat > /etc/fusioninventory/agent.cfg <<EOF
# fusioninventory agent configuration

# all defined values match default
# all commented values are examples


#
# Target definition options
#

# send tasks results to an OCS server
#server = http://server.domain.com/ocsinventory
# send tasks results to a FusionInventory for GLPI server
server = http://$IP/plugins/fusioninventory/
# write tasks results in a directory
#local = /tmp

#
# Task definition options
#

# disable software deployment tasks
#no-task = deploy
#tasks = inventory,deploy,inventory

#
# Target scheduling options
#

# maximum delay before first target, in seconds
# Also the maximum delay on network error. Delay on network error starts
# from 60, is doubled at each new failed attempt until reaching delaytime.
delaytime = 3600
# do not contact the target before next scheduled time
lazy = 0

#
# Inventory task specific options
#

# do not list local printers
# no-category = printer
# allow to scan user home directories
scan-homedirs = 0
# allow to scan user profiles
scan-profiles = 0
# save the inventory as HTML
html = 0
# timeout for inventory modules execution
backend-collect-timeout = 180
# always send data to server
force = 0
# additional inventory content file
additional-content =

#
# Package deployment task specific options
#

# do not use peer to peer to download files
no-p2p = 0

#
# Network options
#

# proxy address
proxy =
# user name for server authentication
user =
# password for server authentication
password =
# CA certificates directory
ca-cert-dir =
# CA certificates file
ca-cert-file =
# do not check server SSL certificate
no-ssl-check = 0
# connection timeout, in seconds
timeout = 180

#
# Web interface options
#

# disable embedded web server
no-httpd = 0
# network interface to listen to
httpd-ip =
# network port to listen to
httpd-port = 62354
# trust requests without authentication token
httpd-trust =

#
# Logging options
#

# Logger backend, either Stderr, File or Syslog (Stderr)
logger = syslog,stderr
# log file
#logfile = /var/log/fusioninventory.log
# maximum log file size, in MB
#logfile-maxsize = 0
# Syslog facility
logfacility = LOG_DAEMON
# Use color in the console
color = 0

#
# Execution mode options
#

# add given tag to inventory results
tag = 
# debug mode
debug = 0

# time to wait to reload config (0 means no reload, it's default value)
# conf-reload-interval = 0

# Since 2.4, you can include all .cfg files from a folder or any given file
# For example:
#   1. file "conf.d/tag.cfg" contains "tag = 'entity123'"
#      using "include 'conf.d' will set tag to 'entity123'
#   2. file "/etc/production/glpi-tag" contains "tag = 'entity123'"
#      using "include '/etc/production/glpi-tag' will set tag to 'entity123'
# Remark:
#   1. Prefer to use full path to avoid confusion, but be aware relative paths are
#      relative against current config file folder
#   2. A parameter set in included file can be over-rided if set again after the directive
#   3. *.cfg files are read in order in folder, it's better to prefix them with a number
#   4. Package maintainers are encouraged to use this feature to avoid conflict
#      during upgrades after configuration update
#
include "conf.d/"
#include "agent.local"

EOF

systemctl restart fusioninventory-agent
systemctl reload fusioninventory-agent
pkill -USR1 -f -P 1 fusioninventory-agent
