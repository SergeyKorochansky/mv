#!/bin/bash

function test_5() {
    create_env
    print_yeallow 'Running Test #5: Target-directory option'
    FILE1='file1'
    DIR1='file2'
    EXIT_CODE=1
    mkdir ${TEST_DIR}/${DIR1} &&
    crete_random_file ${TEST_DIR}/${FILE1} 0 &&
    EXIT_CODE=0
    if [ ${EXIT_CODE} -eq 0 ]; then
        EXIT_CODE=1
        ${PROGRAM} ${TEST_DIR}/${FILE1} -t ${TEST_DIR}/${DIR1} &&
        get_checksum ${TEST_DIR}/${DIR1}/${FILE1} 1 &&
        [[ -d ${TEST_DIR}/${DIR1} ]] &&
        [[ ! -f ${TEST_DIR}/${FILE1} ]] &&
        [[ ${CHECKSUMS[0]} == ${CHECKSUMS[1]} ]] &&
        EXIT_CODE=0
        print_cyan 'Test 5 ' n
        [[ ${EXIT_CODE} -eq 0 ]] && print_ok 23 || print_fail 23
    else
        print_red 'Can not prepare test!'
    fi
    clean_env
}