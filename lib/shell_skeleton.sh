#!/bin/sh -e

CONFIG=""
VERBOSE=false

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
            echo "Global usage: ${0} [--verbose][--debug][--help][--config CONFIG]"

            if function_exists usage; then
                usage
            fi

            exit 0
            ;;
        --verbose)
            VERBOSE=true
            echo "Verbose mode enabled."
            shift
            ;;
        --debug)
            set -x
            shift
            ;;
        *)
            break
            ;;
    esac
done

OPTIND=1
export CONFIG
export VERBOSE
