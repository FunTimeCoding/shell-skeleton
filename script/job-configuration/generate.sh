#!/bin/sh -e

REMOTE=$(git config --get remote.origin.url)
echo "${REMOTE}" | grep --quiet github.com && IS_GITHUB=true || IS_GITHUB=false

if [ "${IS_GITHUB}" = true ]; then
    echo "${REMOTE}" | grep --quiet git@github.com  && IS_SSH=true || IS_SSH=false

    if [ "${IS_SSH}" = true ]; then
        # TODO: GitHub does not allow to give read only permission to personal repositories. Only to organization repositories. In order to not have to create an organization, use HTTPS locators for jobs. Also to not have to create one SSH key per repository, because GitHub only allows to use one public key once.
        REMOTE="https://github.com/${REMOTE#*:}"
    fi
fi

# shellcheck disable=SC2016
jjm --locator "${REMOTE}" --build-command script/build.sh --checkstyle 'build/log/checkstyle-*.xml' --recipients funtimecoding@gmail.com > job.xml
