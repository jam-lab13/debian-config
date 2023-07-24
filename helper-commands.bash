# Flatpak list export
flatpak list --columns=app | grep -iv freedesktop | grep -iv platform | grep -iv wine | grep -iv kde > ~/Documents/code-projects/git/debian-config/flatpaks.txt

### Setup Login Screen
# List your screens
xrandr | grep ' connected'

### Switch desktop environments
sudo tasksel

### Config the login screens so only the primary display is active
sudo su -
YOUR_SECONDARY_MONITOR="DP-1"
YOUR_TERTIARY_MONITOR="HDMI-0"
sudo echo 'xrandr --output' $YOUR_SECONDARY_MONITOR '--off' >> /usr/share/sddm/scripts/Xsetup
sudo echo 'xrandr --output' $YOUR_TERTIARY_MONITOR '--off' >> /usr/share/sddm/scripts/Xsetup
### Push to startup script
sudo printf "[XDisplay]\nDisplayCommand=/usr/share/sddm/scripts/Xsetup" > /etc/sddm.conf
exit

### sed
# Pull out empty lines from a file:
sudo sed -i '/^[[:space:]]*$/d' /path/to/file
# Append a string to the end of each file, starting on line 2
sudo sed -ie '2,$ s/$/ contrib non-free non-free-firmware/' /etc/apt/sources.list.d/nala-sources.list

### Restart kde panels
killall plasmashell
plasmashell &

### Backup /etc/apt/sources.list file
deb http://deb.debian.org/debian/ stable main non-free-firmware
deb-src http://deb.debian.org/debian/ stable main non-free-firmware

deb http://security.debian.org/debian-security stable-security main non-free-firmware
deb-src http://security.debian.org/debian-security stable-security main non-free-firmware

# stable-updates, to get updates before a point release is made;
# see https://www.debian.org/doc/manuals/debian-reference/ch02.en.html#_updates_and_backports
deb http://deb.debian.org/debian/ stable-updates main non-free-firmware
deb-src http://deb.debian.org/debian/ stable-updates main non-free-firmware

### Backup /etc/apt/sources.list.d/nala-sources.list
# Sources file built for nala

deb http://debian-archive.trafficmanager.net/debian/ stable main contrib non-free non-free-firmware
deb https://mirror.i3d.net/debian/ stable main
deb http://mirror.keystealth.org/debian/ stable main
deb http://debian.uchicago.edu/debian/ stable main
deb http://ftp.us.debian.org/debian/ stable main
deb http://mirror.siena.edu/debian/ stable main
deb https://mirror.us.oneandone.net/debian/ stable main
deb http://debian.mirror.constant.com/debian/ stable main
deb https://mirror.dal.nexril.net/debian/ stable main
deb https://plug-mirror.rcac.purdue.edu/debian/ stable main

### SSH Agent on startup:
SSH_ENV="$HOME/.ssh/agent-environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi



