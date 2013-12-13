#!/bin/bash
echo "Setup test evironment"

TEST_DIR='./dev-test'
ANSI_COLOR_RED="\x1b[31m"
ANSI_COLOR_GREEN="\x1b[32m"
ANSI_COLOR_YELLOW="\x1b[33m"
ANSI_COLOR_BLUE="\x1b[34m"
ANSI_COLOR_MAGENTA="\x1b[35m"
ANSI_COLOR_CYAN="\x1b[36m"
ANSI_COLOR_RESET="\x1b[0m"

function print_green() {
    echo -e$2 "${ANSI_COLOR_GREEN}$1${ANSI_COLOR_RESET}"
}

function print_magenta() {
     echo -e$2 "${ANSI_COLOR_MAGENTA}$1${ANSI_COLOR_RESET}"
}

function print_red() {
    echo -e$2 "${ANSI_COLOR_RED}$1${ANSI_COLOR_RESET}"
}

function print_yeallow() {
    echo -e$2 "${ANSI_COLOR_YELLOW}$1${ANSI_COLOR_RESET}"
}

function print_cyan() {
    echo -e$2 "${ANSI_COLOR_CYAN}$1${ANSI_COLOR_RESET}"
}

function print_blue() {
    echo -e$2 "${ANSI_COLOR_BLUE}$1${ANSI_COLOR_RESET}"
}

function clean_env() {
    echo -n 'Cleaning test environment ... '
    rm -rf ${TEST_DIR}
    if [ $? -eq 0 ]; then
        print_green '[OK]'
    else
        print_red '[FAIL]'
    fi
}

function print_fail() {
    for i in $(seq 1 $1)
    do
        echo -n ' '
    done
    print_red '[FAIL]' $2
}

function print_ok() {
    for i in $(seq 1 $1)
    do
        echo -n ' '
    done
    print_green '[OK]' $2
}

function create_env() {
    echo -n 'Creating test environment ... '
    mkdir ${TEST_DIR}
    if [ $? -eq 0 ]; then
        print_ok 0
    else
        print_fail 0
    fi
}

function get_checksum() {
    EXIT_CODE_TEMP=1
    CHECKSUMS[$2]=$(sha1sum $1 | cut -f1 -d' ') && EXIT_CODE_TEMP=0
    return ${EXIT_CODE_TEMP}
}

function crete_random_file() {
    dd if=/dev/urandom of=$1 count=2 >& /dev/null
    EXIT_CODE_TEMP=$?
    get_checksum $1 $2
    [[ EXIT_CODE_TEMP -eq 0 ]] && [[ $? -eq 0 ]] && return 0
    return 1
}