#!/bin/sh
# This script shall not be renamed: it is referenced by analyze.sh and *.ecs.
#
# The aim of this script is to build the project
# specified on the command line.
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
	DEFAULT_MAKE_ARGS="-j4 all"
	if [ -z "${MAKE_ARGS}" ]; then
		MAKE_ARGS="${DEFAULT_MAKE_ARGS}"
	fi
	# Build the project invoking make directly.
	make ${MAKE_ARGS}
else
	ACTION=-build

	if rm "${CLEAN_FILE}" 2>/dev/null; then
		ACTION=-cleanBuild
	fi

	# Build the project.
	"${ECLIPSE}" \
		--launcher.suppressErrors \
		-nosplash \
		-data "${WORKSPACE_DIR}" \
		-import "${PROJECT_DIR}" \
		-application org.eclipse.cdt.managedbuilder.core.headlessbuild \
		"${ACTION}" "${PROJECT}/${BUILD_CONFIG}"
fi
