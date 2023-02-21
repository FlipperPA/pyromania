echo "To install pyromania for all users on your system, sudo access it required."

sudo curl -o /etc/bashrc-pyro.sh https://raw.githubusercontent.com/FlipperPA/pyromania/main/pyro.sh
sudo echo "# Start Pyromania for all system users." >> /etc/bashrc
sudo echo "source /etc/bashrc-pyro.sh" >> /etc/bashrc
