#!/bin/bash

function test_9() {
    create_env
    print_yeallow 'Running Test #9: Force option'
    FILE1='file1'
    FILE2='file2'
    DIR1='dir1'
    EXIT_CODE=1
    mkdir ${TEST_DIR}/${DIR1} &&
    crete_random_file ${TEST_DIR}/${FILE1} 0 &&
    crete_random_file ${TEST_DIR}/${FILE2} 1 &&
    crete_random_file ${TEST_DIR}/${DIR1}/${FILE1} 2 &&
    EXIT_CODE=0
    if [ ${EXIT_CODE} -eq 0 ]; then
        EXIT_CODE=1
        ${PROGRAM} ${TEST_DIR}/${FILE1} ${TEST_DIR}/${FILE2} ${TEST_DIR}/${DIR1} -f &&
        get_checksum ${TEST_DIR}/${DIR1}/${FILE1} 3 &&
        get_checksum ${TEST_DIR}/${DIR1}/${FILE2} 4 &&
        [[ -d ${TEST_DIR}/${DIR1} ]] &&
        [[ ! -f ${TEST_DIR}/${FILE1} ]] &&
        [[ ! -f ${TEST_DIR}/${FILE2} ]] &&
        [[ ${CHECKSUMS[0]} == ${CHECKSUMS[3]} ]] &&
        [[ ${CHECKSUMS[1]} == ${CHECKSUMS[4]} ]] &&
        EXIT_CODE=0
        print_cyan 'Test 9 ' n
        [[ ${EXIT_CODE} -eq 0 ]] && print_ok 23 || print_fail 23
    else
        print_red 'Can not prepare test!'
    fi
    clean_env
}
