if grep -q "# Start Pyromania" /etc/bashrc; then
    echo "It appears Pyromania is already installed for all users. Remove it from"
    echo "/etc/bashrc if you need to reinstall."
else
    sudo curl -sS -o /etc/bashrc-pyro.sh https://raw.githubusercontent.com/FlipperPA/pyromania/main/pyro.sh

    sudo echo "" >> /etc/bashrc
    sudo echo "# Start Pyromania upon login for venv management." >> /etc/bashrc
    sudo echo "source /etc/bashrc-pyro.sh" >> /etc/bashrc
    sudo echo "export VENV_PYTHON=`which python3`" >> /etc/bashrc
    sudo echo "# End Pyromania configuration." >> /etc/bashrc

    echo "Pyromania has been installed! Type 'pyro' for help getting started."

    source /etc/bashrc
fi
