#!/bin/bash

function test_1() {
    create_env
    print_yeallow 'Running Test #1: Rename file'
    FILE1='file1'
    FILE2='file2'
    crete_random_file ${TEST_DIR}/${FILE1} 0
    if [ $? -eq 0 ]; then
        EXIT_CODE=1
        ${PROGRAM} ${TEST_DIR}/${FILE1} ${TEST_DIR}/${FILE2} &&
        get_checksum ${TEST_DIR}/${FILE2} 1 &&
        [[ ! -f ${TEST_DIR}/${FILE1} ]] &&
        [[ ${CHECKSUMS[0]} == ${CHECKSUMS[1]} ]]
        EXIT_CODE=0
        print_cyan 'Test 1 ' n
        [[ ${EXIT_CODE} -eq 0 ]] && print_ok 23 || print_fail 23
    else
        print_red 'Can not prepare test!'
    fi
    clean_env
}