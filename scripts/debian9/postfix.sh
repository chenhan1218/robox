#!/bin/bash -eux

# Configure postfix to listen for relays on port 2525 so it doesn't conflict with magma.
sed -i -e "s/^smtp\([ ]*inet\)/127.0.0.1:2525\1/" /etc/postfix/master.cf

# Copy over the default debian postfix config file.
cp /usr/share/postfix/main.cf.debian /etc/postfix/main.cf

# Configure the postfix hostname and origin parameters.
printf "\ninet_interfaces = localhost\n" >> /etc/postfix/main.cf
printf "inet_protocols = ipv4\n" >> /etc/postfix/main.cf
printf "myhostname = relay.magma.builder\n" >> /etc/postfix/main.cf
printf "myorigin = magma.builder\n" >> /etc/postfix/main.cf
printf "transport_maps = hash:/etc/postfix/transport\n" >> /etc/postfix/main.cf

# printf "magma.builder         smtp:[127.0.0.1]:7000\n" >> /etc/postfix/transport
# postmap /etc/postfix/transport

# So it gets started automatically.
systemctl enable postfix.service && systemctl start postfix.service
