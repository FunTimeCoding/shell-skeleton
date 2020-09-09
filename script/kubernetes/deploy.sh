#!/bin/sh -e

DIRECTORY=$(dirname "${0}")
SCRIPT_DIRECTORY=$(
    cd "${DIRECTORY}" || exit 1
    pwd
)
# shellcheck source=/dev/null
. "${SCRIPT_DIRECTORY}/../../configuration/project.sh"
GIT_TAG="${1}"

if [ "${GIT_TAG}" = '' ]; then
    echo "Usage: ${0} GIT_TAG"

    exit 1
fi

cat >helm-chart/Chart.yaml <<EOF
apiVersion: v2
name: ${PROJECT_NAME_DASH}
description: ${PROJECT_NAME_DASH} microservice
type: application

appVersion: ${GIT_TAG}
version: ${GIT_TAG}.1
EOF

docker run --rm --volume "${PWD}/helm-chart:/helm-chart" --volume "${HOME}/.kube:/root/.kube" dtzar/helm-kubectl helm upgrade "${PROJECT_NAME_DASH}" /helm-chart
git checkout helm-chart/Chart.yaml
