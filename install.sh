if grep -q "# Start Pyromania" ~/.bashrc; then
    echo "It appears Pyromania is already installed. Remove it from ~/.bashrc if"
    echo "you need to reinstall."
else
    curl -sS -o ~/.bashrc-pyro.sh https://raw.githubusercontent.com/FlipperPA/pyromania/main/pyro.sh

    echo "" >> ~/.bashrc
    echo "# Start Pyromania upon login for venv management." >> ~/.bashrc
    echo "source ~/.bashrc-pyro.sh" >> ~/.bashrc
    echo "export VENV_PYTHON=`which python3`" >> ~/.bashrc
    echo "# End Pyromania configuration." >> ~/.bashrc

    echo "Pyromania has been installed!"
    echo ""

    pyro
fi
