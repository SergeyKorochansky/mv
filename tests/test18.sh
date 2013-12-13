#!/bin/sh

function test_18() {
    create_env
    print_yeallow 'Running Test #18: Complicated pattern'
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
        ${PROGRAM} ${TEST_DIR}/${DIR1} ${TEST_DIR}/${DIR2} '--pattern=file1.?.*[$1]' &&
        get_checksum ${TEST_DIR}/${DIR2}/dir1.1/dir1.1.1/file1.1.1.1 10 &&
        [[ ! -f ${TEST_DIR}/${DIR2}/dir1.1/dir1.1.1/file1.1.1.2 ]] &&
        get_checksum ${TEST_DIR}/${DIR2}/dir1.1/dir1.1.2/file1.1.2.1 11 &&
        [[ ! -f ${TEST_DIR}/${DIR2}/dir1.1/dir1.1.2/file1.1.2.2 ]] &&
        get_checksum ${TEST_DIR}/${DIR2}/dir1.1/file1.1.1 12 &&
        [[ ! -f ${TEST_DIR}/${DIR2}/dir1.1/file1.1.2 ]] &&
        get_checksum ${TEST_DIR}/${DIR2}/dir1.2/file1.2.1 13 &&
        [[ ! -f ${TEST_DIR}/${DIR2}/dir1.2/file1.2.2 ]] &&
        [[ ! -f ${TEST_DIR}/${DIR2}/file1 ]] &&
        [[ ! -f ${TEST_DIR}/${DIR2}/file2 ]] &&
        [[ -d ${TEST_DIR}/${DIR2}/dir1.1 ]] &&
        [[ -d ${TEST_DIR}/${DIR2}/dir1.2 ]] &&
        [[ -d ${TEST_DIR}/${DIR2}/dir1.1/dir1.1.1 ]] &&
        [[ -d ${TEST_DIR}/${DIR2}/dir1.1/dir1.1.2 ]] &&
        [[ ${CHECKSUMS[0]} == ${CHECKSUMS[10]} ]] &&
        [[ ${CHECKSUMS[2]} == ${CHECKSUMS[11]} ]] &&
        [[ ${CHECKSUMS[4]} == ${CHECKSUMS[12]} ]] &&
        [[ ${CHECKSUMS[6]} == ${CHECKSUMS[13]} ]] &&
        EXIT_CODE=0
        print_cyan 'Test 18' n
        [[ ${EXIT_CODE} -eq 0 ]] && print_ok 23 || print_fail 23
    else
        print_red 'Can not prepare test!'
    fi
    clean_env
}