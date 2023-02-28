curl -sS -o ~/.bashrc-pyro.sh https://raw.githubusercontent.com/FlipperPA/pyromania/main/pyro.sh

if grep -q "# Start Pyromania" ~/.bashrc; then
    echo "It appears Pyromania is already installed. Remove it from ~/.bashrc"
    echo "for a complete reinstall. Updating the Pyromania script to the latest"
    echo "verison."
else
    echo "" >> ~/.bashrc
    echo "# Start Pyromania upon login for venv management." >> ~/.bashrc
    echo "source ~/.bashrc-pyro.sh" >> ~/.bashrc
    echo "export VENV_PYTHON=`which python3`" >> ~/.bashrc
    echo "# End Pyromania configuration." >> ~/.bashrc

    if ! which python3asdf ; then
        echo "WARNING!"
        echo "'python3' could not be found in the system path. You should edit ~/.bashrc"
        echo "and set 'VENV_PYTHON' to the path of your preferred Python 3 binary."
	echo ""
    fi
    echo "Pyromania has been installed! Type 'pyro --help' for help getting started."

    source ~/.bashrc
fi
