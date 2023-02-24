# Set up the tests by moving to the directory and creating a dummy venv name
DIR="$( dirname -- "${BASH_SOURCE[0]}"; )";
cd $DIR
source ./pyro.sh
TEST_VENV_NAME="test_venv_$(date '+%Y_%m_%d_%H_%M_%S')"
TEST_VENV_DIR="$DIR/$TEST_VENV_NAME"

echo "Starting tests with test venv '$TEST_VENV_NAME'..."

# Test venv creation
VENV_DIR=$TEST_VENV_DIR pyro $TEST_VENV_NAME > /dev/null
if [ -d "$TEST_VENV_DIR" ]; then
    echo "Testing venv creation... passed."
else
    echo "Testing venv creation FAILED."
fi

# Test venv deletion
pyro $TEST_VENV_NAME --delete > /dev/null
if [ ! -d "$TEST_VENV_DIR" ]; then
    echo "Testing venv deletion... passed."
else
    echo "Testing venv deletion FAILED."
fi
