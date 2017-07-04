#!/bin/sh -e

CONFIG=""

function_exists()
{
    # shellcheck disable=SC2039
    declare -f -F "${1}" > /dev/null

    return $?
}

while true; do
    case ${1} in
        --config)
            CONFIG=${2-}
            shift 2
            ;;
        --help)
            echo "Global usage: ${0} [--help][--config CONFIG]"

            if function_exists usage; then
                usage
            fi

            exit 0
            ;;
        *)
            break
            ;;
    esac
done

OPTIND=1

if [ "${CONFIG}" = "" ]; then
    CONFIG="${HOME}/.shell-skeleton.sh"
fi

if [ ! -f "${CONFIG}" ]; then
    echo "Config missing: ${CONFIG}"

    exit 1
fi

# shellcheck source=/dev/null
. "${CONFIG}"

if [ "${TOKEN}" = "" ]; then
    echo "TOKEN not set."

    exit 1
fi
