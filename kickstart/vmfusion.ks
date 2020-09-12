#version=RHEL8
# For VMware fusion
# nvme = nvme0n1
# scsi = sda
ignoredisk --only-use=sda

# Partition clearing information
# clearpart --none --initlabel

# Clear all partition
zerombr
clearpart --all

# Use graphical install
# graphical

# Use text install
text

# Use CDROM installation media
# cdrom

# Use network installation
url --url="http://192.168.235.11/centos82/BaseOS"
repo --name="AppStream" --baseurl="http://192.168.235.11/centos82/AppStream"

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Network information
network  --bootproto=dhcp --device=ens33 --ipv6=auto --activate
network  --hostname=localhost.localdomain


# Root password
# https://access.redhat.com/solutions/221403
# $ python -c 'import crypt,getpass; print crypt.crypt(getpass.getpass())'
# $ openssl passwd -6
rootpw --iscrypted $6$O46j8tUgEY6lpRzu$K1vbSxaoImSXG5Cmydmz9s7HXyPaDDj7NQ2ow2w5V38wyVh3mbHWtMlLGVFA7f4T5cBPREhZbMyUWevA5dQ.S/
user --groups=wheel --name=centos --password=$6$SZORTSRil1lqYxX2$ykdEXeCB69QdAOQKWoqWTRB/N77bYlG1SkQknhSkm3WphyUGkEssPkbrW7OggDlvw6kXjPJlgCbqfI9iIOZEg. --iscrypted --gecos="centos"

# Run the Setup Agent on first boot
# firstboot --enable
firstboot --disable
eula --agreed

# Do not configure the X Window System
skipx

# System services
services --enabled="chronyd"
services --enabled="cockpit.socket"

# System timezone
timezone Asia/Taipei --isUtc --ntpservers=time.stdtime.gov.tw,clock.stdtime.gov.tw

# Disk partitioning information
# nvme = nvme0n1
# scsi = sda
part pv.root --fstype="lvmpv" --ondisk=sda --size=9216 --grow
part /boot --fstype="ext4" --ondisk=sda --size=1024
volgroup vg00 --pesize=4096 pv.root
logvol /tmp --fstype="xfs" --size=5120 --name=tmp --vgname=vg00
logvol swap --fstype="swap" --size=2048 --name=swap1 --vgname=vg00
logvol swap --fstype="swap" --size=2048 --name=swap2 --vgname=vg00
logvol /var/log --fstype="xfs" --size=5120 --name=var_log --vgname=vg00
logvol / --fstype="xfs" --size=51200 --name=root --vgname=vg00
logvol /home --fstype="xfs" --size=20480 --name=home --vgname=vg00

# Reboot after complete installation
reboot

%packages
@^minimal-environment
kexec-tools
cockpit
cockpit-bridge
cockpit-system
cockpit-ws
cockpit-machines

%end

%addon com_redhat_kdump --enable --reserve-mb='auto'

%end

%anaconda
pwpolicy root --minlen=6 --minquality=1 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=1 --notstrict --nochanges --emptyok
pwpolicy luks --minlen=6 --minquality=1 --notstrict --nochanges --notempty
%end
