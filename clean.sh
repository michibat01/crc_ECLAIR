#!/bin/sh
# This script must not be renamed: it is referenced by analyze.sh and *.ecs.
#
# The aim of this script is to remove *all* the object and executable
# files produced by a previous build and prepare for a possible future
# build of the project specified in the command line.
#
# The essential portions of this script are marked with "# NEEDED":
# they may be adapted of course.

# Stop on first error.
set -e

# NEEDED: set the variable for the directory of this script.
TOP=$(dirname "$0")

# Print usage information for the script and exit.
usage() {
    echo "Usage: $0 PROJECT [BUILD_CONFIG]" 1>&2
    exit 2
}

# shellcheck source=./settings.sh
# NEEDED: load script settings for the project specified on the
# command line.
. "${TOP}/settings.sh"

if [ "${USE_MAKE}" = true ]; then
    cd "${BUILD_DIR}"
    DEFAULT_MAKE_ARGS="clean"
    if [ -z "${MAKE_ARGS}" ]; then
        MAKE_ARGS="${DEFAULT_MAKE_ARGS}"
    fi
    # Clean the project invoking make directly.
    make ${MAKE_ARGS}
fi

# Create marker file used to inform that clean is needed.
touch "${CLEAN_FILE}" || true
