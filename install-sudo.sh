if grep -q "# Start Pyromania" /etc/bashrc; then
    echo "It appears Pyromania is already installed for all users. Remove it from"
    echo "/etc/bashrc if you need to reinstall."
    echo ""
    echo "You can update to the latest script version with these commands:"
    echo "sudo curl -sS -o /etc/bashrc-pyro.sh https://raw.githubusercontent.com/FlipperPA/pyromania/main/pyro.sh"
    echo "source /etc/bashrc"
else
    sudo curl -sS -o /etc/bashrc-pyro.sh https://raw.githubusercontent.com/FlipperPA/pyromania/main/pyro.sh
    sudo chmod 644 /etc/bashrc-pyro.sh

    echo "Looking for python3 in the path..."
    PYTHON3="$(sudo which python3)"
    
    sudo sh -c "cat >> /etc/bashrc <<EOT

# Start Pyromania upon login for venv management.
source /etc/bashrc-pyro.sh
export VENV_PYTHON=${PYTHON3}
# End Pyromania configuration.
EOT"
    if ! which python3 ; then
        echo "WARNING!"
        echo "'python3' could not be found in the system path. You should edit /etc/bashrc"
        echo "and set 'VENV_PYTHON' to the path of your preferred Python 3 binary."
	echo ""
    fi
    echo "Pyromania has been installed! Type 'pyro --help' for help getting started."

    source /etc/bashrc
fi
