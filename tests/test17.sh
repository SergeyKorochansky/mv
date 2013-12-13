#!/bin/bash

function test_17() {
    create_env
    print_yeallow 'Running Test #17: None/off backup'
    FILE1='file1'
    FILE2='file2'
    FILE3='file3'
    EXIT_CODE=1 &&
    crete_random_file ${TEST_DIR}/${FILE1} 0 &&
    crete_random_file ${TEST_DIR}/${FILE2} 1 &&
    crete_random_file ${TEST_DIR}/${FILE3} 2 &&
    EXIT_CODE=0
    if [ ${EXIT_CODE} -eq 0 ]; then
        EXIT_CODE=1
        ${PROGRAM} ${TEST_DIR}/${FILE1} ${TEST_DIR}/${FILE3} --backup=none &&
        [[ ! -f ${TEST_DIR}/${FILE1} ]] &&
        get_checksum ${TEST_DIR}/${FILE3} 3 &&
        get_checksum ${TEST_DIR}/${FILE2} 4 &&
        ${PROGRAM} ${TEST_DIR}/${FILE2} ${TEST_DIR}/${FILE3} --backup=off &&
        [[ ! -f ${TEST_DIR}/${FILE1} ]] &&
        [[ ! -f ${TEST_DIR}/${FILE2} ]] &&
        get_checksum ${TEST_DIR}/${FILE3} 5 &&
        [[ ${CHECKSUMS[0]} == ${CHECKSUMS[3]} ]] &&
        [[ ${CHECKSUMS[1]} == ${CHECKSUMS[4]} ]] &&
        [[ ${CHECKSUMS[1]} == ${CHECKSUMS[5]} ]] &&
        EXIT_CODE=0
        print_cyan 'Test 17' n
        [[ ${EXIT_CODE} -eq 0 ]] && print_ok 23 || print_fail 23
    else
        print_red 'Can not prepare test!'
    fi
    clean_env
}
