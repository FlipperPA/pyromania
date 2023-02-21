curl -o ~/.bashrc-pyro.sh https://raw.githubusercontent.com/FlipperPA/pyromania/main/pyro.sh
echo "# Start Pyromania upon login for venv management." >> ~/.bashrc
echo "source /etc/bashrc-pyro.sh" >> /etc/bashrc
