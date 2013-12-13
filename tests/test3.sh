#!/bin/sh

function test_3() {
    create_env
    print_yeallow 'Running Test #3: Move 10 files into directory'
    DIR1='dir1'
    DIR2='dir2'
    EXIT_CODE=1
    mkdir ${TEST_DIR}/${DIR1} &&
    mkdir ${TEST_DIR}/${DIR2} &&
    for i in {0..9}
    do
        crete_random_file ${TEST_DIR}/${DIR1}/file1.${i} ${i}
    done &&
    EXIT_CODE=0
    if [ ${EXIT_CODE} -eq 0 ]; then
        ${PROGRAM} ${TEST_DIR}/${DIR1}/file* ${TEST_DIR}/${DIR2} --pattern=*.[0-7]
        EXIT_CODE=$?
        EXIT_CODE_TEMP2=1
        for i in {0..7}
        do
            get_checksum ${TEST_DIR}/${DIR2}/file1.${i} $(( i+10 ))
        done &&
        [[ -d ${TEST_DIR}/${DIR2} ]] &&
        [[ -d ${TEST_DIR}/${DIR1} ]] &&
        [[ -f ${TEST_DIR}/${DIR1}/file1.8 ]] &&
        [[ -f ${TEST_DIR}/${DIR1}/file1.9 ]] &&
        EXIT_CODE_TEMP2=0
        FAIL_CHECKSUM=0
        print_cyan 'Test 3 ' n
        if [ ${EXIT_CODE_TEMP2} -eq 0 ]; then
            for i in {0..7}
            do
                [[ ${CHECKSUMS[${i}]} != ${CHECKSUMS[$(( i+10 ))]} ]] && FAIL_CHECKSUM=1
            done
            [[ ${FAIL_CHECKSUM} -eq 0 ]] && print_ok 23 || print_fail 23
        else
            print_fail 23
        fi
    else
        print_red 'Can not prepare test!'
    fi
    clean_env
}