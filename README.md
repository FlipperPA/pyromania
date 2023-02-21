# Pyromania

Pyromania helps you manage Python 3 venvs. It was inspired by `virtualenvwrapper`. By default, Pyromania will create a venv named `venv` in the current directory.

## System Wide Installation

To install the `pyro` command for all users on your system with sudo escalation:

```bash
curl -sS https://raw.githubusercontent.com/FlipperPA/pyromania/main/install-sudo.sh | sh
```

## User Installation

To install the `pyro` command for the current user only:

```bash
curl -sS https://raw.githubusercontent.com/FlipperPA/pyromania/main/install.sh | sh
```

## Settings

* `VENV_DIR` (default: `venv`): default venv directory name.
* `VENV_PYTHON` (default: `python3`): the default version of Python to include.

## Usage

* `pyro --list`: Lists the venvs currently managed by pyromania.
* `pyro my_venv`: Activate a venv called `my_venv`, or creates it if it doesn't exist.
* `pyro my_venv --delete`: Deletes a venv called `my_venv`.
* `pyro my_venv --venv`: Changes to to the venv's directory.
