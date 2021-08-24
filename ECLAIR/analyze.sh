#!/bin/bash
# This script usually does not require adaptation.
#
# The aim of this script is to perform a build and corresponding
# analysis for the project specified on the command line.
#
# The essential portions of this script are marked with "# NEEDED":
# they may be adapted of course.

# Stop on first error.
set -e
set -o pipefail

# NEEDED: set the variable for the absolute directory of this script.
HERE=$(
    cd "$(dirname "$0")"
    echo "${PWD}"
)

# NEEDED: set the variable for the top absolute directory for the project.
TOP=$(dirname "${HERE}")

# Print usage information for the script and exit.
usage() {
    echo "Usage: $0 RULESET ARGS..." 1>&2
    echo "  where ARGS... are the arguments for prepare.sh, clean.sh and build.sh" 1>&2
    exit 2
}

# <RULESET> is passed as first argument.
RULESET=$1

# Print usage information and exit if RULESET is missing.
if [ -z "${RULESET}" ]; then
    usage
fi

# Remove first argument.
shift

# shellcheck source=../settings.sh
# NEEDED: load script settings for the project specified on the
# command line.
. "${TOP}/settings.sh"

# NEEDED: set the variable for the ECLAIR project name.
export ECLAIR_PROJECT_NAME="${PROJECT}_${BUILD_CONFIG}_${RULESET}"

# NEEDED: set the variable for the ECLAIR analysis output directory.
# To be kept in sync with browse.sh
export ECLAIR_OUTPUT_DIR="${BUILD_DIR}/out_${RULESET}"

# shellcheck source=./eclair_settings.sh
# Load script settings for the project specified on the command line.
. "${HERE}/eclair_settings.sh"

# Check that the analysis configuration file exists: give error and
# exit otherwise.
if [ ! -f "${ANALYSIS_ECL}" ]; then
    echo "File ${ANALYSIS_ECL} does not exist"
    usage
fi

# Remove the old ECLAIR output directory, if any, and (re-) create it.
rm -rf "${ECLAIR_OUTPUT_DIR}"
mkdir -p "${ECLAIR_DATA_DIR}"

# Clean the project.
"${TOP}/clean.sh" "$@" 2>&1 | tee "${ECLAIR_CLEAN_LOG}"

# NEEDED: set the variable for the ECLAIR analysis log absolute file path.
export ECLAIR_DIAGNOSTICS_OUTPUT="${ECLAIR_ANALYSIS_LOG}"

# Build the project in an ECLAIR environment with the given configuration.
"${ECLAIR_PATH}eclair_env" "-eval_file='${ANALYSIS_ECL}'" -- "${TOP}/build.sh" "$@" 2>&1 | tee "${ECLAIR_BUILD_LOG}"

# Generate the project database.
"${ECLAIR_PATH}eclair_report" "${ECLAIR_DATA_DIR}"/FRAME.*.ecb \
    "-eval_file='${REPORT_ECL}'" 2>&1 | tee "${ECLAIR_REPORT_LOG}"

# Browse the obtained results.
"${HERE}/browse.sh" "${RULESET}" "$@"
