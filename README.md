# Pyromania

Pyromania helps you manage Python 3 venvs. It was inspired by `virtualenvwrapper`. By default, Pyromania will create a venv named `venv` in the current directory

## Installation

We recommend using a `pip install` with sudo, so it is available system wide. This will install a file called `bashrc-pyro` into `/etc`, and append a line to `/etc/bashrc` to invoke it.

```
sudo pip install pyromania
```

## Settings

* `VENV_DIR` (default: `venv`): default venv directory name.
* `VENV_PYTHON` (default: `python3`): the default version of Python to include.

## Usage

* `pyro --list`: Lists the venvs currently managed by pyromania.
* `pyro my_venv`: Activate a venv called `my_venv`, or creates it if it doesn't exist.
* `pyro my_venv --delete`: Deletes a venv called `my_venv`.
* `pyro my_venv --venv`: Changes to to the venv's directory.
