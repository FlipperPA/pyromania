function pyro_help() {
    echo "Pyromania venv Helper"
    echo "---------------------"
    echo "Pyromania creates and manages Python 3 venvs."
    echo ""
    echo "Pyromania uses Python to create a venv folder in the current directory and"
    echo "activates the venv. It upgrades pip and installs wheel. It also creates a"
    echo "script which will automatically change to the directory where it was created"
    echo "when activated, for easy access."
    echo ""
    echo "Usage, where [venv] is the name of the Python virtual environment:"
    echo "pyro [venv] [options]"
    echo ""
    echo "Options:"
    echo "--help, -h"
    echo "--delete, -d"
    echo "--packages, -p"
    echo ""
    echo "Examples:"
    echo "pyro                  List Pyromania managed venvs."
    echo "pyro --help           Display this help menu."
    echo "pyro [venv]           Activates the venv; creates the venv if it does not exist."
    echo "pyro [venv] --delete  Deletes the venv."
    echo "pyro [venv] -p        Changes to the site-packages folder of the venv."
    echo ""
    echo "Settings via Environment Variables"
    echo "----------------------------------"
    echo "VENV_PYTHON (default: 'python3') The Python binary to create the venv."
    echo "    Currently: '$VENV_PYTHON'"
    echo "VENV_DIR (default: 'venv') Directory name of the venv to create in the directory."
    echo "    Currently: '$VENV_DIR'"
    echo ""
    echo "These can be overridden at the command line. Consider this example:"
    echo ""
    echo "VENV_PYTHON=/usr/bin/python3.10 VENV_DIR=my_dir pyro wrds"
    echo ""
    echo "The example uses '/usr/bin/python3.10' to create the venv in directory 'my_dir'"
    echo "instead of using the default environment variable."
    echo ""
    echo "For more information, see: https://github.com/FlipperPA/pyromania"
}

function pyro_list() {
    echo -e $VENV_LIST
}

function pyro_activate() {
    if [ -f "${ACTIVE_DIR}/${ACTIVE_VENV}/bin/activate" ]; then
        # Run commands before activation
        if [ -f "${ACTIVE_DIR}/${ACTIVE_VENV}/pre_activate.sh" ]; then
            . "${ACTIVE_DIR}/${ACTIVE_VENV}/pre_activate.sh"
        fi

        echo "Activating venv ${ACTIVE_NAME}..."
        . "${ACTIVE_DIR}/${ACTIVE_VENV}/bin/activate"

        # Run commands after activation
        if [ -f "${ACTIVE_DIR}/${ACTIVE_VENV}/post_activate.sh" ]; then
            . "${ACTIVE_DIR}/${ACTIVE_VENV}/post_activate.sh"
        fi
    else
        echo "Could not find the venv directory ${ACTIVE_DIR}/${ACTIVE_VENV}."
        echo "You may need to remove the entry from ~/.pyromania."
        echo "Here is a list of venvs:"
        echo -e $VENV_LIST
    fi
}

function pyro_add_to_list() {
    echo "${ACTIVE_NAME}:${ACTIVE_DIR}:${ACTIVE_VENV}" >> ~/.pyromania
}

function pyro_create() {
    ACTIVE_NAME=$1
    ACTIVE_DIR=`pwd`
    ACTIVE_VENV="${VENV_DIR}"

    if [ -f "${ACTIVE_DIR}/${ACTIVE_VENV}/bin/activate" ]; then
    # If we find a venv that already exists, just add it to the list and activate.
    echo "There appears to already be a 'venv' at '${ACTIVE_DIR}/${ACTIVE_VENV}'."
    echo "It will be added to Pyromania's managed venv list."
    pyro_add_to_list
    pyro_activate
    else
    echo "Creating a new venv in directory ${ACTIVE_DIR}/${ACTIVE_VENV}..."
    # Create the venv
    ${VENV_PYTHON} -m venv --copies --prompt ${ACTIVE_NAME} ${ACTIVE_VENV}
    pyro_add_to_list
    
    # Create script to run before venv activation
    echo "# Commands to be run before venv activation" >> "${ACTIVE_VENV}/pre_activate.sh"

    # Create script to run after venv activation, default to current directory
    echo "# Commands to be run after venv activation" >> "${ACTIVE_VENV}/post_activate.sh"
    echo "cd ${PWD}" >> "${ACTIVE_VENV}/post_activate.sh"

    # Activate the new venv
    pyro_activate

    # Get the latest pip
    echo "Upgrading to latest pip & wheel..."
    pip install --quiet --upgrade pip wheel
    fi
}

function pyro_setup() {
    ACTIVE_NAME=""
    ACTIVE_DIR=""
    ACTIVE_VENV=""
    VENV_LIST=""
    ACTION="--create"

    # Default to use venv for the venv directory name
    if [ -z "${VENV_DIR}" ]; then
        VENV_DIR="venv"
    fi

    # Default to using python3 to create a venv
    if [ -z "${VENV_PYTHON}" ]; then
        VENV_PYTHON="python3"
    fi

    param_venv_name=$1

    local IFS=:
    # Ensure that our metadata file exists
    touch ~/.pyromania
    while read line; do
        set $line
        VENV_LIST="$VENV_LIST($1): $2\n"

        if [ "$1" = "$param_venv_name" ]; then
            ACTIVE_NAME=$1
            ACTIVE_DIR=$2
        ACTIVE_VENV=$3
        ACTION="--activate"
        fi
    done < ~/.pyromania
}

function pyro_delete() {
    if [ -d "${ACTIVE_DIR}/${ACTIVE_VENV}" ]; then
        echo "Removing venv at: ${ACTIVE_DIR}/${ACTIVE_VENV}..."
        deactivate 2>/dev/null
        rm -rf "${ACTIVE_DIR}/${ACTIVE_VENV}"
    else
        echo "Directory does not exist: ${ACTIVE_DIR}/${ACTIVE_VENV}"
    echo "Removing name from the list of managed venvs since it does not exist."
    fi

    local IFS=:

    while read line; do
        set $line

        if [ "$1" != "${ACTIVE_NAME}" ]; then
        echo "$line" >> ~/.pyromania-new
        fi
    done < ~/.pyromania
    mv ~/.pyromania-new ~/.pyromania

    unset ACTIVE_NAME
    unset ACTIVE_DIR
    unset ACTIVE_VENV
}

function pyro_cd_venv() {
    pyro_activate
    PYTHON_VERSION=`ls $ACTIVE_DIR/$ACTIVE_VENV/lib/`
    cd "$ACTIVE_DIR/$ACTIVE_VENV/lib/$PYTHON_VERSION/site-packages/"
}

function fn_pyro() {
    # If no parameter, show help, otherwise setup.
    if [ $# -eq 0 ]; then
        pyro_list
        return 0
    else
        pyro_setup $1
    fi

    # Placeholder second parameter, if necessary.
    if [[ -n $2 ]]; then
        ACTION=$2
    fi

    # Action to perform based on parameters.
    if [ $1 = "--help" ]; then
        pyro_help
    elif [ "${ACTION}" = "--create" ]; then
        pyro_create $1
    elif [ "${ACTIVE_NAME}" != "" ] && [ "${ACTIVE_DIR}" != "" ]; then
        if [ "${ACTION}" = "--delete" ] || [ "${ACTION}" = "-d" ]; then
            pyro_delete
        elif [ "${ACTION}" = "--packages" ] || [ "${ACTION}" = "-p" ]; then
            pyro_cd_venv
        else
            pyro_activate
        fi
    fi
}
alias pyro=fn_pyro
