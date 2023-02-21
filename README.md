# Pyromania venv Manager

Pyromania helps make venv management straightforward, inspired by `virtualenvwrapper`. By default, Pyromania will create a venv named `venv` in the current directory, and:

* Install the latest versions of `pip` and `wheel`.
* Includes handy options for switching to the `site-packages` folder.
* Creates pre and post activation hook scripts for additional customization.
* Activating your `venv` will automagically move to your project directory with a default pre-activation hook.

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

## Usage

* `pyro --list`: Lists the venvs currently managed by pyromania.
* `pyro my_venv`: Activate a venv called `my_venv`, or creates it if it doesn't exist.
* `pyro my_venv --delete`: Deletes a venv called `my_venv`.
* `pyro my_venv --venv`: Changes to to the venv's directory.

## Settings

* `VENV_DIR` (default: `venv`): default venv directory name.
* `VENV_PYTHON` (default: `python3`): the default version of Python to include.

## Pre and Post Activation Hooks

Your `venv` will contain to files which can be modified for pre and post activation options:

* `venv/pre_activate.sh`: script is run before the `venv` is activated.
* `venv/post_activate.sh`: script is run after the `venv` is activated.
