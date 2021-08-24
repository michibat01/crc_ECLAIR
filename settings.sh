#!/bin/sh
# This script must not be renamed: it is referenced by build.sh,
# clean.sh, prepare.sh, analyze.sh, browse.sh and eclair_make.sh.
#
# The aim of this script is to set the variables required by the by
# the scripts mentioned above for the project specified on the
# command line.
#
# The essential portions of this script are marked with "# NEEDED":
# they may be adapted of course.

# shellcheck disable=SC2034
# Project id should to be passed as first argument.
PROJECT=$1

# Print usage information and exit if project id is missing.
if [ -z "${PROJECT}" ]; then
    echo "Missing project name."
    usage
fi

# Build configuration id to be used if second argument is missing.
DEFAULT_BUILD_CONFIG=Release

# shellcheck disable=SC2034
# Build configuration id should be passed as second optional argument.
BUILD_CONFIG=${2:-${DEFAULT_BUILD_CONFIG}}

# Set variable for the project directory.
PROJECT_DIR="${TOP}/${PROJECT}"

# shellcheck disable=SC2034
# Set variable for the build directory.
BUILD_DIR="${PROJECT_DIR}/${BUILD_CONFIG}"

# shellcheck disable=SC2034
# Set variable for the marker file used to inform that clean is needed.
CLEAN_FILE="${BUILD_DIR}/.clean"

# shellcheck disable=SC2034
# Set variable for the workspace directory.
WORKSPACE_DIR=${TOP}/workspace

# shellcheck disable=SC2034
# Set variable for eclipse executable.
ECLIPSE=${HOME}/eclipse/eclipse

# shellcheck disable=SC2034
# Set this variable to true if you want to invoke make directly instead
# of use CDT managed build (unrecommended).
USE_MAKE=false
