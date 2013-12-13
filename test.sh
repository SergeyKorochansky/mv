#!/bin/bash
PROGRAM='./mv.rb'
DIR_WITH_TESTS='./tests'
source ${DIR_WITH_TESTS}'/common.sh'
clean_env
for i in {1..18}
do
    source ${DIR_WITH_TESTS}"/test${i}.sh"
    test_${i}
done
