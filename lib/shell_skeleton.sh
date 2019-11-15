#!/bin/sh -e

CONFIGURATION=''

while true; do
    case ${1} in
        --help)
            echo "Global usage: ${0} [--help][--configuration CONFIGURATION]"

            if command -v usage > /dev/null; then
                usage
            fi

            exit 0
            ;;
        --configuration)
            CONFIGURATION=${2-}
            shift 2
            ;;
        *)
            break
            ;;
    esac
done

OPTIND=1

if [ "${CONFIGURATION}" = '' ]; then
    CONFIGURATION="${HOME}/.shell-skeleton.sh"
fi

if [ -f "${CONFIGURATION}" ]; then
    # shellcheck source=configuration/example.sh
    . "${CONFIGURATION}"
fi
