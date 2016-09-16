#!/bin/sh -e

CONFIG=""

function_exists()
{
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
export CONFIG
