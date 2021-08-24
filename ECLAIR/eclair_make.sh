#!/bin/bash

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

ANALYSIS_BUILD_CONFIG="$(basename "${PWD}")"

if [ -z "${RULESET}" ]; then
    echo "Missing ruleset"
    exit 2
fi

if [ -z "${PROJECT_NAME}" ]; then
    echo "Missing project name"
    exit 2
fi

if [ -z "${BUILD_CONFIG}" ]; then
    echo "Missing build config"
    exit 2
fi

CLEAN_TARGET=false
for arg; do
    if [ "${arg}" = clean ]; then
        CLEAN_TARGET=true
        break
    fi
done

# NEEDED: set the variable for the make arguments specified on the command line.
export MAKE_ARGS="$*"

# NEEDED: set arguments for settings.sh .
set -- "${PROJECT_NAME}" "${BUILD_CONFIG}"

# shellcheck source=../settings.sh
# NEEDED: load script settings for the project specified on the
# command line.
. "${TOP}/settings.sh"

# NEEDED: set the variable for the ECLAIR project name.
export ECLAIR_PROJECT_NAME="${PROJECT_NAME} ${ANALYSIS_BUILD_CONFIG} ${BUILD_CONFIG} ${RULESET} ${ANALYSIS_MODE}"

case "${ANALYSIS_MODE}" in
stu-only)
    # NEEDED: enable incremental build and disable analysis of program and project.
    ECLAIR_ENV_ANALYZE_OPTS="+incremental -eval_file='${HERE}/analysis__stu.ecl'"
    ;;
single-file)
    if [ ! -f "${SELECTED_FILE}" ]; then
        echo "Invalid file selected for build: ${SELECTED_FILE}"
        exit 2
    fi
    # NEEDED: enable incremental build and disable analysis of program and project.
    ECLAIR_ENV_ANALYZE_OPTS="+incremental -eval_file='${HERE}/analysis__stu.ecl'"
    # Add relative path selected file as ECLAIR project name suffix.
    REL_PATH="${SELECTED_FILE#${PROJECT_DIR}/}"
    ECLAIR_PROJECT_NAME="${ECLAIR_PROJECT_NAME} ${REL_PATH}"
    ;;
*)
    # NEEDED: disable analysis clean.
    ECLAIR_ENV_ANALYZE_OPTS="+project"
    ;;
esac

# NEEDED: set the variable for the ECLAIR analysis output directory.
export ECLAIR_OUTPUT_DIR="${PWD}/out_${BUILD_CONFIG}_${RULESET}"

# shellcheck source=./eclair_settings.sh
# Load script settings for the project specified on the command line.
. "${HERE}/eclair_settings.sh"

# Check that the analysis configuration file exists: give error and
# exit otherwise.
if [ ! -f "${ANALYSIS_ECL}" ]; then
    echo "File ${ANALYSIS_ECL} does not exist"
    exit 2
fi

# NEEDED: create ECLAIR binary output directory if it does not exist.
mkdir -p "${ECLAIR_DATA_DIR}"

# NEEDED: output the characteristics of current analysis.
output_stamp() {
    echo "${RULESET}"
}

# NEEDED: clean the ECLAIR results.
eclair_clean() {
    # set the ECLAIR report server in changing mode.
    "${ECLAIR_PATH}eclair_report" "-eval_file='${HERE}/changing.ecl'"
    # Remove the old ECLAIR output directory, if any, and (re-) create it.
    rm -rf "${ECLAIR_OUTPUT_DIR}"
    mkdir -p "${ECLAIR_DATA_DIR}"
    # NEEDED: clean ECLAIR project data.
    "${ECLAIR_PATH}eclair_env" +clean "-eval_file='${ANALYSIS_ECL}'" -- 2>&1 | tee "${ECLAIR_ANALYSIS_LOG}"
}

# NEEDED: clean the project.
clean() {
    # NEEDED: clean ECLAIR results.
    eclair_clean
    # NEEDED: clean the project.
    "${TOP}/clean.sh" "${PROJECT_NAME}" "${BUILD_CONFIG}" | tee -a "${ECLAIR_CLEAN_LOG}"
}

# NEEDED: declare function to build the project in an ECLAIR environment.
build() {
    # NEEDED: set the variable for the ECLAIR analysis log destination.
    export ECLAIR_DIAGNOSTICS_OUTPUT="${ECLAIR_ANALYSIS_LOG}_"
    # NEEDED: build the project in an ECLAIR environment with the given configuration.
    if ! "${ECLAIR_PATH}eclair_env" -frame_override=true "-eval_file='${ANALYSIS_ECL}'" \
        ${ECLAIR_ENV_ANALYZE_OPTS} -- "${TOP}/build.sh" "${PROJECT_NAME}" "${BUILD_CONFIG}" | tee -a "${ECLAIR_BUILD_LOG}"; then
        EXIT_CODE=$?
        cat "${ECLAIR_DIAGNOSTICS_OUTPUT}" 2>/dev/null
        cat "${ECLAIR_DIAGNOSTICS_OUTPUT}" 2>/dev/null >>"${ECLAIR_ANALYSIS_LOG}"
        rm -f "${ECLAIR_DIAGNOSTICS_OUTPUT}"
        exit "${EXIT_CODE}"
    fi
    # NEEDED: generate the project database and open the browser if a ECLAIR report server is running.
    "${ECLAIR_PATH}eclair_report" "-eval_file='${HERE}/report__ide.ecl'" 2>&1 | tee -a "${ECLAIR_REPORT_LOG}"

    # Open the file manager on the ECLAIR output directory if textual reports are enabled.
    if [ "${TEXTUAL_REPORTS}" = true ]; then
        if type xdg-open >/dev/null 2>&1; then
            xdg-open "${ECLAIR_OUTPUT_DIR}"
        elif type open >/dev/null 2>&1; then
            open "${ECLAIR_OUTPUT_DIR}"
        else
            echo "See your analysis output in \"${ECLAIR_OUTPUT_DIR}\"."
        fi
    fi
}

# NEEDED: check if the last build was in an ECLAIR environment.
build_is_unchanged() {
    [ -z "$(find "${BUILD_DIR}" -type f '!' -name '*.mk' '!' -name 'makefile' '!' -name '.*' -newer "${STAMP_FILE}")" ]
}

# NEEDED: check if some ECLAIR configurations are changed after the last build.
config_is_unchanged() {
    [ -z "$(find "${HERE}" -type f -newer "${STAMP_FILE}")" ]
}

# NEEDED: create the build directory if it does not exist.
mkdir -p "${BUILD_DIR}"

if [ "${CLEAN_TARGET}" = true ]; then
    # If the analysis mode is "single-file" no clean is needed.
    if [ "${ANALYSIS_MODE}" = single-file ]; then
        exit 0
    fi
    # NEEDED: Clean the project.
    clean
else
    # NEEDED: set the variable for the ECLAIR stamp file.
    STAMP_FILE="${BUILD_DIR}/.ECLAIR.stamp"
    if [ "${ANALYSIS_MODE}" = single-file ]; then
        # NEEDED: clean the ECLAIR results.
        eclair_clean
        # NEEDED: build the project.
        "${TOP}/build.sh" "${PROJECT_NAME}" "${BUILD_CONFIG}"
        # NEEDED: mark as changed the selected file.
        touch "${SELECTED_FILE}"
    elif [ ! -f "${CLEAN_FILE}" ]; then
        # NEEDED: if the old stamp file is different from newer a clean is needed.
        if ! output_stamp | diff -q - "${STAMP_FILE}" >/dev/null 2>&1; then
            clean
        # NEEDED: if the last build was not in ECLAIR environment or the ECLAIR
        # configuration files are changed a clean is needed.
        elif ! build_is_unchanged || ! config_is_unchanged; then
            clean
        fi
    fi

    # NEEDED: build the project.
    build
    if [ "${ANALYSIS_MODE}" = single-file ]; then
        # NEEDED: remove the stamp file to force a clean on next analysis.
        rm -f "${STAMP_FILE}"
    else
        # NEEDED: write the ECLAIR stamp file.
        output_stamp >"${STAMP_FILE}"
    fi
fi
