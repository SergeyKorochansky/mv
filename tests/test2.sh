#!/bin/bash

function test_2() {
    create_env
    print_yeallow 'Running Test #2: Rename dir'
    DIR1='dir1'
    DIR2='dir2'
    EXIT_CODE=1
    mkdir ${TEST_DIR}/${DIR1} &&
    mkdir ${TEST_DIR}/${DIR1}/dir1.1 &&
    mkdir ${TEST_DIR}/${DIR1}/dir1.1/dir1.1.1 &&
    crete_random_file ${TEST_DIR}/${DIR1}/dir1.1/dir1.1.1/file1.1.1.1 0 &&
    crete_random_file ${TEST_DIR}/${DIR1}/dir1.1/dir1.1.1/file1.1.1.2 1 &&
    mkdir ${TEST_DIR}/${DIR1}/dir1.1/dir1.1.2 &&
    crete_random_file ${TEST_DIR}/${DIR1}/dir1.1/dir1.1.2/file1.1.2.1 2 &&
    crete_random_file ${TEST_DIR}/${DIR1}/dir1.1/dir1.1.2/file1.1.2.2 3 &&
    crete_random_file ${TEST_DIR}/${DIR1}/dir1.1/file1.1.1 4 &&
    crete_random_file ${TEST_DIR}/${DIR1}/dir1.1/file1.1.2 5 &&
    mkdir ${TEST_DIR}/${DIR1}/dir1.2 &&
    crete_random_file ${TEST_DIR}/${DIR1}/dir1.2/file1.2.1 6 &&
    crete_random_file ${TEST_DIR}/${DIR1}/dir1.2/file1.2.2  7 &&
    crete_random_file ${TEST_DIR}/${DIR1}/file1 8 &&
    crete_random_file ${TEST_DIR}/${DIR1}/file2 9 &&
    EXIT_CODE=0
    if [ ${EXIT_CODE} -eq 0 ]; then
        EXIT_CODE=1
        ${PROGRAM} ${TEST_DIR}/${DIR1} ${TEST_DIR}/${DIR2} &&
        get_checksum ${TEST_DIR}/${DIR2}/dir1.1/dir1.1.1/file1.1.1.1 10 &&
        get_checksum ${TEST_DIR}/${DIR2}/dir1.1/dir1.1.1/file1.1.1.2 11 &&
        get_checksum ${TEST_DIR}/${DIR2}/dir1.1/dir1.1.2/file1.1.2.1 12 &&
        get_checksum ${TEST_DIR}/${DIR2}/dir1.1/dir1.1.2/file1.1.2.2 13 &&
        get_checksum ${TEST_DIR}/${DIR2}/dir1.1/file1.1.1 14 &&
        get_checksum ${TEST_DIR}/${DIR2}/dir1.1/file1.1.2 15 &&
        get_checksum ${TEST_DIR}/${DIR2}/dir1.2/file1.2.1 16 &&
        get_checksum ${TEST_DIR}/${DIR2}/dir1.2/file1.2.2  17 &&
        get_checksum ${TEST_DIR}/${DIR2}/file1 18 &&
        get_checksum ${TEST_DIR}/${DIR2}/file2 19 &&
        [[ -d ${TEST_DIR}/${DIR2}/dir1.1 ]] &&
        [[ -d ${TEST_DIR}/${DIR2}/dir1.2 ]] &&
        [[ -d ${TEST_DIR}/${DIR2}/dir1.1/dir1.1.1 ]] &&
        [[ -d ${TEST_DIR}/${DIR2}/dir1.1/dir1.1.2 ]] &&
        EXIT_CODE=0
        print_cyan 'Test 2 ' n
        if [ ${EXIT_CODE} -eq 0 ]; then
            EXIT_CODE=1
            for i in {0..9}
            do
                [[ ${CHECKSUMS[$(( i ))]} == ${CHECKSUMS[$(( i+10 ))]} ]] && EXIT_CODE=0
            done
            [[ ${EXIT_CODE} -eq 0 ]] && print_ok 23 || print_fail 23
        else
            print_fail 23
        fi
    else
        print_red 'Can not prepare test!'
    fi
    clean_env
}