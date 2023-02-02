function pyro_list() {
    echo -e $VENV_LIST
}

function pyro_activate() {
    if [ -f "${ACTIVE_DIR}/${VENV_DIR}/bin/activate" ]; then
        # Run commands before activation
        if [ -f "${ACTIVE_DIR}/${VENV_DIR}/pre_activate.sh" ]; then
            . "${ACTIVE_DIR}/${VENV_DIR}/pre_activate.sh"
        fi

        echo "Activating venv ${ACTIVE_NAME}..."
        . "${ACTIVE_DIR}/${VENV_DIR}/bin/activate"

        # Run commands after activation
        if [ -f "${ACTIVE_DIR}/${VENV_DIR}/post_activate.sh" ]; then
            . "${ACTIVE_DIR}/${VENV_DIR}/post_activate.sh"
        fi
    else
        echo "Could not find the venv directory ${ACTIVE_DIR}/${VENV_DIR}."
        echo "You may need to remove the entry from ~/.pyromania."
        echo "Here is a list of venvs:"
        echo $VENV_LIST
    fi
}

function pyro_create() {
    ACTIVE_NAME=$1
    ACTIVE_DIR=`pwd`

    echo "Creating a new venv in directory ${ACTIVE_DIR}/${VENV_DIR}..."
    # Create the venv
    ${VENV_PYTHON} -m venv --copies "${VENV_DIR}"
    echo "${ACTIVE_NAME}:${ACTIVE_DIR}" >> ~/.pyromania

    # Create script to run before venv activation
    echo "# Commands to be run before venv activation" >> "${VENV_DIR}/pre_activate.sh"

    # Create script to run after venv activation, default to current directory
    echo "# Commands to be run after venv activation" >> "${VENV_DIR}/post_activate.sh"
    echo "cd ${PWD}" >> "${VENV_DIR}/post_activate.sh"

    # Activate the new venv
    pyro_activate "$ACTIVE_NAME"

    # Get the latest pip
    echo "Upgrading to latest pip & wheel..."
    pip install --quiet --upgrade pip wheel
}

function pyro_setup() {
    ACTIVE_NAME=""
    ACTIVE_DIR=""
    VENV_LIST=""

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
        else
            CREATE_NEW=1
        fi
    done < ~/.pyromania
}

function pyro_delete() {
    if [ -d "${ACTIVE_DIR}/${VENV_DIR}" ]; then
        echo "Removing venv at: ${ACTIVE_DIR}/${VENV_NAME}..."
        deactivate 2>/dev/null
        unset ACTIVE_NAME
        unset ACTIVE_DIR
        rm -rf "${ACTIVE_DIR}/${VENV_DIR}"
    else
        echo "We couldn't find the directory ${ACTIVE_DIR}/${VENV_DIR}."
        echo "To be safe, we are aborting. You may want to manually remove the entry from ~/.pyromania."
    fi
}

function pyro_cd_venv() {
    cd "${ACTIVE_DIR}/${VENV_NAME}/"
}

function fn_pyro() {
    pyro_setup $1

    if [ $1 = "--list" ]; then
        pyro_list
    elif [ "${CREATE_NEW}" = 1 ]; then
        pyro_create $1
    elif [[ "${ACTIVE_NAME}" != "" && "${ACTIVE_DIR}" != "" ]]; then
        if [ $2 = "--delete" ]; then
            pyro_delete
        elif [ $2 = "--packages" ]; then
            pyro_cd_venv
        else
            pyro_activate
        fi
    fi
}
alias pyro=fn_pyro
