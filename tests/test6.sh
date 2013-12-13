#!/bin/bash

function test_6() {
    create_env
    print_yeallow 'Running Test #6: Strip trailing slashes'
    FILE1='file1'
    FILE2='file2'
    FILE3='file3'
    DIR1='dir2'
    EXIT_CODE=1
    mkdir ${TEST_DIR}/${DIR1} &&
    crete_random_file ${TEST_DIR}/${FILE1} 0 &&
    crete_random_file ${TEST_DIR}/${FILE2} 1 &&
    crete_random_file ${TEST_DIR}/${FILE3} 2 &&
    EXIT_CODE=0
    if [ ${EXIT_CODE} -eq 0 ]; then
        EXIT_CODE=1
        ${PROGRAM} ${TEST_DIR}/${FILE1} ${TEST_DIR}/${FILE2} ${TEST_DIR}/${FILE3} -t ${TEST_DIR}/${DIR1} &&
        get_checksum ${TEST_DIR}/${DIR1}/${FILE1} 3 &&
        get_checksum ${TEST_DIR}/${DIR1}/${FILE2} 4 &&
        get_checksum ${TEST_DIR}/${DIR1}/${FILE3} 5 &&
        [[ -d ${TEST_DIR}/${DIR1} ]] &&
        [[ ! -f ${TEST_DIR}/${FILE1} ]] &&
        [[ ! -f ${TEST_DIR}/${FILE2} ]] &&
        [[ ! -f ${TEST_DIR}/${FILE3} ]] &&
        [[ ${CHECKSUMS[0]} == ${CHECKSUMS[3]} ]] &&
        [[ ${CHECKSUMS[1]} == ${CHECKSUMS[4]} ]] &&
        [[ ${CHECKSUMS[2]} == ${CHECKSUMS[5]} ]] &&
        EXIT_CODE=0
        print_cyan 'Test 6 ' n
        [[ ${EXIT_CODE} -eq 0 ]] && print_ok 23 || print_fail 23
    else
        print_red 'Can not prepare test!'
    fi
    clean_env
}