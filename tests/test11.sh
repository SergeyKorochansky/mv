#!/bin/bash

function test_11() {
    create_env
    print_yeallow 'Running Test #11: Simple backup with default suffix'
    FILE1='file1'
    FILE2='file2'
    FILE3='file3'
    DIR1='dir1'
    BAKUP_SUFFIX='~'
    EXIT_CODE=1
    crete_random_file ${TEST_DIR}/${FILE1} 0 &&
    crete_random_file ${TEST_DIR}/${FILE2} 1 &&
    crete_random_file ${TEST_DIR}/${FILE3} 2 &&
    EXIT_CODE=0
    if [ ${EXIT_CODE} -eq 0 ]; then
        EXIT_CODE=1
        ${PROGRAM} ${TEST_DIR}/${FILE1} ${TEST_DIR}/${FILE3} --backup=simple &&
        [[ ! -f ${TEST_DIR}/${FILE1} ]] &&
        get_checksum ${TEST_DIR}/${FILE3} 4 &&
        get_checksum ${TEST_DIR}/${FILE3}${BAKUP_SUFFIX} 5 &&
        get_checksum ${TEST_DIR}/${FILE2} 7 &&
        ${PROGRAM} ${TEST_DIR}/${FILE2} ${TEST_DIR}/${FILE3} --backup=simple &&
        [[ ! -f ${TEST_DIR}/${FILE1} ]] &&
        [[ ! -f ${TEST_DIR}/${FILE2} ]] &&
        get_checksum ${TEST_DIR}/${FILE3} 8 &&
        get_checksum ${TEST_DIR}/${FILE3}${BAKUP_SUFFIX} 9 &&
        [[ ${CHECKSUMS[0]} == ${CHECKSUMS[4]} ]] &&
        [[ ${CHECKSUMS[0]} == ${CHECKSUMS[9]} ]] &&
        [[ ${CHECKSUMS[1]} == ${CHECKSUMS[7]} ]] &&
        [[ ${CHECKSUMS[1]} == ${CHECKSUMS[8]} ]] &&
        [[ ${CHECKSUMS[2]} == ${CHECKSUMS[5]} ]] &&
        EXIT_CODE=0
        print_cyan 'Test 11' n
        [[ ${EXIT_CODE} -eq 0 ]] && print_ok 23 || print_fail 23
    else
        print_red 'Can not prepare test!'
    fi
    clean_env
}
