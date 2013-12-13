#!/bin/bash

function test_14() {
    create_env
    print_yeallow 'Running Test #14: Numbered backup with custom suffix'
    FILE1='file1'
    FILE2='file2'
    FILE3='file3'
    BAKUP_SUFFIX='op'
    EXIT_CODE=1
    crete_random_file ${TEST_DIR}/${FILE1} 0 &&
    crete_random_file ${TEST_DIR}/${FILE2} 1 &&
    crete_random_file ${TEST_DIR}/${FILE3} 2 &&
    EXIT_CODE=0
    if [ ${EXIT_CODE} -eq 0 ]; then
        EXIT_CODE=1
        ${PROGRAM} ${TEST_DIR}/${FILE1} ${TEST_DIR}/${FILE3} --backup=t --suffix=${BAKUP_SUFFIX} &&
        [[ ! -f ${TEST_DIR}/${FILE1} ]] &&
        get_checksum ${TEST_DIR}/${FILE3} 3 &&
        get_checksum ${TEST_DIR}/${FILE3}.${BAKUP_SUFFIX}1${BAKUP_SUFFIX} 4 &&
        get_checksum ${TEST_DIR}/${FILE2} 5 &&
        ${PROGRAM} ${TEST_DIR}/${FILE2} ${TEST_DIR}/${FILE3} --backup=t --suffix=${BAKUP_SUFFIX} &&
        get_checksum ${TEST_DIR}/${FILE3} 6 &&
        get_checksum ${TEST_DIR}/${FILE3}.${BAKUP_SUFFIX}1${BAKUP_SUFFIX} 7 &&
        get_checksum ${TEST_DIR}/${FILE3}.${BAKUP_SUFFIX}2${BAKUP_SUFFIX} 8 &&
        [[ ! -f ${TEST_DIR}/${FILE1} ]] &&
        [[ ! -f ${TEST_DIR}/${FILE2} ]] &&
        [[ ${CHECKSUMS[0]} == ${CHECKSUMS[3]} ]] &&
        [[ ${CHECKSUMS[0]} == ${CHECKSUMS[8]} ]] &&
        [[ ${CHECKSUMS[1]} == ${CHECKSUMS[5]} ]] &&
        [[ ${CHECKSUMS[1]} == ${CHECKSUMS[6]} ]] &&
        [[ ${CHECKSUMS[2]} == ${CHECKSUMS[4]} ]] &&
        [[ ${CHECKSUMS[2]} == ${CHECKSUMS[7]} ]] &&
        EXIT_CODE=0
        print_cyan 'Test 14' n
        [[ ${EXIT_CODE} -eq 0 ]] && print_ok 23 || print_fail 23
    else
        print_red 'Can not prepare test!'
    fi
    clean_env
}
