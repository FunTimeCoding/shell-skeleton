#!/bin/sh -e

if [ "$(command -v shellcheck || true)" = "" ]; then
    echo "Command not found: shellcheck"

    exit 1
fi

CONTINUOUS_INTEGRATION_MODE=false

if [ "${1}" = "--ci-mode" ]; then
    shift
    mkdir -p build/log
    CONTINUOUS_INTEGRATION_MODE=true
fi

#     12345678901234567890123456789012345678901234567890123456789012345678901234567890
echo "================================================================================"
echo

echo "Run ShellCheck."

if [ "${CONTINUOUS_INTEGRATION_MODE}" = true ]; then
    # shellcheck disable=SC2016
    find . -name '*.sh' -and -not -path '*/vendor/*' -exec sh -c 'shellcheck ${1} || true' '_' '{}' \; | tee build/log/shellcheck.txt
else
    # shellcheck disable=SC2016
    find . -name '*.sh' -and -not -path '*/vendor/*' -exec sh -c 'shellcheck ${1} || true' '_' '{}' \;
fi

echo
echo "================================================================================"
