#!/bin/sh
# This script must not be renamed: it is referenced by analyze.sh and
# browse.sh.
#
# The aim of this script is to set the variables required by the by
# the scripts mentioned above for the project specified on the
# command line.
#
# The essential portions of this script are marked with "# NEEDED":
# they may be adapted of course.

# Ruleset should be passed as first argument
# Project id should be passed as second argument.
# Build configuration id should be passed as third optional argument.
# The following environments should be set entering in this script:
# TOP
# HERE
# RULESET
# ECLAIR_OUTPUT_DIR

# NEEDED: set the directory where the ECLAIR installation's "bin" directory are located.
# If empty, the binaries are searched using  the PATH environment variable;
# otherwise the specified directory shall end with / (slash).
#export ECLAIR_PATH=

# NEEDED: set the variable for the ECLAIR binary output directory.
export ECLAIR_DATA_DIR="${ECLAIR_OUTPUT_DIR}/.data"

# NEEDED: set the variable for the project root directory.
export ECLAIR_PROJECT_ROOT="${TOP}"

# Set the variable for the ECLAIR project database file.
export ECLAIR_PROJECT_ECD="${ECLAIR_DATA_DIR}/PROJECT.ecd"

# shellcheck disable=SC2034
# Set the variable for the clean log file.
ECLAIR_CLEAN_LOG=${ECLAIR_OUTPUT_DIR}/CLEAN.log

# shellcheck disable=SC2034
# Set the variable for the build log file.
ECLAIR_BUILD_LOG=${ECLAIR_OUTPUT_DIR}/BUILD.log

# shellcheck disable=SC2034
# NEEDED: set the variable for the ECLAIR analysis log absolute file path.
ECLAIR_ANALYSIS_LOG=${ECLAIR_OUTPUT_DIR}/ANALYSIS.log

# shellcheck disable=SC2034
# Set the variable for the ECLAIR report log file.
ECLAIR_REPORT_LOG=${ECLAIR_OUTPUT_DIR}/REPORT.log

# shellcheck disable=SC2034
# Set the variable for analysis ECL file specific to <RULESET>.
ANALYSIS_ECL=${HERE}/analysis_${RULESET}.ecl

# shellcheck disable=SC2034
# Set the variable for report ECL file specific to <RULESET>.
REPORT_ECL=${HERE}/report_${RULESET}.ecl

# Use default if a specific report ECL file does not exist: report__cli.ecl.
if [ ! -f "${REPORT_ECL}" ]; then
    REPORT_ECL=${HERE}/report__cli.ecl
fi

# NEEDED: set the evironment variable used by ECLAIR to intercepted
# the selected toolchain components: absolute file paths are used here
# (this is always the safest choice).
export CC_ALIASES="'gcc'"
export CXX_ALIASES="'g++'"
export AS_ALIASES="'as'"
export AR_ALIASES="'ar'"
export LD_ALIASES="'ld'"
