#This script extract PPA and manually installed packages in your OS and make another script for installing same packages on another OS
#Must be run as sudo

#!/bin/bash

#Executing in bash and updating repositories
echo -e "#!/bin/bash\napt update"

#Extracting ALL repositories from /etc/apt/*.list
for APT in `find /etc/apt/ -name \*.list`; do
    grep -Po "(?<=^deb\s).*?(?=#|$)" $APT | while read ENTRY ; do
        HOST=`echo $ENTRY | cut -d/ -f3`
        USER=`echo $ENTRY | cut -d/ -f4`
        PPA=`echo $ENTRY | cut -d/ -f5`
        #echo apt-add-repository ppa:$USER/$PPA
        if [ "ppa.launchpad.net" = "$HOST" ]; then
            echo apt-add-repository -y ppa:$USER/$PPA
        else
            echo apt-add-repository -y \'${ENTRY}\'
        fi
    done
done

#Update again
echo "apt update"

#Extracting manually installed packages marked as "manually installed"
echo "apt install -f -y "$(comm -23 <(apt-mark showmanual | sort -u) <(gzip -dc /var/log/installer/initial-status.gz | sed -n 's/^Package: //p' | sort -u))
