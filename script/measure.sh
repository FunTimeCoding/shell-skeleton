#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(
    cd "${DIRECTORY}" || exit 1
    pwd
)
# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../configuration/project.sh"

if [ "${1}" = --help ]; then
    echo "Usage: ${0} [--ci-mode]"

    exit 0
fi

SYSTEM=$(uname)

if [ "${SYSTEM}" = Darwin ]; then
    WC='gwc'
    FIND='gfind'
else
    WC='wc'
    FIND='find'
fi

FILES_EXCLUDE='^.*\/(build|tmp|vendor|node_modules|\.git|\.vagrant|\.idea|\.tox|__pycache__|[a-z_]+\.egg-info)\/.*$'
FILES=$(${FIND} . -type f -regextype posix-extended ! -regex "${FILES_EXCLUDE}" | ${WC} --lines)
DIRECTORIES_EXCLUDE='^.*\/(build|tmp|vendor|node_modules|\.git|\.vagrant|\.idea|\.tox|__pycache__)(\/.*)?$'
DIRECTORIES=$(${FIND} . -type d -regextype posix-extended ! -regex "${DIRECTORIES_EXCLUDE}" | ${WC} --lines)
INCLUDE='^.*\.sh$'
CODE_EXCLUDE='^.*\/(build|tmp|vendor|node_modules|target|\.git|\.vagrant|\.idea|\.tox)\/.*$'
CODE_EXCLUDE_JAVA_SCRIPT='^\.\/web/main\.js$'
CODE=$(${FIND} . -type f -regextype posix-extended -regex "${INCLUDE}" -and ! -regex "${CODE_EXCLUDE}" -and ! -regex "${CODE_EXCLUDE_JAVA_SCRIPT}" | xargs cat)
LINES=$(echo "${CODE}" | ${WC} --lines)
NON_BLANK_LINES=$(echo "${CODE}" | grep --invert-match --regexp '^$' | ${WC} --lines)
echo "FILES: ${FILES}"
echo "DIRECTORIES: ${DIRECTORIES}"
echo "LINES: ${LINES}"
echo "NON_BLANK_LINES: ${NON_BLANK_LINES}"

if [ "${1}" = --ci-mode ]; then
    shift

    if [ "${SYSTEM}" = Darwin ]; then
        TEE='gtee'
    else
        TEE='tee'
    fi

    mkdir -p build/log

    if [ -f "${HOME}/.static-analysis-tools.sh" ]; then
        # shellcheck source=/dev/null
        . "${HOME}/.static-analysis-tools.sh"
        sonar-scanner --define "sonar.projectKey=${PROJECT_NAME_DASH}" --define "sonar.sources=." --define "sonar.host.url=${SONAR_SERVER}" --define "sonar.login=${SONAR_TOKEN}" | "${TEE}" build/log/sonar-runner.log
    else
        echo "SonarQube configuration missing."

        exit 1
    fi

    RESULT_COUNT=0

    for SECOND in $(seq 1 60); do
        RESULT_COUNT=$(curl --silent --user "${SONAR_TOKEN}:" "${SONAR_SERVER}/api/measures/component_tree?component=${PROJECT_NAME_DASH}&metricKeys=sqale_index" | jq --raw-output '.baseComponent.measures | length')

        if [ ! "${RESULT_COUNT}" = 0 ]; then
            echo ''

            break
        fi

        if [ "${SECOND}" = 20 ]; then
            echo "Timeout reached."

            exit 1
        else
            printf .
            sleep 1
        fi
    done

    CONCERN_FOUND=false
    SQALE_INDEX=$(curl --silent --user "${SONAR_TOKEN}:" "${SONAR_SERVER}/api/measures/component_tree?component=${PROJECT_NAME_DASH}&metricKeys=sqale_index" | jq --raw-output '.baseComponent.measures[].value')
    echo "SQALE_INDEX: ${SQALE_INDEX}"

    if [ ! "${SQALE_INDEX}" = 0 ]; then
        CONCERN_FOUND=true
        echo "Warning: SQALE_INDEX exceeded"
    fi

    DUPLICATED_BLOCKS=$(curl --silent --user "${SONAR_TOKEN}:" "${SONAR_SERVER}/api/measures/component_tree?component=${PROJECT_NAME_DASH}&metricKeys=duplicated_blocks" | jq --raw-output '.baseComponent.measures[].value')
    echo "DUPLICATED_BLOCKS: ${DUPLICATED_BLOCKS}"

    if [ ! "${DUPLICATED_BLOCKS}" = 0 ]; then
        CONCERN_FOUND=true
        echo "Warning: DUPLICATED_BLOCKS exceeded"
    fi

    DUPLICATED_LINES_DENSITY=$(curl --silent --user "${SONAR_TOKEN}:" "${SONAR_SERVER}/api/measures/component_tree?component=${PROJECT_NAME_DASH}&metricKeys=duplicated_lines_density" | jq --raw-output '.baseComponent.measures[].value')
    echo "DUPLICATED_LINES_DENSITY: ${DUPLICATED_LINES_DENSITY}"

    if [ ! "${DUPLICATED_LINES_DENSITY}" = 0.0 ]; then
        CONCERN_FOUND=true
        echo "Warning: DUPLICATED_LINES_DENSITY exceeded"
    fi

    if [ "${CONCERN_FOUND}" = true ]; then
        echo
        echo "Concern(s) of category WARNING found." >&2

        exit 2
    fi
fi
