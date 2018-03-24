#!/bin/sh -e

CONFIG=''

while true; do
    case ${1} in
        --help)
            echo "Global usage: ${0} [--help][--config CONFIG]"

            if command -v usage > /dev/null; then
                usage
            fi

            exit 0
            ;;
        --config)
            CONFIG=${2-}
            shift 2
            ;;
        *)
            break
            ;;
    esac
done

OPTIND=1

if [ "${CONFIG}" = '' ]; then
    CONFIG="${HOME}/.shell-skeleton.sh"
fi

if [ ! -f "${CONFIG}" ]; then
    echo "Config missing: ${CONFIG}"

    exit 1
fi

# shellcheck source=/dev/null
. "${CONFIG}"

if [ "${TOKEN}" = '' ]; then
    echo "TOKEN not set."

    exit 1
fi
